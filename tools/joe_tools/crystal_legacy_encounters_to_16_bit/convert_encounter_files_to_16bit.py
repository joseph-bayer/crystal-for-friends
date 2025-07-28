#!/usr/bin/env python3
"""
Pokemon Crystal Legacy - Wild Pokemon Data Converter to 16-bit

This script converts wild Pokemon encounter data from 8-bit (db) format to 16-bit (dbw) format.
It processes johto_grass.asm, kanto_grass.asm, johto_water.asm, and kanto_water.asm files.

Usage:
    python convert_to_16bit.py [input_dir] [output_dir]

If no arguments provided, it will look for files in ./data/wild/ and output to ./data/wild/16bit/
"""

import os
import sys
import re
from pathlib import Path


def convert_pokemon_encounter_line(line):
    """
    Convert a single line containing Pokemon encounter data from db to dbw format.
    
    Args:
        line (str): Input line that may contain 'db level, POKEMON'
        
    Returns:
        str: Converted line with 'dbw level, POKEMON' if applicable, otherwise unchanged
    """
    # Pattern to match lines like "db 3, RATTATA" or "db 15, SLOWPOKE"
    # This pattern captures the indentation, level, and pokemon name
    pattern = r'^(\s*)(db)\s+(\d+),\s+([A-Z_]+)(.*)$'
    match = re.match(pattern, line)
    
    if match:
        indent, db_keyword, level, pokemon, rest = match.groups()
        # Replace 'db' with 'dbw'
        return f"{indent}dbw {level}, {pokemon}{rest}\n"
    
    # Return line unchanged if it doesn't match the pattern
    return line


def convert_file(input_path, output_path):
    """
    Convert a single wild Pokemon encounter file from 8-bit to 16-bit format.
    
    Args:
        input_path (str or Path): Path to input .asm file
        output_path (str or Path): Path to output .asm file
    """
    input_path = Path(input_path)
    output_path = Path(output_path)
    
    if not input_path.exists():
        print(f"Warning: Input file {input_path} does not exist. Skipping.")
        return False
    
    # Ensure output directory exists
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    try:
        with open(input_path, 'r', encoding='utf-8') as infile:
            lines = infile.readlines()
        
        converted_lines = []
        conversion_count = 0
        
        for line in lines:
            original_line = line
            converted_line = convert_pokemon_encounter_line(line)
            converted_lines.append(converted_line)
            
            # Count conversions for reporting
            if original_line != converted_line:
                conversion_count += 1
        
        with open(output_path, 'w', encoding='utf-8') as outfile:
            outfile.writelines(converted_lines)
        
        print(f"Converted {input_path.name}: {conversion_count} Pokemon encounters converted")
        return True
        
    except Exception as e:
        print(f"Error converting {input_path}: {e}")
        return False


def main():
    """Main function to process all target files."""
    
    # Default paths
    default_input_dir = Path("data/wild")
    default_output_dir = Path("data/wild/16bit")
    
    # Parse command line arguments
    if len(sys.argv) >= 2:
        input_dir = Path(sys.argv[1])
    else:
        input_dir = default_input_dir
        
    if len(sys.argv) >= 3:
        output_dir = Path(sys.argv[2])
    else:
        output_dir = default_output_dir
    
    # Files to convert
    target_files = [
        "johto_grass.asm",
        "kanto_grass.asm", 
        "johto_water.asm",
        "kanto_water.asm"
    ]
    
    print(f"Converting Pokemon encounter files from {input_dir} to {output_dir}")
    print("=" * 60)
    
    success_count = 0
    total_count = len(target_files)
    
    for filename in target_files:
        input_path = input_dir / filename
        output_path = output_dir / filename
        
        if convert_file(input_path, output_path):
            success_count += 1
    
    print("=" * 60)
    print(f"Conversion complete: {success_count}/{total_count} files processed successfully")
    
    if success_count > 0:
        print(f"\nConverted files saved to: {output_dir}")
        print("\nConverted files:")
        for filename in target_files:
            output_path = output_dir / filename
            if output_path.exists():
                print(f"  - {output_path}")


if __name__ == "__main__":
    main()
