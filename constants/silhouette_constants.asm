; Four-color mon icons: the background silhouette trick (plans/follower_four_color_spec.md).
; A mon sprite's black pixels are transparent, and the background tiles under it get those pixels
; painted in color 3, so black shows through and the sprite's palette holds three real colors.

DEF SIL_MAX_SLOTS  EQU 5  ; sprite VRAM slots that can carry a silhouette mask
DEF SIL_MAX_ICONS  EQU 5  ; icons drawn per frame
DEF SIL_CELLS      EQU 9  ; background cells one 16x16 icon can cover (3x3)
DEF SIL_MASK_TILES EQU 24 ; 12 standing + 12 walking sprite tiles
DEF SIL_MASK_SIZE  EQU SIL_MASK_TILES * 8 ; 1bpp
DEF SIL_MAX_ENTRIES EQU SIL_MAX_ICONS * 4 ; OAM entries
DEF SIL_BUFFER_TILES EQU SIL_MAX_ICONS * SIL_CELLS
DEF SIL_PRIVATE_FIRST EQU $80 ; first private BG tile id, in vTiles4 (VRAM bank 1)
DEF SIL_LIST_MAX   EQU SIL_BUFFER_TILES * 2 ; VBlank writes: new cells plus restored ones

; one entry of SilArtTable: species, art, mask, three normal colors, three shiny colors
DEF SILART_LENGTH EQU 2 + 2 + 2 + 3 * 2 + 3 * 2

; one silhouette slot
rsreset
DEF SILSLOT_USED rb
DEF SILSLOT_BANK rb ; sprite VRAM bank
DEF SILSLOT_BASE rb ; first standing tile, as OAM numbers it
DEF SILSLOT_LENGTH EQU _RS

; one icon drawn last frame
rsreset
DEF SILICON_ACTIVE  rb
DEF SILICON_STRUCT  rb ; the object VRAM slot it is drawn from
DEF SILICON_CX      rb ; top-left background cell
DEF SILICON_CY      rb
DEF SILICON_MATCHED rb
DEF SILICON_MODE    rb SIL_CELLS ; 0: the cell shows its own tile, 1: its private tile
DEF SILICON_TILE    rb SIL_CELLS ; the cell's own tile id
DEF SILICON_ATTR    rb SIL_CELLS ; the cell's own attributes
DEF SILICON_KEY     rb 4 * 4 + 1 ; last frame's entries (y, x, mask tile, attributes) and count
DEF SILICON_LENGTH EQU 64
assert _RS <= SILICON_LENGTH

; the masks of one icon, plotted: 24 x 24 pixels, row-major
DEF SIL_GRID_ROW  EQU 3
DEF SIL_GRID_SIZE EQU SIL_GRID_ROW * 24

; one OAM entry of an icon, in background pixels
rsreset
DEF SILENTRY_X    rb
DEF SILENTRY_Y    rb
DEF SILENTRY_TILE rb
DEF SILENTRY_ATTR rb
DEF SILENTRY_LENGTH EQU _RS
