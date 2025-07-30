#!/usr/bin/env python3
"""
Pokemon Crystal Legacy Evos/Attacks Data to 16-bit ASM Converter

This script reads the evos_attacks.asm file and converts it to the 16-bit ASM format
with moves as 16-bit values (dw instead of db) and appropriate evolution format changes.

Evolution format conversions:
- db EVOLVE_LEVEL, level, species -> dbbw EVOLVE_LEVEL, level, species
- db EVOLVE_ITEM, item, species -> dbww EVOLVE_ITEM, item, species
- db EVOLVE_TRADE, item, species -> dbww EVOLVE_TRADE, item, species
- db EVOLVE_HAPPINESS, time, species -> dbww EVOLVE_HAPPINESS, time, species
- db EVOLVE_STAT, level, stat, species -> dbbww EVOLVE_STAT, level, stat, species

Move format conversions:
- db level, move -> dbw level, move

Usage:
    python convert_evos_attacks_to_16bit.py [input_file] [output_file]
    
    If no arguments provided, uses default:
    input_file = data/pokemon/evos_attacks.asm
    output_file = data/pokemon/evos_attacks_16bit.asm
"""

import re
import sys
from pathlib import Path


def convert_evolution_line(line):
    """Convert evolution lines to 16-bit format"""
    original_line = line
    line = line.strip()
    
    # Extract comment if present
    comment = ""
    if ";" in line:
        comment = " " + line[line.index(";"):]
        line = line[:line.index(";")].strip()
    
    # Handle EVOLVE_STAT specially (4 parameters)
    evolve_stat_pattern = r'\s*db\s+(EVOLVE_STAT),\s*([^,]+),\s*([^,]+),\s*(.+)$'
    match = re.match(evolve_stat_pattern, line)
    if match:
        evolve_type = match.group(1)
        level = match.group(2).strip()
        stat = match.group(3).strip()
        species = match.group(4).strip()
        return f"\tdbbww {evolve_type}, {level}, {stat}, {species}{comment}"
    
    # Handle other evolution types (3 parameters)
    evolution_pattern = r'\s*db\s+(EVOLVE_\w+),\s*([^,]+),\s*(.+)$'
    match = re.match(evolution_pattern, line)
    
    if not match:
        return original_line  # Return unchanged if not an evolution line
    
    evolve_type = match.group(1)
    param1 = match.group(2).strip()
    param2 = match.group(3).strip()
    
    # Convert based on evolution type
    if evolve_type == "EVOLVE_LEVEL":
        # db EVOLVE_LEVEL, level, species -> dbbw EVOLVE_LEVEL, level, species
        return f"\tdbbw {evolve_type}, {param1}, {param2}{comment}"
    elif evolve_type in ["EVOLVE_ITEM", "EVOLVE_TRADE", "EVOLVE_HAPPINESS"]:
        # db EVOLVE_ITEM/TRADE/HAPPINESS, item/time, species -> dbww EVOLVE_*, item/time, species
        return f"\tdbww {evolve_type}, {param1}, {param2}{comment}"
    
    return original_line  # Return unchanged if we can't parse it


def convert_move_line(line):
    """Convert move lines to 16-bit format"""
    line = line.strip()
    
    # Match move patterns: db level, move
    move_pattern = r'\s*db\s+(\d+),\s*(\w+)(?:\s*;.*)?$'
    match = re.match(move_pattern, line)
    
    if not match:
        return line  # Return unchanged if not a move line
    
    level = match.group(1)
    move = match.group(2)
    
    # Extract comment if present
    comment = ""
    if ";" in line:
        comment = " " + line[line.index(";"):]
    
    return f"\tdbw {level}, {move}{comment}"


def is_evolution_line(line):
    """Check if line is an evolution definition"""
    return re.match(r'\s*db\s+EVOLVE_\w+', line) is not None


def is_move_line(line):
    """Check if line is a move definition (level, move)"""
    # Match lines like "db 1, BUBBLE" but not "db 0 ; no more evolutions"
    return re.match(r'\s*db\s+\d+\s*,\s*\w+', line) is not None


def is_terminator_line(line):
    """Check if line is a terminator (db 0)"""
    return re.match(r'\s*db\s+0\s*;', line) is not None


def convert_evos_attacks_to_16bit(input_file, output_file):
    """Convert the evos_attacks.asm file to 16-bit format"""
    
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    converted_lines = []
    stats = {
        'evolution_lines': 0,
        'move_lines': 0,
        'total_lines': len(lines)
    }
    
    for line in lines:
        original_line = line.rstrip('\n\r')
        
        # Skip empty lines and preserve them
        if not line.strip():
            converted_lines.append(original_line)
            continue
        
        # Preserve comments, labels, includes, and other non-data lines
        if (line.startswith(';') or 
            line.startswith('INCLUDE') or 
            line.startswith('SECTION') or 
            line.endswith(':\n') or 
            line.endswith(':\r\n') or
            is_terminator_line(line)):
            converted_lines.append(original_line)
            continue
        
        # Convert evolution lines
        if is_evolution_line(line):
            converted_lines.append(convert_evolution_line(line))
            stats['evolution_lines'] += 1
            continue
        
        # Convert move lines
        if is_move_line(line):
            converted_lines.append(convert_move_line(line))
            stats['move_lines'] += 1
            continue
        
        # For all other lines, keep them unchanged
        converted_lines.append(original_line)
    
    # Write the converted content
    with open(output_file, 'w', encoding='utf-8') as f:
        for line in converted_lines:
            f.write(line + '\n')
    
    print(f"Successfully converted evos_attacks.asm to 16-bit format: {output_file}")
    print(f"Statistics:")
    print(f"  Total lines processed: {stats['total_lines']}")
    print(f"  Evolution lines converted: {stats['evolution_lines']}")
    print(f"  Move lines converted: {stats['move_lines']}")
    print(f"  Total conversions: {stats['evolution_lines'] + stats['move_lines']}")


def main():
    input_file = Path("data/pokemon/evos_attacks.asm")
    output_file = Path("data/pokemon/evos_attacks_16bit.asm")
    
    # Handle help request
    if len(sys.argv) > 1 and sys.argv[1] in ['-h', '--help', 'help']:
        print(__doc__)
        return 0
    
    if len(sys.argv) > 1:
        input_file = Path(sys.argv[1])
    if len(sys.argv) > 2:
        output_file = Path(sys.argv[2])
    
    if not input_file.exists():
        print(f"Error: Input file '{input_file}' not found")
        return 1
    
    try:
        convert_evos_attacks_to_16bit(input_file, output_file)
        return 0
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
