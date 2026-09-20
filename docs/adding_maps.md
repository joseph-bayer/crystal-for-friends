# Adding maps, and connecting them

How a new map gets into this ROM, what has to be registered where, and how maps join up — both by
warp and by seamless connection. Written against this tree, because CSE diverges from vanilla
pokecrystal in a few places the pret wiki tutorials will lead you wrong on.

- [What a map is made of](#what-a-map-is-made-of)
- [Adding a map](#adding-a-map)
- [Connecting maps](#connecting-maps)
- [Outdoor maps versus interiors](#outdoor-maps-versus-interiors)
- [Tilesets](#tilesets)
- [Porting a map from a Gen 1 decomp](#porting-a-map-from-a-gen-1-decomp)
- [Tooling](#tooling)
- [Checklist](#checklist)


## What a map is made of

Five pieces of data, in three different places:

| Piece | Where | Notes |
|---|---|---|
| Identity and size | `constants/map_constants.asm` | `map_const NAME, width, height`, **in blocks** |
| Block layout | `maps/Name.ablk` | one byte per block, exactly `width * height` bytes |
| Header | `data/maps/maps.asm` | tileset, environment, landmark, music, palette, fish group |
| Attributes | `data/maps/attributes.asm` | border block, connections, pointers to the other three |
| Events and scripts | `maps/Name.asm` | warps, coord events, bg events, object events, scripts |

A block is 4x4 tiles, so one block is a 32x32 pixel square, or 2x2 of the walkable tiles the player
moves through. A map declared `10, 18` is 10 blocks wide and 18 tall — 20x36 walkable tiles, and
its `.ablk` is 180 bytes.

**`.ablk` is raw data with no build step.** There is no Makefile rule for it; `data/maps/blocks.asm`
just `INCBIN`s it. Structurally it is identical to vanilla's `.blk` — the different extension only
marks that the tileset carries a companion attributes file. Renaming between the two is lossless,
which matters when using a map editor that filters on extension.


## Adding a map

### 1. Declare it

In `constants/map_constants.asm`, inside one of the `newgroup` / `endgroup` blocks:

```asm
	map_const VIRIDIAN_FOREST,                             17, 24 ; 92
```

**Append at the end of a group.** `map_const` numbers maps sequentially within their group, so
inserting in the middle renumbers every map after it — and the save file stores the player's map
group and number. Appending is the difference between "new map" and "everyone's save is now
somewhere else."

The group also decides roofs and a few other per-group tables, so pick one that fits: `DUNGEONS`
for interiors that are not attached to a town, otherwise the group of the nearest town.

### 2. Draw it

`maps/Name.ablk`, `width * height` bytes. See [Tooling](#tooling).

### 3. Write the script file

`maps/Name.asm`. The skeleton, in order — the macros assert on the order and on the counts:

```asm
	object_const_def
	const VIRIDIANFOREST_BUG_CATCHER

ViridianForest_MapScripts:
	def_scene_scripts
	def_callbacks

	def_warp_events
	warp_event  x,  y, VIRIDIAN_FOREST_SOUTH_GATE, 1

	def_coord_events
	def_bg_events
	def_object_events
	object_event  x,  y, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_..., 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SomeScript, -1
```

Cap is 17 `object_event`s per map — `NUM_OBJECTS` is 19, less the player and the follower's
reserved slot. Only 12 can be *loaded at once* (`NUM_OBJECT_STRUCTS` 14, same two reservations),
which is a separate limit that bites when many objects cluster on one screen.

### 4. Register the blocks

`data/maps/blocks.asm`:

```asm
ViridianForest_Blocks:
	INCBIN "maps/ViridianForest.ablk"
```

### 5. Register the script file

`data/maps/scripts.asm`:

```asm
INCLUDE "maps/ViridianForest.asm"
```

Both files are split into banked sections — `SECTION "Map Blocks 1".."3"` and
`SECTION "Map Scripts 1".."25"`, with a single `ENDSECTION` closing out each file. Add to a section
that still has room.
If they are all full, a **new section needs an entry in `layout.link`** as well; the linker will
tell you loudly if you forget.

### 6. Attributes

`data/maps/attributes.asm`:

```asm
	map_attributes ViridianForest, VIRIDIAN_FOREST, $05, 0
```

The third argument is the **border block** — the block id repeated in the void beyond the map's
edge. The fourth is the connection bitmask, `0` for none. See
[Connecting maps](#connecting-maps).

### 7. Header

`data/maps/maps.asm`, in the right `MapGroup_*` table, in the same order as the `map_const` list:

```asm
	map ViridianForest, TILESET_FOREST, CAVE, LANDMARK_VIRIDIAN_FOREST, MUSIC_UNION_CAVE, FALSE, PALETTE_NITE, FISHGROUP_NONE
```

Copy the closest existing map rather than inventing values. Ilex Forest is the near neighbour here
— `map IlexForest, TILESET_FOREST, CAVE, LANDMARK_ILEX_FOREST, MUSIC_UNION_CAVE, FALSE,
PALETTE_NITE, FISHGROUP_POND`, with border block `$05`. Note it uses `CAVE`, not `DUNGEON`: a
forest canopy is dark and enclosed, so it wants the cave treatment and a pinned night palette.

Each group table ends in `assert_table_length NUM_<GROUP>_MAPS`, which is derived from the
`map_const` count — so a mismatch between steps 1 and 7 fails the build rather than corrupting at
runtime. Environments are `TOWN`, `ROUTE`, `INDOOR`, `CAVE`, `ENVIRONMENT_5`, `GATE`, `DUNGEON`
(`constants/map_data_constants.asm`). Fish groups are `FISHGROUP_NONE`, `_SHORE`, `_OCEAN`,
`_LAKE`, and the rest of that list.

### 7b. If you added a whole new map *group*

Four more tables are indexed by map group and all assert their length, so a new `newgroup` means
four more entries or the build fails:

| File | Add |
|---|---|
| `data/maps/maps.asm` | a `dw MapGroup_<Name>` in `MapGroupPointers` |
| `data/maps/roofs.asm` | a `MapGroupRoofs` byte — `-1` for a group with no roofs |
| `data/maps/sgb_roof_pal_inds.asm` | a `PREDEFPAL_*` byte (unused — Crystal has no SGB support — but still asserted) |
| `gfx/tilesets/roofs.pal` | a three-line RGB block: morn/day, nite, eve |

The last two are easy to miss because nothing about them says "map group" in the filename. Copy
group 0's placeholder values in `roofs.pal` if the group has no roofs.

### 8. Landmark, if it needs a name

A landmark is what the town map and the "arrived at" banner show. Add a `LANDMARK_*` to
`constants/landmark_constants.asm` and a matching `landmark x, y, Name` row to
`data/maps/landmarks.asm`. Interior maps normally reuse the landmark of whatever they sit inside.

`LANDMARK_SPECIAL` is "no place of its own": no banner, and the Town Map, Fly and the region
checks fall back to the **backup map**, the last map entered through a warp whose destination
warp is `-1`. A map that should behave that way but still announce itself gets a **hidden
landmark**: append it after `HIDDEN_LANDMARK` in `constants/landmark_constants.asm` and give it a
row at the end of the table with `0, 0` for coordinates. The banner shows the name; everything else
goes through `GetWorldMapLocationOrBackup` and treats the map as special. Apricorn Forest and its
clearing are the examples.

### 9. Everything optional

- Wild encounters: `data/wild/johto_grass.asm`, `johto_water.asm`
- Wandering overworld Pokemon: see [overworld_pokemon.md](overworld_pokemon.md)
- Fly destination: `data/maps/flypoints.asm` plus a `SPAWN_*` in `data/maps/spawn_points.asm`
- Scene scripts: `data/maps/scenes.asm`


## Connecting maps

Two unrelated mechanisms. Pick by whether the player should see a loading seam.

### Warps

Doors, cave mouths, stairs. Nothing outside the two map files changes:

```asm
	def_warp_events
	warp_event  3, 35, VIRIDIAN_FOREST_SOUTH_GATE, 1
```

The arguments are `x, y, destination map, destination warp index` — and the index is **1-based,
counting the target's `warp_event`s in order**. Both maps need a warp pointing at the other, and
getting the index wrong is the single most common way to end up somewhere strange.

**Warp pads.** A warp whose tile has `WARP_PANEL` collision spins the player up and away, fades,
and spins them back down on the far side, the way Yellow's gym and hideout pads do. Nothing in
the warp itself changes; `WarpPadScript` in `engine/overworld/events.asm` wraps it in the
Teleport move's animation. The forest tileset's block `$30` is a floor block with a pad on its
top-left tile; the pokecenter, tower and underground tilesets have pads of their own. The
arrival tile need not be a pad.

### Connections

Seamless outdoor scrolling. Declared in `data/maps/attributes.asm`, and they are **reciprocal** —
both maps must declare the connection, with the offset sign flipped:

```asm
	map_attributes Route40, ROUTE_40, $35, SOUTH | EAST
	connection south, Route41, ROUTE_41, -15
	connection east, OlivineCity, OLIVINE_CITY, -9

	map_attributes Route41, ROUTE_41, $35, NORTH | WEST
	connection north, Route40, ROUTE_40, 15
	connection west, CianwoodCity, CIANWOOD_CITY, 0
```

Three rules the macro enforces or assumes:

- The direction must appear in the `map_attributes` bitmask.
- The `connection` lines must be listed **north, south, west, east**.
- The fourth argument is the target map's offset along the shared edge, **in blocks** — an x offset
  for east/west, a y offset for north/south. The two declarations carry the same magnitude with
  opposite signs.

`MAP_CONNECTION_PADDING_WIDTH` is 3 (`constants/gfx_constants.asm`): the strip of the neighbouring
map kept loaded past the seam. The macro clamps the copied length to the target's dimensions, so an
offset that runs a short map off the end of a long one silently shortens the seam rather than
erroring.

**Connected maps do not have to share a tileset.** Four pairs already differ — Goldenrod City and
Route 35, and Route 32 and Route 33, straddle `JOHTO` and `JOHTO_MODERN`. Blocks along the shared
edge should still match visually or the seam shows.


## Outdoor maps versus interiors

The nine steps are identical. Four things change:

- **Environment** (`maps.asm`): `ROUTE`/`TOWN` versus `CAVE`/`DUNGEON`/`INDOOR`. Drives Flash,
  encounter music, bike and weather behaviour, and whether the map counts as outdoors.
- **Palette**: outdoor maps take `PALETTE_AUTO` so they tint with the time of day; interiors
  normally pin one.
- **Roofs are per map _group_, not per map.** `MapGroupRoofs` in `data/maps/roofs.asm` is indexed
  by `MAPGROUP_*`; interiors and groups without buildings use `-1`. Put a new town in the wrong
  group and it gets the wrong roof colour.
- **Landmark and fly point** matter for a route, rarely for a dungeon interior.

Connections are in practice outdoor-only. Nothing stops an interior declaring one, but the seam
handling assumes the scrolling overworld.

> **CSE divergence.** The pret tutorial "Add a new map and landmark" tells you to update
> `data/maps/outdoor_sprites.asm`. **That file does not exist in this fork** — the dynamic palette
> system replaced it. Only a stale comment at `constants/map_constants.asm:29` still refers to it.
> Skip that step.


## Tilesets

This fork runs **384-tile tilesets with per-block attributes**, well past vanilla's 192. That makes
the pret tutorial "Expand tilesets from 192 to 255 tiles" moot here. A tileset is four files:

| File | Contents |
|---|---|
| `gfx/tilesets/<name>.png` | the tile sheet |
| `data/tilesets/<name>_metatiles.bin` | blocks: 16 bytes each, 4x4 tile ids |
| `data/tilesets/<name>_attributes.bin` | per-tile CGB attributes: palette, VRAM bank, priority |
| `data/tilesets/<name>_collision.asm` | `tilecoll` per block, four quadrants: TL, TR, BL, BR |

Adding a whole new tileset -- registering it, where its data goes, VRAM layout, colors,
animations, bank room -- is its own walkthrough: [adding_tilesets.md](adding_tilesets.md).

Collision is per **quadrant**, not per tile — each block gets one `tilecoll COLL_a, COLL_b, COLL_c,
COLL_d` line covering its four walkable tiles. Register a new tileset in `gfx/tilesets.asm` and
`constants/tileset_constants.asm`.


## Porting a map from a Gen 1 decomp

The container formats match, which is misleading. Yellow's `maps/ViridianForest.blk` is 17x24
blocks = 408 bytes, one byte per block, 4x4 tiles per block — byte-for-byte a valid `.ablk`.

**But the block ids index a different blockset, so the bytes are meaningless here:**

| | pokeyellow | this fork |
|---|---|---|
| Forest blocks | `gfx/blocksets/forest.bst`, 2048 bytes = **128 blocks** | `data/tilesets/forest_metatiles.bin`, 640 bytes = **40 blocks** |
| Attributes | none — Gen 1 has no CGB attributes | `forest_attributes.bin` |
| Collision | `data/tilesets/collision_tile_ids.asm`, a flat passable-tile list | per-quadrant `tilecoll` |

Yellow's map references blocks up to ~127; this fork's forest tileset stops at 39. There are **no
`.bin` files anywhere in the Yellow tree**. So there are two honest routes:

**Redraw with an existing CSE tileset.** What most hacks do. Use the Gen 1 map as a reference image
and lay it out again. Fast, and it looks like it belongs in Johto.

**Port the Gen 1 tileset too**, and then the `.blk` works verbatim after renaming. Three pieces:

- *Blocks*: `forest.bst` to `forest_gen1_metatiles.bin` is a straight copy — identical 16-byte,
  4x4 layout.
- *Graphics*: the Gen 1 `.png` is already 2bpp-compatible. Register it as a new tileset.
- *Collision and attributes*: **no Gen 1 equivalent exists; both must be authored.** 128 blocks of
  four-quadrant collision, plus a CGB palette for every tile. This is the real cost.

Events never port. Gen 1 uses different macros for warps, signs and objects; they get retyped.


## Tooling

Polished Map ships as two separate builds, and which one you need depends on the project:

| Build | Supports | Use it for |
|---|---|---|
| **Polished Map** | pokecrystal, pokegold, **pokered, pokeyellow**, Polished Crystal v2 | reading a Gen 1 map to copy from |
| **Polished Map++** | projects with 256–512 tiles and per-block attributes | **this fork** |

Polished Map++ **cannot read a Gen 1 project** — it looks for `*_metatiles.bin` and
`*_attributes.bin` and Yellow has neither. That is a format mismatch, not a broken install. Porting
from Yellow means running both builds side by side.

For this fork, PM++ wants `maps/*.ablk` (see the `.blk` rename note at the top), the dimensions from
`constants/map_constants.asm` and `data/maps/attributes.asm`, and the four tileset files above.


## Checklist

```
[ ] constants/map_constants.asm   map_const, appended at the end of a group
[ ] maps/Name.ablk                width * height bytes
[ ] maps/Name.asm                 scripts and events
[ ] data/maps/blocks.asm          Name_Blocks: INCBIN
[ ] data/maps/scripts.asm         INCLUDE, in a section with room
[ ] data/maps/attributes.asm      map_attributes + any connections, both sides
[ ] data/maps/maps.asm            map header, in group order
[ ] landmark_constants.asm        + data/maps/landmarks.asm, if it needs a name
[ ] optional                      encounters, wandering mon, fly point, scenes
[ ] make all                      asserts are the test suite; all three targets must build
```
