#!/usr/bin/env python3
"""
Pokemon Crystal Legacy Trainer Data CSV to 16-bit ASM Converter

This script reads the trainer_parties.csv fil                # Determine final trainer type - use the original from CSV, don't override
                original_trainer_type = pokemon_list[0]['trainer_type']
                trainer_type = determine_trainer_type(original_trainer_type)
                
                f.write(f"\tdb \"{trainer_name}@\", {trainer_type}\n") converts it to the 16-bit ASM format
with species and moves as 16-bit values (dw instead of db).
"""

import csv
import sys
from pathlib import Path
from collections import defaultdict

def determine_trainer_type(trainer_type_str):
    """Determine the simplified trainer type based on the original trainer type"""
    # Skip complex trainer types that don't fit the 16-bit format
    if any(complex_type in trainer_type_str for complex_type in [
        'TRAINERTYPE_DVS', 'TRAINERTYPE_STAT_EXP', 
        'TRAINERTYPE_NICKNAME', 'TRAINERTYPE_HAPPINESS'
    ]):
        return None  # Skip this trainer
    
    # Map to simpler 16-bit equivalents - check exact strings first
    if trainer_type_str == 'TRAINERTYPE_ITEM_MOVES':
        return 'TRAINERTYPE_ITEM_MOVES'
    elif trainer_type_str == 'TRAINERTYPE_MOVES':
        return 'TRAINERTYPE_MOVES'
    elif trainer_type_str == 'TRAINERTYPE_ITEM':
        return 'TRAINERTYPE_ITEM'
    else:
        return 'TRAINERTYPE_NORMAL'

def has_moves(pokemon_data):
    """Check if Pokemon has any moves defined"""
    return any(pokemon_data.get(f'move{i}', '').strip() for i in range(1, 5))

def has_item(pokemon_data):
    """Check if Pokemon has an item defined"""
    item = pokemon_data.get('item', '').strip()
    return item and item != 'NO_ITEM'

def format_moves(pokemon_data):
    """Format the 4 moves for a Pokemon"""
    moves = []
    for i in range(1, 5):
        move = pokemon_data.get(f'move{i}', '').strip()
        if move:
            moves.append(move)
        else:
            moves.append('NO_MOVE')
    return ', '.join(moves)

def convert_csv_to_16bit_asm(input_file, output_file):
    """Convert the CSV file to 16-bit ASM format"""
    
    # Read CSV data
    trainers = defaultdict(list)
    
    with open(input_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = (row['trainer_group'], row['trainer_name'], row['team_number'])
            trainers[key].append(row)
    
    # Group trainers by trainer group
    groups = defaultdict(list)
    for (group, name, team_num), pokemon_list in trainers.items():
        groups[group].append((name, team_num, pokemon_list))
    
    # Write ASM output
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("; Trainer data structure:\n")
        f.write("; - db \"NAME@\", TRAINERTYPE_* constant\n")
        f.write("; - 1 to 6 Pokémon:\n")
        f.write(";    * for TRAINERTYPE_NORMAL:     db level\n")
        f.write(";                                  dw species\n")
        f.write(";    * for TRAINERTYPE_MOVES:      db level\n")
        f.write(";                                  dw species\n")
        f.write(";                                  dw 4 moves\n")
        f.write(";    * for TRAINERTYPE_ITEM:       db level\n")
        f.write(";                                  dw species\n")
        f.write(";                                  dw item\n")
        f.write(";    * for TRAINERTYPE_ITEM_MOVES: db level\n")
        f.write(";                                  dw species\n")
        f.write(";                                  dw item\n")
        f.write(";                                  dw 4 moves\n")
        f.write("; - db -1 ; end\n\n")
        
        f.write("SECTION \"Enemy Trainer Parties 1\", ROMX\n\n")
        
        # Process groups in original order
        skipped_trainers = 0
        total_trainers_processed = 0
        
        for group_name in groups.keys():
            f.write(f"{group_name}:\n")
            
            # Process trainers within group in original order
            trainers_in_group = groups[group_name]
            
            team_counter = 1
            group_has_trainers = False
            
            for trainer_name, team_num, pokemon_list in trainers_in_group:
                # Sort Pokemon by pokemon_number to maintain order
                pokemon_list.sort(key=lambda x: int(x['pokemon_number']))
                
                # Check if this trainer should be skipped
                original_trainer_type = pokemon_list[0]['trainer_type']
                trainer_type = determine_trainer_type(original_trainer_type)
                
                if trainer_type is None:
                    skipped_trainers += 1
                    continue  # Skip this trainer
                
                group_has_trainers = True
                total_trainers_processed += 1
                group_has_trainers = True
                total_trainers_processed += 1
                
                # Get comment if available
                comment = pokemon_list[0].get('comment', '').strip()
                if comment:
                    f.write(f"\tnext_list_item ; {comment}\n")
                else:
                    f.write(f"\tnext_list_item ; {trainer_name} ({team_counter})\n")
                
                # Determine final trainer type - use the original from CSV, don't override
                original_trainer_type = pokemon_list[0]['trainer_type']
                trainer_type = determine_trainer_type(original_trainer_type)
                
                f.write(f"\tdb \"{trainer_name}@\", {trainer_type}\n")
                
                # Write Pokemon data
                for pokemon in pokemon_list:
                    level = pokemon['level']
                    species = pokemon['species']
                    
                    f.write(f"\tdb {level}\n")
                    f.write(f"\tdw {species}\n")
                    
                    if trainer_type == 'TRAINERTYPE_ITEM_MOVES':
                        item = pokemon.get('item', 'NO_ITEM').strip()
                        if not item:
                            item = 'NO_ITEM'
                        f.write(f"\tdw {item}\n")
                        moves = format_moves(pokemon)
                        f.write(f"\tdw {moves}\n")
                    elif trainer_type == 'TRAINERTYPE_MOVES':
                        moves = format_moves(pokemon)
                        f.write(f"\tdw {moves}\n")
                    elif trainer_type == 'TRAINERTYPE_ITEM':
                        item = pokemon.get('item', 'NO_ITEM').strip()
                        if not item:
                            item = 'NO_ITEM'
                        f.write(f"\tdw {item}\n")
                    # TRAINERTYPE_NORMAL doesn't need additional data
                
                f.write(f"\tdb -1 ; end\n\n")
                team_counter += 1
            
            # Add end_list_items at the end of each group
            f.write(f"\tend_list_items\n\n")
            
            # Only write the group if it has trainers that weren't skipped
            if not group_has_trainers:
                # Remove the group header if no trainers were written
                f.seek(f.tell() - len(f"{group_name}:\n"))
                f.truncate()
        
        print(f"Successfully converted CSV to 16-bit ASM format: {output_file}")
        
        # Print summary
        total_trainers = sum(len(valid_trainers) for group_name in groups.keys() 
                           for valid_trainers in [[(name, num, plist) for name, num, plist in groups[group_name] 
                                                 if determine_trainer_type(plist[0]['trainer_type']) is not None]])
        total_pokemon = sum(len(pokemon_list) for group_name in groups.keys()
                           for name, num, pokemon_list in groups[group_name] 
                           if determine_trainer_type(pokemon_list[0]['trainer_type']) is not None)
        total_skipped = sum(len(groups[group_name]) for group_name in groups.keys()) - total_trainers
        
        print(f"Total groups: {len([g for g in groups.keys() if any(determine_trainer_type(plist[0]['trainer_type']) is not None for _, _, plist in groups[g])])}")
        print(f"Total trainers processed: {total_trainers}")
        print(f"Total trainers skipped (complex types): {total_skipped}")
        print(f"Total Pokemon: {total_pokemon}")

def main():
    input_file = Path("trainer_parties.csv")
    output_file = Path("trainer_parties_16bit.asm")
    
    if len(sys.argv) > 1:
        input_file = Path(sys.argv[1])
    if len(sys.argv) > 2:
        output_file = Path(sys.argv[2])
    
    if not input_file.exists():
        print(f"Error: Input file '{input_file}' not found")
        return 1
    
    try:
        convert_csv_to_16bit_asm(input_file, output_file)
        return 0
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
