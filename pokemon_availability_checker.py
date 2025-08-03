#!/usr/bin/env python3
"""
Pokemon Availability Checker for Pokemon Crystal
Analyzes pokemon_data.csv to find Pokemon that cannot be obtained in the game
"""

import csv
import sys
from pathlib import Path
from typing import Set, Dict, List

class PokemonAvailabilityChecker:
    def __init__(self, csv_file: str):
        self.csv_file = Path(csv_file)
        self.pokemon_data = {}
        self.unavailable_pokemon = []
        self.available_pokemon = []
        self.no_encounter_pokemon = []  # Pokemon whose evolution lines have no encounters
        
        # Track Pokemon by exclusive obtainment methods
        self.exclusive_npc_trade = []
        self.exclusive_headbutt = []
        self.exclusive_rock_smash = []
        self.exclusive_gift = []
        
        # Columns that indicate ways to obtain Pokemon
        self.location_columns = [
            'Johto Morning Wild',
            'Johto Day Wild', 
            'Johto Night Wild',
            'Kanto Morning Wild',
            'Kanto Day Wild',
            'Kanto Night Wild',
            'Gift Locations',
            'NPC Trade Locations',
            'Headbutt Tree Locations',
            'Rock Smash Locations',
            'Static Locations'
        ]
        
    def load_pokemon_data(self):
        """Load Pokemon data from the CSV file"""
        if not self.csv_file.exists():
            print(f"Error: CSV file '{self.csv_file}' not found!")
            sys.exit(1)
            
        with open(self.csv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                pokemon_name = row['Pokemon Name']
                self.pokemon_data[pokemon_name] = row
                
        print(f"Loaded data for {len(self.pokemon_data)} Pokemon")
        
    def can_be_obtained_directly(self, pokemon_name: str) -> bool:
        """Check if a Pokemon can be obtained directly (not through evolution)"""
        pokemon = self.pokemon_data.get(pokemon_name, {})
        
        # Check all location columns
        for column in self.location_columns:
            if pokemon.get(column, '').strip():
                return True
                
        # Check if it can be hatched from an egg
        if pokemon.get('Can be Hatched from an Egg', '').strip().lower() == 'yes':
            return True
            
        return False
    
    def has_encounters(self, pokemon_name: str) -> bool:
        """Check if a Pokemon has any encounters (excluding egg hatching)"""
        pokemon = self.pokemon_data.get(pokemon_name, {})
        
        # Check all location columns
        for column in self.location_columns:
            if pokemon.get(column, '').strip():
                return True
        
        return False
    
    def is_exclusively_available_through(self, pokemon_name: str, method: str) -> bool:
        """Check if a Pokemon's entire evolution line is only available through a specific method"""
        evolution_line = self.get_full_evolution_line(pokemon_name)
        
        # Check if any Pokemon in the evolution line has the specified method
        has_method = False
        has_other_methods = False
        
        for evo_pokemon in evolution_line:
            pokemon_data = self.pokemon_data.get(evo_pokemon, {})
            
            # Check for the specific method
            if method == 'trade' and pokemon_data.get('NPC Trade Locations', '').strip():
                has_method = True
            elif method == 'headbutt' and pokemon_data.get('Headbutt Tree Locations', '').strip():
                has_method = True
            elif method == 'rock_smash' and pokemon_data.get('Rock Smash Locations', '').strip():
                has_method = True
            elif method == 'gift' and pokemon_data.get('Gift Locations', '').strip():
                has_method = True
            
            # Check for other methods (excluding the target method and egg hatching)
            other_location_columns = [col for col in self.location_columns 
                                    if col not in ['NPC Trade Locations', 'Headbutt Tree Locations', 'Rock Smash Locations', 'Gift Locations']]
            
            if method != 'trade' and pokemon_data.get('NPC Trade Locations', '').strip():
                has_other_methods = True
            elif method != 'headbutt' and pokemon_data.get('Headbutt Tree Locations', '').strip():
                has_other_methods = True  
            elif method != 'rock_smash' and pokemon_data.get('Rock Smash Locations', '').strip():
                has_other_methods = True
            elif method != 'gift' and pokemon_data.get('Gift Locations', '').strip():
                has_other_methods = True
            elif any(pokemon_data.get(col, '').strip() for col in other_location_columns):
                has_other_methods = True
        
        # Pokemon is exclusive to the method if it has the method but no other methods
        return has_method and not has_other_methods
        
    def can_be_obtained_through_evolution(self, pokemon_name: str, checked_pokemon: Set[str] = None) -> bool:
        """Check if a Pokemon can be obtained through evolution chain"""
        if checked_pokemon is None:
            checked_pokemon = set()
            
        # Avoid infinite loops
        if pokemon_name in checked_pokemon:
            return False
        checked_pokemon.add(pokemon_name)
        
        # Check if this Pokemon can be obtained directly
        if self.can_be_obtained_directly(pokemon_name):
            return True
        
        # If this Pokemon can't be obtained directly, check its pre-evolution
        pokemon = self.pokemon_data.get(pokemon_name, {})
        evolves_from = pokemon.get('Evolves From', '').strip()
        
        if evolves_from:
            # This evolves from another Pokemon, check if that Pokemon is available
            pre_evolution_pokemon = [p.strip() for p in evolves_from.split(',') if p.strip()]
            for pre_evolution in pre_evolution_pokemon:
                if self.can_be_obtained_through_evolution(pre_evolution, checked_pokemon.copy()):
                    return True
        
        # Check if any Pokemon evolves from this one (check evolution chain forward)
        return self.check_evolution_chain_forward(pokemon_name, checked_pokemon.copy())
    
    def check_evolution_chain_forward(self, pokemon_name: str, checked_pokemon: Set[str]) -> bool:
        """Check if any Pokemon in the forward evolution chain can be obtained directly"""
        if pokemon_name in checked_pokemon:
            return False
        checked_pokemon.add(pokemon_name)
        
        # Find all Pokemon that evolve from this one
        for other_pokemon, pokemon_data in self.pokemon_data.items():
            evolves_from = pokemon_data.get('Evolves From', '').strip()
            if evolves_from:
                pre_evolution_pokemon = [p.strip() for p in evolves_from.split(',') if p.strip()]
                if pokemon_name in pre_evolution_pokemon:
                    # This other_pokemon evolves from pokemon_name
                    if self.can_be_obtained_directly(other_pokemon):
                        return True
                    # Recursively check its evolution chain
                    if self.check_evolution_chain_forward(other_pokemon, checked_pokemon.copy()):
                        return True
        
        return False
    
    def evolution_line_has_encounters(self, pokemon_name: str) -> bool:
        """Check if any Pokemon in the entire evolution line has direct encounters"""
        evolution_line = self.get_full_evolution_line(pokemon_name)
        return any(self.can_be_obtained_directly(evo_pokemon) for evo_pokemon in evolution_line)
    
    def evolution_line_has_non_egg_encounters(self, pokemon_name: str) -> bool:
        """Check if any Pokemon in the entire evolution line has encounters (excluding eggs)"""
        evolution_line = self.get_full_evolution_line(pokemon_name)
        return any(self.has_encounters(evo_pokemon) for evo_pokemon in evolution_line)
    
    def get_full_evolution_line(self, pokemon_name: str) -> Set[str]:
        """Get all Pokemon in the same evolution line (both pre and post evolutions)"""
        evolution_line = {pokemon_name}
        
        # Get all pre-evolutions recursively
        def get_pre_evolutions(poke_name: str, visited: Set[str]) -> Set[str]:
            if poke_name in visited:
                return set()
            visited.add(poke_name)
            
            result = {poke_name}
            pokemon_data = self.pokemon_data.get(poke_name, {})
            evolves_from = pokemon_data.get('Evolves From', '').strip()
            
            if evolves_from:
                pre_evolution_pokemon = [p.strip() for p in evolves_from.split(',') if p.strip()]
                for pre_evolution in pre_evolution_pokemon:
                    result.update(get_pre_evolutions(pre_evolution, visited.copy()))
            
            return result
        
        # Get all post-evolutions recursively
        def get_post_evolutions(poke_name: str, visited: Set[str]) -> Set[str]:
            if poke_name in visited:
                return set()
            visited.add(poke_name)
            
            result = {poke_name}
            for other_pokemon, pokemon_data in self.pokemon_data.items():
                evolves_from = pokemon_data.get('Evolves From', '').strip()
                if evolves_from:
                    pre_evolution_pokemon = [p.strip() for p in evolves_from.split(',') if p.strip()]
                    if poke_name in pre_evolution_pokemon:
                        result.update(get_post_evolutions(other_pokemon, visited.copy()))
            
            return result
        
        # Combine pre and post evolutions
        evolution_line.update(get_pre_evolutions(pokemon_name, set()))
        evolution_line.update(get_post_evolutions(pokemon_name, set()))
        
        return evolution_line

    def analyze_availability(self):
        """Analyze which Pokemon are available and which are not"""
        for pokemon_name in self.pokemon_data:
            # A Pokemon is available if:
            # 1. It can be obtained directly, OR
            # 2. Any Pokemon in its evolution line can be obtained directly
            if self.evolution_line_has_encounters(pokemon_name):
                # Check if this Pokemon's evolution line has no non-egg encounters
                if not self.evolution_line_has_non_egg_encounters(pokemon_name):
                    self.no_encounter_pokemon.append(pokemon_name)
                else:
                    self.available_pokemon.append(pokemon_name)
            else:
                self.unavailable_pokemon.append(pokemon_name)
                
        # Sort lists for better readability
        self.available_pokemon.sort()
        self.unavailable_pokemon.sort()
        self.no_encounter_pokemon.sort()
        
        # Find Pokemon exclusively available through specific methods
        for pokemon_name in self.available_pokemon:
            if self.is_exclusively_available_through(pokemon_name, 'trade'):
                self.exclusive_npc_trade.append(pokemon_name)
            elif self.is_exclusively_available_through(pokemon_name, 'headbutt'):
                self.exclusive_headbutt.append(pokemon_name)
            elif self.is_exclusively_available_through(pokemon_name, 'rock_smash'):
                self.exclusive_rock_smash.append(pokemon_name)
            elif self.is_exclusively_available_through(pokemon_name, 'gift'):
                self.exclusive_gift.append(pokemon_name)
        
        self.exclusive_npc_trade.sort()
        self.exclusive_headbutt.sort()
        self.exclusive_rock_smash.sort()
        self.exclusive_gift.sort()
        
    def print_unavailable_pokemon(self):
        """Print Pokemon that cannot be obtained in the game"""
        if not self.unavailable_pokemon:
            print("\n🎉 All Pokemon can be obtained in the game!")
            return
            
        print(f"\n❌ Pokemon that CANNOT be obtained in the game ({len(self.unavailable_pokemon)}):")
        print("=" * 60)
        
        for i, pokemon in enumerate(self.unavailable_pokemon, 1):
            pokemon_data = self.pokemon_data[pokemon]
            evolves_from = pokemon_data.get('Evolves From', '').strip()
            can_hatch = pokemon_data.get('Can be Hatched from an Egg', '').strip().lower() == 'yes'
            
            # Get the full evolution line
            evolution_line = self.get_full_evolution_line(pokemon)
            evolution_line_str = ', '.join(sorted(evolution_line))
            
            print(f"{i:3d}. {pokemon}")
            if evolves_from:
                print(f"     └─ Evolves from: {evolves_from}")
            if can_hatch:
                print(f"     └─ Can be hatched but no way to obtain parents")
            print(f"     └─ Full evolution line: {evolution_line_str}")
            
            # Check if any Pokemon in the evolution line has encounters
            has_encounters = False
            for evo_pokemon in evolution_line:
                if self.can_be_obtained_directly(evo_pokemon):
                    has_encounters = True
                    break
            
            if not has_encounters:
                print(f"     └─ ⚠️  ENTIRE evolution line lacks encounters!")
            print()
    
    def print_no_encounter_pokemon(self):
        """Print Pokemon whose evolution lines have no encounters (only obtainable through breeding)"""
        if not self.no_encounter_pokemon:
            return
            
        print(f"\n� Pokemon whose evolution lines have NO ENCOUNTERS ({len(self.no_encounter_pokemon)}):")
        print("=" * 60)
        print("These Pokemon can only be obtained through breeding (egg hatching)")
        print("=" * 60)
        
        for i, pokemon in enumerate(self.no_encounter_pokemon, 1):
            pokemon_data = self.pokemon_data[pokemon]
            evolves_from = pokemon_data.get('Evolves From', '').strip()
            
            # Get the full evolution line
            evolution_line = self.get_full_evolution_line(pokemon)
            evolution_line_str = ', '.join(sorted(evolution_line))
            
            print(f"{i:3d}. {pokemon}")
            if evolves_from:
                print(f"     └─ Evolves from: {evolves_from}")
            print(f"     └─ Full evolution line: {evolution_line_str}")
            print(f"     └─ ⚠️  No wild/static/gift/trade encounters in entire line!")
            print()
    
    def print_exclusive_obtainment_pokemon(self):
        """Print Pokemon that are exclusively available through specific methods"""
        if not any([self.exclusive_npc_trade, self.exclusive_headbutt, self.exclusive_rock_smash, self.exclusive_gift]):
            return
        
        print(f"\n🎯 Pokemon EXCLUSIVELY available through specific methods:")
        print("=" * 60)
        
        if self.exclusive_gift:
            print(f"\n🎁 Gift Pokemon ONLY ({len(self.exclusive_gift)} Pokemon):")
            print("-" * 40)
            for i, pokemon in enumerate(self.exclusive_gift, 1):
                pokemon_data = self.pokemon_data[pokemon]
                gift_location = pokemon_data.get('Gift Locations', '').strip()
                evolution_line = self.get_full_evolution_line(pokemon)
                evolution_line_str = ', '.join(sorted(evolution_line))
                
                print(f"{i:3d}. {pokemon}")
                print(f"     └─ Gift Locations: {gift_location}")
                print(f"     └─ Evolution line: {evolution_line_str}")
                print()
        
        if self.exclusive_npc_trade:
            print(f"\n💱 NPC Trade ONLY ({len(self.exclusive_npc_trade)} Pokemon):")
            print("-" * 40)
            for i, pokemon in enumerate(self.exclusive_npc_trade, 1):
                pokemon_data = self.pokemon_data[pokemon]
                trade_location = pokemon_data.get('NPC Trade Locations', '').strip()
                evolution_line = self.get_full_evolution_line(pokemon)
                evolution_line_str = ', '.join(sorted(evolution_line))
                
                print(f"{i:3d}. {pokemon}")
                print(f"     └─ Trade Location: {trade_location}")
                print(f"     └─ Evolution line: {evolution_line_str}")
                print()
        
        if self.exclusive_headbutt:
            print(f"\n🌳 Headbutt Trees ONLY ({len(self.exclusive_headbutt)} Pokemon):")
            print("-" * 40)
            for i, pokemon in enumerate(self.exclusive_headbutt, 1):
                pokemon_data = self.pokemon_data[pokemon]
                headbutt_location = pokemon_data.get('Headbutt Tree Locations', '').strip()
                evolution_line = self.get_full_evolution_line(pokemon)
                evolution_line_str = ', '.join(sorted(evolution_line))
                
                print(f"{i:3d}. {pokemon}")
                print(f"     └─ Headbutt Locations: {headbutt_location}")
                print(f"     └─ Evolution line: {evolution_line_str}")
                print()
        
        if self.exclusive_rock_smash:
            print(f"\n🪨 Rock Smash ONLY ({len(self.exclusive_rock_smash)} Pokemon):")
            print("-" * 40)
            for i, pokemon in enumerate(self.exclusive_rock_smash, 1):
                pokemon_data = self.pokemon_data[pokemon]
                rock_smash_location = pokemon_data.get('Rock Smash Locations', '').strip()
                evolution_line = self.get_full_evolution_line(pokemon)
                evolution_line_str = ', '.join(sorted(evolution_line))
                
                print(f"{i:3d}. {pokemon}")
                print(f"     └─ Rock Smash Locations: {rock_smash_location}")
                print(f"     └─ Evolution line: {evolution_line_str}")
                print()
            
    def print_availability_summary(self):
        """Print a summary of Pokemon availability"""
        total_pokemon = len(self.pokemon_data)
        available_count = len(self.available_pokemon)
        unavailable_count = len(self.unavailable_pokemon)
        no_encounter_count = len(self.no_encounter_pokemon)
        
        print("\n" + "=" * 60)
        print("POKEMON AVAILABILITY SUMMARY")
        print("=" * 60)
        print(f"Total Pokemon: {total_pokemon}")
        print(f"Available with encounters: {available_count} ({available_count/total_pokemon*100:.1f}%)")
        print(f"Breeding only (no encounters): {no_encounter_count} ({no_encounter_count/total_pokemon*100:.1f}%)")
        print(f"Unavailable: {unavailable_count} ({unavailable_count/total_pokemon*100:.1f}%)")
        print(f"Total obtainable: {available_count + no_encounter_count} ({(available_count + no_encounter_count)/total_pokemon*100:.1f}%)")
        
    def print_obtainment_methods_summary(self):
        """Print a summary of how Pokemon can be obtained"""
        methods = {
            'Wild Encounters': 0,
            'Gift Pokemon': 0,
            'NPC Trades': 0,
            'Static Encounters': 0,
            'Headbutt Trees': 0,
            'Rock Smash': 0,
            'Breeding Only': 0,
            'Evolution Only': 0
        }
        
        for pokemon_name, pokemon_data in self.pokemon_data.items():
            if pokemon_name in self.unavailable_pokemon:
                continue
                
            # Check each method
            has_wild = any(pokemon_data.get(col, '').strip() for col in [
                'Johto Morning Wild', 'Johto Day Wild', 'Johto Night Wild',
                'Kanto Morning Wild', 'Kanto Day Wild', 'Kanto Night Wild'
            ])
            has_gift = pokemon_data.get('Gift Locations', '').strip()
            has_trade = pokemon_data.get('NPC Trade Locations', '').strip()
            has_static = pokemon_data.get('Static Locations', '').strip()
            has_headbutt = pokemon_data.get('Headbutt Tree Locations', '').strip()
            has_rock_smash = pokemon_data.get('Rock Smash Locations', '').strip()
            can_hatch = pokemon_data.get('Can be Hatched from an Egg', '').strip().lower() == 'yes'
            
            # Count primary obtainment method
            if has_wild:
                methods['Wild Encounters'] += 1
            elif has_gift:
                methods['Gift Pokemon'] += 1
            elif has_trade:
                methods['NPC Trades'] += 1
            elif has_static:
                methods['Static Encounters'] += 1
            elif has_headbutt:
                methods['Headbutt Trees'] += 1
            elif has_rock_smash:
                methods['Rock Smash'] += 1
            elif can_hatch and pokemon_name in self.no_encounter_pokemon:
                methods['Breeding Only'] += 1
            else:
                methods['Evolution Only'] += 1
                
        print("\n" + "=" * 60)
        print("OBTAINMENT METHODS SUMMARY")
        print("=" * 60)
        for method, count in methods.items():
            if count > 0:
                print(f"{method}: {count}")
                
    def export_unavailable_list(self, output_file: str = "unavailable_pokemon.txt"):
        """Export list of unavailable Pokemon to a text file"""
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("Pokemon that cannot be obtained in the game:\n")
            f.write("=" * 50 + "\n\n")
            
            for i, pokemon in enumerate(self.unavailable_pokemon, 1):
                pokemon_data = self.pokemon_data[pokemon]
                evolves_from = pokemon_data.get('Evolves From', '').strip()
                
                f.write(f"{i:3d}. {pokemon}\n")
                if evolves_from:
                    f.write(f"     Evolves from: {evolves_from}\n")
                f.write("\n")
                
        print(f"\nUnavailable Pokemon list exported to: {output_file}")
        
    def run_analysis(self):
        """Run the complete availability analysis"""
        print("Pokemon Availability Checker")
        print("=" * 40)
        
        self.load_pokemon_data()
        print("Analyzing Pokemon availability...")
        self.analyze_availability()
        
        self.print_availability_summary()
        self.print_obtainment_methods_summary()
        
        if self.unavailable_pokemon:
            self.print_unavailable_pokemon()
        
        if self.no_encounter_pokemon:
            self.print_no_encounter_pokemon()
        
        # Print exclusive obtainment methods
        self.print_exclusive_obtainment_pokemon()
        
        if self.unavailable_pokemon:
            export_choice = input("\nWould you like to export the unavailable Pokemon list to a file? (y/n): ")
            if export_choice.lower() in ['y', 'yes']:
                self.export_unavailable_list()


def main():
    """Main function"""
    csv_file = "pokemon_data.csv"
    
    # Check if CSV file exists
    if len(sys.argv) > 1:
        csv_file = sys.argv[1]
    
    checker = PokemonAvailabilityChecker(csv_file)
    checker.run_analysis()


if __name__ == "__main__":
    main()
