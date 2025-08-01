#!/usr/bin/env python3
"""
Script to update Pokemon base stats from legacy files to current format.

This script reads legacy base stat files from the current directory and applies
specific attributes to the corresponding files in data/pokemon/base_stats.

Updated attributes:
- Base stats (HP, Attack, Defense, Speed, Special Attack, Special Defense)
- Catch rate
- Base experience
- Gender ratio
- Step cycles to hatch
- Growth rate
- TM/HM learnset
"""

import os
import re
import sys
from pathlib import Path


def parse_legacy_file(file_path):
    """Parse a legacy base stat file and extract the required values."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    data = {}
    
    # Extract base stats line (6 values after the first db line)
    base_stats_match = re.search(r'db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)', content)
    if base_stats_match:
        data['base_stats'] = f"db {', '.join([f'{int(x):3d}' for x in base_stats_match.groups()])}"
    
    # Extract catch rate
    catch_rate_match = re.search(r'db\s+(\d+)\s*;\s*catch rate', content)
    if catch_rate_match:
        data['catch_rate'] = f"db {catch_rate_match.group(1)} ; catch rate"
    
    # Extract base experience
    base_exp_match = re.search(r'db\s+(\d+)\s*;\s*base exp', content)
    if base_exp_match:
        data['base_exp'] = f"db {base_exp_match.group(1)} ; base exp"
    
    # Extract gender ratio
    gender_match = re.search(r'db\s+(GENDER_[A-Z0-9_]+)\s*;\s*gender ratio', content)
    if gender_match:
        data['gender_ratio'] = f"db {gender_match.group(1)} ; gender ratio"
    
    # Extract step cycles to hatch
    hatch_match = re.search(r'db\s+(\d+)\s*;\s*step cycles to hatch', content)
    if hatch_match:
        data['step_cycles'] = f"db {hatch_match.group(1)} ; step cycles to hatch"
    
    # Extract growth rate
    growth_match = re.search(r'db\s+(GROWTH_[A-Z_]+)\s*;\s*growth rate', content)
    if growth_match:
        data['growth_rate'] = f"db {growth_match.group(1)} ; growth rate"
    
    # Extract TM/HM learnset (everything after "; tm/hm learnset" until "; end")
    tmhm_match = re.search(r';\s*tm/hm learnset\s*\n\s*tmhm\s+(.*?)\s*;\s*end', content, re.DOTALL)
    if tmhm_match:
        # Clean up the learnset line
        learnset = re.sub(r'\s+', ' ', tmhm_match.group(1).strip())
        data['tmhm_learnset'] = f"tmhm {learnset}"
    
    return data


def update_current_file(current_file_path, legacy_data):
    """Update the current base stat file with data from the legacy file."""
    if not os.path.exists(current_file_path):
        print(f"Warning: Current file not found: {current_file_path}")
        return False, []
    
    with open(current_file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    lines = content.split('\n')
    updated_lines = []
    changes_made = []
    i = 0
    
    while i < len(lines):
        line = lines[i].strip()
        original_line = lines[i]
        
        # Update base stats (look for the pattern with 6 numbers)
        if re.match(r'\s*db\s+\d+,\s*\d+,\s*\d+,\s*\d+,\s*\d+,\s*\d+', lines[i]):
            if 'base_stats' in legacy_data:
                new_line = f"\t{legacy_data['base_stats']}"
                if original_line.strip() != new_line.strip():
                    changes_made.append(f"base_stats: {original_line.strip()} -> {new_line.strip()}")
                updated_lines.append(new_line)
            else:
                updated_lines.append(lines[i])
        
        # Update catch rate
        elif re.search(r'db\s+\d+\s*;\s*catch rate', line):
            if 'catch_rate' in legacy_data:
                new_line = f"\t{legacy_data['catch_rate']}"
                if original_line.strip() != new_line.strip():
                    changes_made.append(f"catch_rate: {original_line.strip()} -> {new_line.strip()}")
                updated_lines.append(new_line)
            else:
                updated_lines.append(lines[i])
        
        # Update base experience
        elif re.search(r'db\s+\d+\s*;\s*base exp', line):
            if 'base_exp' in legacy_data:
                new_line = f"\t{legacy_data['base_exp']}"
                if original_line.strip() != new_line.strip():
                    changes_made.append(f"base_exp: {original_line.strip()} -> {new_line.strip()}")
                updated_lines.append(new_line)
            else:
                updated_lines.append(lines[i])
        
        # Update gender ratio
        elif re.search(r'db\s+GENDER_[A-Z0-9_]+\s*;\s*gender ratio', line):
            if 'gender_ratio' in legacy_data:
                new_line = f"\t{legacy_data['gender_ratio']}"
                if original_line.strip() != new_line.strip():
                    changes_made.append(f"gender_ratio: {original_line.strip()} -> {new_line.strip()}")
                updated_lines.append(new_line)
            else:
                updated_lines.append(lines[i])
        
        # Update step cycles to hatch
        elif re.search(r'db\s+\d+\s*;\s*step cycles to hatch', line):
            if 'step_cycles' in legacy_data:
                new_line = f"\t{legacy_data['step_cycles']}"
                if original_line.strip() != new_line.strip():
                    changes_made.append(f"step_cycles: {original_line.strip()} -> {new_line.strip()}")
                updated_lines.append(new_line)
            else:
                updated_lines.append(lines[i])
        
        # Update growth rate
        elif re.search(r'db\s+GROWTH_[A-Z_]+\s*;\s*growth rate', line):
            if 'growth_rate' in legacy_data:
                new_line = f"\t{legacy_data['growth_rate']}"
                if original_line.strip() != new_line.strip():
                    changes_made.append(f"growth_rate: {original_line.strip()} -> {new_line.strip()}")
                updated_lines.append(new_line)
            else:
                updated_lines.append(lines[i])
        
        # Update TM/HM learnset
        elif line.startswith('tmhm ') and 'tmhm_learnset' in legacy_data:
            new_line = f"\t{legacy_data['tmhm_learnset']}"
            if original_line.strip() != new_line.strip():
                changes_made.append(f"tmhm_learnset: UPDATED")
            updated_lines.append(new_line)
        
        else:
            updated_lines.append(lines[i])
        
        i += 1
    
    # Only write if there were changes
    if changes_made:
        updated_content = '\n'.join(updated_lines)
        with open(current_file_path, 'w', encoding='utf-8') as f:
            f.write(updated_content)
        return True, changes_made
    
    return False, []


def main():
    """Main function to process all legacy files."""
    script_dir = Path(__file__).parent
    legacy_dir = script_dir
    base_stats_dir = script_dir.parent.parent.parent / 'data' / 'pokemon' / 'base_stats'
    
    if not base_stats_dir.exists():
        print(f"Error: Base stats directory not found: {base_stats_dir}")
        sys.exit(1)
    
    print(f"Processing legacy files from: {legacy_dir}")
    print(f"Updating files in: {base_stats_dir}")
    print()
    
    processed_count = 0
    updated_count = 0
    all_changes = {}
    
    # Process all .asm files in the legacy directory (except this script)
    for legacy_file in legacy_dir.glob('*.asm'):
        if legacy_file.name == 'update_base_stats.py':
            continue
            
        pokemon_name = legacy_file.stem
        current_file = base_stats_dir / f"{pokemon_name}.asm"
        
        print(f"Processing {pokemon_name}...")
        
        # Parse legacy file
        try:
            legacy_data = parse_legacy_file(legacy_file)
            processed_count += 1
            
            if not legacy_data:
                print(f"  Warning: No data extracted from {legacy_file}")
                continue
            
            # Update current file
            was_updated, changes = update_current_file(current_file, legacy_data)
            if was_updated:
                updated_count += 1
                all_changes[pokemon_name] = changes
                print(f"  ✓ Updated {pokemon_name} with {len(changes)} changes:")
                for change in changes:
                    print(f"    - {change}")
            else:
                if changes:  # This means the file was found but no changes were needed
                    print(f"  ○ No changes needed for {pokemon_name}")
                else:
                    print(f"  ✗ Failed to update {pokemon_name}")
                
        except Exception as e:
            print(f"  ✗ Error processing {pokemon_name}: {e}")
    
    print()
    print("=" * 60)
    print("SUMMARY:")
    print(f"Processed {processed_count} legacy files")
    print(f"Updated {updated_count} current files")
    
    # Prepare summary content for both console and file output
    summary_lines = []
    summary_lines.append("Pokemon Base Stats Update Summary")
    summary_lines.append("=" * 40)
    summary_lines.append(f"Date: {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    summary_lines.append(f"Processed: {processed_count} legacy files")
    summary_lines.append(f"Updated: {updated_count} current files")
    summary_lines.append("")
    
    if all_changes:
        print(f"\nPokemon with changes ({len(all_changes)}):")
        summary_lines.append(f"Pokemon with changes ({len(all_changes)}):")
        summary_lines.append("")
        
        for pokemon, changes in all_changes.items():
            print(f"\n{pokemon.upper()}:")
            summary_lines.append(f"{pokemon.upper()}:")
            for change in changes:
                print(f"  - {change}")
                summary_lines.append(f"  - {change}")
            summary_lines.append("")
    else:
        print("\nNo Pokemon files were changed.")
        summary_lines.append("No Pokemon files were changed.")
    
    # Write summary to file
    summary_file = script_dir / "update_summary.txt"
    try:
        with open(summary_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(summary_lines))
        print(f"\nSummary written to: {summary_file}")
    except Exception as e:
        print(f"\nWarning: Could not write summary file: {e}")
    
    print("\nDone!")


if __name__ == "__main__":
    main()
