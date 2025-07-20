DoSpriteAnimFrame:
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
; entries correspond to SPRITE_ANIM_FUNC_* constants (see constants/sprite_anim_constants.asm)
	table_width 2
	dw DoNothing ; SpriteAnimFunc_Null
	dw SpriteAnimFunc_PartyMon
	dw SpriteAnimFunc_PartyMonSwitch
	dw SpriteAnimFunc_PartyMonSelected
	dw SpriteAnimFunc_GSTitleTrail
	dw SpriteAnimFunc_NamingScreenCursor
	dw SpriteAnimFunc_GameFreakLogo
	dw SpriteAnimFunc_GSGameFreakLogoStar
	dw SpriteAnimFunc_GSGameFreakLogoSparkle
	dw SpriteAnimFunc_SlotsGolem
	dw SpriteAnimFunc_SlotsChansey
	dw SpriteAnimFunc_SlotsChanseyEgg
	dw SpriteAnimFunc_MailCursor
	dw DoNothing
	dw SpriteAnimFunc_MemoryGameCursor
	dw SpriteAnimFunc_PokegearArrow
	dw SpriteAnimFunc_TradePokeBall
	dw SpriteAnimFunc_TradeTubeBulge
	dw SpriteAnimFunc_TrademonInTube
	dw SpriteAnimFunc_RevealNewMon
	dw SpriteAnimFunc_RadioTuningKnob
	dw SpriteAnimFunc_CutLeaves
	dw SpriteAnimFunc_FlyFrom
	dw SpriteAnimFunc_FlyLeaf
	dw SpriteAnimFunc_FlyTo
	dw SpriteAnimFunc_GSIntroHoOhLugia
	dw SpriteAnimFunc_IntroSuicune
	dw SpriteAnimFunc_IntroPichuWooper
	dw SpriteAnimFunc_Celebi
	dw SpriteAnimFunc_IntroUnown
	dw SpriteAnimFunc_IntroUnownF
	dw SpriteAnimFunc_IntroSuicuneAway
	dw SpriteAnimFunc_PcCursor
	dw SpriteAnimFunc_PcQuick
	dw SpriteAnimFunc_PcMode
	dw SpriteAnimFunc_PcPack
	assert_table_length NUM_SPRITE_ANIM_FUNCS

SpriteAnimFunc_PartyMon:
	ld a, [wMenuCursorY]

	ld hl, SPRITEANIMSTRUCT_INDEX
	add hl, bc
	cp [hl]
	jr z, SpriteAnimFunc_PartyMonSwitch

	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], 8 * 2

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], 0
	ret

SpriteAnimFunc_PartyMonSwitch:
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], 8 * 3

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	ld d, a
	inc [hl]
	and $f
	ret nz

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld e, [hl]

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld a, d
	and $10 ; bit 4
	jr z, .load_zero
	ld a, e
	and a
	jr z, .load_minus_two
	cp $1
	jr z, .load_minus_one
.load_zero
	xor a
	ld [hl], a
	ret

.load_minus_one
	ld [hl], -1
	ret

.load_minus_two
	ld [hl], -2
	ret

SpriteAnimFunc_PartyMonSelected:
	ld a, [wMenuCursorY]

	ld hl, SPRITEANIMSTRUCT_INDEX
	add hl, bc
	cp [hl]
	jr z, .three_offset_right

	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], 8 * 2
	ret

.three_offset_right
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], 8 * 3
	ret

SpriteAnimFunc_GSTitleTrail:
	call AnimSeqs_AnonJumptable
	jp hl
.anon_dw
	dw .zero
	dw .one

.zero
	call AnimSeqs_IncAnonJumptableIndex

	ld hl, SPRITEANIMSTRUCT_INDEX
	add hl, bc
	ld a, [hl]

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	and $3
	ld [hl], a
	inc [hl]
	swap a

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], a

.one
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp $a4
	jr nc, .delete

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	add 4

	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	inc [hl]

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	add a
	add a

	ld d, 2
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	add 3
	ld [hl], a
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

.delete
	jmp DeinitializeSprite

SpriteAnimFunc_GSIntroHoOhLugia:
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld d, 2
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_NamingScreenCursor:
	farjp NamingScreen_AnimateCursor

SpriteAnimFunc_MailCursor:
	farjp ComposeMail_AnimateCursor

SpriteAnimFunc_GameFreakLogo:
	farjp GameFreakLogoSpriteAnim

SpriteAnimFunc_GSGameFreakLogoStar:
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .delete

	dec [hl]
	dec [hl]
	ld d, a
	and $1f
	jr nz, .stay
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	dec [hl]

.stay
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld a, [hl]
	push af
	push de
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]

	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	add [hl]
	ld [hl], a
	ret

.delete
	ld a, 1
	ld [wIntroSceneFrameCounter], a
	jmp DeinitializeSprite

SpriteAnimFunc_GSGameFreakLogoSparkle:
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .delete

	ld hl, SPRITEANIMSTRUCT_VAR4
	add hl, bc
	ld d, [hl]

	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld a, [hl]
	push af
	push de
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a

	ld hl, SPRITEANIMSTRUCT_VAR3
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h

	ld hl, SPRITEANIMSTRUCT_VAR3
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, -$10
	add hl, de
	ld e, l
	ld d, h

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d

	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld a, [hl]
	xor $20
	ld [hl], a
	ret

.delete
	jmp DeinitializeSprite

SpriteAnimFunc_SlotsGolem:
	farjp Slots_AnimateGolem

SpriteAnimFunc_SlotsChansey:
	farcall Slots_AnimateChansey
	ld hl, wSlotsDelay
	ld a, [hl]
	cp $2
	ret nz
	ld [hl], $3
	ld a, SPRITE_ANIM_FRAMESET_SLOTS_CHANSEY_2
	jmp _ReinitSpriteAnimFrame

SpriteAnimFunc_SlotsChanseyEgg:
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld a, [hl]
	dec [hl]
	ld e, a
	and $1
	jr z, .move_vertical

	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp 15 * TILE_WIDTH
	jr c, .move_right
	call DeinitializeSprite
	ld a, $4
	ld [wSlotsDelay], a
	ld de, SFX_PLACE_PUZZLE_PIECE_DOWN
	jmp PlaySFX

.move_right
	inc [hl]
.move_vertical
	ld a, e
	ld d, 32
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_PokegearArrow:
	farjp AnimatePokegearModeIndicatorArrow

SpriteAnimFunc_MemoryGameCursor:
	farjp MemoryGame_InterpretJoypad_AnimateCursor

SpriteAnimFunc_TradePokeBall:
	call AnimSeqs_AnonJumptable
	jp hl
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw .delete

.zero
	ld a, SPRITE_ANIM_FRAMESET_TRADE_POKE_BALL_WOBBLE
	call _ReinitSpriteAnimFrame

	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], 2 ; .two

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $20
	ret

.two
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next
	dec [hl]
	ret

.next
	call AnimSeqs_IncAnonJumptableIndex

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $40

.three
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp 48
	jr c, .done
	dec [hl]
	ld d, 40
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

.done
	ld de, SFX_GOT_SAFARI_BALLS
	call PlaySFX
	jr .delete

.one
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld [hl], $4

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $30

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], $24
	ret

.four
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done2

	ld d, a
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $3f
	ret nz

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld [hl], $20

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	sub $c
	ld [hl], a
	ld de, SFX_SWITCH_POKEMON
	jmp PlaySFX

.done2
	xor a

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	jmp AnimSeqs_IncAnonJumptableIndex

.delete
	jmp DeinitializeSprite

SpriteAnimFunc_TradeTubeBulge:
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	cp $b0
	jr nc, .delete
	and $3
	ret nz
	ld de, SFX_POKEBALLS_PLACED_ON_TABLE
	jmp PlaySFX

.delete
	jmp DeinitializeSprite

SpriteAnimFunc_TrademonInTube:
	farjp TradeAnim_AnimateTrademonInTube

SpriteAnimFunc_RevealNewMon:
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp $80
	jr nc, .finish_EggShell
	ld d, a
	add 8
	ld [hl], a

	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld a, [hl]
	xor $20
	ld [hl], a

	push af
	push de
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a

	pop de
	pop af
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

.finish_EggShell
	jmp DeinitializeSprite

SpriteAnimFunc_RadioTuningKnob:
	farjp AnimateTuningKnob

SpriteAnimFunc_CutLeaves:
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $80
	add hl, de
	ld e, l
	ld d, h

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d

	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	push af
	push de
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_FlyFrom:
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	and a
	ret z

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $40
	ret c

	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]
	dec [hl]

	ld hl, SPRITEANIMSTRUCT_VAR4
	add hl, bc
	ld a, [hl]
	ld d, a
	cp $40
	jr nc, .skip
	add 8
	ld [hl], a
.skip
	ld hl, SPRITEANIMSTRUCT_VAR3
	add hl, bc
	ld a, [hl]
	inc [hl]
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_FlyLeaf:
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hl]
	cp -9 * TILE_WIDTH
	jr nc, .delete_leaf
	inc [hl]
	inc [hl]

	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	dec [hl]

	ld d, $40
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	inc [hl]
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

.delete_leaf
	jmp DeinitializeSprite

SpriteAnimFunc_FlyTo:
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	cp 10 * TILE_WIDTH + 4
	ret z

	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	inc [hl]
	inc [hl]

	ld hl, SPRITEANIMSTRUCT_VAR4
	add hl, bc
	ld a, [hl]
	ld d, a
	and a
	jr z, .stay
	sub $2
	ld [hl], a
.stay
	ld hl, SPRITEANIMSTRUCT_VAR3
	add hl, bc
	ld a, [hl]
	inc [hl]
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_IntroSuicune:
	ld a, [wIntroSceneTimer]
	and a
	ret z
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], $0

	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld a, [hl]
	add 2
	ld [hl], a
	cpl
	inc a
	ld d, 32
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ld a, SPRITE_ANIM_FRAMESET_INTRO_SUICUNE_2
	jmp _ReinitSpriteAnimFrame

SpriteAnimFunc_IntroPichuWooper:
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	cp 20
	ret nc
	add 2
	ld [hl], a
	cpl
	inc a
	ld d, 32
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_IntroUnown:
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld d, [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, [hl]
	push af
	push de
	farcall Sine

	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	pop de
	pop af
	farcall Cosine

	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_IntroUnownF:
	ld a, [wSlotsDelay]
	cp $40
	ret nz
	ld a, SPRITE_ANIM_FRAMESET_INTRO_UNOWN_F_2
	jmp _ReinitSpriteAnimFrame

SpriteAnimFunc_IntroSuicuneAway:
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, [hl]
	add 16
	ld [hl], a
	ret

SpriteAnimFunc_Celebi:
	farjp UpdateCelebiPosition

AnimSeqs_AnonJumptable:
	ld hl, sp+0
	ld a, [hli]
	ld d, [hl]
	ld e, a
	inc de

	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

AnimSeqs_IncAnonJumptableIndex:
	ld hl, SPRITEANIMSTRUCT_JUMPTABLE_INDEX
	add hl, bc
	inc [hl]
	ret

SpriteAnimFunc_PcCursor:
	; Switch frameset ID depending on item mode setting.
	farcall BillsPC_CheckBagDisplay
	ld a, SPRITE_ANIM_FRAMESET_PC_CURSOR_ITEM
	jr z, .got_frameset
	assert SPRITE_ANIM_FRAMESET_PC_CURSOR == SPRITE_ANIM_FRAMESET_PC_CURSOR_ITEM - 1
	dec a
.got_frameset
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	push de
	push bc
	farcall BillsPC_GetCursorSlot
	farcall BillsPC_GetXYFromStorageBox
	pop bc
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	add hl, bc
	ld [hl], d
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], e
	pop de

	; Check for static cursor
	ld a, [wBillsPC_CursorAnimFlag]
	and a
	ret z

	; If we're picking up, the PC UI handles this flag.
	cp PCANIM_PICKUP
	jr c, .not_picking
	sub PCANIM_PICKUP - 1
	add [hl]
	ld [hl], a
	ret
.not_picking
	cp PCANIM_ANIMATE / 2 + 1
	jr c, .dont_bop
	inc [hl]
	inc [hl]
.dont_bop
	dec a
	ld [wBillsPC_CursorAnimFlag], a
	ret nz
	ld a, PCANIM_ANIMATE
	ld [wBillsPC_CursorAnimFlag], a
	ret

SpriteAnimFunc_PcQuick:
	; Moves a storage system icon from one destination to another.
	push de

	; Check if the animation has concluded
	ld hl, wBillsPC_QuickFrames
	inc [hl]
	dec [hl]
	jr z, .finish_anim
	dec [hl]

	; Handle x movement.
	ld a, [wBillsPC_QuickFromX]
	ld d, a
	ld a, [wBillsPC_QuickToX]
	ld e, a
	ld hl, SPRITEANIMSTRUCT_XOFFSET
	call .ShiftPos
	ld a, [wBillsPC_QuickFromY]
	ld d, a
	ld a, [wBillsPC_QuickToY]
	ld e, a
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	call .ShiftPos
	jr .done

.finish_anim
	farcall BillsPC_FinishQuickAnim
	; fallthrough
.done
	pop de
	ret

.ShiftPos:
	; Set sprite position depending on movement frame.
	push hl
	push bc

	; Compute the difference between the coordinates
	ld a, d
	sub e

	; Load the result into bc. This sets b to $ff if we got a negative result.
	ld c, a
	sbc a
	ld b, a

	; Multiply by the frame number.
	xor a
	ld h, a
	ld l, a
	ld a, [wBillsPC_QuickFrames]
	inc a
.loop
	dec a
	jr z, .got_multiplier
	add hl, bc
	jr .loop
.got_multiplier
	; Divide by 8 and put 8bit result in a.
	ld a, l
	sra h
	rra
	sra h
	rra
	sra h
	rra

	; Get resulting coordinate.
	add e

	; Write to sprite anim coord.
	pop bc
	pop hl
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_PcMode:
	ld a, [wBillsPC_CursorMode]
	ld h, a
	add h
	add h
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a
	ret

SpriteAnimFunc_PcPack:
	; Display male or female pack
	ld a, [wPlayerGender]
	add a
	add a
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a

	; Hide pack outside Item mode
	farcall BillsPC_CheckBagDisplay
	ld a, $80 ; move it out of view
	jr nz, .got_pack_y
	xor a
.got_pack_y
	ld hl, SPRITEANIMSTRUCT_YOFFSET
	add hl, bc
	ld [hl], a
	ret
