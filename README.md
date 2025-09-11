# Crystal For Friends

This is a version of Pokemon Crystal meant for me and my friends. It is built upon the CrystalShireEngine.

## Changes
- **Built upon the CrystalShireEngine** See section below titled "CrystalShireEngine" to see the README for that project

- **Rebalances based heavily upon Crystal Legacy** Credits: [Crystal Legacy Team](https://github.com/cRz-Shadows/Pokemon_Crystal_Legacy)
  - Trainer Teams
  - Dynamic teams for CHUCK, PRYCE, and JASMINE depending on the order you face them in
  - Wild Encounters
  - NPC Trades
  - Fossils
    - Solve the fossil mon puzzles in the Ruins of Alph for each respective fossil
  - Celebi Event
    - Solve the Ho-Oh puzzle in the Ruins of Alph
  - Game Corner Prizes
  - Updated Evolution methods
  - Level-up learnsets
  - TM/HM learnsets
  - Reduced hatch cycles
  - Hatch Cycles
  - Move updates

- **All 251 Pokemon Available**
  - TODO: All Pokemon available
    - TODO: Articuno
    - TODO: Zapdos
    - TODO: Moltres
    - TODO: Mewtwo
    - TODO: Mew

- **Type Rebalance**
  - Dark type moves are now Physical
  - Ghost type moves are now Special

- **Odd Egg Upgrades**
  - Always Shiny
  - Odds of getting each kind of mon is more even

- **Track Caught Ball**
  - The ball that a Pokemon is caught in is displayed on the stats screen

- **Wild Held Item Rebalance**
	- Wild Pokemon are more likely to hold items

	| Common Item | Rare Item |
	|----------------|-------------------|
	| **40%** *(+17%)* | **10%** *(+8%)* |

- **Flee Mechanic Upgrades**
	- Only Roaming Legendaries flee wild battles

- **Hidden Power Upgrades**
  - Base Power is always 60 Credits: [Grate Oracle Lewot](https://github.com/Grate-Oracle-Lewot)
  - TODO: Display Hidden Power type on Stats Screen

- **Headbutt Tree Encounters Simplified**
  - Headbutting a headbutt tree always results in a Pokemon appearing
  - Each area type has one encounter table instead of a common and uncommon table

- **Breeding Upgrades** 
  - Fewer step cycles required to hatch eggs
  - Update "hatching soon" and egg animation logic to scale down with the lower overall cycles
  - Egg has blue spots when shiny
  - Daycare man stands outside fence when egg is ready 
  - Updated Route 34 map to remove grass patch in egg hatching path
  - Removed trainer ID penalty (same trainer IDs no longer reduce compatibility)
  - Improved egg generation rates:
    | Pokemon Pairing | Egg Generation Chance |
    |----------------|-------------------|
    | Same species | 50% |
    | Different species | 25% |

- **Mystery Gift with various NPCs**
  - Improved rarity distribution - Uncommon, rare, and super rare items appear more often
  - All evolution items can be obtained from Mystery Gifting with NPCs
  - Locations
    - Carrie (Goldenrod Dept. Store 5f)
    - Kim (Blackthorn City)
    - Charlie (Silph Co. 1f)
    - TODO: Pocky
  - Limit once per day, per NPC

- **New and Updated Daily Events**
  - Bug Catching Contest now appears on Sundays as well (on top of Tuesdays, Thursdays, and Saturdays)

- **New Cosmetic Forms**
  - Cosmetic Forms
    - Pikachu
      - Unlocked by Learning Surf

- **Misc.**
  - Turn around after healing in the Pokecenter so you don't accidentally heal again
  - Minor update to Goldenrod layout so it's easier to get to the underground and the bike shop


## Below, you will find the original readme for the CrystalShireEngine

---

# CrystalShireEngine (CSE)

CrystalShireEngine (CSE) is an enhanced engine for Pokemon Crystal romhacking.

#### CSE is currently still **under developement**. You will likely experience significant bugs and differences in the engine compared to vanilla pokecrystal. If you wish to use CSE, we highly recommend you join our [discord server](https://discord.gg/dvpf6wcqMn) for support. We need your help to identify bugs, so we may improve the engine for everyone!

## Features

- **Extended 16-bit Indexes:** Pokemon & Moves. Detailed info & usage can be found at the [pokecrystal16 wiki](https://github.com/vulcandth/pokecrystal16/wiki). Credits: [aaaaaa123456789](https://github.com/aaaaaa123456789), [vulcandth](https://github.com/vulcandth), [Rangi42](https://github.com/Rangi42).
- **Newbox:** Complete overhaul of Bill's PC. Credits: [Rangi42](https://github.com/Rangi42), [FredrIQ](https://github.com/FredrIQ), [vulcandth](https://github.com/vulcandth).
- **Assembly Optimizations:** Provides minor improvements in CPU cycles and memory usage.
- **Improved Farcall:** From PolishedCrystal, preserves all registers. Credits: [Rangi42](https://github.com/Rangi42), [FredrIQ](https://github.com/FredrIQ), Pokemon Polished Crystal.
- **60fps Overworld & CGB Doublespeed Mode:** Experience smoother gameplay with a 60fps overworld and enhanced performance on Color Game Boy. Credits: [vulcandth](https://github.com/vulcandth), [FredrIQ](https://github.com/FredrIQ), [luckytyphlosion](https://github.com/luckytyphlosion).
- **Running Shoes:** Press the B button to use running shoes, making navigation faster. Credits: [vulcandth](https://github.com/vulcandth), [FredrIQ](https://github.com/FredrIQ), [luckytyphlosion](https://github.com/luckytyphlosion).
- **Gender-Accurate Link Battle/Trade Rooms:** Resolved the issue where playing as a girl (Kris) would result in the sprite changing to a boy (Chris) in Link Battle or Link Trade rooms. Gender information is now preserved during link communications, allowing for accurate representation of both players. Credits: [vulcandth](https://github.com/vulcandth).
- **Enhance Tileset Functionality:** Expanded tilesets from 192 to 384 tiles with gateless map connections and allowed tiles to have different attributes in various blocks. Credits: [Rangi42](https://github.com/Rangi42), [vulcandth](https://github.com/vulcandth), Pokemon Polished Crystal.
- **Enhance Trainer Card Features:** Added a third page for Kanto badges, introduced colors to badges, and fixed missing tops of Gym Leaders' heads on the trainer card.
- **Unique Colors for Poké Balls:** Added unique colors for each type of Poké Ball. Credits: [SoupPotato](https://github.com/SoupPotato), [Rangi42](https://github.com/Rangi42).
- **Short Low HP Beep:** Replaced continuous low hp beeping with a shorter sound.
- **Show Weather Icon:** Added an icon to show the current weather during battles.
- **Optimize Various Routines and Functions:** Optimized several functions including EnterMapConnection, GetSquareRoot, VBlank routines, LZ decompression, UpdateBGMap, and Multiply and Divide. Credits: [Rangi42](https://github.com/Rangi42), Pokemon Polished Crystal, Pokemon Prism.
- **Split Maps Section:** Split the 'Maps' section into 'Map Headers' and 'Map Attributes'.
- **Copy BillsPC_LCDCode to WRAM0:** Copied BillsPC_LCDCode to WRAM0. Credits: [FredrIQ](https://github.com/FredrIQ), Pokemon Polished Crystal.
- **Optimize and Define LZ Compression:** Improved LZ compression through adding defines, implementing Meithecatte's optimization in ax6's lzcomp, and optimizing lz counts to use 9 bits. Credits: [ariscop](https://github.com/ariscop), Pokemon Polished Crystal.
- **Port Utils/Farcheck.py:** Ported farcheck.py from Polished Crystal. Credits: [Rangi42](https://github.com/Rangi42), Pokemon Polished Crystal.
- **Port Prism's LoadMapPart:** Ported LoadMapPart function from Prism. Credits: Pokemon Prism.
- **Port Battle Pal Changing:** Ported battle pal changing feature from Polished Crystal. Credits: [FredrIQ](https://github.com/FredrIQ), Pokemon Polished Crystal.
- **Replace Stat Experience with EVs:** Implemented EV system, replacing stat experience.
- **Dynamic OW OBJ Pal System:** Overworld Objects now load their palette dynamically. Credits: [vulcandth](https://github.com/vulcandth), [Rangi42](https://github.com/Rangi42), Pokemon Polished Crystal, Pokmeon Mystic Crystal.
- **Dynamic Sprite Reload:** Reloaded dynamic sprites. Credits: [FredrIQ](https://github.com/FredrIQ), Pokemon Polished Crystal.
- **Smooth Fading Routines** Port smooth fading routines from Polished Crystal/Prism. Credits: [Rangi42](https://github.com/Rangi42), [FredrIQ](https://github.com/FredrIQ), Pokemon Polished Crystal, Pokemon Prism.
- **newbag:** A refactor of the backpack, which includes the ability to expand pockets in the bag. Credits: [Monstarules](https://github.com/Monstarules)
- **Sliding Map Sign:** Map sign slides into view, ported from Polished Crystal. Credits: [Rangi42](https://github.com/Rangi42), [FredrIQ](https://github.com/FredrIQ).
- **Deferred Map Graphics Loading:** Map graphics load after map connections for smoother transitions.
- **Expanded Battle Animation Limit:** Allows more animation objects for custom battle animations.


## Contributions

We warmly welcome contributions to the CrystalShireEngine project. If you're interested in contributing, please contact [vulcandth](https://github.com/vulcandth) on Discord to discuss how you can help!

## Branch Structure

- **core:** The default branch, aimed at integrating optimizations, bug & design flaw fixes, and various other engine improvements to support rom hacking.
- **gen3, gen4, ...:** Upcoming branches set to incorporate a plethora of features (pokemon, moves, mechanics, etc.) from respective generations into the Crystal engine.
