#!/usr/bin/env python3
"""
Pokemon Usage Analysis Script for GruntM and GruntF Trainers
Analyzes the trainer parties file to determine pokemon usage statistics.
"""

import re
from collections import Counter, defaultdict
from typing import Dict, List, Tuple

def parse_trainer_data(file_path: str) -> Tuple[Dict[str, List[str]], Dict[str, List[str]], Dict[str, List[str]], Dict[str, List[str]]]:
    """
    Parse the trainer parties file and extract pokemon data for GruntM, GruntF, ExecutiveM, and ExecutiveF.
    
    Returns:
        Tuple containing dictionaries of GruntM, GruntF, ExecutiveM, and ExecutiveF pokemon lists
    """
    grunt_m_pokemon = defaultdict(list)
    grunt_f_pokemon = defaultdict(list)
    executive_m_pokemon = defaultdict(list)
    executive_f_pokemon = defaultdict(list)
    
    # Define unused trainers that should be excluded from analysis
    unused_trainers = {
        'GruntM_12', 'GruntM_22', 'GruntM_23', 'GruntM_26', 'GruntM_27', 'GruntM_30'
    }
    
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
    except UnicodeDecodeError:
        # Try with different encoding if UTF-8 fails
        with open(file_path, 'r', encoding='latin1') as file:
            content = file.read()
    
    # Find GruntM section
    grunt_m_match = re.search(r'GruntMGroup:(.*?)end_list_items', content, re.DOTALL)
    if grunt_m_match:
        grunt_m_section = grunt_m_match.group(1)
        parse_grunt_section(grunt_m_section, grunt_m_pokemon, "GruntM", unused_trainers)
    
    # Find GruntF section  
    grunt_f_match = re.search(r'GruntFGroup:(.*?)end_list_items', content, re.DOTALL)
    if grunt_f_match:
        grunt_f_section = grunt_f_match.group(1)
        parse_grunt_section(grunt_f_section, grunt_f_pokemon, "GruntF", unused_trainers)
    
    # Find ExecutiveM section
    executive_m_match = re.search(r'ExecutiveMGroup:(.*?)end_list_items', content, re.DOTALL)
    if executive_m_match:
        executive_m_section = executive_m_match.group(1)
        parse_grunt_section(executive_m_section, executive_m_pokemon, "ExecutiveM", unused_trainers)
    
    # Find ExecutiveF section
    executive_f_match = re.search(r'ExecutiveFGroup:(.*?)end_list_items', content, re.DOTALL)
    if executive_f_match:
        executive_f_section = executive_f_match.group(1)
        parse_grunt_section(executive_f_section, executive_f_pokemon, "ExecutiveF", unused_trainers)
    
    return dict(grunt_m_pokemon), dict(grunt_f_pokemon), dict(executive_m_pokemon), dict(executive_f_pokemon)

def parse_grunt_section(section: str, pokemon_dict: Dict[str, List[str]], trainer_type: str, unused_trainers: set = None):
    """Parse a grunt section and extract pokemon data."""
    
    if unused_trainers is None:
        unused_trainers = set()
    
    # Split by next_list_item to get individual trainers
    trainers = re.split(r'\s*next_list_item\s*;', section)[1:]  # Skip the first empty element
    
    for i, trainer_data in enumerate(trainers, 1):
        trainer_id = f"{trainer_type}_{i}"
        
        # Skip unused trainers
        if trainer_id in unused_trainers:
            print(f"Skipping unused trainer: {trainer_id}")
            continue
        
        # Parse trainer structure based on trainer type
        lines = trainer_data.split('\n')
        current_pokemon = []
        has_moves = False
        
        # Find trainer type first
        for line in lines:
            line = line.strip()
            if 'TRAINERTYPE_MOVES' in line:
                has_moves = True
                break
            elif 'TRAINERTYPE_NORMAL' in line:
                has_moves = False
                break
        
        # Parse pokemon based on structure
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            
            # Skip empty lines, comments, trainer name lines, and end markers
            if (not line or line.startswith(';') or 
                line == 'db -1 ; end' or
                (line.startswith('db ') and '"@"' in line)):
                i += 1
                continue
            
            # Level line (db XX) - pokemon comes next
            if re.match(r'^db\s+\d+$', line):
                i += 1
                # Next line should be pokemon (dw POKEMON_NAME)
                if i < len(lines):
                    pokemon_line = lines[i].strip()
                    pokemon_match = re.match(r'dw\s+([A-Z_][A-Z0-9_]*)', pokemon_line)
                    if pokemon_match:
                        current_pokemon.append(pokemon_match.group(1))
                        i += 1
                        
                        # If this trainer has moves, skip the move line
                        if has_moves and i < len(lines):
                            move_line = lines[i].strip()
                            # Move lines are either single moves or comma-separated moves
                            if move_line.startswith('dw '):
                                i += 1
                continue
            
            i += 1
        
        if current_pokemon:
            pokemon_dict[trainer_id] = current_pokemon

def analyze_pokemon_usage(pokemon_data: Dict[str, List[str]], trainer_type: str) -> Counter:
    """Analyze pokemon usage frequency."""
    all_pokemon = []
    for trainer_pokemon in pokemon_data.values():
        all_pokemon.extend(trainer_pokemon)
    
    return Counter(all_pokemon)

def print_combined_usage_stats(grunt_m_usage: Counter, grunt_f_usage: Counter, grunt_m_count: int, grunt_f_count: int):
    """Print combined usage statistics for all grunts."""
    
    # Combine the counters
    combined_usage = Counter()
    combined_usage.update(grunt_m_usage)
    combined_usage.update(grunt_f_usage)
    
    total_encounters = sum(combined_usage.values())
    unique_species = len(combined_usage)
    
    print(f"\n{'='*50}")
    print("COMBINED GRUNT POKEMON USAGE (ALL GRUNTS)")
    print(f"{'='*50}")
    print(f"Total GruntM trainers: {grunt_m_count}")
    print(f"Total GruntF trainers: {grunt_f_count}")
    print(f"Total grunt trainers: {grunt_m_count + grunt_f_count}")  
    print(f"Total pokemon encounters: {total_encounters}")
    print(f"Unique pokemon species: {unique_species}")
    
    print(f"\nAll pokemon ranked by usage frequency:")
    print("-" * 50)
    
    for i, (pokemon, count) in enumerate(combined_usage.most_common(), 1):
        percentage = (count / total_encounters) * 100
        
        # Show breakdown by grunt type
        m_count = grunt_m_usage.get(pokemon, 0)
        f_count = grunt_f_usage.get(pokemon, 0)
        
        breakdown = f"(M:{m_count}, F:{f_count})"
        print(f"{i:2d}. {pokemon:<15} - {count:2d} times ({percentage:4.1f}%) {breakdown}")

def print_executive_combined_usage_stats(executive_m_usage: Counter, executive_f_usage: Counter, executive_m_count: int, executive_f_count: int):
    """Print combined usage statistics for all executives."""
    
    # Combine the counters
    combined_usage = Counter()
    combined_usage.update(executive_m_usage)
    combined_usage.update(executive_f_usage)
    
    total_encounters = sum(combined_usage.values())
    unique_species = len(combined_usage)
    
    print(f"\n{'='*50}")
    print("COMBINED EXECUTIVE POKEMON USAGE (ALL EXECUTIVES)")
    print(f"{'='*50}")
    print(f"Total ExecutiveM trainers: {executive_m_count}")
    print(f"Total ExecutiveF trainers: {executive_f_count}")
    print(f"Total executive trainers: {executive_m_count + executive_f_count}")  
    print(f"Total pokemon encounters: {total_encounters}")
    print(f"Unique pokemon species: {unique_species}")
    
    print(f"\nAll pokemon ranked by usage frequency:")
    print("-" * 50)
    
    for i, (pokemon, count) in enumerate(combined_usage.most_common(), 1):
        percentage = (count / total_encounters) * 100
        
        # Show breakdown by executive type
        m_count = executive_m_usage.get(pokemon, 0)
        f_count = executive_f_usage.get(pokemon, 0)
        
        breakdown = f"(M:{m_count}, F:{f_count})"
        print(f"{i:2d}. {pokemon:<15} - {count:2d} times ({percentage:4.1f}%) {breakdown}")

def print_comparison(grunt_m_usage: Counter, grunt_f_usage: Counter):
    """Print comparison between GruntM and GruntF usage."""
    
    print(f"\n{'='*50}")
    print("GRUNTM vs GRUNTF COMPARISON")
    print(f"{'='*50}")
    
    # Find common pokemon
    common_pokemon = set(grunt_m_usage.keys()) & set(grunt_f_usage.keys())
    grunt_m_only = set(grunt_m_usage.keys()) - set(grunt_f_usage.keys())
    grunt_f_only = set(grunt_f_usage.keys()) - set(grunt_m_usage.keys())
    
    print(f"Pokemon used by both: {len(common_pokemon)}")
    print(f"Pokemon used only by GruntM: {len(grunt_m_only)}")
    print(f"Pokemon used only by GruntF: {len(grunt_f_only)}")
    
    if common_pokemon:
        print(f"\nCommon pokemon (sorted by total usage):")
        common_with_totals = [(pokemon, grunt_m_usage[pokemon], grunt_f_usage[pokemon], 
                              grunt_m_usage[pokemon] + grunt_f_usage[pokemon]) 
                             for pokemon in common_pokemon]
        common_with_totals.sort(key=lambda x: x[3], reverse=True)
        
        for pokemon, m_count, f_count, total in common_with_totals:
            print(f"  {pokemon:<15} - GruntM: {m_count}, GruntF: {f_count}, Total: {total}")
    
    if grunt_m_only:
        print(f"\nPokemon exclusive to GruntM (sorted by usage):")
        sorted_grunt_m = sorted(grunt_m_only, key=lambda x: grunt_m_usage[x], reverse=True)
        for pokemon in sorted_grunt_m:
            count = grunt_m_usage[pokemon]
            print(f"  {pokemon:<15} - {count} times")
    
    if grunt_f_only:
        print(f"\nPokemon exclusive to GruntF (sorted by usage):")
        sorted_grunt_f = sorted(grunt_f_only, key=lambda x: grunt_f_usage[x], reverse=True)
        for pokemon in sorted_grunt_f:
            count = grunt_f_usage[pokemon]
            print(f"  {pokemon:<15} - {count} times")

def print_executive_comparison(executive_m_usage: Counter, executive_f_usage: Counter):
    """Print comparison between ExecutiveM and ExecutiveF usage."""
    
    print(f"\n{'='*50}")
    print("EXECUTIVEM vs EXECUTIVEF COMPARISON")
    print(f"{'='*50}")
    
    # Find common pokemon
    common_pokemon = set(executive_m_usage.keys()) & set(executive_f_usage.keys())
    executive_m_only = set(executive_m_usage.keys()) - set(executive_f_usage.keys())
    executive_f_only = set(executive_f_usage.keys()) - set(executive_m_usage.keys())
    
    print(f"Pokemon used by both: {len(common_pokemon)}")
    print(f"Pokemon used only by ExecutiveM: {len(executive_m_only)}")
    print(f"Pokemon used only by ExecutiveF: {len(executive_f_only)}")
    
    if common_pokemon:
        print(f"\nCommon pokemon (sorted by total usage):")
        common_with_totals = [(pokemon, executive_m_usage[pokemon], executive_f_usage[pokemon], 
                              executive_m_usage[pokemon] + executive_f_usage[pokemon]) 
                             for pokemon in common_pokemon]
        common_with_totals.sort(key=lambda x: x[3], reverse=True)
        
        for pokemon, m_count, f_count, total in common_with_totals:
            print(f"  {pokemon:<15} - ExecutiveM: {m_count}, ExecutiveF: {f_count}, Total: {total}")
    
    if executive_m_only:
        print(f"\nPokemon exclusive to ExecutiveM (sorted by usage):")
        sorted_executive_m = sorted(executive_m_only, key=lambda x: executive_m_usage[x], reverse=True)
        for pokemon in sorted_executive_m:
            count = executive_m_usage[pokemon]
            print(f"  {pokemon:<15} - {count} times")
    
    if executive_f_only:
        print(f"\nPokemon exclusive to ExecutiveF (sorted by usage):")
        sorted_executive_f = sorted(executive_f_only, key=lambda x: executive_f_usage[x], reverse=True)
        for pokemon in sorted_executive_f:
            count = executive_f_usage[pokemon]
            print(f"  {pokemon:<15} - {count} times")

def main():
    """Main function to run the analysis."""
    
    # Path to the trainer parties file
    file_path = r"data\trainers\parties.asm"
    
    print("Pokemon Usage Analysis for Team Rocket Trainers")
    print("=" * 60)
    print(f"Analyzing file: {file_path}")
    
    try:
        # Parse the trainer data
        grunt_m_data, grunt_f_data, executive_m_data, executive_f_data = parse_trainer_data(file_path)
        
        # Analyze usage
        grunt_m_usage = analyze_pokemon_usage(grunt_m_data, "GruntM")
        grunt_f_usage = analyze_pokemon_usage(grunt_f_data, "GruntF")
        executive_m_usage = analyze_pokemon_usage(executive_m_data, "ExecutiveM")
        executive_f_usage = analyze_pokemon_usage(executive_f_data, "ExecutiveF")
        
        # Print combined grunt statistics
        print_combined_usage_stats(grunt_m_usage, grunt_f_usage, len(grunt_m_data), len(grunt_f_data))
        
        # Print grunt comparison
        print_comparison(grunt_m_usage, grunt_f_usage)
        
        # Print combined executive statistics
        print_executive_combined_usage_stats(executive_m_usage, executive_f_usage, len(executive_m_data), len(executive_f_data))
        
        # Print executive comparison
        print_executive_comparison(executive_m_usage, executive_f_usage)
        
        # Print trainer details if requested
        print(f"\n{'='*50}")
        print("DETAILED TRAINER BREAKDOWN")
        print(f"{'='*50}")
        
        print(f"\nNote: Excluded unused trainers: GruntM_12, GruntM_22, GruntM_23, GruntM_26, GruntM_27, GruntM_30")
        
        print("\nGruntM trainers:")
        for trainer_id in sorted(grunt_m_data.keys(), key=lambda x: int(x.split('_')[1])):
            pokemon_list = ", ".join(grunt_m_data[trainer_id])
            print(f"  {trainer_id:<10}: {pokemon_list}")
        
        print("\nGruntF trainers:")
        for trainer_id in sorted(grunt_f_data.keys(), key=lambda x: int(x.split('_')[1])):
            pokemon_list = ", ".join(grunt_f_data[trainer_id])
            print(f"  {trainer_id:<10}: {pokemon_list}")
        
        print("\nExecutiveM trainers:")
        for trainer_id in sorted(executive_m_data.keys(), key=lambda x: int(x.split('_')[1])):
            pokemon_list = ", ".join(executive_m_data[trainer_id])
            print(f"  {trainer_id:<12}: {pokemon_list}")
        
        print("\nExecutiveF trainers:")
        for trainer_id in sorted(executive_f_data.keys(), key=lambda x: int(x.split('_')[1])):
            pokemon_list = ", ".join(executive_f_data[trainer_id])
            print(f"  {trainer_id:<12}: {pokemon_list}")
            
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found!")
        print("Make sure you're running this script from the correct directory.")
    except Exception as e:
        print(f"Error analyzing file: {e}")

if __name__ == "__main__":
    main()