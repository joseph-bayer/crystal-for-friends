HiddenPowerDamage:
; Override Hidden Power's type based on the user's DVs, and its power based on the user's
; Hidden Power level.
; out: BattleCommand_DamageStats's damage stats, with d = Hidden Power's power

	ld hl, wBattleMonDVs
	ldh a, [hBattleTurn]
	and a
	jr z, .got_dvs
	ld hl, wEnemyMonDVs
.got_dvs
	call GetHiddenPowerType

; Overwrite the current move type.
	push af
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	pop af
	ld [hl], a

; Get the rest of the damage formula variables
; based on the new type.
	farcall BattleCommand_DamageStats ; damagestats

	push bc
	push de
	call GetUserHiddenPowerPower
	pop de
	ld d, a
	pop bc
	ret

GetHiddenPowerType::
; in: hl = a mon's DVs
; out: a = its Hidden Power type

	; Def & 3
	ld a, [hl]
	and %0011
	ld b, a

	; + (Atk & 3) << 2
	ld a, [hl]
	and %0011 << 4
	swap a
	add a
	add a
	or b

; Skip Normal
	inc a

; Skip Bird
	cp BIRD
	ret c
	inc a

; Skip unused types
	cp UNUSED_TYPES
	ret c
	add UNUSED_TYPES_END - UNUSED_TYPES
	ret

GetUserHiddenPowerPower:
; The battle user's (hBattleTurn) Hidden Power power. The player's mon uses its own level, and so
; does a link opponent's; a wild mon uses 0, and any other trainer's mon MAX_HP_LEVEL.
; out: a = power
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wCurBattleMon]
	ld hl, wPartyMon1HPLevel
	call GetPartyLocation
	ld a, [hl]
	and HP_LEVEL_MASK
	ld b, a
	ld a, [wBattleMonSpecies]
	jr GetHiddenPowerPower

.enemy
	ld a, [wLinkMode]
	and a
	jr nz, .link_opponent
	ld a, [wBattleMode]
	cp WILD_BATTLE
	ld a, MAX_HP_LEVEL
	jr nz, .got_enemy_level
	xor a
	jr .got_enemy_level

.link_opponent
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1HPLevel
	call GetPartyLocation
	ld a, [hl]
	and HP_LEVEL_MASK
.got_enemy_level
	ld b, a
	ld a, [wEnemyMonSpecies]
	; fallthrough

GetHiddenPowerPower::
; in: a = species ID, b = Hidden Power level (0 to MAX_HP_LEVEL)
; out: a = Hidden Power's power (Unown's table is higher)
	push bc
	call IsUnownID
	pop bc
	ld hl, HiddenPowerPowers
	jr nz, .got_table
	ld hl, HiddenPowerUnownPowers
.got_table
	ld a, b
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hl]
	ret

IsUnownID::
; in: a = species ID
; out: z if it's Unown
	call GetPokemonIndexFromID
	ld a, l
	cp LOW(UNOWN)
	ret nz
	ld a, h
	cp HIGH(UNOWN)
	ret

MoveScreen_PrintMoveType::
; The party menu's move screen (PlaceMoveData).
; Print the move's type at hl. Hidden Power's comes from this mon's DVs, not the move data.
	push hl
	ld a, [wCurSpecies]
	ld l, a
	ld a, MOVE_EFFECT
	call GetMoveAttribute
	pop hl
	cp EFFECT_HIDDEN_POWER
	jr z, .hidden_power_type
	ld a, [wCurSpecies]
	ld b, a
	predef_jump PrintMoveType

.hidden_power_type
	push hl
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1DVs
	call GetPartyLocation
	call GetHiddenPowerType
	pop hl
	ld b, a
	predef_jump PrintType

MoveScreen_HiddenPowerPower::
; The party menu's move screen (PlaceMoveData).
; Hidden Power shows this mon's power, from its Hidden Power level, not the move data's.
; in: a = the move data's power
; out: a = the power to show
	push af
	ld a, [wCurSpecies]
	call GetMoveIndexFromID
	ld a, l
	cp LOW(HIDDEN_POWER)
	jr nz, .not_hidden_power
	ld a, h
	cp HIGH(HIDDEN_POWER)
	jr nz, .not_hidden_power
	pop af
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1HPLevel
	call GetPartyLocation
	ld a, [hl]
	and HP_LEVEL_MASK
	push af
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Species
	call GetPartyLocation
	pop bc ; b = the level
	ld a, [hl]
	jr GetHiddenPowerPower

.not_hidden_power
	pop af
	ret

HiddenPowerPowers:
; even steps, rounded down
	table_width 1
for n, MAX_HP_LEVEL + 1
	db HIDDEN_POWER_MIN_POWER + n * (HIDDEN_POWER_MAX_POWER - HIDDEN_POWER_MIN_POWER) / MAX_HP_LEVEL
endr
	assert_table_length MAX_HP_LEVEL + 1

HiddenPowerUnownPowers:
	table_width 1
for n, MAX_HP_LEVEL + 1
	db HIDDEN_POWER_MIN_POWER + n * (HIDDEN_POWER_UNOWN_MAX_POWER - HIDDEN_POWER_MIN_POWER) / MAX_HP_LEVEL
endr
	assert_table_length MAX_HP_LEVEL + 1
