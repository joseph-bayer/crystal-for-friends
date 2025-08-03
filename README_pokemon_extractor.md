# Pokemon Data Extractor for Pokemon Crystal

This Python script extracts Pokemon location and evolution data from the Pokemon Crystal assembly source files and generates a comprehensive CSV table.

## Features

The script generates a CSV file with the following columns for each Pokemon:
- **Pokemon Name**: The Pokemon's constant name (e.g., BULBASAUR)
- **Johto Wild Locations**: Where the Pokemon can be found in Johto wild grass encounters
- **Kanto Wild Locations**: Where the Pokemon can be found in Kanto wild grass encounters
- **Swarm Locations**: Where the Pokemon can be found during swarms
- **Gift Locations**: Where the Pokemon is given as a gift (via `givepoke` commands)
- **Evolves From**: Which Pokemon evolves into this one

## Usage

1. Place the script in the root directory of your Pokemon Crystal source code
2. Run the script:
   ```bash
   python pokemon_data_extractor.py
   ```
3. The script will generate `pokemon_data.csv` in the same directory

## Data Sources

The script extracts data from the following files:
- `constants/pokemon_constants.asm` - Pokemon name constants
- `data/wild/kanto_grass.asm` - Kanto wild encounters
- `data/wild/johto_grass.asm` - Johto wild encounters  
- `data/wild/swarm_grass.asm` - Swarm encounters
- `maps/*.asm` - Gift Pokemon (excludes PlayersHouse2F.asm and unused/ folder)
- `data/pokemon/evos_attacks_kanto.asm` - Evolution data
- `data/pokemon/evos_attacks_johto.asm` - Evolution data

## Adding Context Overrides

You can add manual overrides to provide additional context for Pokemon locations. This is useful for adding information that isn't easily parsed from the assembly files.

### Example Overrides

In the `main()` function, you can add overrides like this:

```python
# Add context that Aerodactyl is given at Ruins of Alph after solving puzzle
extractor.add_override("AERODACTYL", "gift", "Ruins of Alph Research Lab (Aerodactyl puzzle)")

# Add more specific context for other Pokemon
extractor.add_override("TOGEPI", "gift", "Professor Elm's assistant (after completing Pokedex)")
extractor.add_override("LAPRAS", "gift", "Union Cave (Fridays)")
extractor.add_override("RED_GYARADOS", "johto_wild", "Lake of Rage (special encounter)")
```

### Override Categories

The second parameter specifies the data category:
- `"johto_wild"` - Johto wild encounter locations
- `"kanto_wild"` - Kanto wild encounter locations
- `"swarm"` - Swarm locations  
- `"gift"` - Gift Pokemon locations
- `"evolution"` - Evolution relationships

### Adding New Overrides

To add new overrides, simply add more `add_override()` calls in the `main()` function before `extractor.run_extraction()`. The override data will be merged with the automatically extracted data.

## Output Format

The CSV file uses commas (`,`) to separate multiple locations within the same category. For example:

```csv
Pokemon Name,Johto Wild Locations,Kanto Wild Locations,Swarm Locations,Gift Locations,Evolves From
DRATINI,,,,"Dragon Shrine, Goldenrod Game Corner",
AERODACTYL,,,,"Ruins Of Alph Research Center, Ruins of Alph Research Lab (Aerodactyl puzzle)",
IVYSAUR,,,,BULBASAUR
```

## Statistics

The script provides statistics after completion:
- Total Pokemon processed
- Pokemon found in wild encounters
- Pokemon found in swarms
- Pokemon given as gifts
- Pokemon with evolution data

## Customization

The script is designed to be easily extensible. You can:
- Add new data sources by creating additional parsing methods
- Modify the output format by editing the `generate_csv()` method
- Add new override categories as needed
- Customize location name formatting in the parsing methods

## Requirements

- Python 3.6+
- No external dependencies (uses only standard library)
