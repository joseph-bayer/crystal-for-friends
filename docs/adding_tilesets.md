# Adding a tileset

How to give a set of maps their own tileset in this fork, worked for the mystery islands. Read
[adding_maps.md](adding_maps.md) first for the map side; this covers only the tileset.

This fork runs **384-tile tilesets with per-tile CGB attributes**, so the pret wiki's tileset
tutorials (written for 192 tiles and no attributes) do not apply. The shape is CrystalShire's.

- [What a tileset is](#what-a-tileset-is)
- [Start from a copy](#start-from-a-copy)
- [Register it](#register-it)
- [Where the graphics land in VRAM](#where-the-graphics-land-in-vram)
- [Colors](#colors)
- [Animations](#animations)
- [Bank room](#bank-room)
- [Point maps at it](#point-maps-at-it)
- [Editing with Polished Map++](#editing-with-polished-map)
- [Gotchas](#gotchas)
- [Checklist](#checklist)


## What a tileset is

Four source files, one header row, one animation table, and one constant.

| Piece | Where | What it holds |
|---|---|---|
| Tile sheet | `gfx/tilesets/<name>.png` | 128 px wide, 16 tiles a row, up to 24 rows (384 tiles). 4 colors. |
| Blocks | `data/tilesets/<name>_metatiles.bin` | 16 bytes per block: the 4x4 tile ids, row by row |
| Attributes | `data/tilesets/<name>_attributes.bin` | 16 bytes per block, one per tile: palette (bits 0-2), VRAM bank (bit 3), X/Y flip (5, 6), priority (7) |
| Collision | `data/tilesets/<name>_collision.asm` | one `tilecoll TL, TR, BL, BR` per block, `COLL_*` names from `constants/collision_constants.asm` |
| Header row | `data/tilesets.asm`, in `Tilesets` | `tileset Tileset<Name>` — banks and addresses of the five data blobs plus the animation table |
| Data blobs | `gfx/tilesets.asm`, in a `Tileset Data N` section | the labels the header row names, each an `INCBIN` of a generated `.lz` |
| Animations | `engine/tilesets/tileset_anims.asm` | `Tileset<Name>Anim::` — which tiles animate and how |
| Constant | `constants/tileset_constants.asm` | `TILESET_<NAME>`, the index into `Tilesets` |

Make does the rest: `.png` to `.2bpp`, the `.2bpp` split into three 128-tile pieces
(`tools/sub_2bpp.sh`), and every blob compressed to `.lz` (`tools/lzcomp`). None of the generated
files is committed; `make clean` deletes them.

The three per-block files must stay in step: **blocks, attributes and collision all have one entry
per block id**, and nothing asserts that they do. Johto has 133 blocks, so 2128 bytes in each `.bin`
and 133 `tilecoll` lines.


## Start from a copy

For the islands, copy Johto rather than starting blank: the islands are drawn with Johto blocks
today, so a copy renders identically and can then diverge. Four copies:

```
gfx/tilesets/johto.png                  -> gfx/tilesets/islands.png
data/tilesets/johto_metatiles.bin       -> data/tilesets/islands_metatiles.bin
data/tilesets/johto_attributes.bin      -> data/tilesets/islands_attributes.bin
data/tilesets/johto_collision.asm       -> data/tilesets/islands_collision.asm
```

Every `.ablk` written against Johto keeps meaning the same thing under the copy, because block ids
are unchanged. Anything drawn afterwards is the islands' own.


## Register it

Four edits, and the order of the first two must match.

1. **Constant.** Append to the `const_def 1` list in `constants/tileset_constants.asm`, before
   `NUM_TILESETS`:
   ```asm
   	const TILESET_ISLANDS ; xx
   ```
   Appending, never inserting: the value is the row number in `Tilesets`, and every map header
   stores it.

2. **Header row.** Append to `Tilesets` in `data/tilesets.asm`, same position:
   ```asm
   	tileset TilesetIslands
   ```
   `table_width TILESET_LENGTH` there asserts the row is 18 bytes; the macro expands the name into
   the six labels below, so the name has to match exactly.

3. **Data blobs.** In `gfx/tilesets.asm`, inside a `Tileset Data N` section with room (see
   [Bank room](#bank-room)):
   ```asm
   TilesetIslandsvTiles2GFX::
   INCBIN "gfx/tilesets/islands.2bpp.vtiles2.lz"

   TilesetIslandsvTiles5GFX::
   INCBIN "gfx/tilesets/islands.2bpp.vtiles5.lz"

   TilesetIslandsvTiles4GFX::
   INCBIN "gfx/tilesets/islands.2bpp.vtiles4.lz"

   TilesetIslandsMeta::
   INCBIN "data/tilesets/islands_metatiles.bin.lz"

   TilesetIslandsColl::
   INCLUDE "data/tilesets/islands_collision.asm"

   TilesetIslandsAttr::
   INCBIN "data/tilesets/islands_attributes.bin.lz"
   ```
   The header row stores the three GFX addresses with **one** bank byte, so the three GFX blobs
   must sit in the same section. `Meta`, `Coll` and `Attr` each carry their own bank and may go
   anywhere; Johto keeps its `Attr` in a different section from the rest.

4. **Animation table.** In `engine/tilesets/tileset_anims.asm`, a `TilesetIslandsAnim::` label —
   see [Animations](#animations).

Then `make all`. A missing label fails the link; a mismatched name fails the `tileset` macro.


## Where the graphics land in VRAM

The sheet is split at tile 128 and tile 256, and the three pieces go to three places:

| Sheet tiles | Piece | VRAM | Tile id in a block | Attribute bank bit |
|---|---|---|---|---|
| 0-127 | `vtiles2` | bank 0, `$9000` | `$00`-`$7F` | 0 |
| 128-255 | `vtiles5` | bank 1, `$9000` | `$00`-`$7F` | 1 |
| 256-383 | `vtiles4` | bank 1, `$8800` | `$80`-`$FF` | 1 |

So a block byte alone does not name a sheet tile; the attribute byte's bank bit completes it.
Polished Map++ does this bookkeeping for you and shows the sheet as one 384-tile strip. Bank 0
`$8800` (`vtiles1`) is **not** available to tilesets: it holds sprites.

Johto uses 224 tiles today, so its `vtiles4` piece is empty (1 byte compressed) and the whole third
bank-1 block is free for new art. A copy inherits that room.


## Colors

The attribute byte picks **which of eight BG palettes** a tile uses. What those eight palettes
contain comes from the map, not the tileset:

- `data/maps/environment_colors.asm` maps the map's **environment** (`TOWN`, `ROUTE`, `CAVE`, ...)
  and the time of day to eight indexes into `gfx/tilesets/bg_tiles.pal`. A `ROUTE` map gets
  `.OutdoorColors`: morning, day, night and evening sets. Every outdoor Johto map shares them.
- A tileset that wants its **own** colors is special-cased in `LoadSpecialMapPalette`
  (`engine/tilesets/tileset_palettes.asm`): Ice Path, Pokécom Center, the house, the radio tower
  and the mansion each `cp TILESET_*` there and load a `.pal` of their own. Add a `cp
  TILESET_ISLANDS` branch and an `INCLUDE "gfx/tilesets/islands.pal"` the same way. Such a palette
  is fixed; if it should still follow the time of day, it needs the four sets written out, as the
  outdoor table does.

For the islands the practical path is: keep `ROUTE` and the outdoor colors while the art is still
Johto's, and only add a special palette if the islands' own art needs colors the outdoor eight do
not have. Paint in Aseprite against `bg_tiles.pal` and the choice is obvious.


## Animations

`Tileset<Name>Anim` is a list of `dw target, routine` pairs run one per frame in rotation, ending in
`DoneTileAnimation`. `TilesetJohtoAnim` animates water at `vTiles2 tile $14`, the water palette,
flowers and four whirlpool frames. `Tileset0Anim` (shared by Kanto and Johto Modern) is the same
without the whirlpools.

The tile addresses are **positions in VRAM**, so a copied sheet keeps them valid only for as long
as the water and flower tiles stay where Johto has them. Move those tiles and the table must move
with them. A tileset with nothing animated points at a table that is just
`dw NULL, DoneTileAnimation`. For a copy of Johto, an alias is enough:

```asm
TilesetIslandsAnim::
TilesetJohtoAnim::
	...
```


## Bank room

Tileset data lives in eleven `Tileset Data N` sections, pinned to banks by `layout.link`. Measured
from `pokecrystal.map` on 2026-09-16, after a build:

| Section | Bank | Free |
|---|---|---|
| Tileset Data 1, 2, 3, 4, 9, 10, 11 | 6, 7, 8, 12, 2, 1, 4 | none to speak of (0-6 bytes) |
| Tileset Data 5 | 45 | 4,721 bytes |
| Tileset Data 6 | 55 | 4,193 bytes |
| Tileset Data 7 | 119 | 5,945 bytes |
| Tileset Data 8 | 120 | 14,997 bytes |

A full Johto-sized tileset compresses to about 3.1 KB (graphics 2.0 KB, blocks 0.9 KB, attributes
0.3 KB) plus 532 bytes of uncompressed collision. **Tileset Data 8** takes a new one with room to
spare. If the linker reports an overflow, move blobs to another section or add a `Tileset Data 12`
to `layout.link`; it is a layout decision, not a size one.


## Point maps at it

In `data/maps/maps.asm`, the map header's second field:

```asm
	map HiddenGrove, TILESET_ISLANDS, ROUTE, LANDMARK_SPECIAL, MUSIC_ROUTE_36, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
```

The `.ablk` needs no change for a copied tileset. Roofs are per map group
(`data/maps/roofs.asm`) and the islands' group already says `-1`, no roof. `PALETTE_AUTO` means
"follow the time of day"; `PALETTE_DAY` and friends pin one.

`TilesetUnchanged` short-circuits graphics loading when two consecutive maps share a tileset, so
walking between two island maps on the same tileset is cheaper than warping from Cianwood to an
island. Nothing to do; it works from the constant.


## Editing with Polished Map++

Use the **++** build (see [adding_maps.md](adding_maps.md#tooling)). It finds a tileset by the
constant in `constants/tileset_constants.asm` and the four files named after it, so name them
consistently before opening the project. It edits blocks, attributes and collision together, which
is far less error-prone than keeping three files in step by hand, and it renders the 384-tile sheet
as one strip.

Tile art itself is drawn in Aseprite on the `.png`: 8x8 grid, 4 colors per tile, painted against
the palette the tile will use. Make regenerates everything downstream.


## Gotchas

- **Changing a shared tileset changes every map on it.** Johto has 32. Copy first, then diverge.
- **The three per-block files have no cross-check.** A block added to `metatiles.bin` without its
  16 attribute bytes and its `tilecoll` line shifts every later block's attributes and collision.
  PM++ keeps them together; by hand, count.
- **The three GFX blobs share one bank byte.** Same section, always.
- **Animation addresses are VRAM positions**, not sheet positions. Moving an animated tile in the
  sheet silently animates whatever moved into its old slot.
- **Bank 0 `$8800` is sprites.** Tilesets get three 128-tile blocks, not four.
- **Generated files are gitignored.** `.2bpp`, `.vtiles[245]`, `.lz` all come from Make; commit the
  `.png`, the two `.bin`s and the `.asm`.


## Checklist

```
[ ] gfx/tilesets/<name>.png                     128 px wide, <= 24 rows, 4 colors
[ ] data/tilesets/<name>_metatiles.bin          16 bytes per block
[ ] data/tilesets/<name>_attributes.bin         16 bytes per block, same count
[ ] data/tilesets/<name>_collision.asm          one tilecoll per block, same count
[ ] constants/tileset_constants.asm             TILESET_<NAME>, appended
[ ] data/tilesets.asm                           tileset Tileset<Name>, appended, same position
[ ] gfx/tilesets.asm                            six labels in a section with room; GFX three together
[ ] engine/tilesets/tileset_anims.asm           Tileset<Name>Anim, or an alias
[ ] engine/tilesets/tileset_palettes.asm        only if it needs its own colors
[ ] data/maps/maps.asm                          map headers switched to the new constant
[ ] make all                                    all three targets; the link catches a missing label
```
