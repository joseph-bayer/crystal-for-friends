SmearglePalettePointers:
; Each normal.gbcpal is generated from the corresponding .png, and
; only the middle two colors are included, not black or white.
; Shiny palettes are defined directly, not generated.

	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN "gfx/pokemon/smeargle/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/smeargle/shiny.pal"
INCLUDE "gfx/pokemon/smeargle_blue/normal.pal"
INCLUDE "gfx/pokemon/smeargle/shiny.pal"
INCLUDE "gfx/pokemon/smeargle_yellow/normal.pal"
INCLUDE "gfx/pokemon/smeargle/shiny.pal"
INCLUDE "gfx/pokemon/smeargle_purple/normal.pal"
INCLUDE "gfx/pokemon/smeargle/shiny.pal"
INCLUDE "gfx/pokemon/smeargle_green/normal.pal"
INCLUDE "gfx/pokemon/smeargle/shiny.pal"
INCLUDE "gfx/pokemon/smeargle_orange/normal.pal"
INCLUDE "gfx/pokemon/smeargle/shiny.pal"