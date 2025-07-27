#!/usr/bin/env python3
"""
Pokemon Crystal Legacy Trainer Data to CSV Converter

This script parses the trainer party data from the ASM file and converts it to a CSV format.
It handles all trainer types including those with nicknames, DVs, stat experience, happiness, items, and moves.
"""

import csv
import re
import sys
from pathlib import Path

def parse_trainer_name_and_type(line):
    """Parse trainer name and type from a line like 'db "FALKNER@", TRAINERTYPE_ITEM_MOVES'"""
    match = re.match(r'\s*db\s+"([^"]+)@",\s+(.+)', line)
    if match:
        name = match.group(1)
        trainer_type = match.group(2).strip()
        return name, trainer_type
    return None, None

def parse_trainer_flags(trainer_type):
    """Parse trainer type flags to determine what extra data to expect"""
    flags = {
        'nickname': 'TRAINERTYPE_NICKNAME' in trainer_type,
        'dvs': 'TRAINERTYPE_DVS' in trainer_type,
        'stat_exp': 'TRAINERTYPE_STAT_EXP' in trainer_type,
        'happiness': 'TRAINERTYPE_HAPPINESS' in trainer_type,
        'item': 'TRAINERTYPE_ITEM' in trainer_type,
        'moves': 'TRAINERTYPE_MOVES' in trainer_type
    }
    return flags

def parse_pokemon_line(line):
    """Parse a Pokemon line like 'db  8,  PIDGEY,  NO_ITEM,  TACKLE, MUD_SLAP, QUICK_ATTACK, NO_MOVE'"""
    # Remove leading/trailing whitespace and 'db '
    line = line.strip()
    if line.startswith('db '):
        line = line[3:].strip()
    
    # Split by comma and clean up
    parts = [part.strip() for part in line.split(',')]
    
    # Check if this is actually a Pokemon line (should start with a level number)
    if len(parts) >= 2:
        try:
            level = int(parts[0])  # First part should be a level number
            species = parts[1]
            
            # For basic pokemon entries (level, species only)
            if len(parts) == 2:
                return {
                    'level': str(level),
                    'species': species,
                    'item': '',
                    'move1': '',
                    'move2': '',
                    'move3': '',
                    'move4': ''
                }
            
            # For pokemon with items and moves
            item = parts[2] if len(parts) > 2 else ''
            moves = parts[3:7] if len(parts) > 3 else ['', '', '', '']
            
            # Pad moves to 4 slots
            while len(moves) < 4:
                moves.append('')
            
            return {
                'level': str(level),
                'species': species,
                'item': item,
                'move1': moves[0],
                'move2': moves[1],
                'move3': moves[2],
                'move4': moves[3]
            }
        except ValueError:
            # First part is not a number, so this is not a Pokemon line
            return None
    
    return None

def parse_nickname_line(line):
    """Parse a nickname line like 'db "@JOLTEON@"'"""
    match = re.match(r'\s*db\s+"@([^@]+)@"', line)
    if match:
        return match.group(1)
    return ''

def parse_dvs_line(line):
    """Parse DV line like 'db $ed, PERFECT_DV ; atk|def, spd|spc'"""
    line = line.strip()
    if line.startswith('db '):
        line = line[3:].strip()
    
    # Remove comments
    if ';' in line:
        line = line.split(';')[0].strip()
    
    parts = [part.strip() for part in line.split(',')]
    return {
        'atk_def_dv': parts[0] if len(parts) > 0 else '',
        'spd_spc_dv': parts[1] if len(parts) > 1 else ''
    }

def parse_stat_exp_line(line):
    """Parse stat experience line like 'dw $01FE, $01FE, $01FE, $01FE, $01FE ; hp, atk, def, spd, spc'"""
    line = line.strip()
    if line.startswith('dw '):
        line = line[3:].strip()
    
    # Remove comments
    if ';' in line:
        line = line.split(';')[0].strip()
    
    parts = [part.strip() for part in line.split(',')]
    return {
        'hp_exp': parts[0] if len(parts) > 0 else '',
        'atk_exp': parts[1] if len(parts) > 1 else '',
        'def_exp': parts[2] if len(parts) > 2 else '',
        'spd_exp': parts[3] if len(parts) > 3 else '',
        'spc_exp': parts[4] if len(parts) > 4 else ''
    }

def parse_happiness_line(line):
    """Parse happiness line like 'db 255'"""
    line = line.strip()
    if line.startswith('db '):
        line = line[3:].strip()
    
    # Remove comments
    if ';' in line:
        line = line.split(';')[0].strip()
    
    return line

def convert_trainer_data_to_csv(input_file, output_file):
    """Convert the trainer party ASM file to CSV format"""
    
    trainers = []
    
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    i = 0
    current_trainer = None
    current_group = ""
    team_counters = {}  # Track team numbers within each group
    pokemon_count = 0
    last_comment = ""  # Store the most recent comment
    
    while i < len(lines):
        line = lines[i].strip()
        
        # Skip empty lines
        if not line:
            i += 1
            continue
        
        # Capture comments that might describe trainer parties
        if line.startswith(';'):
            # Store comments that look like trainer descriptions
            comment_text = line[1:].strip()  # Remove the ';' and leading/trailing spaces
            if comment_text and not comment_text.lower().startswith('end'):
                last_comment = comment_text
            i += 1
            continue
        
        # Check for group names (lines ending with ':')
        if line.endswith(':') and not line.startswith('\t') and not line.startswith(' '):
            current_group = line[:-1]  # Remove the ':'
            i += 1
            continue
        
        # Check for trainer definition
        trainer_name, trainer_type = parse_trainer_name_and_type(line)
        if trainer_name and trainer_type:
            # Generate team number within the group
            group_trainer_key = f"{current_group}_{trainer_name}"
            if group_trainer_key not in team_counters:
                team_counters[group_trainer_key] = 0
            team_counters[group_trainer_key] += 1
            team_number = team_counters[group_trainer_key]
            
            current_trainer = {
                'group': current_group,
                'name': trainer_name,
                'team_number': team_number,
                'type': trainer_type,
                'comment': last_comment,
                'pokemon': []
            }
            flags = parse_trainer_flags(trainer_type)
            pokemon_count = 0
            i += 1
            continue
        
        # Check for end of trainer
        if line.startswith('db -1'):
            if current_trainer:
                trainers.append(current_trainer)
                current_trainer = None
            i += 1
            continue
        
        # Parse Pokemon data
        if current_trainer is not None and (line.startswith('db ') and not line.startswith('db -1')):
            pokemon_data = parse_pokemon_line(line)
            if pokemon_data:
                pokemon_count += 1
                pokemon_data['trainer_group'] = current_trainer['group']
                pokemon_data['trainer_name'] = current_trainer['name']
                pokemon_data['team_number'] = current_trainer['team_number']
                pokemon_data['trainer_type'] = current_trainer['type']
                pokemon_data['comment'] = current_trainer['comment']
                pokemon_data['pokemon_number'] = pokemon_count
                pokemon_data['nickname'] = ''
                pokemon_data['atk_def_dv'] = ''
                pokemon_data['spd_spc_dv'] = ''
                pokemon_data['hp_exp'] = ''
                pokemon_data['atk_exp'] = ''
                pokemon_data['def_exp'] = ''
                pokemon_data['spd_exp'] = ''
                pokemon_data['spc_exp'] = ''
                pokemon_data['happiness'] = ''
                
                flags = parse_trainer_flags(current_trainer['type'])
                j = i + 1
                
                # Parse additional data based on flags
                if flags['nickname'] and j < len(lines):
                    nickname_line = lines[j].strip()
                    if nickname_line.startswith('db '):
                        nickname = parse_nickname_line(nickname_line)
                        if nickname:
                            pokemon_data['nickname'] = nickname
                            j += 1
                
                if flags['dvs'] and j < len(lines):
                    dvs_line = lines[j].strip()
                    if dvs_line.startswith('db '):
                        dvs = parse_dvs_line(dvs_line)
                        pokemon_data['atk_def_dv'] = dvs['atk_def_dv']
                        pokemon_data['spd_spc_dv'] = dvs['spd_spc_dv']
                        j += 1
                
                if flags['stat_exp'] and j < len(lines):
                    stat_exp_line = lines[j].strip()
                    if stat_exp_line.startswith('dw '):
                        stat_exp = parse_stat_exp_line(stat_exp_line)
                        pokemon_data['hp_exp'] = stat_exp['hp_exp']
                        pokemon_data['atk_exp'] = stat_exp['atk_exp']
                        pokemon_data['def_exp'] = stat_exp['def_exp']
                        pokemon_data['spd_exp'] = stat_exp['spd_exp']
                        pokemon_data['spc_exp'] = stat_exp['spc_exp']
                        j += 1
                
                if flags['happiness'] and j < len(lines):
                    happiness_line = lines[j].strip()
                    if happiness_line.startswith('db '):
                        happiness = parse_happiness_line(happiness_line)
                        pokemon_data['happiness'] = happiness
                        j += 1
                
                # For complex trainer types, item and moves might be on separate lines
                if (flags['item'] or flags['moves']) and j < len(lines):
                    # Check if we need to parse item and moves from separate lines
                    if pokemon_data['item'] == '' and pokemon_data['move1'] == '':
                        # Look for item line
                        if j < len(lines):
                            item_line = lines[j].strip()
                            if item_line.startswith('db ') and not parse_pokemon_line(item_line):
                                item = item_line[3:].strip()
                                if ';' in item:
                                    item = item.split(';')[0].strip()
                                pokemon_data['item'] = item
                                j += 1
                        
                        # Look for moves line
                        if j < len(lines):
                            moves_line = lines[j].strip()
                            if moves_line.startswith('db ') and not parse_pokemon_line(moves_line):
                                moves_part = moves_line[3:].strip()
                                if ';' in moves_part:
                                    moves_part = moves_part.split(';')[0].strip()
                                moves = [move.strip() for move in moves_part.split(',')]
                                while len(moves) < 4:
                                    moves.append('')
                                pokemon_data['move1'] = moves[0] if len(moves) > 0 else ''
                                pokemon_data['move2'] = moves[1] if len(moves) > 1 else ''
                                pokemon_data['move3'] = moves[2] if len(moves) > 2 else ''
                                pokemon_data['move4'] = moves[3] if len(moves) > 3 else ''
                                j += 1
                
                current_trainer['pokemon'].append(pokemon_data)
                i = j - 1  # j will be incremented at the end of the loop
        
        i += 1
    
    # Write to CSV
    if trainers:
        # Flatten the data - one row per Pokemon
        csv_data = []
        for trainer in trainers:
            for pokemon in trainer['pokemon']:
                csv_data.append(pokemon)
        
        # Define CSV columns
        fieldnames = [
            'trainer_group', 'trainer_name', 'team_number', 'comment', 'trainer_type', 'pokemon_number',
            'level', 'species', 'nickname', 'item',
            'move1', 'move2', 'move3', 'move4',
            'atk_def_dv', 'spd_spc_dv',
            'hp_exp', 'atk_exp', 'def_exp', 'spd_exp', 'spc_exp',
            'happiness'
        ]
        
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(csv_data)
        
        print(f"Successfully converted {len(trainers)} trainers with {len(csv_data)} total Pokemon to {output_file}")
    else:
        print("No trainer data found in the input file")

def main():
    input_file = Path("data/trainers/parties.asm")
    output_file = Path("trainer_parties.csv")
    
    if len(sys.argv) > 1:
        input_file = Path(sys.argv[1])
    if len(sys.argv) > 2:
        output_file = Path(sys.argv[2])
    
    if not input_file.exists():
        print(f"Error: Input file '{input_file}' not found")
        return 1
    
    try:
        convert_trainer_data_to_csv(input_file, output_file)
        return 0
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
