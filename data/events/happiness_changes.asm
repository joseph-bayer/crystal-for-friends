HappinessChanges:
; entries correspond to HAPPINESS_* constants
	table_width 3
	; change if happiness < 100, change if happiness < 200, change otherwise
	db  +8,  +4,  +3 ; Gained a level
	db  +5,  +3,  +2 ; Vitamin
	db  +1,  +1,  +0 ; X Item
	db  +5,  +3,  +1 ; Battled a Gym Leader
	db  +1,  +1,  +0 ; Learned a move
	db  -1,  -1,  -1 ; Lost to an enemy
	db  -5,  -5, -10 ; Fainted due to poison
	db  -5,  -5, -10 ; Lost to a much stronger enemy
	db  +4,  +4,  +4 ; Haircut (older brother) 1
	db  +8,  +8,  +8 ; Haircut (older brother) 2
	db +16, +16, +16 ; Haircut (older brother) 3
	db  +4,  +4,  +4 ; Haircut (younger brother) 1
	db  +8,  +8,  +8 ; Haircut (younger brother) 2
	db +16, +16, +16 ; Haircut (younger brother) 3
	db  -5,  -5, -10 ; Used Heal Powder or Energypowder (bitter)
	db -10, -10, -15 ; Used Energy Root (bitter)
	db -15, -15, -20 ; Used Revival Herb (bitter)
	db  +4,  +4,  +4 ; Grooming
	db +10,  +6,  +4 ; Gained a level in the place where it was caught
	assert_table_length NUM_HAPPINESS_CHANGES
