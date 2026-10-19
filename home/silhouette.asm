; Four-color mon icons: the VBlank half (engine/overworld/silhouette.asm does the rest).

SilhouetteVBlank::
; Send the private tiles drawn for this frame's sprite positions, point background cells at
; them, and put back the cells icons have left -- in the same VBlank that latches the OAM.
	ld a, [wSilPending]
	and a
	ret z
	ldh a, [rWBK]
	push af
	ldh a, [rVBK]
	push af
	ld a, [wSilSendTiles]
	and a
	jr z, .no_tiles
	dec a
	ld b, a
	ld a, BANK(wSilStaging)
	ldh [rWBK], a
	ld a, BANK(vTiles4)
	ldh [rVBK], a
	ld a, HIGH(wSilStaging)
	ldh [rVDMA_SRC_HIGH], a
	ld a, LOW(wSilStaging)
	ldh [rVDMA_SRC_LOW], a
	ld a, HIGH(vTiles4 tile (SIL_PRIVATE_FIRST - $80))
	ldh [rVDMA_DEST_HIGH], a
	ld a, LOW(vTiles4 tile (SIL_PRIVATE_FIRST - $80))
	ldh [rVDMA_DEST_LOW], a
	ld a, b
	ldh [rHDMA5], a ; general-purpose DMA: done before the next instruction
.no_tiles
	ld a, BANK(wSilList)
	ldh [rWBK], a
	xor a
	ldh [rVBK], a
	ld hl, wSilListCount
	ld a, [hli]
	and a
	jr z, .done
	ld b, a
	push hl
	push bc
.tiles
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [de], a
	inc hl
	dec b
	jr nz, .tiles
	pop bc
	pop hl
	ld a, 1
	ldh [rVBK], a
.attrs
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	inc hl
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .attrs
.done
	pop af
	ldh [rVBK], a
	pop af
	ldh [rWBK], a
	xor a
	ld [wSilPending], a
	ret

SilhouetteReset::
; The background map is about to be rewritten from wTilemap, so every private cell goes with it.
	xor a
	ld [wSilPending], a
	inc a
	ld [wSilResetReq], a
	ret

SilObjectStart::
; InitSprites is about to write object a's OAM entries. If its sprite has a silhouette, note
; where they start. Keeps every register.
	push af
	push bc
	push hl
	ld c, a
	ld hl, wSilStructMask
	cp 8
	jr c, .low_byte
	inc hl
	sub 8
.low_byte
	ld b, [hl]
	inc a
.shift
	rr b
	dec a
	jr nz, .shift
	jr nc, .done ; carry is bit n
	ldh a, [rWBK]
	push af
	ld a, BANK(wSilObjs)
	ldh [rWBK], a
	ld a, [wSilObjCount]
	cp SIL_MAX_ICONS
	jr nc, .full
	ld l, a
	add a
	add l
	add LOW(wSilObjs)
	ld l, a
	adc HIGH(wSilObjs)
	sub l
	ld h, a
	ld [hl], c
	inc hl
	ldh a, [hUsedSpriteIndex] ; where InitSprite starts writing
	ld [hl], a
	ld a, TRUE
	ld [wSilObjOpen], a
.full
	pop af
	ldh [rWBK], a
.done
	pop hl
	pop bc
	pop af
	ret

SilObjectEnd::
; ...and note where they ended. Keeps every register.
	push af
	ld a, [wSilObjOpen]
	and a
	jr z, .done
	push hl
	xor a
	ld [wSilObjOpen], a
	ldh a, [rWBK]
	push af
	ld a, BANK(wSilObjs)
	ldh [rWBK], a
	ld a, [wSilObjCount]
	ld l, a
	add a
	add l
	add LOW(wSilObjs + 2)
	ld l, a
	adc HIGH(wSilObjs + 2)
	sub l
	ld h, a
	ldh a, [hUsedSpriteIndex]
	ld [hl], a
	ld hl, wSilObjCount
	inc [hl]
	pop af
	ldh [rWBK], a
	pop hl
.done
	pop af
	ret

SilObjectsReset::
; InitSprites is starting over.
	push af
	ldh a, [rWBK]
	push af
	ld a, BANK(wSilObjCount)
	ldh [rWBK], a
	xor a
	ld [wSilObjCount], a
	ld [wSilObjOpen], a
	pop af
	ldh [rWBK], a
	pop af
	ret
