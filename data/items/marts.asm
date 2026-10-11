Marts:
; entries correspond to MART_* constants (see constants/mart_constants.asm)
	table_width 2
	dw MartCherrygrove
	dw MartAzalea
	dw MartCianwood
	dw MartGoldenrod2F1
	dw MartGoldenrod2F2
	dw MartGoldenrod3F
	dw MartGoldenrod4F
	dw MartGoldenrod5F1
	dw MartGoldenrod5F2
	dw MartGoldenrod5F3
	dw MartGoldenrod5F4
	dw MartOlivine
	dw MartMahogany1
	dw MartMahogany2
	dw MartBlackthorn
	dw MartCerulean
	dw MartVermilion
	dw MartCeladon2F1
	dw MartCeladon2F2
	dw MartCeladon3F
	dw MartCeladon3F_2
	dw MartCeladon4F
	dw MartCeladon5F1
	dw MartCeladon5F1_2
	dw MartCeladon5F2
	dw MartCeladon5F2_2
	dw MartMtMoon
	dw MartUnderground
	dw MartScalingNoExtras
	assert_table_length NUM_MARTS

MartCherrygrove:
	db 4 ; # items
	dw POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING

; MARTTYPE_SCALING extras
MartAzalea:
	db 1 ; # items
	dw CHARCOAL
	assert (@ - MartAzalea - 1) / 2 <= SCALING_MART_MAX_EXTRAS

MartCianwood:
	db 5 ; # items
	dw POTION
	dw SUPER_POTION
	dw HYPER_POTION
	dw FULL_HEAL
	dw REVIVE

MartGoldenrod2F1:
	db 7 ; # items
	dw POTION
	dw SUPER_POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw ICE_HEAL

MartGoldenrod2F2:
	db 8 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw ESCAPE_ROPE
	dw REPEL
	dw REVIVE
	dw FULL_HEAL
	dw POKE_DOLL
	dw FLOWER_MAIL

MartGoldenrod3F:
	db 7 ; # items
	dw X_SPEED
	dw X_SPECIAL
	dw X_DEFEND
	dw X_ATTACK
	dw DIRE_HIT
	dw GUARD_SPEC
	dw X_ACCURACY

MartGoldenrod4F:
	db 5 ; # items
	dw PROTEIN
	dw IRON
	dw CARBOS
	dw CALCIUM
	dw HP_UP

MartGoldenrod5F1:
	db 3 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH

MartGoldenrod5F2:
	db 4 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH
	dw TM_HEADBUTT

MartGoldenrod5F3:
	db 4 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH
	dw TM_ROCK_SMASH

MartGoldenrod5F4:
	db 5 ; # items
	dw TM_THUNDERPUNCH
	dw TM_FIRE_PUNCH
	dw TM_ICE_PUNCH
	dw TM_HEADBUTT
	dw TM_ROCK_SMASH

; MARTTYPE_SCALING extras
MartOlivine:
	db 1 ; # items
	dw SURF_MAIL
	assert (@ - MartOlivine - 1) / 2 <= SCALING_MART_MAX_EXTRAS

MartMahogany1:
	db 6 ; # items
	dw TM_FRUSTRATION
	dw TM_ROAR
	dw TINYMUSHROOM
	dw SLOWPOKETAIL
	dw POKE_BALL
	dw POTION

MartMahogany2:
	db 12 ; # items
	dw RAGECANDYBAR
	dw METAL_COAT
	dw UP_GRADE
	dw BRICK_PIECE
	dw TM_DIG
	dw TM_ROLLOUT
	dw TM_SWIFT
	dw TM_NIGHTMARE
	dw TM_DEFENSE_CURL
	dw TM_DETECT
	dw TM_FRUSTRATION
	dw TM_ROAR

MartBlackthorn:
	db 10 ; # items
	dw ULTRA_BALL
	dw HYPER_POTION
	dw MAX_REPEL
	dw FULL_HEAL
	dw TM_SLUDGE_BOMB
	dw TM_STEEL_WING
	dw TM_THIEF
	dw TM_PSYCH_UP
	dw TM_RAIN_DANCE
	dw TM_SUNNY_DAY

; MARTTYPE_SCALING extras
MartCerulean:
	db 1 ; # items
	dw SURF_MAIL
	assert (@ - MartCerulean - 1) / 2 <= SCALING_MART_MAX_EXTRAS

; MARTTYPE_SCALING extras
MartVermilion:
	db 1 ; # items
	dw LITEBLUEMAIL
	assert (@ - MartVermilion - 1) / 2 <= SCALING_MART_MAX_EXTRAS

MartCeladon2F1:
	db 7 ; # items
	dw POTION
	dw SUPER_POTION
	dw HYPER_POTION
	dw MAX_POTION
	dw REVIVE
	dw SUPER_REPEL
	dw MAX_REPEL

MartCeladon2F2:
	db 10 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw ULTRA_BALL
	dw ESCAPE_ROPE
	dw FULL_HEAL
	dw ANTIDOTE
	dw BURN_HEAL
	dw ICE_HEAL
	dw AWAKENING
	dw PARLYZ_HEAL

MartCeladon3F:
	db 5 ; # items
	dw TM_SUNNY_DAY
	dw TM_RAIN_DANCE
	dw TM_SANDSTORM
	dw TM_PROTECT
	dw TM_ENDURE

MartCeladon3F_2:
	db 9 ; # items
	dw TM_SUNNY_DAY
	dw TM_RAIN_DANCE
	dw TM_SANDSTORM
	dw TM_PROTECT
	dw TM_ENDURE
	dw TM_EARTHQUAKE
	dw TM_SOLARBEAM
	dw TM_PSYCHIC_M
	dw TM_ZAP_CANNON

MartCeladon4F:
	db 5 ; # items
	dw HP_UP
	dw PROTEIN
	dw IRON
	dw CARBOS
	dw CALCIUM

MartCeladon5F1:
	db 8 ; # items
	dw TM_MUD_SLAP
	dw TM_FURY_CUTTER
	dw TM_ATTRACT
	dw TM_SHADOW_BALL
	dw TM_DYNAMICPUNCH
	dw TM_ICY_WIND
	dw TM_IRON_TAIL
	dw TM_DRAGONBREATH

MartCeladon5F1_2:
	db 10 ; # items
	dw TM_MUD_SLAP
	dw TM_FURY_CUTTER
	dw TM_ATTRACT
	dw TM_SHADOW_BALL
	dw TM_DYNAMICPUNCH
	dw TM_ICY_WIND
	dw TM_IRON_TAIL
	dw TM_DRAGONBREATH
	dw TM_TOXIC
	dw TM_GIGA_DRAIN

MartCeladon5F2:
	db 5 ; # items
	dw TM_HIDDEN_POWER
	dw TM_SWAGGER
	dw TM_SNORE
	dw TM_SLEEP_TALK
	dw TM_SWEET_SCENT

MartCeladon5F2_2:
	db 9 ; # items
	dw TM_HIDDEN_POWER
	dw TM_SWAGGER
	dw TM_SNORE
	dw TM_SLEEP_TALK
	dw TM_SWEET_SCENT
	dw TM_RETURN
	dw TM_DREAM_EATER
	dw TM_CURSE
	dw TM_REST

MartMtMoon:
	db 6 ; # items
	dw POKE_DOLL
	dw FRESH_WATER
	dw SODA_POP
	dw LEMONADE
	dw REPEL
	dw PORTRAITMAIL

MartUnderground:
	db 4 ; # items
	dw ENERGYPOWDER
	dw ENERGY_ROOT
	dw HEAL_POWDER
	dw REVIVAL_HERB

MartScalingNoExtras:
	db 0 ; # items

; MARTTYPE_SCALING tier lists. A scaling mart sells the list for the player's
; badge count (Johto + Kanto), followed by the extras list it was opened with.

ScalingMartTiers:
; min badges, list (highest first; the last row must be 0)
	dbw 8, MartScaling8Badges
	dbw 6, MartScaling6Badges
	dbw 4, MartScaling4Badges
	dbw 2, MartScaling2Badges
	dbw 0, MartScaling0Badges

MartScaling0Badges:
	db 9 ; # items
	dw POKE_BALL
	dw POTION
	dw SUPER_POTION
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw POKE_DOLL
	dw ESCAPE_ROPE
	dw REPEL
	assert (@ - MartScaling0Badges - 1) / 2 + SCALING_MART_MAX_EXTRAS <= MAX_MART_ITEMS

MartScaling2Badges:
	db 13 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw POTION
	dw SUPER_POTION
	dw REVIVE
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw ICE_HEAL
	dw POKE_DOLL
	dw ESCAPE_ROPE
	dw REPEL
	assert (@ - MartScaling2Badges - 1) / 2 + SCALING_MART_MAX_EXTRAS <= MAX_MART_ITEMS

MartScaling4Badges:
	db 14 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw SUPER_POTION
	dw HYPER_POTION
	dw REVIVE
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw ICE_HEAL
	dw FULL_HEAL
	dw POKE_DOLL
	dw ESCAPE_ROPE
	dw SUPER_REPEL
	assert (@ - MartScaling4Badges - 1) / 2 + SCALING_MART_MAX_EXTRAS <= MAX_MART_ITEMS

MartScaling6Badges:
	db 15 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw ULTRA_BALL
	dw SUPER_POTION
	dw HYPER_POTION
	dw REVIVE
	dw ANTIDOTE
	dw PARLYZ_HEAL
	dw AWAKENING
	dw BURN_HEAL
	dw ICE_HEAL
	dw FULL_HEAL
	dw POKE_DOLL
	dw ESCAPE_ROPE
	dw SUPER_REPEL
	assert (@ - MartScaling6Badges - 1) / 2 + SCALING_MART_MAX_EXTRAS <= MAX_MART_ITEMS

MartScaling8Badges:
	db 13 ; # items
	dw POKE_BALL
	dw GREAT_BALL
	dw ULTRA_BALL
	dw POTION
	dw SUPER_POTION
	dw HYPER_POTION
	dw FULL_RESTORE
	dw REVIVE
	dw FULL_HEAL
	dw POKE_DOLL
	dw ESCAPE_ROPE
	dw SUPER_REPEL
	dw MAX_REPEL
	assert (@ - MartScaling8Badges - 1) / 2 + SCALING_MART_MAX_EXTRAS <= MAX_MART_ITEMS

DefaultMart:
	db 2 ; # items
	dw POKE_BALL
	dw POTION
