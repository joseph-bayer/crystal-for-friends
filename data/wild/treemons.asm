TreeMons:
; entries correspond to TREEMON_SET_* constants
	table_width 2
	dw TreeMonSet_None
	dw TreeMonSet_Canyon
	dw TreeMonSet_Town
	dw TreeMonSet_Route
	dw TreeMonSet_Kanto
	dw TreeMonSet_Lake
	dw TreeMonSet_Forest
	dw TreeMonSet_Rock
	assert_table_length NUM_TREEMON_SETS
	dw TreeMonSet_None ; unused

; Two tables each (common, rare).
; Structure:
;	db  %, level, species

TreeMonSet_None:
; no encounter data

TreeMonSet_Canyon:
	dbbw 50, 10, SPEAROW
	dbbw 15, 10, SPEAROW
	dbbw 15, 10, SPEAROW
	dbbw 10, 10, AIPOM
	dbbw  5, 10, AIPOM
	dbbw  5, 10, HERACROSS
	db -1

TreeMonSet_Town:
	dbbw 50, 10, SPEAROW
	dbbw 15, 10, EKANS
	dbbw 15, 10, SPEAROW
	dbbw 10, 10, AIPOM
	dbbw  5, 10, AIPOM
	dbbw  5, 10, HERACROSS
	db -1

TreeMonSet_Route:
	dbbw 50, 10, HOOTHOOT
	dbbw 15, 10, SPINARAK
	dbbw 15, 10, LEDYBA
	dbbw 10, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	dbbw  5, 10, PINECO
	db -1

TreeMonSet_Kanto:
	dbbw 50, 10, HOOTHOOT
	dbbw 15, 10, EKANS
	dbbw 15, 10, HOOTHOOT
	dbbw 10, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	dbbw  5, 10, PINECO
	db -1

TreeMonSet_Lake:
	dbbw 50, 10, HOOTHOOT
	dbbw 15, 10, VENONAT
	dbbw 15, 10, HOOTHOOT
	dbbw 10, 10, EXEGGCUTE
	dbbw  5, 10, EXEGGCUTE
	dbbw  5, 10, PINECO
	db -1

TreeMonSet_Forest:
	dbbw 30, 10, HOOTHOOT
	dbbw 15, 10, PINECO
	dbbw 15, 10, PINECO
	dbbw 10, 10, NOCTOWL
  dbbw  5, 10, CATERPIE
	dbbw  5, 10, WEEDLE
  dbbw  5, 10, METAPOD
	dbbw  5, 10, KAKUNA
	dbbw  5, 10, BUTTERFREE
	dbbw  5, 10, BEEDRILL
	db -1

TreeMonSet_Rock:
	dbbw 90, 15, KRABBY
	dbbw 10, 15, SHUCKLE
	db -1
