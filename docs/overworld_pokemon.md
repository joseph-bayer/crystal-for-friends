# Overworld Pokémon

Pokémon standing in the world rather than in a battle: the ones that have always been there as map
objects, and the ones that now wander a route and can be walked into.

Two features, built in that order, sharing one mechanism.

## Contents

- [Why they used to be the wrong species](#why-they-used-to-be-the-wrong-species)
- [Mon slots](#mon-slots)
- [Colors](#colors)
- [Sprites are built from menu icons](#sprites-are-built-from-menu-icons)
- [Wandering wild Pokémon](#wandering-wild-pokémon)
- [The rolled encounter](#the-rolled-encounter)
- [The area tables](#the-area-tables)
- [Perks and balance knobs](#perks-and-balance-knobs)
- [Meeting one](#meeting-one)
- [Saving and loading](#saving-and-loading)
- [Bugs worth remembering](#bugs-worth-remembering)
- [Known gaps](#known-gaps)


## Why they used to be the wrong species

Red and Blue had a handful of hand-drawn overworld Pokémon sprites, and Gold/Silver kept them: 35
species, listed in `data/sprites/sprite_mons.asm`. Any other species that needed to stand in a room
borrowed the closest one available. Blackthorn's Dratini was an Ekans, Mr. Fuji's Psyduck a Rhydon,
the four Miltank on Route 39 a herd of Tauros — **43 objects across 28 maps** showing the wrong
Pokémon.

That compromise made sense when a sprite was 12 tiles of bespoke artwork. It stopped making sense
here, because CSE draws overworld Pokémon from their **party menu icons**, which exist for all 251
species and every cosmetic form. The artwork was never the problem. The one-byte sprite id was.


## Mon slots

A map object's sprite field is one byte, which cannot hold a 16-bit species index — let alone a
cosmetic form or a shiny flag. So `SPRITE_OW_MON_1`..`_4` name a **slot**, and something else says
what the slot holds.

```asm
object_event  5,  5, SPRITE_OW_MON_1, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SomeScript, -1
```

`GetOverworldMonSlot` (`engine/overworld/overworld_mons.asm`) resolves one, and it looks in two
places:

1. **A rolled encounter**, if this map has one in that slot — see
   [wandering wild Pokémon](#wandering-wild-pokémon).
2. **`data/maps/overworld_mons.asm`**, a sparse table keyed by map, for the fixed NPCs. 27 maps,
   32 entries, about 200 bytes. It is scanned rather than cached, which keeps it out of WRAM and
   therefore out of the save.

The four slots fill in a fixed order — a map's static entries first, then its grass slots, then
its water ones — and `RollOverworldMons` starts rolling above whatever the static table already
owns. Without that, a roll into slot 1 would redraw the static mon that slot belongs to: the whole
Route 39 Miltank herd, or the Red Gyarados, becoming whatever wandered in.

Objects may share a slot: the six Rocket Base Electrode and the four Route 39 Miltank each declare
one entry between them. Two maps are now at the four-slot ceiling — Route 45 (four grass) and Lake
of Rage (the Red Gyarados plus three Magikarp).

**`SpriteMons` still exists** and still earns its keep — 20 of its 35 entries are load-bearing for
room decorations, which map each doll to a `SPRITE_*`.


## Colors

Every overworld Pokémon is drawn in **its own colors**, the two its battle sprite uses, arranged by
`data/pokemon/icon_palette_order.asm`. The same treatment the follower gets, and it covers the
dolls and the day-care mons too.

`MarkUsedPal` dedupes by palette *index*, so each distinct mon on screen needs its own.
`ClaimOverworldMonPalette` hands one out from `PAL_OW_MON_1`..`_4`:

1. `_GetSpritePalette.is_pokemon` reads `wCurIcon` and `wForm`, which `GetMonSprite` has just
   filled in. A mon slot, a `SpriteMons` id, a doll's variable sprite and a day-care mon therefore
   all arrive by the same door.
2. `GetArrangedMonIconColors` turns those into two colors.
3. The claim searches `wOverworldMonPals` for those exact colors, reusing the index if they are
   already there. **Identical mon share an index**, which is what keeps six Electrode to one
   palette.
4. `CopySpritePal` reads the entry back and bookends it white and black, sharing the follower's
   code including its time-of-day tinting.

The table resets in `LoadMapObjects` — deliberately *not* in `ClearSavedObjPals`, which also runs
on returns from menus and battles where nothing reclaims, and an index left pointing at a cleared
entry would draw the mon black.

**The budget is eight hardware OBJ palettes and the follower permanently owns one.** Measured
across every map: 32 maps have one distinct mon, four have two, two have three. If a map ever
needs more, the claim returns carry and the object falls back to a flat overworld color rather
than misdrawing.


## Sprites are built from menu icons

A party menu icon is **8 tiles**: two 2×2 frames. An overworld sprite is **12 standing + 12
walking**, with down at `$00`, up at `$04`, left/right at `$08`.

`ExpandMonIconToSprite` (`engine/overworld/overworld.asm`) bridges the two: frame 1 into all three
standing facings, frame 2 into all three walking facings, then the down-facing copies mirrored in
place so walking towards the camera reads differently from walking away. Mirroring is done in
software — a horizontal flip of 2bpp data is a bit reversal — once per sprite load.

It is shared with the follower, and `GetMonSprite.Mon` routes every overworld Pokémon through it.


## Wandering wild Pokémon

A Pokémon that wanders a route. Walk onto it, or face it and press A, and it starts a **wild**
battle — with the mon you were looking at.

| Piece | Where |
| --- | --- |
| `OBJECTTYPE_WILDMON`, the proximity and talk triggers, the battle script | `engine/overworld/events.asm` |
| The roll, the masks, the battle setup | `engine/overworld/overworld_mons.asm` |
| Rosters | `data/wild/overworld_mons.asm` |
| Struct, perks, table shape | `constants/overworld_mon_constants.asm` |
| Reading the roll instead of rolling | `engine/battle/core.asm`, in `LoadEnemyMon` |

An object opts in with `OBJECTTYPE_WILDMON`, a `SPRITE_OW_MON_*` sprite, palette byte `0` so it
takes the mon's own colors, and `SPRITEMOVEDATA_WANDER_NOCLIP` (or `SWIM_WANDER_NOCLIP` on water).
Its event flag is `-1`: whether one is standing there is decided by whether its slot holds a mon.


## The rolled encounter

**The whole encounter is decided when the map is entered, and the battle reads it back rather than
generating its own.** That is the core of the design, not an optimisation.

`LoadEnemyMon` normally generates the form byte (which carries `SHINY_MASK`), the DVs and the held
item at the moment the battle starts — long after the sprite was drawn. Roll twice and they
disagree, so an ordinary-looking sprite turns into a shiny, or into a different cosmetic form, the
instant you touch it.

So `wOverworldMonEncounters` holds, per slot: species index, form byte, level, DVs, held item,
perks, and an extra move. `LoadEnemyMon` gains three branches, at the three points where it already
branched on `wBattleType` for roaming mon and the Bug Catching Contest:

| What | Where | The `BATTLETYPE_OVERWORLD_MON` branch |
| --- | --- | --- |
| Held item | `.UpdateItem` | take the rolled item |
| DVs | `.GenerateDVs` | take the rolled DVs |
| Form and shininess | `.generate_shininess` | take the rolled form byte whole |

The move is applied by `ApplyOverworldMonMove`, after `FillMoves` and before the PP fill so it gets
PP for free. It fills an empty slot, or replaces move 1 if the mon already knows four. **It is
stored as a 16-bit move index, not an 8-bit ID** — IDs come from a recycled table and can be
evicted, and the roll may be minutes old.

### When the roll happens

`RollOverworldMons` runs from `HandleNewMap`, which fires on warps, connections and fly — and
**not** on returning from a battle or closing a menu. That is what makes a route reroll when you
leave and come back, and hold still otherwise.

Getting this wrong is easy: `MAPCALLBACK_OBJECTS` and `LoadMapObjects` run on *every* map setup,
including the one after a battle, so rolling there would change the species of the mon you just
fled from while you watched.

### Hiding the ones that did not appear

A slot the roll leaves empty, and a slot whose mon has been battled, must not be drawn.

The obvious mechanism would be an `EVENT_TEMPORARY_UNTIL_MAP_RELOAD_*` flag, which clears on
exactly the right boundary — but **all eight are already spoken for** by Bill's house, the Dragon
Shrine, Goldenrod Underground, Kurt's house, Player's house, the ports, the Route 36 gate and the
link rooms. There is no ninth short of extending the reset and shifting every event flag in the
game.

So there is no flag. `UpdateOverworldMonObjectMasks` writes `wObjectMasks` directly, from
`LoadMapObjects` and **after** `LoadObjectMasks` has rebuilt the array. **A slot being empty is the
hidden state**, with nothing standing in for it, and the routine masks and unmasks so it is the
whole truth and can be called from anywhere.


## The area tables

`data/wild/overworld_mons.asm` holds **two** tables, `OverworldWildMonsGrass` and
`OverworldWildMonsWater`, the way `JohtoGrassWildMons` and `JohtoWaterWildMons` are two tables.
`RollOverworldMons` runs one pass over each — grass slots draw only from the grass table, water
slots only from the water one. A map appears in whichever tables it needs, and in both if it has
slots on both.

```asm
	def_ow_wildmons ROUTE_29
	db 2 ; how many can be out at once -- one SPRITE_OW_MON_n object each
	db 100 percent ; the chance each one shows up
	; morn
	ow_wildmon 30, PIDGEY,  3, PLAIN_FORM, 0, PURSUIT
	...
	end_ow_wildmons
```

A single blended roster was tried first and read badly: the water table concentrates its odds in
three fat entries and crowded the land mon out of a four-entry roster, so Tentacool turned up in
fields.

`ow_wildmon` is **weight, species, level, form, perks, move**. Weights are out of 100 within their
time of day; a block adding to less than 100 falls through to its last entry more often. Four
choices per time of day, fixed width so a daytime can be indexed rather than walked. Evening
shares the night roster, as the grass tables do.

The form byte takes a cosmetic form, `SHINY_MASK`, or both — so a roster can specify a Surfing
Pikachu, or one that is always shiny.

These are **separate from the grass and water tables** on purpose. The species overlap but nothing
else does: their own odds, a shorter list, a chance of nobody appearing, and per-entry forms,
perks and moves that a grass encounter has no field for.


## Perks and balance knobs

Every wandering Pokémon, as named constants in `constants/pokemon_data_constants.asm` beside the
other shiny rates:

| Constant | Value | Against |
| --- | --- | --- |
| `OVERWORLD_MON_SHINY_NUMERATOR` | 128/65536 = 1/512 | a grass encounter's 1/8192 |
| `OVERWORLD_MON_MIN_DV` | 10 of 15, as a floor on each DV | a free roll |
| `OVERWORLD_MON_NO_ITEM_CHANCE` | 20% | a grass encounter's 50% |

Per entry, an `OW_PERK_*` bit field:

- `OW_PERK_ALWAYS_ITEM` — skip the item roll
- `OW_PERK_EXTRA_SHINY` — `OVERWORLD_MON_EXTRA_SHINY_NUMERATOR`, currently 1/256

**The perks use `shift_const`**, giving each both a value for the tables and an `_F` bit number for
the code. That is not decoration: a plain `1, 2, 3` enumeration reads fine in the data and is a
trap in the engine, because `bit OW_PERK_EXTRA_SHINY, a` against value 2 tests bit 2, which is
never the bit that was set.

The extra-shiny roll deliberately **skips the 1/256 gate** that every other shiny roll uses.
Behind that gate no numerator can push a perk past about 1/257, so the perk would be a rounding
error rather than a reward. Its numerator is therefore out of 256, not 65536.

Adding a perk is one `shift_const` and one branch in the roller. The perks byte is carried into the
encounter struct, so a perk that has to act during the *battle* still has its flags to hand.


## Meeting one

Two triggers, sharing `TryClaimOverworldMonBattle`:

- **Walk onto it.** `OW_MON_TRIGGER_DISTANCE` is `0` — the same tile. They do not block the player
  (the player's bump check takes the same exit the follower uses), and `NOCLIP_OBJS` lets them walk
  onto *you*.
- **Face it and press A.** `.wildmon` in `ObjectEventTypeArray`.

The overlap check requires the mon to be **standing**, not mid-step. An object's map coordinates
change when a step *begins*, not when the sprite arrives, so without that a mon walking towards you
triggers while it is still visibly a tile away.

**Any finished battle spends it** — beaten, caught or run from, it is gone until the route is left
and re-entered. `wBattleResult` could tell those apart; nothing consults it, because there is
nothing to decide.

Two touches around the encounter: the player and the follower are hidden for the battle transition
so only the mon is on screen, and a route that rolled a shiny plays `SFX_SHINE` once, the first
frame the player has control.


## Saving and loading

`MapSetupScript_Continue` is a different path: it uses `LoadMapAttributes_SkipObjects` and never
calls `HandleNewMap` or `LoadMapObjects`. But **map objects are inside the save block and the
encounters are not**, so without help the wandering mon come back pointing at slots holding
whatever was left in WRAM.

`RollOverworldMonsOnContinue` is a mapsetup command added only to that script — it could not go in
`HandleContinueMap`, which `HandleNewMap` falls through into and would have rolled twice. It
rolls, updates the masks, and calls `RefreshOverworldMonPalettes`, which re-derives every wandering
mon's palette index; the palette state *is* saved, so otherwise a fresh Tentacool wears the
previous Pikachu's colors.

**Consequence: reloading a save rerolls the route**, the same as walking out and back. Reload
scumming for a shiny therefore works. Moving the encounter struct inside `wGameData` would close
that, at the cost of a save-layout shift.


## Bugs worth remembering

Every one of these assembled cleanly and was found by playing.

**Overworld Pokémon were drawn with the follower's form.** `GetMonSprite.pokemon_sprite` left `d`
at 0, which tells `LoadOverworldMonIcon` "`wForm` is already set" — but nothing set it for a map
object, so it held whatever wrote it last, and the follower is map object 1 and loads first. With a
Flying Pikachu following you, the Pikachu doll in your room came out flying. Fixed with an explicit
`PLAIN_FORM` write: a `SpriteMons` entry names a species and nothing else.

**The trigger never fired.** The distance check used `d` as scratch — and `de` was the caller's map
object pointer, so the next line read the sprite id through a half-overwritten pointer.

**Garbage when one turned.** Mon icons are 8 tiles and the loader copies 12 per facing, so "up"
got the icon's second frame and "left/right" got whatever followed in the icon table. Invisible on
a Pokémon that only faces the camera, which is why the static NPCs never showed it. Fixed by
routing everything through `ExpandMonIconToSprite`.

**It froze between steps.** `OBJECT_ACTION_FOLLOWER_IDLE` set in the movement function was not
enough: a *completed* step never reaches the movement function, because `StepFunction_ContinueWalk`
jumps straight into `RandomStepDuration_Slow`, which parks the object on `OBJECT_ACTION_STAND`.
`KeepOverworldMonAnimating` promotes that action every frame instead.

**The perk never fired.** See [perks](#perks-and-balance-knobs) — a bit number used as a value.


## Known gaps

- **The Bug Catching Contest is not compatible.** `wBattleType` is one byte and both features want
  it: `BATTLETYPE_OVERWORLD_MON` would replace `BATTLETYPE_CONTEST` and take the park-ball menu,
  the ball count, the contest ending and the scoring with it. Nothing breaks today, because the
  contest map has no roster — but do not give it one without decoupling first.
  `wOverworldMonBattleSlot` is already non-zero exactly when the battle is against a wandering mon,
  so the three `LoadEnemyMon` branches could test that instead and leave `wBattleType` alone.
- **Reload scumming for a shiny works**, as above.
- **They swim and walk with the follower's hop**, which suits a Sentret and may not suit a
  Tentacool.
- **A mon can be dodged.** If you step onto one that is mid-step and it steps away, no battle. It
  cannot soft-lock, because pressing A always works.
- **`OW_MON_DEBUG_FORCE_SHINY_SLOT`** in `engine/overworld/overworld_mons.asm` forces a slot shiny
  in `_DEBUG` builds. Testing a rate by walking in and out of a route a few hundred times is not a
  test; what needs checking is whether the sprite and the battle agree.
