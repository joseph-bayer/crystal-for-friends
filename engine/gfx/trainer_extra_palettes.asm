; An enemy trainer's front pic can use up to 3 BG palettes in battle: palette A in
; PAL_BATTLE_BG_ENEMY (from TrainerPalettes), palettes B and C in PAL_BATTLE_BG_5 and
; PAL_BATTLE_BG_6 (from TrainerExtraPalettes). Each 8x8 tile of the pic picks one of them.
;
; wEnemyTrainerPicCol is the screen column of the pic's column 0, or 0 when no pic that uses
; extra palettes is on screen. Pics with only palette A keep it at 0, so they take the vanilla
; path everywhere.

DEF TRAINER_PIC_TILES        EQU 7 ; the pic is 7x7 tiles
DEF TRAINER_PIC_MAP_SIZE     EQU (TRAINER_PIC_TILES * TRAINER_PIC_TILES * 2 + 7) / 8
DEF TRAINER_EXTRA_PALS_SIZE  EQU 2 * (COLOR_SIZE * 2) + TRAINER_PIC_MAP_SIZE
; the attribute box that the enemy pic slides through (the PAL_BATTLE_BG_ENEMY box)
DEF ENEMY_PIC_BOX_LEFT       EQU 11
DEF ENEMY_PIC_PUSH_LEFT      EQU 12 ; cols 12-19: the pic's columns, in pairs
DEF ENEMY_PIC_PUSH_PAIRS     EQU (SCREEN_WIDTH - ENEMY_PIC_PUSH_LEFT) / 2
DEF ENEMY_PIC_PUSH_ROWS_1    EQU 4 ; rows pushed in the first frame
	assert ENEMY_PIC_PUSH_ROWS_1 * ENEMY_PIC_PUSH_PAIRS <= (wBGMapBufferEnd - wBGMapBufferPointers) / 2, \
		"the first half of the pic box doesn't fit in wBGMapBuffer"
	assert (TRAINER_PIC_TILES - ENEMY_PIC_PUSH_ROWS_1) * ENEMY_PIC_PUSH_PAIRS <= (wBGMapBufferEnd - wBGMapBufferPointers) / 2, \
		"the second half of the pic box doesn't fit in wBGMapBuffer"

LoadTrainerExtraBattlePals::
; While the enemy pic is a trainer, load palettes B and C into wBGPals1.
	ld a, [wTempEnemyMonSpecies]
	and a
	ret nz
	call GetTrainerExtraPalsEntry
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld de, wBGPals1 palette PAL_BATTLE_BG_5
	call .LoadPal
	assert PAL_BATTLE_BG_6 == PAL_BATTLE_BG_5 + 1
	call .LoadPal
	pop af
	ldh [rWBK], a
	ret

.LoadPal:
; White, the 2 colors at hl, black
	ld a, LOW(PALRGB_WHITE)
	ld [de], a
	inc de
	ld a, HIGH(PALRGB_WHITE)
	ld [de], a
	inc de
	ld c, COLOR_SIZE * 2
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ret

SetEnemyTrainerPicCol::
; Set wEnemyTrainerPicCol to a if the trainer's pic uses extra palettes, else to 0.
	push af
	call GetTrainerExtraPalsEntry
	ld bc, 2 * (COLOR_SIZE * 2)
	add hl, bc
	ld c, TRAINER_PIC_MAP_SIZE
	xor a
.loop
	or [hl]
	inc hl
	dec c
	jr nz, .loop
	and a
	jr z, .got_col
	pop af
	push af
.got_col
	ld [wEnemyTrainerPicCol], a
	pop af
	ret

ApplyEnemyTrainerPicAttrs::
; Write the pic's tile palettes into wAttrmap at wEnemyTrainerPicCol, clipped at the right edge.
	ld a, [wEnemyTrainerPicCol]
	and a
	ret z
	call GetTrainerExtraPalsEntry
	ld de, 2 * (COLOR_SIZE * 2)
	add hl, de
	ld e, l
	ld d, h ; de = tile map
	ld a, [wEnemyTrainerPicCol]
	ld b, a ; screen column
	ld c, 0 ; pic column
.col_loop
	ld a, b
	cp SCREEN_WIDTH
	ret nc
	push bc
	ld hl, wAttrmap
	ld c, b
	ld b, 0
	add hl, bc
	pop bc
	push bc
	; tile index = column * 7
	ld a, c
	ld b, a
	add a
	add a
	add a
	sub b
	ld c, a
	ld b, TRAINER_PIC_TILES
.row_loop
	ld a, c
	call GetTrainerPicTilePal
	and a
	jr z, .palette_a
	add PAL_BATTLE_BG_5 - 1
	jr .got_pal
.palette_a
	ld a, PAL_BATTLE_BG_ENEMY
.got_pal
	push de
	ld e, a
	ld a, [hl]
	and ~BG_PALETTE
	or e
	ld [hl], a
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	inc c
	dec b
	jr nz, .row_loop
	pop bc
	inc b
	inc c
	ld a, c
	cp TRAINER_PIC_TILES
	jr c, .col_loop
	ret

GetTrainerPicTilePal:
; a = tile index (in --columns order), de = tile map
; Returns a = 0 (palette A), 1 (B) or 2 (C). Preserves bc, de, hl.
	push hl
	push bc
	ld c, a
	srl a
	srl a
	add e
	ld l, a
	adc d
	sub l
	ld h, a
	ld b, [hl]
	; the first tile of each byte is in the high bits
	ld a, c
	and %11
	xor %11
	jr z, .done
.shift
	srl b
	srl b
	dec a
	jr nz, .shift
.done
	ld a, b
	and %11
	pop bc
	pop hl
	ret

GetTrainerExtraPalsEntry:
; hl = wTrainerClass's TrainerExtraPalettes entry
	ld a, [wTrainerClass]
	ld hl, TrainerExtraPalettes
	ld bc, TRAINER_EXTRA_PALS_SIZE
	rst AddNTimes
	ret

SlideEnemyTrainerPicAttrsRight::
; One step of the enemy trainer pic's slide-out (SlideBattlePicOut): move its attributes one
; column right along with its tiles, then push both. Takes 2 frames, like the step it replaces.
	hlcoord SCREEN_WIDTH - 2, 0, wAttrmap
	ld b, TRAINER_PIC_TILES
.row_loop
	push hl
	ld c, SCREEN_WIDTH - 1 - ENEMY_PIC_BOX_LEFT
.col_loop
	ld a, [hli]
	ld [hld], a
	dec hl
	dec c
	jr nz, .col_loop
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .row_loop
	ld hl, wEnemyTrainerPicCol
	inc [hl]
	jr PushEnemyPicBox

EnemyTrainerPicSlideInStep::
; One step of the win slide-in (BattleWinSlideInEnemyTrainerFrontpic), after it has drawn
; pic columns 0 to c-1 at screen columns 20-c to 19: paint their palettes, then push both.
; Takes 2 frames.
	ld a, SCREEN_WIDTH
	sub c
	ld [wEnemyTrainerPicCol], a
	call ApplyEnemyTrainerPicAttrs
	; fallthrough

PushEnemyPicBox:
; Push the tiles and attributes of rows 0-6, cols 12-19 through wBGMapBuffer, which VBlank
; writes in pairs of tile + attribute, so they always reach the screen together.
; Rows 0-3 go in the first frame and rows 4-6 in the second.
	lb bc, 0, ENEMY_PIC_PUSH_ROWS_1
	call .QueueRows
	call DelayFrame
	lb bc, ENEMY_PIC_PUSH_ROWS_1, TRAINER_PIC_TILES - ENEMY_PIC_PUSH_ROWS_1
	call .QueueRows
	jmp DelayFrame

.QueueRows:
; Queue c rows starting at row b.
	; tiles and attributes, ENEMY_PIC_PUSH_PAIRS pairs per row, in order
	push bc
	ld a, b
	ld hl, wTilemap + ENEMY_PIC_PUSH_LEFT
	ld de, wBGMapBuffer
	call .CopyRows
	pop bc
	push bc
	ld a, b
	ld hl, wAttrmap + ENEMY_PIC_PUSH_LEFT
	ld de, wBGMapPalBuffer
	call .CopyRows
	pop bc

	; a BG map pointer per pair
	push bc
	ldh a, [hBGMapAddress]
	ld l, a
	ldh a, [hBGMapAddress + 1]
	ld h, a
	ld a, b
	ld bc, TILEMAP_WIDTH
	rst AddNTimes
	ld de, ENEMY_PIC_PUSH_LEFT
	add hl, de
	pop bc
	push bc
	ld de, wBGMapBufferPointers
.pointer_row
	push hl
	ld b, ENEMY_PIC_PUSH_PAIRS
.pointer_pair
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	inc hl
	inc hl
	dec b
	jr nz, .pointer_pair
	pop hl
	ld a, TILEMAP_WIDTH
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	dec c
	jr nz, .pointer_row
	pop bc

	; hBGMapTileCount counts pointers
	ld a, c
	add a
	add a
	assert ENEMY_PIC_PUSH_PAIRS == 4
	ldh [hBGMapTileCount], a
	ld a, 1
	ldh [hBGMapUpdate], a
	ret

.CopyRows:
; Copy c rows of ENEMY_PIC_PUSH_PAIRS * 2 bytes from hl + a * SCREEN_WIDTH to de.
	push bc
	ld bc, SCREEN_WIDTH
	rst AddNTimes
	pop bc
.copy_row
	push bc
	push hl
	ld bc, ENEMY_PIC_PUSH_PAIRS * 2
	rst CopyBytes
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec c
	jr nz, .copy_row
	ret
