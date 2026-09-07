; LoadMenuMonIcon.Jumptable indexes (see engine/gfx/mon_icons.asm)
	const_def
	const MONICON_PARTYMENU
	const MONICON_NAMINGSCREEN
	const MONICON_MOVES
	const MONICON_TRADE
	const MONICON_MOBILE1
	const MONICON_MOBILE2
	const MONICON_UNUSED

; The party menu gives each party slot the OBJ palette matching its own number, holding that
; mon's own colors, so the red the held-item indicator wants no longer sits at palette 0.
DEF PARTY_MENU_ITEM_PAL EQU 6
assert PARTY_LENGTH <= PARTY_MENU_ITEM_PAL, "party slots would overwrite the held-item palette"

; Screens that show a single mon icon give it a palette to itself rather than one of the eight
; shared icon colors. Cursors and other menu sprites tend to hard-code palette 0, so take the far
; end instead. The trade screen is the exception -- its palette 7 is the trade tube.
DEF MENU_MON_ICON_PAL EQU 7
DEF TRADE_MON_ICON_PAL EQU 1

; How a mon's two colors are arranged into an icon palette. A mon pic is drawn as
; white / color 1 / color 2 / black, but icon art is not always shaded the same way round, so
; some species read better with the two swapped or with the light slot pushed to an off-white.
; These are flags, so ICON_PAL_SWAP | ICON_PAL_OFFWHITE is a valid combination.
DEF ICON_PAL_SWAP_F     EQU 0 ; use color 2 where color 1 would go, and vice versa
DEF ICON_PAL_OFFWHITE_F EQU 1 ; replace whichever color lands in the light slot with off-white

DEF ICON_PAL_NORMAL   EQU 0
DEF ICON_PAL_SWAP     EQU 1 << ICON_PAL_SWAP_F
DEF ICON_PAL_OFFWHITE EQU 1 << ICON_PAL_OFFWHITE_F

; What ICON_PAL_OFFWHITE puts in the light slot. White reads cleanly because slot 0 of an OBJ
; palette is transparent rather than drawn, so nothing else on the icon is already this color.
; Dial it down for a softer off-white.
DEF PALRGB_ICON_LIGHT EQU palred 31 + palgreen 31 + palblue 31

; party menu icon palettes
	const_def
	const PAL_ICON_RED    ; 0
	const PAL_ICON_BLUE   ; 1
	const PAL_ICON_GREEN  ; 2
	const PAL_ICON_BROWN  ; 3
	const PAL_ICON_PINK   ; 4
	const PAL_ICON_GRAY   ; 5
	const PAL_ICON_TEAL   ; 6
	const PAL_ICON_PURPLE ; 7
