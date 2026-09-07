# Plan: overworld Pokémon objects

Status: **phase 1 implemented**; phase 2 still a proposal.

Two goals, one mechanism:

1. **Now** — fix the 43 map objects that show the wrong species, like the Dratini in Blackthorn
   drawn as an Ekans.
2. **Later** — a dynamic "wild Pokémon in the overworld" object that picks a species from an
   area list, may carry a form, a boosted shiny chance or a special move, appears at one of several
   spots, and sometimes does not appear at all.

The second is the reason not to solve the first by adding `SPRITE_DRATINI`.


## Contents

- [Where the mismatches come from](#where-the-mismatches-come-from)
- [What already works](#what-already-works)
- [Why not just add more SPRITE_ constants](#why-not-just-add-more-sprite_-constants)
- [The design: mon slots](#the-design-mon-slots)
  - [How many Pokémon can share a map](#how-many-pokémon-can-share-a-map)
- [What was built](#what-was-built)
- [The mismatch list](#the-mismatch-list)
- [Colors](#colors)
- [Phase 2: dynamic area mon](#phase-2-dynamic-area-mon)
- [Risks and things to verify](#risks-and-things-to-verify)
- [Size](#size)


## Where the mismatches come from

They are vanilla's, not ours. Red and Blue had a handful of hand-drawn overworld Pokémon sprites,
and Gold/Silver kept them: 35 species, listed in `data/sprites/sprite_mons.asm`. Any *other*
species that needed to stand in a room borrowed the closest one available. Blackthorn's Dratini got
Ekans because Ekans was the nearest snake; Mr. Fuji's Psyduck got Rhydon; four Miltank on Route 39
are Tauros.

The compromise made sense when each sprite was 12 tiles of bespoke artwork. It stopped making
sense here, because CSE draws overworld Pokémon from their **party menu icons** — which exist for
all 251 species, and for every cosmetic form. The artwork is already in the ROM. Only the plumbing
still says Ekans.


## What already works

Worth stating plainly, because it decides the shape of the fix.

**Overworld mon are already drawn from menu icons.** `GetMonSprite.pokemon_sprite` maps a
`SPRITE_*` id through `SpriteMons` to a species index, and hands it to `LoadOverworldMonIcon` —
the same routine the day-care mons and the follower use. There is no per-species overworld artwork
left to draw.

**Graphics are allocated per object struct, not per sprite id.** `GetSpriteVTile` derives the VRAM
tile from `hObjectStructIndex`, so every object on the map owns a fixed 12-tile slot and loads its
own copy. (`AddSpriteGFX` and most of `wUsedSprites` are vanilla leftovers; only the player still
goes through that list.) **Consequence: giving two objects on one map two different species costs
nothing.** There is no shared sprite budget to overflow, which removes the constraint that would
otherwise have limited this.

**The palette pipeline is already indirect.** An object's `OBJECT_PAL_INDEX` holds a *requested*
`PAL_OW_*` value; `MarkUsedPal` maps it onto one of the eight hardware OBJ slots at draw time. So a
new palette source is a new index plus a branch, not a change to the allocator.

**`PAL_OW_FOLLOWER` is a working precedent for "colors from the mon itself".** The follower already
sits past every counted `PAL_OW_*` range, and `CopySpritePal` special-cases it to build a palette
out of the mon's own two colors, with time-of-day tinting. Phase 2's true-color option is that
branch again, parameterised.

**`_DoesSpriteHaveFacings` already covers ids above `SPRITE_POKEMON`.** It tests
`cp SPRITE_POKEMON` / `jr nc, .only_down`, so any new id in that range gets the right answer with
no change.


## Why not just add more `SPRITE_` constants

It is the cheap fix — 26 new constants, 26 rows in `SpriteMons`, done — and it is a dead end
for three reasons.

**The id space does not reach.** The sprite field in a map object is one byte, and the Pokémon
window is `$80`–`$df`: 96 ids, 35 already spent. Fine for 26 more. Not fine for 251 species, and
the dynamic feature wants "most Pokémon".

**It cannot express a form or a shiny.** The id *is* the species; there is nowhere to put
`MON_FORM`. The mon *inside* the encounter is fine — the Red Gyarados is genuinely shiny, because
`loadvar VAR_BATTLETYPE, BATTLETYPE_FORCESHINY` makes `core.asm` set `SHINY_MASK` in
`wEnemyMonForm`, and that flag rides into the caught mon. It is the **overworld object** that has
no way to say so: it is `SPRITE_GYARADOS` painted `PAL_NPC_RED`, and a Unown object could not say
which letter it is either. A slot carries a form byte, so an object can finally be told what the
script already knows.

**It puts the roster in the wrong place.** Every new overworld Pokémon becomes a constant, a table
row, and an `assert_table_length` bump, forever, so that map data can name it.

`SpriteMons` should stay, though — 20 of its 35 entries are load-bearing for room decorations
(`data/decorations/attributes.asm` maps each doll to a `SPRITE_*`), and the objects that already
show the right species have no reason to change.


## The design: mon slots

A small array of **runtime slots**, each holding a 16-bit species index and a form byte, plus one
sprite id per slot. This is the same shape as `wVariableSprites` / `SPRITE_VARS`, which is how the
engine already lets a map decide at load time what a sprite should be.

```
constants/sprite_constants.asm
	const_next $c0
DEF SPRITE_OW_MON EQU const_value
	const SPRITE_OW_MON_1 ; c0
	const SPRITE_OW_MON_2 ; c1
	const SPRITE_OW_MON_3 ; c2
	const SPRITE_OW_MON_4 ; c3
DEF NUM_OW_MON_SLOTS EQU const_value - SPRITE_OW_MON
```

```
ram/wram.asm  (map-scoped, NOT in the save block)
wOverworldMonSlots::
	; NUM_OW_MON_SLOTS entries of: dw species index, db form
	ds NUM_OW_MON_SLOTS * OW_MON_SLOT_LENGTH
```

A map object then reads:

```asm
	object_event  5,  5, SPRITE_OW_MON_1, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, BlackthornDragonSpeechHouseDratiniScript, -1
```

and the map declares what slot 1 holds.

**Why slots rather than resolving per object.** The other candidate was to key the species off the
object's own index — `hMapObjectIndex` is set before `GetSpriteVTile` and `GetSpritePalette`, so it
would work at the call sites that matter, and it would have no per-map cap. It was rejected because
the sprite id would no longer determine the sprite: every present and future caller of `GetSprite`,
`GetSpritePalette` or `DoesSpriteHaveFacings` would have to have the right object in context, and
some (`UpdateFollowPalette`, the dynamic sprite reload) reach those routines from a different
direction. A slot id is self-describing, which is worth more here than an unlimited cap.

### How many Pokémon can share a map

**Start at four slots**, because the static fix needs three — Mr. Fuji's house wants Psyduck,
Nidorino and Pidgey — but four is a starting value, not a ceiling the design imposes. Slots are
cheap and independent of each other, so **several runtime Pokémon on one route is supported by
construction**: one slot per distinct species, and the number of slots is a constant.

What actually bounds it, cheapest limit first:

| Limit | Headroom | Notes |
| --- | --- | --- |
| WRAM | Effectively none | 3 bytes per slot |
| Sprite ids | **32 slots** | `$c0`–`$df` is free; `SPRITE_DAY_CARE_MON_1` starts at `$e0` |
| Object structs | **12 on screen** | `NUM_OBJECT_STRUCTS` is 14, less the player and the follower — shared with every NPC |
| Map objects | **18 per map** | `NUM_OBJECTS` is 19, less the follower's reserved slot |
| OBJ palettes | **7**, or unlimited | Only if each mon wants its own true colors; see [Colors](#colors) |

Two of those deserve emphasis.

**Extra copies of the same species are free.** Several objects can point at one slot — exactly what
the four Route 39 Miltank and the six Rocket Base Electrode do today. Three Rattata rustling in one
patch of grass costs **one** slot, **one** palette and three object structs.

**Object structs are the real ceiling, and they are not negotiable.** Twelve is what a map has for
everything on screen at once, wild mon and NPCs together, so a busy town has far less spare than a
route. And `NUM_OBJECT_STRUCTS` **cannot simply be raised**: `FIRST_VRAM1_OBJECT_STRUCT = 9` is
derived from it, and only `9` works at 14 structs — see
[following_pokemon.md](following_pokemon.md#the-tile-budget). Treat 12 as fixed.

So the honest figure for phase 2 is **two or three distinct species visible at once on a route in
their own colors, more if they share a palette**, with copies of each on top of that. That is more
than the feature needs. Put an `assert` on the slot count so overflowing is a build failure, and
raise the constant when a map genuinely wants more — each extra slot is three bytes and one id.

One consequence worth designing for early: once several mon can appear, "each one shows up at one
of a few spots, or not at all" stops being per-object logic and becomes **place K of M candidates**.
That wants one small placement routine that picks a subset and masks the rest, written once, rather
than a roll bolted onto each object.

**Where the declarations live.** A sparse table keyed by map, `data/maps/overworld_mons.asm`, read
once during `LoadMapObjects`:

```asm
OverworldMonObjects:
	ow_mon_map MR_FUJIS_HOUSE
		ow_mon PSYDUCK,  PLAIN_FORM
		ow_mon NIDORINO, PLAIN_FORM
		ow_mon PIDGEY,   PLAIN_FORM
	ow_mon_map LAKE_OF_RAGE
		ow_mon GYARADOS, PLAIN_FORM | SHINY_MASK
	...
	db -1
```

Three reasons over a `MAPCALLBACK_OBJECTS` callback per map:

- **No bank 3 cost.** A declarative `overworldmon` script command would need a `Script_*` handler
  in the scripting bank, and that bank is full — the debug PC filler already had to be reached by
  `callasm` for exactly this reason.
- **No churn in 28 map files** beyond the `object_event` lines that have to change anyway.
- **One place to read the whole roster**, which is where the phase 2 area lists want to live too.

Cost is 27 map rows plus 32 entries, about 200 bytes in one bank.

Maps that need *logic* rather than a declaration get the other door: `SetOverworldMonSlot`, called
from a `callasm` in a `MAPCALLBACK_OBJECTS` callback. That is what phase 2 uses, and it overrides
the table because the callback runs after it.


## What was built

Six changes, and three things the plan expected that turned out to be unnecessary.

| File | Change |
| --- | --- |
| `constants/sprite_constants.asm` | `SPRITE_OW_MON_1`..`_4` at `$c0`, `NUM_OW_MON_SLOTS`, and an assert that they stay clear of `SPRITE_DAY_CARE_MON_1` |
| `constants/sprite_data_constants.asm` | `OW_MON_SLOT_SPECIES` / `_FORM` / `_LENGTH` |
| `macros/scripts/maps.asm` | `ow_mon_map` and `ow_mon`, counting entries the way `def_object_events` counts objects |
| `data/maps/overworld_mons.asm` | The roster: 27 maps, 32 entries, 177 bytes |
| `engine/overworld/overworld_mons.asm` | `GetOverworldMonSlot`, and the `INCLUDE` of the table |
| `engine/overworld/overworld.asm` | `GetMonSprite.ow_mon` |

`.ow_mon` is the whole graphics change:

```asm
.ow_mon
	sub SPRITE_OW_MON
	farcall GetOverworldMonSlot ; hl = species index, a = form byte, carry if the slot is filled
	jr nc, .NoBreedmon
	ld [wForm], a
	call GetPokemonIDFromIndex
	ld d, 0 ; not a day-care mon, so the form written above is used as-is
	jr .Mon
```

### What the plan got wrong

**No WRAM, and no save-layout change.** The plan wanted `wOverworldMonSlots` filled during
`LoadMapObjects`. But every non-saved WRAM region that was big enough turned out to be a
`SECTION UNION`, which another screen would clobber mid-map, and the only safe home was inside
`wPlayerData` — shifting the save layout for the third time this feature. Scanning the table on
demand avoids all of it. The scan runs when an object's graphics load (map setup, and again as an
object scrolls on screen), never per frame, and it is a few dozen comparisons over 177 bytes.

**No `LoadMapObjects` hook**, for the same reason — there is nothing to fill.

**No `_GetSpritePalette` change.** It calls `GetMonSprite`, which now answers for the new ids and
returns carry, so the new range lands in `.is_pokemon` and returns palette 0 with no edit. Same for
`_DoesSpriteHaveFacings`, whose `cp SPRITE_POKEMON` / `jr nc` already covers `$c0`.

**`SetOverworldMonSlot` is deferred.** A runtime override needs the WRAM array the table scan
avoids, so it belongs with phase 2, which is the first thing that actually needs it.

### Verified

All three ROM targets assemble and link; `utils/optimize.py` reports 0 findings on the changed
files; `farcheck.py` and `unreferenced.py` are clean. The assembled table was walked byte by byte
out of the ROM to confirm the forward-referenced count bytes resolved — 27 rows, correct
terminator, and Lake of Rage reading species 130 form `$80`.

**Untested on hardware.** Nothing here has been played yet.

### The one failure mode to know about

An object pointing at a slot the table does not fill takes `GetMonSprite.NoBreedmon`, which is the
engine's existing "empty day-care" fallback — and that returns `WALKING_SPRITE`, which the caller
indexes as `OverworldSprites[0]`. **The object draws as Chris**, not as nothing. Harmless, no
crash, but it is what a missing table row looks like, and nothing catches it at build time.

## The mismatch list

43 object events across 28 maps. Intended species read off each object's own script — most call
`cry`, and the rest are named by their label or dialogue.

| Map | Objects | Shows | Should be |
| --- | --- | --- | --- |
| BlackthornDragonSpeechHouse | 1 | Ekans | Dratini |
| CeladonCity | 1 | Poliwag | Poliwrath |
| CeladonMansion1F | 2 | Growlithe ×2 | Meowth, Nidoran♀ |
| CeruleanCity | 1 | Slowpoke | Slowbro |
| CeruleanTradeSpeechHouse | 1 | Rhydon | Kangaskhan |
| CharcoalKiln | 1 | Moltres | Farfetch'd |
| CopycatsHouse1F | 1 | Clefairy | Blissey |
| CopycatsHouse2F | 1 | Moltres | Dodrio |
| GoldenrodDeptStoreB1F | 1 | Machop | Machoke |
| IlexForest | 1 | Bird | Farfetch'd |
| IndigoPlateauPokecenter1F | 1 | Jynx | Abra |
| LakeOfRage | 1 | Gyarados, overworld red | Gyarados, shiny colors (the battle is already shiny) |
| MahoganyMart1F | 1 | Dragon | Dragonite |
| MountMoonSquare | 2 | Fairy ×2 | Clefairy ×2 |
| MrFujisHouse | 3 | Rhydon, Growlithe, Moltres | Psyduck, Nidorino, Pidgey |
| NationalPark | 1 | Growlithe | Persian |
| OlivineLighthouse6F | 1 | Monster | Ampharos |
| PewterNidoranSpeechHouse | 1 | Growlithe | Nidoran♂ |
| PokemonFanClub | 1 | Oddish | Bayleef |
| RadioTower4F | 1 | Growlithe | Meowth |
| Route28SteelWingHouse | 1 | Moltres | Fearow |
| Route30 | 2 | Monster ×2 | Rattata ×2 |
| Route39 | 4 | Tauros ×4 | Miltank ×4 |
| Route39Barn | 1 | Tauros | Miltank (Moomoo) |
| TeamRocketBaseB2F | 7 | Dragon, Voltorb ×6 | Dragonite, Electrode ×6 |
| TeamRocketBaseB3F | 1 | Moltres | Murkrow |
| VioletNicknameSpeechHouse | 1 | Bird | Pidgey |
| ViridianNicknameSpeechHouse | 2 | Moltres, Growlithe | Spearow, Rattata |

Two of these need no slot at all: **Mount Moon Square**'s pair are Clefairy, and `SPRITE_CLEFAIRY`
already exists — change the constant and stop. **Lake of Rage** is the opposite case, a correct
species whose *object* cannot be told it is shiny — the encounter already is.

26 distinct species are involved, and under the slot design **none of them needs a new constant.**

**Deliberately left alone:**

- The three dolls in Copycat's bedroom and the Clefairy doll in the Fan Club. `SPRITE_MONSTER`,
  `SPRITE_FAIRY` and `SPRITE_BIRD` are the plush artwork, which is what those objects want.
- Every object whose species already matches: the Slowpoke in Azalea, Kurt's house and Slowpoke
  Well, Zubat in Cerulean, Rhydon in the Dance Theater and Olivine, Jigglypuff in Pewter and the
  Radio Tower, Diglett, Butterfree, Machop in Vermilion, Ho-Oh, Lugia, and the big Snorlax.

**Optional follow-up:** `SPRITE_GROWLITHE`, `SPRITE_MOLTRES`, `SPRITE_JYNX`, `SPRITE_EKANS`,
`SPRITE_TAUROS`, `SPRITE_TOGEPI`, `SPRITE_PARAS`, `SPRITE_LAPRAS` and `SPRITE_SNORLAX` end up
referenced by nothing. They are cheap to leave (`SpriteMons` is positional, so removing one means
renumbering the constants) and `utils/unreferenced.py` will name them. Worth doing as its own pass,
not folded into this one.


## Colors

**Implemented: every overworld Pokemon is now drawn in its own colors**, the same two its battle
sprite uses, arranged by `data/pokemon/icon_palette_order.asm` — exactly what the follower does.
Not just the 43 objects whose species were wrong: every object the engine draws from a menu icon,
including the correct ones (Ho-Oh, Lugia, Zubat, the Dance Theater Rhydon) and the Pokemon dolls
in the player's room.

### How an index is claimed

`MarkUsedPal` dedupes by palette *index*, so every distinct mon on screen needs its own index.
`PAL_OW_MON_1`..`_4` sit just past `PAL_OW_FOLLOWER`, and `ClaimOverworldMonPalette` hands one out:

1. `_GetSpritePalette.is_pokemon` reads `wCurIcon` and `wForm`, which `GetMonSprite` has just
   filled in — so a mon slot, a `SpriteMons` id, a doll's variable sprite and a day-care mon all
   arrive by the same door, with no per-path special casing.
2. `GetArrangedMonIconColors` turns those into the two colors.
3. The claim searches `wOverworldMonPals` for those exact colors, reusing the index if they are
   already there and taking the next one if not. **Identical mon share an index**, which is what
   keeps six Electrode and four Miltank to one palette apiece.
4. `CopySpritePal` reads the entry back and bookends it white and black, sharing the follower's
   code including its time-of-day tinting.

The table resets in `LoadMapObjects` — deliberately *not* in `ClearSavedObjPals`, which also runs
on returns from menus and battles where nothing reclaims, and an index left pointing at a cleared
entry would draw the mon black.

### The budget

Eight hardware OBJ palettes; the follower permanently owns one. Measured across every map:

| Distinct mon on one map | Maps |
| --- | --- |
| 1 | 32 |
| 2 | 4 |
| 3 | 2 (Mr. Fuji's house, Celadon Mansion 1F) |

So four indexes is one more than the worst case, and the worst case leaves four palettes for NPCs
on two quiet indoor maps. If a map ever needs more, `ClaimOverworldMonPalette` returns carry and
the object falls back to a flat overworld color rather than misdrawing — and because the search
runs before the claim, a full table still recognises colors it already holds.

Grayscale is therefore not needed, and was not built. It stays the fallback if phase 2's dynamic
mon ever crowd a busy route.

### What changed on screen

29 objects had a `PAL_NPC_*` override in their `object_event`, which would have beaten the sprite
default; their palette byte is now `0`. Two consequences worth knowing:

- **Ho-Oh, Lugia and the Red Gyarados** were flat overworld red or blue and are now themselves.
- **Route 30's two Rattata are no longer told apart by color.** Vanilla painted Joey's red and
  Mikey's blue; both are now Rattata-colored, because both are Rattata. Position and dialogue
  still distinguish them. Easy to revert on those two lines alone if it reads worse.

## Phase 2: dynamic area mon

Sketch only — the point of the design above is that this becomes additive.

**The area list.** Per landmark rather than per map, so a whole route shares one roster, with
entries carrying species, form, a shiny weight, and optionally a move or level. Shape it like the
encounter tables it will sit beside, and consider whether `tools/joe_tools/encounter_guide` should
learn to read it.

**Rolling.** In a `MAPCALLBACK_OBJECTS` callback via `callasm`: pick an entry, pick one of the
map's candidate spots, or decide nobody appears, then `SetOverworldMonSlot`.

**Not appearing.** `LoadObjectMasks` runs immediately after `MAPCALLBACK_OBJECTS`, so the callback
can mask the object out. This is the existing mechanism and needs nothing new.

**Re-rolling.** `LoadMapObjects` runs on every map setup, not only on entry from another map, so a
naive roll re-rolls after a battle or a menu — the mon would change species while you watch. The
roll wants to be cached: either keyed to the map and cleared on `MAPCALLBACK_NEWMAP`, or done there
in the first place. **Check this before building anything else**; it is the one thing in phase 2
that is easy to get subtly wrong.

**Interacting.** One generic script that reads the slot: `cry` it, offer a battle, let the roll's
special move and form carry into `LoadEnemyMon`. The follower's interaction table is the model for
picking dialogue off a species.

**Placement data.** Candidate coordinates have to come from somewhere. Options are several
`object_event`s that the callback masks down to one, or one object the callback moves. The former
needs no new movement code and costs an object struct each; the latter is tidier in the map file.
Decide when there is a map to try it on.


## Risks and things to verify

**The 16-bit ID round trip.** `.ow_mon` converts a stored *index* to an *ID* and hands it straight
to `LoadOverworldMonIcon`, which converts it back. The window is a few instructions, so eviction
cannot intervene and **no `LOCKED_MON_ID_*` slot is needed** — unlike the follower, which holds an
ID across frames in `wFollowerSpriteID` and does need one. What to watch instead is churn:
`GetPokemonIDFromIndex` allocates on every call, and objects re-resolve as they scroll on screen,
so the conversion table sees traffic it did not before. If that turns out to matter, the fix is an
index-taking entry point beside `LoadOverworldMonIcon` rather than a lock.

**`wForm` was a global that mon objects read stale — confirmed and fixed.** Reproduced in game:
with a Flying Pikachu as the follower, the Pikachu doll in the player's room came out flying.
`GetMonSprite.pokemon_sprite` left `d` at 0, which tells `LoadOverworldMonIcon` "`wForm` is already
set" — but nothing set it for a map object, so it held whatever wrote it last, and the follower is
map object 1 and loads first. The fix is a `xor a` / `ld [wForm], a` on that path: a `SpriteMons`
entry names a species and nothing else, so its form is always plain. The slot path already wrote
the form it looked up. Shininess never showed, because `_LoadOverworldMonIcon` masks with
`FORM_MASK` before the cosmetic-form lookup; only the form index leaked.

**Slots must not enter the save block.** They are derived from map data every load; saving them
would shift the save layout and invalidate existing saves for nothing.

**An empty slot must be safe.** Covered above, but it is the most likely crash: a map object
pointing at a slot the table never filled.

**`assert NUM_OW_MON_SLOTS` is doing real work.** Nothing in the data format stops a map from
declaring five; make it a build failure rather than a silent overwrite.

**Every object in `def_object_events` is positional.** The events use `object_const_def`
constants and scripts index objects by number, so edit sprite ids in place — do not reorder.
`BLACKTHORNDRAGONSPEECHHOUSE_EKANS` and friends are now misnamed; renaming them is safe and
worthwhile, but it touches every script that references them.

**Tile budget is a non-issue, and that is worth re-checking rather than trusting.** The claim is
that per-object-struct VRAM allocation means Celadon Mansion going from one shared wrong sprite to
two correct ones costs nothing. Celadon Mansion 1F is the map to load first after the change.


## Size

**Phase 1 is small.** Perhaps 60 lines of new code across four files, one new data file of about
177 bytes, and 43 single-line edits in 28 map files. No new graphics, no new script command, no
bank juggling, no save-format change, and no change to what any of it looks like on screen except
that the species are right.

**Phase 2 is a feature**, and most of its weight is in data and design (the area lists, the
placement data, the roll) rather than in the engine — which is the point of doing the slot work now.
