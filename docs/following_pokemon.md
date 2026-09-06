# Following Pokémon

How the follow-mons feature was brought into this hack, what was changed to make it work with the
CrystalShireEngine, the bugs that came out of the gap between the two engines, and how follower
graphics and palettes actually get chosen.

Source: `fellowship-of-the-roms/pokecrystal`, branch `follow-mons`, tip `28da8e085`.


## Contents

- [Why the merge was done as a patch](#why-the-merge-was-done-as-a-patch)
- [Decisions made along the way](#decisions-made-along-the-way)
- [Where the code lives](#where-the-code-lives)
- [Bugs found and fixed](#bugs-found-and-fixed)
- [Bugs from the source branch](#bugs-from-the-source-branch)
- [The tile budget](#the-tile-budget)
- [Follower graphics](#follower-graphics)
- [Follower palettes](#follower-palettes)
- [Known gaps](#known-gaps)
- [TODO](#todo)


## Why the merge was done as a patch

The follow-mons branch lives in a different repository. Git had no common ancestor to compare
against, so it could not tell "you changed this line" from "they changed this line" — it treated
every shared file as though both sides had invented it from scratch. A plain `git merge` produced
**1,020 conflicts**. Resolving those by hand would have meant re-deriving the whole engine from a
diff.

Also worth recording, because it shaped the work: the branch is **not** based on pokecrystal16. It
sits on plain pokecrystal, so every species reference in the feature was an 8-bit number. Converting
those to CSE's 16-bit index scheme became the substance of the port rather than a detail.

What was done instead:

1. Abort the merge, rescue the in-progress work, start a fresh branch.
2. Diff only the commit range that *is* the feature (`8565401a8..28da8e085`) and apply it as a patch
   with a three-way fallback. Everything before that range — the GDMA routine, dynamic sprite
   reload — was already in CSE.
3. Exclude the files where CSE already does the job better (see below), which removed a large slice
   of the conflicts outright.
4. Hand-resolve the remaining **22** conflicts. Most followed one rule: keep CSE's version, append
   the follower's additions after it. A lot of the noise was cosmetic — CSE writes `jmp` where
   vanilla writes `jp`.
5. Rewrite the parts that assume 8-bit species.

Result: 360 files changed, and all three ROM targets build with zero `utils/optimize.py` findings on
changed files.


## Decisions made along the way

| Decision | Reasoning |
| --- | --- |
| Dropped the feature's party-menu icon rewrite | It rebuilds menu icons out of the follower sprites. CSE already has colored, shiny-aware, cosmetic-form-aware icons. Taking the feature's version would have deleted that work. |
| Pinned the follower's species ID | CSE converts species between a real 16-bit index and a temporary 8-bit handle drawn from a small recycled table. Handles get evicted. The follower's now occupies a reserved slot (`LOCKED_MON_ID_FOLLOWER`) so a long walk cannot silently swap its sprite. |
| Appended script commands rather than renumbering | Both engines added new script commands at the same opcodes. The follower's nine were appended after CSE's, at `$b0`–`$b8`, so existing scripts keep working. |
| Reused CSE's icon palettes for the overworld | Instead of the feature's parallel palette table, the follower's colors come from `MonMenuIconPals`, which is already shiny-aware, mapped onto overworld palettes. |
| Reserved map object slot 1 for the follower | The feature's design. CSE's object loading was adjusted to start map objects at slot 2. |
| Moved a ROM section rather than shrinking code | The feature overflowed bank 5 by 261 bytes. `"Load Map Part"` is only ever reached across banks, so it moved to a bank with room. |


## Where the code lives

| Path | Contents |
| --- | --- |
| `engine/events/follower.asm` | The follower's interaction table and all its dialogue scripts |
| `engine/overworld/overworld.asm` | `GetFollowingSprite` / `GetFollowerIconSprite` (builds the sprite), `_GetSpritePalette` (colors) |
| `engine/overworld/map_objects.asm` | `MovementFunction_FollowerObj` (the movement state machine), Poké Ball animation |
| `engine/overworld/player_object.asm` | `FollowObjTemplate`, `RefreshFollowingCoords`, warp/connection handling |
| `gfx/icons/*.png` | The party menu icons the follower is drawn from, 16×32 px = 8 tiles |
| `engine/overworld/map_object_action.asm` | `SetFacingFollowerStep` / `SetFacingFollowerRun`, the two-frame walk cycle |
| `constants/ram_constants.asm` | `wFollowerFlags` bits |


## Bugs found and fixed

All of these assembled without warnings. Every one was found by playing the game.

**The follower vanished while walking.** CSE changed how a step starts: the caller passes the
animation to use in register `d`. Vanilla decides internally. The ported code passed nothing, which
means "stand still" — and an object told to stand still mid-step is skipped by the drawing routine.
Fixed by passing the walk animation, and the run animation when running shoes are active.

**NPCs turned into Poké Balls.** CSE uses the top bit of a sprite's tile number to pick a VRAM bank,
then strips it off. Vanilla has no such convention, so the ball's tile number meant one place to the
loader and another to the renderer, and the loader's copy landed on another character's graphics.
Fixed by encoding the tile the way CSE expects and parking the ball's 12 tiles in a genuinely free
gap.

**Garbage above talking NPCs and under jumping sprites.** The feature forces every temporary object
(speech bubbles, jump shadows) into VRAM bank 1. Harmless in vanilla, which has no banks; in CSE it
overrode the convention above and sent them into a region holding map tileset data, so they drew
scenery as sprites. Fixed by removing the override — CSE's own convention already handled it.

**The follower changed color after menus.** CSE assigns overworld palettes dynamically: one field
holds the *requested* color, and the engine decides which of the eight hardware slots to use. The
ported code wrote the requested color straight into the slot field. Fixed by writing to the request
field, plus a guard so it cannot recolor whatever else occupies that slot when no follower is out.

**The happy jump rendered the Pokémon as letters.** Not corruption — it was reading the font,
exactly as stored. While a text box is open, the font occupies the same tiles as walking frames and
shadows. Every other follower reaction animates *before* opening its box; this one opened the box
first. Fixed by reordering.

**The follower stopped hopping ledges after any scripted movement.** This one is upstream's, and
took two attempts — see [Bugs from the source branch](#bugs-from-the-source-branch).

Also fixed in passing: the paralysis reaction had `writetext` with no `opentext` and no `closetext`,
so it would have drawn text with no window.


## The tile budget

Three of the bugs above are the same constraint wearing different hats. Sprite graphics live in a
small, fixed area of video memory, and every object gets a hard-wired 12-tile slot based on its slot
number. Adding the follower added a fourteenth object, which pushed the arithmetic past what the old
split allowed.

| Region | Bank 0 | Bank 1 | Holds |
| --- | --- | --- | --- |
| Standing frames | `$00`–`$6b` | `$00`–`$3b` | 9 objects / 5 objects |
| Walking frames | `$80`–`$eb` | `$40`–`$7b` | The same objects, in motion |
| Poké Ball | `$6c`–`$77` | — | Follower recall animation |
| Emotes, shadow, grass | `$f8`–`$ff` | — | Speech bubbles, jump shadow |

The number tying it together is `FIRST_VRAM1_OBJECT_STRUCT` — where objects switch from bank 0 to
bank 1. Set it too low and bank 1's standing and walking frames collide; too high and there is no
contiguous gap left for the Poké Ball. With 14 object structs, only `9` works.

**Do not change `NUM_OBJECT_STRUCTS` without redoing this arithmetic.**


## Follower graphics

The follower is drawn from the same party menu icon the menus use. It has no artwork of its own.

### How a sprite gets built

`GetFollowingSprite` runs when the overworld needs the follower's graphics:

1. Pick the follower: the first party member with HP above zero, falling back to the first member.
   Its 8-bit species handle goes in `wFollowerSpriteID` and is locked so it cannot be evicted; its
   1-based party slot goes in `wFollowerPartyNum`.
2. Copy that member's form byte into `wForm`, then call `LoadOverworldMonIcon` — the same routine
   the day-care mons use. It returns the icon's graphics, bank, and length.
3. `GetFollowerIconSprite` assembles a 24-tile overworld sprite from it in `wDecompressScratch`.

Step 3 works because the two layouts line up. A menu icon is 8 tiles: two 2×2 frames, each stored
top-left, top-right, bottom-left, bottom-right. An overworld sprite wants 12 standing tiles — facing
down at `$00`, up at `$04`, left/right at `$08` — followed by the same 12 walking tiles at `+$80`,
in that identical order. So:

- **frame 1** is copied into all three standing facings,
- **frame 2** into all three walking facings,
- then the **down-facing** copies of both are mirrored in place, so walking towards the camera reads
  as a different pose from walking away rather than being identical.

The engine's own walk cycle then alternates the two frames, with no changes to the movement code.

Mirroring is done in software (`.MirrorFrameInPlace`): the two columns swap and every byte's bits
are reversed, since horizontal flipping of 2bpp data is a bit reversal. It runs once per sprite
load, not per frame.

### Forms, Unown and eggs come free

Because the lookup goes through `LoadOverworldMonIcon`, anything the icon system knows about works
without extra tables: cosmetic forms (that is what the `wForm` write feeds), Unown letters, and eggs
(`IconPointers` carries an `EGG is -3` entry ahead of the table). There is no separate follower
graphics table to keep in sync, and no per-form artwork to draw.

### The two-frame walk cycle

The engine's normal walk cycle has four steps: standing, walking, standing, then **the walking frame
mirrored**. That last one is fine for hand-drawn NPC art but flips a mon icon left-to-right
mid-stride. `SetFacingFollowerStep` and `SetFacingFollowerRun` mask the step frame to one bit
instead of two, so the follower alternates only the first two. They are wired up as
`OBJECT_ACTION_FOLLOWER_STEP` and `OBJECT_ACTION_FOLLOWER_RUN`, chosen in
`MovementFunction_FollowerObj` according to the step speed.

## Follower palettes

### How a color gets chosen

The follower does not get its battle-sprite colors. It gets one of the overworld palettes, chosen
in `_GetSpritePalette`:

1. Set `wCurPartySpecies` to the follower's species and point at its `MON_FORM` byte.
2. Call `GetMenuMonIconPalette`, which checks the shiny bit in that form byte and returns the
   species' **normal or shiny party-menu icon palette** — one of eight `PAL_ICON_*` values, from
   `data/pokemon/menu_icon_pals.asm`.
3. Map that through `FollowingPalLookupTable` to the matching `PAL_OW_*` value.
4. Store it in `OBJECT_PAL_INDEX` and let CSE's dynamic palette system assign one of the eight
   hardware OBJ slots.

### What palettes are available

CSE defines 17 time-of-day-aware overworld palettes (`PAL_OW_RED` through `PAL_OW_TREE`), plus emote
palettes and background-copy palettes. Of those, the first thirteen are general colors: red, blue,
green, brown, purple, gray, pink, teal, yellow, orange, azure, white, black.

**Followers can currently only reach eight of them** — red, blue, green, brown, pink, gray, teal,
purple — because the input is a `PAL_ICON_*` value and there are only eight of those. Yellow,
orange, azure, white and black are defined and available but unreachable through the current path.

Two separate limits are worth keeping straight:

- **Eight colors reachable**, because of the icon palette table feeding the lookup.
- **Eight hardware slots total**, allocated dynamically and shared with every NPC on the map. On a
  busy map the follower competes for a slot like anything else.

Palettes are also time-of-day aware — `CopySpritePal` darkens them at night and in caves — so a
follower's colors shift with the clock, the same as NPCs.

### Do shiny followers show shiny colors?

**Yes, this already works.** The shiny bit lives in the form byte, `GetMenuMonIconPalette` checks
it, and the shiny nibble of `MonMenuIconPals` is used. No extra work is needed.

The caveat: it is the shiny *icon* palette, not the mon's true shiny colors. Bulbasaur is teal
normally and green when shiny, so the difference reads clearly. But **38 of the 255 entries in
`menu_icon_pals.asm` list the same palette for normal and shiny**, and for those species a shiny
follower is indistinguishable from a normal one in the overworld. That is a data problem, not a code
one — editing the shiny nibble for those species fixes it, and improves the party menu at the same
time.

### Where else the same palettes are used

All three surfaces read the same source of truth — `MonMenuIconPals` in
`data/pokemon/menu_icon_pals.asm`, a normal/shiny nibble pair per species naming one of the eight
`PAL_ICON_*` colors, whose RGB lives in `PartyMenuOBPals`:

| Surface | How it applies the color |
| --- | --- |
| Party menu | `SetMenuMonIconColor` sets an OAM palette *number*, sharing the eight palettes `InitPartyMenuOBPals` loads |
| Box (Bill's PC) | `WriteIconPaletteData` → `GetMonPalInBCDE` looks up the same table, then copies the **RGB values** into a per-slot palette (`wBillsPC_MonPals*`) |
| Overworld follower | The same table, mapped through `FollowingPalLookupTable` to a `PAL_OW_*` value |

That makes the box the easiest place to introduce true per-species colors: it already writes
per-slot RGB rather than sharing fixed palette numbers, so pointing `GetMonPalInBCDE` at
`data/pokemon/palettes.asm` / `cosmetic_palettes.asm` would mostly do it. The party menu would first
have to move from shared palette numbers to per-icon palettes. The overworld is hardest, because the
follower competes with every NPC for the same eight hardware slots.

## Bugs from the source branch

These are defects in `follow-mons` itself rather than artifacts of porting it here — they would
reproduce on plain pokecrystal. Written up so they can be contributed back.

### 1. The follower stops hopping ledges after any scripted movement

**Symptom.** Talk to a happy follower so it jumps for joy, or trigger any cutscene that moves it,
and from then on it walks over ledges instead of hopping them, and stops sliding on ice. Crossing
into a new map fixes it.

**Cause.** `Movement_step_end`, which ends every `applymovement`, calls `RestoreDefaultMovement`,
and that reads the movement type back out of the object's *map object* entry. `FollowObjTemplate` in
`engine/overworld/player_object.asm` declares `SPRITEMOVEDATA_FOLLOWNOTEXACT`, which is plain
following with no ledge-hop or slide handling. The richer `SPRITEMOVEDATA_FOLLOWEROBJ` state machine
is only ever installed at runtime, by `RefreshFollowingCoords`, which runs during map setup. So each
of the 50-plus `applymovement FOLLOWER` sites silently downgrades the follower until the next map
load. A scripted movement also leaves `wFollowerNextMovement` wherever its sequence stopped.

The author appears to have hit this: `maps/NewBarkTown.asm` carries a `callasm .follower_movement_fix`
that zeroes `wFollowerNextMovement` right after an `applymovement FOLLOWER`, commented "hacky fix".

**Fix.** Two parts. Changing `FollowObjTemplate` to `SPRITEMOVEDATA_FOLLOWEROBJ` makes
`RestoreDefaultMovement` return the right mode, and is the correct default — but on its own it did
not clear the symptom in testing, so the state is also restored explicitly. Added to
`engine/events/follower.asm`:

```asm
RestoreFollowerAfterMovement:
	xor a
	ld [wFollowerNextMovement], a
	ld a, FOLLOWER
	call GetObjectStruct
	ld hl, OBJECT_MOVEMENT_TYPE
	add hl, bc
	ld [hl], SPRITEMOVEDATA_FOLLOWEROBJ
	ret
```

called with `callasm RestoreFollowerAfterMovement` immediately after each `applymovement FOLLOWER`
in that file. For upstream the cleaner form would be to perform this restore inside
`Movement_step_end` (or `RestoreDefaultMovement`) whenever the object is the follower, which would
cover the map scripts too and let the NewBarkTown hack be deleted.

### 2. The joy-jump animation renders the Pokemon as font tiles

**Symptom.** Talking to a happy follower makes it jump — as letters, with digits for a shadow.

**Cause.** `DefaultInteraction` runs `opentext` *before*
`applymovement FOLLOWER, .followerjumptest`. While a text box is open the font occupies vTiles1,
which is the same region that holds objects' walking frames and the emote and shadow tiles. The jump
uses walking frames and spawns a shadow, so both read the font. Every other interaction in the file
emotes *before* opening its box.

**Fix.** Move `followcry` and the `applymovement` ahead of `opentext`, and give the `.give_item`
branch its own `opentext`.

### 3. ParalyzeInteraction has no text box

**Symptom.** Talking to a paralyzed follower draws text with no window.

**Cause.** The script is `showemote` / `writetext` / `end` — missing `opentext` and `closetext`,
unlike every sibling interaction.

**Fix.** Add `opentext`, `followcry` and `closetext` to match the others.

### 4. SPRITE_FOLLOWER has no OverworldSprites entry

**Symptom.** Latent; needs the follower object present with no usable party member.

**Cause.** The branch changes `data/sprites/sprites.asm` to
`assert_table_length NUM_OVERWORLD_SPRITES - 1`, deliberately leaving `SPRITE_FOLLOWER` without a
table entry because `GetFollowingSprite` intercepts it first. But when there is no follower species
that interception falls through to `GetMonSprite` and then to the table lookup, which indexes one
entry past the end of `OverworldSprites` — yielding a garbage pointer *and* a garbage tile count for
the VRAM copy that follows.

**Fix.** Return the engine's existing "no sprite" fallback when the party yields no follower, instead
of falling through to the table.

### 5. _SetPlayerPalette is dead code that would corrupt memory

In upstream's `engine/overworld/map_objects.asm`. Nothing calls it. It contains `ld bc, 0 ; debug?`
followed by `ld hl, OBJECT_DIRECTION` / `add hl, bc`, so it would read and write near address `$0008`
rather than an object struct. Harmless while unreferenced; worth deleting before someone wires it up.
It never reached this repo — the merge dropped it — so there is nothing to fix on our side.

### 6. CheckFollowerLoaded is stubbed out

In `engine/overworld/player_object.asm` the routine opens with `xor a` / `ret`, making the loop below
it unreachable and the follower unconditionally spawned. Looks like leftover debugging.

### 7. The follower vanishes next to a pacing NPC

**Symptom.** Stand still where an NPC's patrol route crosses the follower's tile — the blue-shirted
woman in southern Cherrygrove is a reliable spot — and after a few of her passes the follower
disappears. The graphics are still in VRAM; it simply stops being drawn.

**Cause.** `HideFollowerIfNPCBump` hides the follower whenever an NPC would walk into it, setting
`FOLLOWER_INVISIBLE_F` and `FOLLOWER_INVISIBLE_ONE_STEP_F` so the NPC can pass through. The matching
restore lives in `CheckFollowerInvisOneStep`, which begins `cp PLAYER` / `ret nz` — so it only runs
while the *player* is taking a step. Stand still and nothing ever puts the follower back.

The author clearly intended a different condition: the restore contains a commented-out call to
`IsObjectStandingOnSomeoneElse` with its `ret c` still live underneath, guarding on a carry flag
nothing sets any more.

**Fix.** Added `TryRestoreHiddenFollower`, called from `MovementFunction_FollowerObj` so it runs
every frame the follower is idle rather than only on player steps. It restores visibility once
`IsNPCAtCoord` reports nothing else on the follower's tile — the check the commented-out code was
reaching for. `IsNPCAtCoord` already excludes the calling object, so the follower does not detect
itself. The dead `ret c` and its commented block were removed.

### 8. FrozenInteraction emotes on the player

It uses `showemote EMOTE_SHOCK, PLAYER, 40` where its siblings target `FOLLOWER`. Possibly
deliberate — flagged as a question rather than a defect.

### Not a bug upstream, but worth telling them

`InitSprite` gains a branch forcing every temporary object (`OBJECT_SPRITE == -1`) into `OAM_BANK1`.
Vanilla has no VRAM-bank-1 objects, so it does nothing there — but it silently breaks any engine
that does put objects in bank 1, by hijacking emotes and jump shadows. Worth a comment upstream
explaining what it is for.


## Known gaps

- **Follower speed on a bicycle is untested.** The animation timings came from vanilla, which has
  neither running shoes nor a 60fps overworld.
- **The Poké Ball recall animation shares a tile region with map graphics** that vary by tileset. It
  looks correct where it has been tested; worth a look on unusual maps.
- **Icons always face the camera.** A follower walking away from you still faces forwards; the
  mirrored down-facing frames are the only cue to travel direction.
- **`FrozenInteraction` shows its emote above the player**, not the follower, unlike its siblings.
  Possibly deliberate; flagged in case it is not.

## TODO

- **True per-species follower palettes.** Followers, the party menu and the box all borrow one of
  eight party-menu icon colors (see [Where else the same palettes are used](#where-else-the-same-palettes-are-used)).
  Giving them real colors would mean a reserved `PAL_OW_*` index meaning "use the follower's own
  palette" and teaching `CopySpritePal` to pull from `data/pokemon/palettes.asm` /
  `cosmetic_palettes.asm`. Costs one of the eight shared OBJ slots permanently, and overworld
  sprites only get three colors plus transparency, so battle palettes will not transfer exactly.
  The box is the cheapest place to start.
- **Shiny followers are invisible for some species.** 38 of the 255 entries in
  `menu_icon_pals.asm` list the same palette for normal and shiny, so those look identical in the
  overworld, party menu and box alike. That is a data fix, not a code one.
