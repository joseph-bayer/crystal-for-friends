; Debug ROM: the animation viewer, in the Lab scientist's menu in the bedroom. A battle against a
; level 50 Chansey where no turn is ever taken: instead, every move and special animation can be
; played from either side (plans/move_animations_port_spec.md).
;   Left/Right: the previous or next animation; Up/Down: 10 at a time
;   SELECT: the animation's param, 0-10 (Magnitude's level, multi-hit count, send-out shiny...)
;   START: which sides play it: both, the player's Pokemon only, or the enemy's only
;   A: play; B: leave the battle

if DEF(_DEBUG)

; wDebugAnimSides values
	const_def
	const DEBUG_ANIM_SIDES_BOTH
	const DEBUG_ANIM_SIDES_PLAYER
	const DEBUG_ANIM_SIDES_ENEMY
DEF NUM_DEBUG_ANIM_SIDES EQU const_value

DEF DEBUG_ANIM_MAX_PARAM EQU 10

DebugSpecialAnims:
; the specials after the moves; DebugSpecialAnimNames matches
	dw ANIM_IN_RAIN
	dw ANIM_IN_SUN
	dw ANIM_IN_SANDSTORM
	dw ANIM_BRN
	dw ANIM_PSN
	dw ANIM_SLP
	dw ANIM_FRZ
	dw ANIM_PAR
	dw ANIM_CONFUSED
	dw ANIM_IN_LOVE
	dw ANIM_IN_NIGHTMARE
	dw ANIM_SAP
	dw ANIM_HELD_ITEM_TRIGGER
	dw ANIM_FUTURE_SIGHT_FORESAW
	dw ANIM_SEND_OUT_MON
	dw ANIM_RETURN_MON
	dw ANIM_PLAYER_STAT_DOWN
	dw ANIM_ENEMY_STAT_DOWN
	dw ANIM_PLAYER_DAMAGE
	dw ANIM_ENEMY_DAMAGE
	dw ANIM_MISS
	dw ANIM_WOBBLE
	dw ANIM_SHAKE
	dw ANIM_HIT_CONFUSION
DEF NUM_DEBUG_SPECIAL_ANIMS EQU (@ - DebugSpecialAnims) / 2

DebugSpecialAnimNames:
	list_start
	li "RAIN"
	li "SUN"
	li "SANDSTORM"
	li "BURN"
	li "POISON"
	li "SLEEP"
	li "FROZEN"
	li "PARALYZED"
	li "CONFUSED"
	li "IN LOVE"
	li "NIGHTMARE"
	li "LEECH SEED"
	li "HELD ITEM"
	li "FORESAW"
	li "SEND OUT"
	li "RETURN"
	li "YOUR STAT DOWN"
	li "FOE STAT DOWN"
	li "YOUR DAMAGE"
	li "FOE DAMAGE"
	li "MISS"
	li "WOBBLE"
	li "SHAKE"
	li "HIT CONFUSION"
	assert_list_length NUM_DEBUG_SPECIAL_ANIMS

DebugAnimViewerScript::
	closetext
	loadwildmon CHANSEY, 50
	loadvar VAR_BATTLETYPE, BATTLETYPE_DEBUG_ANIMATIONS
	startbattle
	reloadmap
	end

DebugAnimViewer::
; Runs in place of the battle's turns (BattleTurn), once both Pokemon are out.
	ld hl, wDebugAnimEntry
	xor a
	ld [hli], a
	inc a
	ld [hli], a ; entry 1 (big-endian, for PrintNum): POUND
	xor a
	ld [hli], a ; param 0
	ld [hl], a ; DEBUG_ANIM_SIDES_BOTH
	farcall EmptyBattleTextbox
	call LoadTilemapToTempTilemap ; the scene, put back after each animation
.loop
	call .Draw
.input
	call DelayFrame
	call JoyTextDelay
	ldh a, [hJoyPressed]
	bit B_PAD_B, a
	ret nz
	bit B_PAD_A, a
	jr nz, .play
	bit B_PAD_SELECT, a
	jr nz, .param
	bit B_PAD_START, a
	jr nz, .sides
	ldh a, [hJoyLast]
	ld b, 1
	bit B_PAD_RIGHT, a
	jr nz, .forward
	bit B_PAD_UP, a
	ld b, 10
	jr nz, .forward
	bit B_PAD_LEFT, a
	ld b, 1
	jr nz, .back
	bit B_PAD_DOWN, a
	ld b, 10
	jr nz, .back
	jr .input

.forward
	call DebugAnimViewer_Next
	dec b
	jr nz, .forward
	jr .loop

.back
	call DebugAnimViewer_Previous
	dec b
	jr nz, .back
	jr .loop

.param
	ld hl, wDebugAnimParam
	ld a, [hl]
	inc a
	cp DEBUG_ANIM_MAX_PARAM + 1
	jr c, .got_param
	xor a
.got_param
	ld [hl], a
	jr .loop

.sides
	ld hl, wDebugAnimSides
	ld a, [hl]
	inc a
	cp NUM_DEBUG_ANIM_SIDES
	jr c, .got_sides
	xor a
.got_sides
	ld [hl], a
	jr .loop

.play
	ld a, [wDebugAnimSides]
	cp DEBUG_ANIM_SIDES_ENEMY
	jr z, .enemy_side
	xor a ; the player's Pokemon uses it
	call DebugAnimViewer_PlayFrom
	ld a, [wDebugAnimSides]
	cp DEBUG_ANIM_SIDES_PLAYER
	jr z, .loop
.enemy_side
	ld a, 1 ; the enemy's Pokemon uses it
	call DebugAnimViewer_PlayFrom
	jr .loop

.Draw:
	hlcoord 1, 14
	lb bc, 3, SCREEN_WIDTH - 2
	call ClearBox
	hlcoord 1, 14
	ld de, wDebugAnimEntry
	lb bc, PRINTNUM_LEADINGZEROS | 2, 3
	call PrintNum
	call DebugAnimViewer_GetName ; de = the name
	hlcoord 5, 14
	rst PlaceString
	hlcoord 1, 16
	ld de, .ParamText
	rst PlaceString
	hlcoord 7, 16
	ld de, wDebugAnimParam
	lb bc, 1, 2
	call PrintNum
	ld a, [wDebugAnimSides]
	ld hl, .SidesTexts
	call DebugAnimViewer_SkipStrings
	hlcoord 11, 16
	rst PlaceString
	jmp WaitBGMap

.ParamText:
	db "PARAM@"

.SidesTexts:
; entries correspond to DEBUG_ANIM_SIDES_* constants
	db "BOTH SIDES@"
	db "YOURS ONLY@"
	db "FOE ONLY@"

DebugAnimViewer_Next:
; The next entry, after the last the first. Preserves b.
	ld hl, wDebugAnimEntry
	ld a, [hli]
	ld d, a
	ld e, [hl]
	inc de
	ld a, d
	cp HIGH(NUM_ATTACKS + NUM_DEBUG_SPECIAL_ANIMS + 1)
	jr nz, DebugAnimViewer_SetEntry
	ld a, e
	cp LOW(NUM_ATTACKS + NUM_DEBUG_SPECIAL_ANIMS + 1)
	jr nz, DebugAnimViewer_SetEntry
	ld de, 1
	jr DebugAnimViewer_SetEntry

DebugAnimViewer_Previous:
; The previous entry, before the first the last. Preserves b.
	ld hl, wDebugAnimEntry
	ld a, [hli]
	ld d, a
	ld e, [hl]
	dec de
	ld a, d
	or e
	jr nz, DebugAnimViewer_SetEntry
	ld de, NUM_ATTACKS + NUM_DEBUG_SPECIAL_ANIMS
	; fallthrough

DebugAnimViewer_SetEntry:
	ld hl, wDebugAnimEntry
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

DebugAnimViewer_GetEntry:
; out: hl = the entry; carry if it's a move (its index is the entry), else a = which special
	ld hl, wDebugAnimEntry
	ld a, [hli]
	ld l, [hl]
	ld h, a
	push hl
	ld de, -(NUM_ATTACKS + 1)
	add hl, de
	ld a, l ; the special, if not a move
	pop hl
	ccf
	ret

DebugAnimViewer_GetName:
; out: de = the current animation's name
	call DebugAnimViewer_GetEntry
	jr nc, .special
	call GetMoveIDFromIndex
	ld [wNamedObjectIndex], a
	call GetMoveName
	ld de, wStringBuffer1
	ret

.special
	ld hl, DebugSpecialAnimNames
	; fallthrough

DebugAnimViewer_SkipStrings:
; in: hl = a list of strings, a = which one. out: de = that string
	and a
	jr z, .got
.skip
	push af
.skip_char
	ld a, [hli]
	cp "@"
	jr nz, .skip_char
	pop af
	dec a
	jr nz, .skip
.got
	ld d, h
	ld e, l
	ret

DebugAnimViewer_PlayFrom:
; Play the current animation with a = hBattleTurn's Pokemon (0: the player's) as its user, then put
; the scene back: some animations hide, swap or recolor the Pokemon.
	ldh [hBattleTurn], a
	ld a, [wDebugAnimParam]
	ld [wBattleAnimParam], a
	xor a
	ld [wBattleAfterAnim], a
	call DebugAnimViewer_GetEntry
	ld d, h
	ld e, l
	jr c, .got_anim ; a move: its animation has its index
	add a
	ld e, a
	ld d, 0
	ld hl, DebugSpecialAnims
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
.got_anim
	farcall Call_PlayBattleAnim
	call SafeLoadTempTilemapToTilemap
	farcall _LoadBattleFontsHPBar
	farcall GetBattleMonBackpic
	farcall GetEnemyMonFrontpic
	call WaitBGMap
	farjp FinishBattleAnim

endc
