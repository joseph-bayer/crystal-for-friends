# Pokemon Crystal Crunch

> **Disclaimer:** Generative AI was used as a code assistant for some systems programming. All art/maps/dialogue (and everything creative) was made by myself and the community or was commissioned from real artists.

This is a hack of Pokemon Crystal meant to make you smile. All systems were designed with a pre gen 3 mindset. Other hacks already port new features like abilities, new moves, new items, etc. into Crystal (and do it incredibly well), so I don't see a reason to tread the same ground. There are exceptions to this rule when it comes to QoL - for example, the storage system now uses the Gen 3 UI.

## Changes
- **All 251 Pokemon Available**
  - TODO: All Pokemon available
    - Articuno, Zapdos and Moltres appear once you have all 16 badges: Zapdos outside the Power Plant on Route 10, Articuno on Route 20 near the Seafoam Islands, and Moltres in Victory Road.
      - The locations of Zapdos and Articuno may be temporary and may be updated in the future.
    - TODO: Mewtwo
    - TODO: Mew

- **Following Pokemon**
  - Press **Select** on a party member to make it your follower
  - A fainted follower waits in its Poke Ball, and comes back out when you heal it
  - Eggs can follow you too!

- **Wild Pokemon in the Overworld**
  - Many routes and towns have Pokemon wandering in the open
  - Walk into one, or face it and press **A**, to start a wild battle
  - What you see is what you fight - a shiny out in the grass is shiny in the battle
  - They are worth chasing: better DVs, far more likely to be holding an item, and better shiny odds than the same Pokemon in the grass
  - Some know egg moves or otherwise unobtainable moves 
  - Some turn up in forms you cannot find any other way
  - A chime plays when you walk into an area that has a shiny in it
  - Who turns up is decided fresh each time you enter an area, so it is worth passing back through

- **Hidden Power Overhaul**
  - Every Pokemon's Hidden Power attack power can be increased via various methods. The attack power starts at **20** and caps at **70**. Unown cap at **120**.
  - Every 256 steps a Pokemon's Hidden Power attack power can go up via the following methods:
    - Pokemon holding a new item, the **GLYPH SHARD**, get a 25% chance to increase their power.
	- The GLYPH SHARD can be found as a rare item on wild Unown.
    - If an Unown is in the party, every Pokemon in the party gets a 25% chance to increase their power.
  - Hidden Power can be Physical or Special, depending on which of its user's stat is higher (no longer dependant on type).
  - **The Shaman**: Based on the TCG card art for Desert Shaman illustrated by Kagemaru Himeno. Meet her at the Ruins of Alph Research Center, then visit her house in the Ruins of Alph
    - She unlocks a 4th stats page showing each Pokemon's Hidden Power type and level
    - She gives you your first GLYPH SHARD
    - She teaches Hidden Power for free, any time

- **HM Upgrades**
  - You can use an HM outside of battle if a Pokemon in your party can learn it, as long as you have the HM in your bag. It doesn't have to know the move
  - Rock Smash works the same way once you've received its TM, even if you've since taught it
  - Headbutt still has to be known
  - HM moves can be forgotten like any other move, and Pokemon that know them can be released
  - Fly from the Pokegear map: press A on a town you've visited. The Pokemon that would fly is shown on the town
  - In a dark area, press A to prompt Flash

- **New and Updated Daily Events**
  - Bug Catching Contest now appears on Sundays as well (on top of Tuesdays, Thursdays, and Saturdays)
  - A Sailor in Cianwood will take you to a mystery island once a day, where you can find new places to explore, rare Pokemon, and more
  - Once a day, find rare variants in swarms by tuning into radio channel 12.5
  - Mystery Gift with various NPCs once per day for rare items

- **Mystery Gift with various NPCs**
  - Improved rarity distribution - Uncommon, rare, and super rare items appear more often
  - Upgraded rewards - All evolution items can be obtained by Mystery Gifting with NPCs
  - Locations
    - Carrie (Goldenrod Dept. Store 5f)
    - Kim (Blackthorn City)
    - Charlie (Silph Co. 1f)
  - Limit once per day, per NPC

- **Swarm System Overhaul**
  - Daily swarms are announced via the radio on station 12.5, the Collection Guild's swarm report. Kanto swarms start after beating the Elite Four
  - Team Rocket's Pokémon, left behind when as you complete the story
  - Up to three swarms can be going at once: Arnie's and Anthony's phone calls still start theirs (Yanma on Route 35, Dunsparce in Dark Cave), and a new radio station picks one more every day
  - Swarms end at midnight
  - The radio won't announce the same swarm as either of the last two days you played
  - A swarm takes over about 60% of a route's grass or surf encounters, at the route's own levels
  - Find special forms in swarms
  - Heightened shiny chance (see Shininess section)
  - Swarm mon replace some overworld mon on the route. Battle one and the route's wandering Pokemon are rolled again, to increase chance of finding shinies.
  - Active swarms are marked on the Pokegear map and the Fly map. When icons share a spot, they take turns showing

- **Roaming Legendaries Overhaul**
  - Roaming legendaries appear in the overworld now instead of in the grass
  - The location of the roaming legendaries can be tracked on the Pokegear map 
  - A roaming legendary stays put while you're on its route, so you can walk up to it. It only moves on when you leave, or after you battle it
  - Check the Shininess section about updates to shiny mechanics surrounding the roaming legendaries

- **Pokegear Upgrades**
  - Press **Select** on the Pokegear map or the Fly map to switch what the map shows:

	| View | Shows |
	|---------|-------------------|
	| SWARMS | Active swarms and roaming legendaries |
	| REMATCH | Trainers who are ready for a rematch |
	| GIFTS | Trainers who have an item waiting for you |
  - When there are more trainers than fit on screen, they take turns showing
  - Press **Start** to slide over to the other region's map, once you've visited Indigo Plateau. On the Fly map, Left and Right still work too
  - TODO: Pokegear cards wrap around

- **Phone Overhaul**
  - No more full phone: you can register every trainer who offers you their number
  - Trainers offer their number right after you beat them
  - Answer or decline calls: press **A** to answer, **B** to decline. Mom, Prof. Oak, Bill and Prof. Elm can't be declined
  - Fewer filler calls: trainers are more likely to call about a rematch or a gift
  - A trainer with a rematch or gift waiting won't call again until you go see them

- **Type Rebalance**
  - Dark type moves are now Physical
  - Ghost type moves are now Special
  - Dragon type moves are now Physical

- **Shininess**
  - Shiny Pokemon no longer tied to specific DV spreads
	- Unown can be shiny in any form - not just "I" and "V"
	- You can get shinies that are super weak, super strong, and everywhere in between
  - A shiny symbol appears below the mon's name when it's shiny
  - Eggs are blue when shiny
  - Standard Odds **1/8192**
  - Gift Mon **1/512**
  - Swarm Pokemon **1/512**
  - Starters
    - In Elm's lab the three starters stand on the table. All three are rolled at once when you walk in, at **1/512** each and are visibly shiny. Save before entering to hunt for a shiny starter!
  - Bug Catching Contest **1/512**
  - Eggs
  	| Parent Shininess | Odds |
  	|------------------|------------|
  	| No shiny parents | **1/4096** |
  	| One shiny parent | **1/64** |
  	| Two shiny parents | **1/32** |
  - Roaming Legendarys
    - When the beasts are first seen in Burned Tower, they will each have a 1/512 chance of appearing as shiny (and will remain shiny as they roam). This makes them soft-resetable all at the same time.
    - After that, every time one turns up on the route you're on, it has another **1/512** chance to be shiny
    - Once you see a shiny roaming mon in the overworld, it will remain shiny for all subsequent encounters. You do not need to actually encounter the mon in battle for this to happen.

- **Breeding Upgrades** 
  - Fewer step cycles required to hatch eggs
  - Update "hatching soon" and egg animation logic to scale down with the lower overall cycles
  - Egg has blue spots when shiny
  - Daycare man stands outside fence when egg is ready 
  - Updated Route 34 map to remove grass patch in egg hatching path
  - Removed trainer ID penalty (same trainer IDs no longer reduce egg generation chance)
  - Simplified & Improved egg generation rates:
    | Pokemon Pairing | Egg Generation Chance |
    |-----------------|-----------------------|
    | Same species | 50% |
    | Different species | 25% |


- **New Cosmetic Forms**
TODO: mention a few. Put the rest on the dex site if people want spoilers
	| Species	| Form			| How to Obtain |
	|---------------|-----------------------|---------------|
	| Pikachu	| Surfing Pikachu	| Teach it Surf |
	| Pikachu	| Flying Pikachu	| Teach it Fly |
	| Pikachu	| Red/Blue		| Mystery Island - Potential Hidden Grove Spawn |
	| Shuckle	| Happy Shuckie		| Reach 150 happiness with Mania's Shuckle, "Shuckie" |
	| Magikarp	| Extra Small		| Wild Magikarp that's less than 2 feet |
	| Magikarp	| Extra Large		| Wild Magikarp that's larger than 4 feet 5 inches |
	| Smeargle	| Red			| Found in the Ruins of Alph outdoors |
	| Smeargle	| Blue			| Found in the Ruins of Alph outdoors |
	| Smeargle	| Yellow		| Found in the Ruins of Alph outdoors |
	| Smeargle	| Purple		| Bred from a Red and Blue Smeargle |
	| Smeargle	| Orange		| Bred from a Red and Yellow Smeargle |
	| Smeargle	| Green			| Bred from a Blue and Yellow Smeargle |
	| Scyther	| Forest Green		| Bug Catching Contest |
	| Scyther	| Teal			| Bug Catching Contest |
	| Scizor	| Crimson		| Evolve Forest Green Scyther |
	| Scizor	| Dusty Rose		| Evolve Teal Scyther |
	| Pinsir	| Vine Green		| Bug Catching Contest |
	| Scizor	| Slate Gray		| Bug Catching Contest |
	| Snorlax	| Full Belly		| The Snorlax asleep in the Apricorn Forest clearing |
	| Tentacool     | Red/Blue              | Tune into channel 12.5 |
	| Tentacruel    | Red/Blue              | Evolve an RB Tentacool |
	| Machop        | Red/Blue              | Tune into channel 12.5 |
	| Machoke       | Red/Blue              | Evolve an RB Machop |
	| Machamp       | Red/Blue              | Evolve an RB Machoke |
	| Pichu         | Beta                  | Breed an RB Pikachu or Raichu |
	| Raichu        | Red/Blue              | Evolve an RB Pikachu |
	| Igglybuff     | Beta                  | Breed an RB Jigglypuff or Wigglytuff |
	| Jigglypuff    | Red/Blue              | Tune into channel 12.5 |
	| Wigglytuff    | Red/Blue              | Evolve an RB Jigglypuff |
	| Nidoran♂      | Red/Blue              | Tune into channel 12.5 |
	| Nidorino      | Red/Blue              | Evolve an RB Nidoran♂ |
	| Nidoking      | Red/Blue              | Evolve an RB Nidorino |
	| Nidoran♀      | Red/Blue              | Tune into channel 12.5 |
	| Nidorina      | Red/Blue              | Evolve an RB Nidoran♀ |
	| Nidoqueen     | Red/Blue              | Evolve an RB Nidorina |
	| Zubat         | Red/Blue              | Tune into channel 12.5 |
	| Golbat        | Red/Blue              | Evolve an RB Zubat |
	| Crobat        | Beta                  | Evolve an RB Golbat |
	| Geodude       | Red/Blue              | Tune into channel 12.5 |
	| Graveler      | Red/Blue              | Evolve an RB Geodude |
	| Golem         | Red/Blue              | Evolve an RB Graveler |
	| Shellder      | Red/Blue              | Tune into channel 12.5 |
	| Cloyster      | Red/Blue              | Evolve an RB Shellder |
	| Gastly        | Red/Blue              | Tune into channel 12.5 |
	| Haunter       | Red/Blue              | Evolve an RB Gastly |
	| Gengar        | Red/Blue              | Evolve an RB Haunter |
	| Koffing       | Red/Blue              | Tune into channel 12.5 |
	| Weezing       | Red/Blue              | Evolve an RB Koffing |
	| Horsea        | Red/Blue              | Tune into channel 12.5 |
	| Seadra        | Red/Blue              | Evolve an RB Horsea |
	| Kingdra       | Beta                  | Evolve an RB Seadra |
	| Psyduck       | Red/Blue              | Tune into channel 12.5 |
	| Golduck       | Red/Blue              | Evolve an RB Psyduck |
	| Magikarp      | Red/Blue              | Tune into channel 12.5 |
	| Gyarados      | Red/Blue              | Evolve an RB Magikarp |
	| Staryu        | Red/Blue              | Tune into channel 12.5 |
	| Starmie       | Red/Blue              | Evolve an RB Staryu |
	| Golbat        | Team Rocket           | Tune into channel 12.5 after clearing the Mahogany hideout |
	| Crobat        | Team Rocket           | Evolve a Team Rocket Golbat |
	| Weezing       | Team Rocket           | Tune into channel 12.5 after clearing the Mahogany hideout |
	| Charmeleon    | Team Rocket           | Tune into channel 12.5 after freeing the Radio Tower |
	| Charizard     | Team Rocket           | Evolve a Team Rocket Charmeleon |
	| Arbok         | Team Rocket           | Tune into channel 12.5 after freeing the Radio Tower |
  - *NOTE:* Some forms will have a symbol that goes along with them to indicate that they're different. Not all forms will have this.

- **Scaling Marts**
  - Town Poke Marts sell better stock as you earn badges (new stock at 2, 4, 6, and 8 badges), so going back to an early town doesn't mean worse shopping
  - A few towns keep a specialty item: Charcoal in Azalea, Surf Mail in Olivine and Cerulean, LiteBlueMail in Vermilion
  - Blackthorn's mart, the department stores, and specialty shops keep fixed stock; Blackthorn and the department stores sell TMs (see TM shops above)

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

- **Headbutt Tree Encounters Simplified**
  - Headbutting a headbutt tree always results in a Pokemon appearing
  - Each area type has one encounter table instead of a common and uncommon table

- **Misc.**
  - Kurt makes Apricorn balls instantly, and can make several at once
  - Turn around after healing in the Pokecenter so you don't accidentally heal again
  - Minor update to Goldenrod layout so it's easier to get to the underground and the bike shop
  - Bug Catching Contest rebalanced + includes overworld encounters
  - Happiness
    - Happiness goes up by 2 points every other step cycle instead of 1
    - Leveling up, Haircuts, Daisy grooming, and battling gym leaders give more happiness.
  - Simplified the clock reset
    - Hold **Down + B + Select** at the title screen, then confirm

---

## **Code Credits**
  - **Built upon the CrystalShireEngine** See section below titled "CrystalShireEngine" to see the README for that project. This includes a majority of bugfixes, engine upgrades, and a lot of QoL improvements (like the new box UI).

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
    - TM shops
    - Updated Evolution methods
    - Level-up learnsets
    - TM/HM learnsets
    - Reduced hatch cycles
    - Hatch Cycles
    - Move updates
  - Parts of the [Add a new party menu icon](https://github.com/pret/pokecrystal/wiki/Add-a-new-party-menu-icon) tutorial were used and modified for cosmetic form party menu/daycare overworld/box icons. Credits to [Rangi42](https://github.com/Rangi42) for writing the original tutorial and [Cherryello](https://github.com/Cherryello), [mid-kid](https://github.com/mid-kid), [aaaaaa123456789](https://github.com/aaaaaa123456789), [Idain](https://github.com/Idain), [FrenchOrange](https://github.com/FrenchOrange), [SonicRay100](https://github.com/SonicRay100), and [Brianum](https://github.com/Brianum) for their updates to it.
  - Untying shininess from DVs partially based on a similar implementation in [Polished Crystal](https://github.com/Rangi42/polishedcrystal)
  - New shiny check algorithm [Polished Crystal](https://github.com/Rangi42/polishedcrystal)
  - Follower Mon code [Vulcandth](https://github.com/vulcandth) and [AtmaBuster](https://github.com/AtmaBuster)
  - Using HMs without knowing them, Fly from the Pokegear map, the Flash prompt and the Ilex Forest HM texts ported from [Polished Crystal](https://github.com/Rangi42/polishedcrystal)
  - The simplified clock reset follows the [Simplify the Clock Reset Procedure](https://github.com/pret/pokecrystal/wiki/Simplify-the-Clock-Reset-Procedure) tutorial by [SonicRay100](https://github.com/SonicRay100) from the pret/pokecrystal wiki
  - Move and battle animations ported from [Sour Crystal](https://github.com/SoupPotato/sourcrystal)
  - The Hidden Power stats page follows the [Add a fourth stats page](https://github.com/pret/pokecrystal/wiki/Add-a-fourth-stats-page) tutorial by [Rangi42](https://github.com/Rangi42) from the pret/pokecrystal wiki
  - The unlimited phone contact list, evening rematch times and the one-byte special phone call fix are ported from [Polished Crystal](https://github.com/Rangi42/polishedcrystal)
  - Answering or declining phone calls is ported from [Sour Crystal](https://github.com/SoupPotato/sourcrystal)
  - Trainers offering their number right after battle follows the [Improve the trainer rematch system](https://github.com/pret/pokecrystal/wiki/Improve-the-trainer-rematch-system) tutorial by Grate Oracle Lewot from the pret/pokecrystal wiki
  - Kurt making Apricorn balls instantly follows the [Kurt Makes Pokeballs Instantly](https://github.com/pret/pokecrystal/wiki/Kurt-Makes-Pokeballs-Instantly) tutorial by [Nayru62](https://github.com/Nayru62) from the pret/pokecrystal wiki (adapted from [Polished Crystal](https://github.com/Rangi42/polishedcrystal)), with the fade back in from [Sour Crystal](https://github.com/SoupPotato/sourcrystal)

## **Art Credits**
  - SCMidna for Surfing Pikachu front sprites
  - bloodless for Flying Pikachu back sprite
  - Kuroko Aizawa, bloodless, and metalflygon08 for Flying Pikachu front sprites 
  - Unown party menu icons from [Polished Crystal](https://github.com/Rangi42/polishedcrystal)
    - I could not find specific artist credits for these icons. If you made them, please let me know and I'll update this!
  - Sage for Golbat sprite used by Rockets. Colors modified from original.
  - Sage for Arbok sprite used by Rockets. Colors modified from original.
  - Sage for Charmeleon sprite. Colors modified from original.
  - Sage for Charizard sprite used by Rockets. Color modified from original.
  - Sage for Weezing sprite.
  - Sage for Crobat sprite used by Rockets. Colors modified from the original.
  - Sage for Electrode sprite used by Rockets. Colors modified from the original.
  - Kester Henrick for blackbelt overworld sprite used for Karate Master
  - [FrenchOrange](https://github.com/FrenchOrange) for help with the Shaman's overworld sprite
  - Campfire sprite and fire-pit tiles in the Shaman's house from [Polished Crystal](https://github.com/Rangi42/polishedcrystal)
  - [FrenchOrange](https://github.com/FrenchOrange) for Lorelei's and Agatha's trainer sprites
  - MauveSea for Giovanni's trainer sprite
  - Most Pokemon party menu icons from [Sour Crystal](https://github.com/SoupPotato/sourcrystal)
  - New and redrawn move animation graphics from [Sour Crystal](https://github.com/SoupPotato/sourcrystal)

---

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
