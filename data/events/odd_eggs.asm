DEF NUM_ODD_EGGS EQU 7

MACRO prob
	DEF prob_total += \1
	dw prob_total * $ffff / 100
ENDM

OddEggProbabilities:
; entries correspond to OddEggs (below)
	table_width 2
DEF prob_total = 0
; Pichu
	prob 14
; Cleffa
	prob 14
; Igglybuff
	prob 14
; Smoochum
	prob 14
; Magby
	prob 14
; Elekid
	prob 15
; Tyrogue
	prob 15
	assert_table_length NUM_ODD_EGGS
	assert prob_total == 100, "OddEggProbabilities do not sum to 100%!"

OddEggSpecies:
	table_width 2
	dw PICHU
	dw CLEFFA
	dw IGGLYBUFF
	dw SMOOCHUM
	dw MAGBY
	dw ELEKID
	dw TYROGUE
	assert_table_length NUM_ODD_EGGS

OddEggMoves:
	dw THUNDERSHOCK, CHARM, DIZZY_PUNCH, NO_MOVE
	dw POUND, CHARM, DIZZY_PUNCH, NO_MOVE
	dw SING, CHARM, DIZZY_PUNCH, NO_MOVE
	dw POUND, LICK, DIZZY_PUNCH, NO_MOVE
	dw EMBER, DIZZY_PUNCH, NO_MOVE, NO_MOVE
	dw QUICK_ATTACK, LEER, DIZZY_PUNCH, NO_MOVE
	dw TACKLE, DIZZY_PUNCH, NO_MOVE, NO_MOVE

OddEggs:
	table_width NICKNAMED_MON_STRUCT_LENGTH

  ; Shiny Pichu
	db 0 ; Species, will be filled on load
	db NO_ITEM
	db 0, 0, 0, 0 ; Moves, will be filled on load
	dw 00256 ; OT ID
	bigdt 125 ; Exp
	db 0, 0, 0, 0, 0, 0 ; EVs
	db 0, 0, 0 ; padding
  db %00000011 ; caught ball TODO: change to something fun!
	dn 2, 10, 10, 10 ; DVs
	db 30, 20, 10, 0 ; PP
	db 4 ; Step cycles to hatch
	db 0, 0, 0 ; Pokerus, Caught data
	db 5 ; Level
	db 0, 0 ; Status
	bigdw 0 ; HP
	bigdw 17 ; Max HP
	bigdw 9 ; Atk
	bigdw 7 ; Def
	bigdw 12 ; Spd
	bigdw 9 ; SAtk
	bigdw 9 ; SDef
	db "EGG@@@@@@@@"

  ; Shiny Cleffa
	db 0 ; Species, will be filled on load
	db NO_ITEM
	db 0, 0, 0, 0 ; Moves, will be filled on load
	dw 00768 ; OT ID
	bigdt 125 ; Exp
	db 0, 0, 0, 0, 0, 0 ; EVs
	db 0, 0, 0 ; padding
  db %00000011 ; caught ball TODO: change to something fun!
	dn 2, 10, 10, 10 ; DVs
	db 35, 20, 10, 0 ; PP
	db 4 ; Step cycles to hatch
	db 0, 0, 0 ; Pokerus, Caught data
	db 5 ; Level
	db 0, 0 ; Status
	bigdw 0 ; HP
	bigdw 20 ; Max HP
	bigdw 7 ; Atk
	bigdw 8 ; Def
	bigdw 7 ; Spd
	bigdw 10 ; SAtk
	bigdw 11 ; SDef
	db "EGG@@@@@@@@"

  ; Shiny Igglybuff
	db 0 ; Species, will be filled on load
	db NO_ITEM
	db 0, 0, 0, 0 ; Moves, will be filled on load
	dw 00768 ; OT ID
	bigdt 125 ; Exp
	db 0, 0, 0, 0, 0, 0 ; EVs
	db 0, 0, 0 ; padding
  db %00000011 ; caught ball TODO: change to something fun!
	dn 2, 10, 10, 10 ; DVs
	db 15, 20, 10, 0 ; PP
	db 4 ; Step cycles to hatch
	db 0, 0, 0 ; Pokerus, Caught data
	db 5 ; Level
	db 0, 0 ; Status
	bigdw 0 ; HP
	bigdw 24 ; Max HP
	bigdw 8 ; Atk
	bigdw 7 ; Def
	bigdw 7 ; Spd
	bigdw 10 ; SAtk
	bigdw 8 ; SDef
	db "EGG@@@@@@@@"

  ; Shiny Smoochum
	db 0 ; Species, will be filled on load
	db NO_ITEM
	db 0, 0, 0, 0 ; Moves, will be filled on load
	dw 00512 ; OT ID
	bigdt 125 ; Exp
	db 0, 0, 0, 0, 0, 0 ; EVs
	db 0, 0, 0 ; padding
  db %00000011 ; caught ball TODO: change to something fun!
	dn 2, 10, 10, 10 ; DVs
	db 35, 30, 10, 0 ; PP
	db 4 ; Step cycles to hatch
	db 0, 0, 0 ; Pokerus, Caught data
	db 5 ; Level
	db 0, 0 ; Status
	bigdw 0 ; HP
	bigdw 19 ; Max HP
	bigdw 8 ; Atk
	bigdw 7 ; Def
	bigdw 12 ; Spd
	bigdw 14 ; SAtk
	bigdw 12 ; SDef
	db "EGG@@@@@@@@"

  ; Shiny Magby
	db 0 ; Species, will be filled on load
	db NO_ITEM
	db 0, 0, 0, 0 ; Moves, will be filled on load
	dw 00512 ; OT ID
	bigdt 125 ; Exp
	db 0, 0, 0, 0, 0, 0 ; EVs
	db 0, 0, 0 ; padding
  db %00000011 ; caught ball TODO: change to something fun!
	dn 2, 10, 10, 10 ; DVs
	db 25, 10, 0, 0 ; PP
	db 4 ; Step cycles to hatch
	db 0, 0, 0 ; Pokerus, Caught data
	db 5 ; Level
	db 0, 0 ; Status
	bigdw 0 ; HP
	bigdw 19 ; Max HP
	bigdw 12 ; Atk
	bigdw 9 ; Def
	bigdw 14 ; Spd
	bigdw 13 ; SAtk
	bigdw 11 ; SDef
	db "EGG@@@@@@@@"

  ; Shiny Elekid
	db 0 ; Species, will be filled on load
	db NO_ITEM
	db 0, 0, 0, 0 ; Moves, will be filled on load
	dw 00512 ; OT ID
	bigdt 125 ; Exp
	db 0, 0, 0, 0, 0, 0 ; EVs
	db 0, 0, 0 ; padding
  db %00000011 ; caught ball TODO: change to something fun!
	dn 2, 10, 10, 10 ; DVs
	db 30, 30, 10, 0 ; PP
	db 4 ; Step cycles to hatch
	db 0, 0, 0 ; Pokerus, Caught data
	db 5 ; Level
	db 0, 0 ; Status
	bigdw 0 ; HP
	bigdw 19 ; Max HP
	bigdw 11 ; Atk
	bigdw 9 ; Def
	bigdw 15 ; Spd
	bigdw 12 ; SAtk
	bigdw 11 ; SDef
	db "EGG@@@@@@@@"

  ; Shiny Tyrogue
	db 0 ; Species, will be filled on load
	db NO_ITEM
	db 0, 0, 0, 0 ; Moves, will be filled on load
	dw 00256 ; OT ID
	bigdt 125 ; Exp
	db 0, 0, 0, 0, 0, 0 ; EVs
	db 0, 0, 0 ; padding
  db %00000011 ; caught ball TODO: change to something fun!
	dn 2, 10, 10, 10 ; DVs
	db 35, 10, 0, 0 ; PP
	db 4 ; Step cycles to hatch
	db 0, 0, 0 ; Pokerus, Caught data
	db 5 ; Level
	db 0, 0 ; Status
	bigdw 0 ; HP
	bigdw 18 ; Max HP
	bigdw 8 ; Atk
	bigdw 9 ; Def
	bigdw 9 ; Spd
	bigdw 9 ; SAtk
	bigdw 9 ; SDef
	db "EGG@@@@@@@@"

	assert_table_length NUM_ODD_EGGS
