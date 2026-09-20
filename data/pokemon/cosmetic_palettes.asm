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

CharmeleonPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN	"gfx/pokemon/charmeleon/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/charmeleon/shiny.pal"
INCBIN	"gfx/pokemon/charmeleon_rocket/normal.gbcpal", middle_colors ; built from the front alone, see the Makefile
; A shiny Rocket Charmeleon takes the ordinary shiny Charmeleon colours, by design.
INCLUDE "gfx/pokemon/charmeleon/shiny.pal"
	assert_table_length NUM_CHARMELEON_FORMS

CharizardPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN	"gfx/pokemon/charizard/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/charizard/shiny.pal"
INCBIN	"gfx/pokemon/charizard_rocket/normal.gbcpal", middle_colors ; built from the front alone, see the Makefile
; A shiny Rocket Charizard takes the ordinary shiny Charizard colours, by design.
INCLUDE "gfx/pokemon/charizard/shiny.pal"
	assert_table_length NUM_CHARIZARD_FORMS

ArbokPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN	"gfx/pokemon/arbok/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/arbok/shiny.pal"
INCBIN	"gfx/pokemon/arbok_rocket/normal.gbcpal", middle_colors
; A shiny Rocket Arbok takes the ordinary shiny Arbok colours, by design.
INCLUDE "gfx/pokemon/arbok/shiny.pal"
	assert_table_length NUM_ARBOK_FORMS

GolbatPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN	"gfx/pokemon/golbat/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/golbat/shiny.pal"
INCBIN	"gfx/pokemon/golbat_rocket/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/golbat_rocket/shiny.pal"
	assert_table_length NUM_GOLBAT_FORMS

SnorlaxPalettes:
	; 2 middle palettes, normal and shiny, with 2 colors each
	table_width COLOR_SIZE * 2 * 2
INCBIN	"gfx/pokemon/snorlax/normal.gbcpal", middle_colors
INCLUDE "gfx/pokemon/snorlax/shiny.pal"
INCBIN	"gfx/pokemon/snorlax_apricorn/normal.gbcpal", middle_colors ; built from the front alone, see the Makefile
INCLUDE "gfx/pokemon/snorlax/shiny.pal"
	assert_table_length NUM_SNORLAX_FORMS

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
