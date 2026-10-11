; mart types (see engine/items/mart.asm)
	const_def
	const MARTTYPE_STANDARD
	const MARTTYPE_BITTER
	const MARTTYPE_BARGAIN
	const MARTTYPE_PHARMACY
	const MARTTYPE_ROOFTOP
	const MARTTYPE_SCALING ; tier list by badge count + extras (see data/items/marts.asm)
DEF NUM_MART_TYPES EQU const_value

; Marts indexes (see data/items/marts.asm)
	const_def
	const MART_CHERRYGROVE
	const MART_AZALEA
	const MART_CIANWOOD
	const MART_GOLDENROD_2F_1
	const MART_GOLDENROD_2F_2
	const MART_GOLDENROD_3F
	const MART_GOLDENROD_4F
	const MART_GOLDENROD_5F_1
	const MART_GOLDENROD_5F_2
	const MART_GOLDENROD_5F_3
	const MART_GOLDENROD_5F_4
	const MART_OLIVINE
	const MART_MAHOGANY_1
	const MART_MAHOGANY_2
	const MART_BLACKTHORN
	const MART_CERULEAN
	const MART_VERMILION
	const MART_CELADON_2F_1
	const MART_CELADON_2F_2
	const MART_CELADON_3F
	const MART_CELADON_3F_2
	const MART_CELADON_4F
	const MART_CELADON_5F_1
	const MART_CELADON_5F_1_2
	const MART_CELADON_5F_2
	const MART_CELADON_5F_2_2
	const MART_MT_MOON
	const MART_UNDERGROUND
	const MART_SCALING_NO_EXTRAS
DEF NUM_MARTS EQU const_value

DEF MAX_MART_ITEMS EQU 16

; MARTTYPE_SCALING: largest extras list a scaling mart appends to its tier list
DEF SCALING_MART_MAX_EXTRAS EQU 1
