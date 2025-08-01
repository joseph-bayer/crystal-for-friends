#!/usr/bin/env python3
"""
Crystal Legacy Move Importer

This script reads moves from the legacy moves.asm file and applies their attributes
(effect, power, type, accuracy, pp, effect_chance) to the current moves.asm file.

Author: Generated for CrystalShireEngine-core
"""

import os
import re
import sys
from typing import Dict, List, Tuple, Optional

class MoveData:
    """Represents a single move's data"""
    def __init__(self, name: str, effect: str, power: int, type_name: str, 
                 accuracy: int, pp: int, effect_chance: int):
        self.name = name
        self.effect = effect
        self.power = power
        self.type_name = type_name
        self.accuracy = accuracy
        self.pp = pp
        self.effect_chance = effect_chance
    
    def __repr__(self):
        return f"MoveData({self.name}, {self.effect}, {self.power}, {self.type_name}, {self.accuracy}, {self.pp}, {self.effect_chance})"
    
    def __eq__(self, other):
        if not isinstance(other, MoveData):
            return False
        return (self.effect == other.effect and 
                self.power == other.power and 
                self.type_name == other.type_name and 
                self.accuracy == other.accuracy and 
                self.pp == other.pp and 
                self.effect_chance == other.effect_chance)

class CrystalLegacyMoveImporter:
    """Main importer class"""
    
    def __init__(self, script_dir: str):
        self.script_dir = script_dir
        self.legacy_moves: Dict[str, MoveData] = {}
        self.current_moves: Dict[str, MoveData] = {}
        self.changes: List[Tuple[str, MoveData, MoveData]] = []
        
    def parse_legacy_moves(self, legacy_file_path: str) -> Dict[str, MoveData]:
        """Parse the legacy moves.asm file and extract move data"""
        moves = {}
        
        with open(legacy_file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Pattern to match move lines in legacy format
        # move MOVE_NAME, EFFECT, power, TYPE, accuracy, pp, effect_chance
        move_pattern = r'move\s+(\w+),\s*(\w+),\s*(\d+),\s*(\w+),\s*(\d+),\s*(\d+),\s*(\d+)'
        
        for match in re.finditer(move_pattern, content):
            name = match.group(1)
            effect = match.group(2)
            power = int(match.group(3))
            type_name = match.group(4)
            accuracy = int(match.group(5))
            pp = int(match.group(6))
            effect_chance = int(match.group(7))
            
            moves[name] = MoveData(name, effect, power, type_name, accuracy, pp, effect_chance)
        
        print(f"Parsed {len(moves)} moves from legacy file")
        return moves
    
    def parse_current_moves(self, current_file_path: str) -> Dict[str, MoveData]:
        """Parse the current moves.asm file and extract move data"""
        moves = {}
        
        with open(current_file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Pattern to match move lines in current format
        # move EFFECT, power, TYPE, accuracy, pp, effect_chance ;MOVE_NAME
        move_pattern = r'move\s+(\w+),\s*(\d+),\s*(\w+),\s*(\d+),\s*(\d+),\s*(\d+)\s*;(\w+)'
        
        for match in re.finditer(move_pattern, content):
            effect = match.group(1)
            power = int(match.group(2))
            type_name = match.group(3)
            accuracy = int(match.group(4))
            pp = int(match.group(5))
            effect_chance = int(match.group(6))
            name = match.group(7)
            
            moves[name] = MoveData(name, effect, power, type_name, accuracy, pp, effect_chance)
        
        print(f"Parsed {len(moves)} moves from current file")
        return moves
    
    def compare_moves(self) -> List[Tuple[str, MoveData, MoveData]]:
        """Compare legacy and current moves, return list of changes needed"""
        changes = []
        
        for move_name in self.legacy_moves:
            if move_name in self.current_moves:
                legacy_move = self.legacy_moves[move_name]
                current_move = self.current_moves[move_name]
                
                if legacy_move != current_move:
                    changes.append((move_name, current_move, legacy_move))
            else:
                print(f"Warning: Move {move_name} found in legacy but not in current file")
        
        print(f"Found {len(changes)} moves that need updates")
        return changes
    
    def format_move_line(self, effect: str, power: int, type_name: str, accuracy: int, pp: int, effect_chance: int, move_name: str) -> str:
        """Format a move line to match the exact formatting of the original file"""
        
        # Analyze the exact formatting from the original file:
        # \tmove EFFECT_NORMAL_HIT,         40, NORMAL,        100, 35,   0      ;POUND
        # \tmove EFFECT_PARALYZE_HIT,       75, ELECTRIC,      100, 15,  10      ;THUNDERPUNCH
        # \tmove EFFECT_ATTACK_UP_2,         0, NORMAL,        100, 30,   0      ;SWORDS_DANCE
        
        # The pattern is:
        # - Tab + "move " (5 chars)
        # - Effect name + comma, padded to column 32
        # - Power right-aligned in 3 chars + comma + space (5 chars total)
        # - Type name + comma, padded so accuracy starts at specific column
        # - Accuracy right-aligned + comma + space  
        # - PP right-aligned + comma + spaces
        # - Effect chance right-aligned + 6 spaces + semicolon + move name
        
        # Calculate effect field width to align power at column 32
        base_len = len("\tmove ")  # 6 characters (tab counts as 1 for our purposes)
        effect_with_comma = f"{effect},"
        effect_field_width = 32 - base_len - len(effect_with_comma)
        if effect_field_width < 1:
            effect_field_width = 1
        
        # Power is right-aligned in 3 characters
        power_field = f"{power:>3}"
        
        # Calculate type field spacing
        # After power field: ", " (2 chars) 
        current_pos = 32 + 3 + 2  # position after power field
        type_with_comma = f"{type_name},"
        
        # Accuracy should start around column 48-50, depending on type length
        # Looking at examples:
        # "NORMAL,        " vs "ELECTRIC,      " vs "FIGHTING,      "
        # The target seems to be to align accuracy at a consistent column
        
        if len(type_name) <= 6:  # NORMAL, FIRE, etc.
            type_spacing = 8
        elif len(type_name) <= 8:  # FIGHTING, ELECTRIC
            type_spacing = 6
        elif len(type_name) <= 12:  # PSYCHIC_TYPE
            type_spacing = 2
        else:
            type_spacing = 1
        
        # Format the line
        line = (f"\tmove {effect_with_comma}"
                f"{' ' * effect_field_width}"
                f"{power_field}, "
                f"{type_with_comma}"
                f"{' ' * type_spacing}"
                f"{accuracy:>3}, "
                f"{pp:>2}, "
                f"{effect_chance:>3}"
                f"      ;{move_name}")
        
        return line

    def apply_changes(self, current_file_path: str, backup: bool = True) -> None:
        """Apply the changes to the current moves.asm file"""
        
        if backup:
            backup_path = current_file_path + '.backup'
            with open(current_file_path, 'r', encoding='utf-8') as src:
                with open(backup_path, 'w', encoding='utf-8') as dst:
                    dst.write(src.read())
            print(f"Created backup at {backup_path}")
        
        with open(current_file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Apply changes line by line
        for i, line in enumerate(lines):
            # Check if this line contains a move that needs to be updated
            for move_name, current_move, legacy_move in self.changes:
                # Look for the move line with this move name
                if f";{move_name}" in line and "move " in line:
                    # Replace this line with the properly formatted legacy data
                    lines[i] = self.format_move_line(
                        legacy_move.effect,
                        legacy_move.power, 
                        legacy_move.type_name,
                        legacy_move.accuracy,
                        legacy_move.pp,
                        legacy_move.effect_chance,
                        move_name
                    ) + "\n"
                    break
        
        # Write the updated content back
        with open(current_file_path, 'w', encoding='utf-8') as f:
            f.writelines(lines)
        
        print(f"Applied {len(self.changes)} changes to {current_file_path}")
    
    def generate_summary(self, summary_file_path: str) -> None:
        """Generate a summary text file of all changes made"""
        
        with open(summary_file_path, 'w', encoding='utf-8') as f:
            f.write("Crystal Legacy Move Importer - Change Summary\n")
            f.write("=" * 50 + "\n\n")
            f.write(f"Total moves processed: {len(self.legacy_moves)}\n")
            f.write(f"Total changes applied: {len(self.changes)}\n\n")
            
            if self.changes:
                f.write("Detailed Changes:\n")
                f.write("-" * 20 + "\n\n")
                
                # Sort changes by move name for easier reading
                sorted_changes = sorted(self.changes, key=lambda x: x[0])  # Sort by move name (first element)
                
                for move_name, current_move, legacy_move in sorted_changes:
                    f.write(f"Move: {move_name}\n")
                    
                    # Show only the attributes that changed
                    changes_list = []
                    if current_move.effect != legacy_move.effect:
                        changes_list.append(f"effect: {current_move.effect} -> {legacy_move.effect}")
                    if current_move.power != legacy_move.power:
                        changes_list.append(f"power: {current_move.power} -> {legacy_move.power}")
                    if current_move.type_name != legacy_move.type_name:
                        changes_list.append(f"type: {current_move.type_name} -> {legacy_move.type_name}")
                    if current_move.accuracy != legacy_move.accuracy:
                        changes_list.append(f"accuracy: {current_move.accuracy} -> {legacy_move.accuracy}")
                    if current_move.pp != legacy_move.pp:
                        changes_list.append(f"pp: {current_move.pp} -> {legacy_move.pp}")
                    if current_move.effect_chance != legacy_move.effect_chance:
                        changes_list.append(f"effect_chance: {current_move.effect_chance} -> {legacy_move.effect_chance}")
                    
                    f.write(f"  Changes: {', '.join(changes_list)}\n\n")
            else:
                f.write("No changes were needed - all moves already match legacy data.\n")
        
        print(f"Generated summary at {summary_file_path}")
    
    def run(self):
        """Main execution method"""
        
        # File paths
        legacy_file = os.path.join(self.script_dir, 'moves.asm')
        current_file = os.path.join(self.script_dir, '..', '..', '..', 'data', 'moves', 'moves.asm')
        summary_file = os.path.join(self.script_dir, 'change_summary.txt')
        
        # Convert to absolute paths
        legacy_file = os.path.abspath(legacy_file)
        current_file = os.path.abspath(current_file)
        summary_file = os.path.abspath(summary_file)
        
        print(f"Legacy moves file: {legacy_file}")
        print(f"Current moves file: {current_file}")
        print(f"Summary file: {summary_file}")
        
        # Check if files exist
        if not os.path.exists(legacy_file):
            print(f"Error: Legacy moves file not found: {legacy_file}")
            return 1
            
        if not os.path.exists(current_file):
            print(f"Error: Current moves file not found: {current_file}")
            return 1
        
        try:
            # Parse both files
            print("\nParsing legacy moves...")
            self.legacy_moves = self.parse_legacy_moves(legacy_file)
            
            print("Parsing current moves...")
            self.current_moves = self.parse_current_moves(current_file)
            
            # Compare and find changes
            print("\nComparing moves...")
            self.changes = self.compare_moves()
            
            if self.changes:
                # Ask for confirmation
                print(f"\nFound {len(self.changes)} moves that need updating.")
                response = input("Do you want to apply these changes? (y/N): ")
                
                if response.lower() in ['y', 'yes']:
                    print("\nApplying changes...")
                    self.apply_changes(current_file)
                    
                    print("Generating summary...")
                    self.generate_summary(summary_file)
                    
                    print("\nProcess completed successfully!")
                else:
                    print("Changes cancelled by user.")
                    # Still generate summary for review
                    self.generate_summary(summary_file)
            else:
                print("\nNo changes needed - all moves already match legacy data.")
                self.generate_summary(summary_file)
            
            return 0
            
        except Exception as e:
            print(f"Error during processing: {e}")
            return 1

def main():
    """Entry point"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    importer = CrystalLegacyMoveImporter(script_dir)
    return importer.run()

if __name__ == '__main__':
    sys.exit(main())
