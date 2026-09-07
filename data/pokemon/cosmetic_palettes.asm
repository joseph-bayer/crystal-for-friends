; Each normal.gbcpal is generated from the corresponding .png, and
; only the middle two colors are included, not black or white.
; Shiny palettes are defined directly, not generated.

PikachuPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN	"gfx/pokemon/pikachu/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/pikachu/shiny.pal"
; Surf and Fly Pikachu are drawn in greys (21,21,21 and 10,10,10) rather than in their own
; colors, so they take Pikachu's yellow and brown. Their generated normal.gbcpal files are
; luminance-ordered the same way, so the light and dark slots line up.
INCBIN	"gfx/pokemon/pikachu/normal.gbcpal", middle_colors ; Surf: greyscale art, Pikachu's colors
INCLUDE "gfx/pokemon/pikachu/shiny.pal"
INCBIN	"gfx/pokemon/pikachu/normal.gbcpal", middle_colors ; Fly: greyscale art, Pikachu's colors
INCLUDE "gfx/pokemon/pikachu/shiny.pal"
INCBIN	"gfx/pokemon/pikachu_rb/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/pikachu/shiny.pal"
	assert_table_length NUM_PIKACHU_FORMS

SmearglePalettes:
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
	assert_table_length NUM_SMEARGLE_FORMS

ScytherPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN "gfx/pokemon/scyther/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/scyther/shiny.pal"
INCLUDE "gfx/pokemon/scyther_forest_green/normal.pal"
INCLUDE "gfx/pokemon/scyther/shiny.pal"
INCLUDE "gfx/pokemon/scyther_teal/normal.pal"
INCLUDE "gfx/pokemon/scyther/shiny.pal"
	assert_table_length NUM_SCYTHER_FORMS

ScizorPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN "gfx/pokemon/scizor/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/scizor/shiny.pal"
INCLUDE "gfx/pokemon/scizor_crimson/normal.pal"
INCLUDE "gfx/pokemon/scizor/shiny.pal"
INCLUDE "gfx/pokemon/scizor_dusty_rose/normal.pal"
INCLUDE "gfx/pokemon/scizor/shiny.pal"
	assert_table_length NUM_SCIZOR_FORMS

PinsirPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN "gfx/pokemon/pinsir/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/pinsir/shiny.pal"
INCLUDE "gfx/pokemon/pinsir_vine/normal.pal"
INCLUDE "gfx/pokemon/pinsir/shiny.pal"
INCLUDE "gfx/pokemon/pinsir_slate/normal.pal"
INCLUDE "gfx/pokemon/pinsir/shiny.pal"
	assert_table_length NUM_PINSIR_FORMS
