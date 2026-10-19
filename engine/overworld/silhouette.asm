; Four-color mon icons: the background silhouette trick (plans/follower_four_color_spec.md).
;
; A mon sprite's black pixels are drawn transparent, and the background tiles under it get those
; pixels set to color 3, so black shows through and the sprite's OBJ palette holds three colors.
;
; While InitSprites builds OAM, SilObjectStart/End (home/silhouette.asm) note where the entries
; of every object whose sprite has a silhouette mask went. Then, once a frame, SilhouetteUpdate:
; 1. reads each such object's OAM entries; an object whose entries haven't changed is skipped;
; 2. ORs each entry's mask into a 24x24-pixel grid (3x3 background cells) at its pixel offset;
; 3. draws a private copy of every covered background tile with the mask painted in as color 3,
;    into a staging buffer: one fixed private tile per icon cell, in vTiles4;
; 4. leaves SilhouetteVBlank the tiles to GDMA and the cells to repoint or put back. VBlank does
;    both together with this frame's OAM, so the black never lags the sprite.
;
; Where a sprite is drawn behind the background (tall grass, swimming, BG-priority tiles), a
; silhouette pixel is only painted over color 0, which is exactly where its black would have shown.
;
; Spike scope: the Johto tileset only; source pixels come from an uncompressed copy of it below.

SilhouetteUpdate::
; farcall hands the callee's registers back, so keep the caller's here.
	push af
	push bc
	push de
	push hl
	ldh a, [rWBK]
	push af
	assert BANK(wMapTileset) == BANK(wMapGroup) && BANK(wMapTileset) == BANK(wBGMapAnchor)
	ld a, BANK(wMapTileset)
	ldh [rWBK], a
	ld a, [wMapTileset]
	ld b, a
	ld a, [wMapGroup]
	ld c, a
	ld hl, wBGMapAnchor
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, BANK(wSilIcons)
	ldh [rWBK], a
	ld a, b
	ld [wSilTileset], a
	ld a, c
	ld [wSilGroup], a
	; the anchor's background cell
	ld a, e
	and %11111
	ld [wSilAnchorCol], a
	ld a, d
	and %11
	ld d, a
	ld a, e
	srl d
	rra
	srl d
	rra
	srl a
	srl a
	srl a
	ld [wSilAnchorRow], a
	call SilUpdate
	pop af
	ldh [rWBK], a
	pop hl
	pop de
	pop bc
	pop af
	ret

SilUpdate:
	ld a, [wSilPending]
	and a
	ret nz ; last frame's work hasn't been applied yet
	ld a, [wSilResetReq]
	and a
	call nz, SilForgetIcons
	ld a, [wSilDisable]
	and a
	jr nz, .off
	ld a, [wSilTileset]
	cp TILESET_JOHTO
	jr nz, .off
	jr SilDrawFrame

.off
	call SilClearList
	ld hl, wSilIcons + SILICON_MATCHED
	call SilClearMatched
	call SilRestoreUnmatched
	jmp SilFinishList

SilForgetIcons:
; The background map was rewritten, so no cell shows a private tile any more.
	xor a
	ld [wSilResetReq], a
	ld hl, wSilIcons + SILICON_ACTIVE
	; fallthrough
SilClearMatched:
; Clear one byte of every icon record, from hl.
	ld de, SILICON_LENGTH
	ld b, SIL_MAX_ICONS
	xor a
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

; One frame -------------------------------------------------------------------------------------

SilDrawFrame:
	ld hl, wSilIcons + SILICON_MATCHED
	call SilClearMatched
	call SilClearList
	xor a
	ld [wSilRendered], a
	ld [wSilObjIndex], a
	ld [wSilAnyDrawn], a
.object_loop
	ld a, [wSilObjIndex]
	ld hl, wSilObjCount
	cp [hl]
	jr nc, .objects_done
	call SilDoObject
	ld hl, wSilObjIndex
	inc [hl]
	jr .object_loop

.objects_done
	xor a
	ld [wSilDirty], a
	call SilRestoreUnmatched
	; every icon's tiles go together, from the first through the highest drawn this frame
	ld a, [wSilAnyDrawn]
	and a
	jr z, .no_tiles
	ld a, [wSilRendered]
	and a
	jr z, .no_tiles
	ld b, a
	add a
	add a
	add a
	add b ; * 9
	ld [wSilSendTiles], a
.no_tiles
	jmp SilFinishList

SilRestoreUnmatched:
; Put back the cells of every icon that wasn't drawn this frame, and forget it.
	xor a
	ld [wSilCur], a
.loop
	call SilCurIconPtr
	ld a, [hl] ; SILICON_ACTIVE
	and a
	jr z, .next
	ld de, SILICON_MATCHED
	add hl, de
	ld a, [hl]
	and a
	jr nz, .next
	call SilCurIconPtr
	xor a
	ld [hl], a ; no longer active
	ld hl, wSilNewMode ; nothing new covers its cells
	ld b, SIL_CELLS
.clear_new
	ld [hli], a
	dec b
	jr nz, .clear_new
	call SilRestoreOldCells
.next
	ld hl, wSilCur
	inc [hl]
	ld a, [hl]
	cp SIL_MAX_ICONS
	jr nz, .loop
	ret

SilCurIconPtr:
; hl = icon record wSilCur
	assert SILICON_LENGTH == 64
	ld a, [wSilCur]
	ld h, a
	ld l, 0
	srl h
	rr l
	srl h
	rr l ; * 64
	ld a, l
	add LOW(wSilIcons)
	ld l, a
	ld a, h
	adc HIGH(wSilIcons)
	ld h, a
	ret

; One object ------------------------------------------------------------------------------------

SilDoObject:
; Draw object wSilObjIndex's icon, if its OAM entries changed since last frame.
	ld a, [wSilObjIndex]
	ld b, a
	add a
	add b
	add LOW(wSilObjs)
	ld l, a
	adc HIGH(wSilObjs)
	sub l
	ld h, a
	ld a, [hli] ; object VRAM slot
	ld [wSilObjStruct], a
	ld c, a
	ld a, [hli] ; first OAM byte
	ld [wSilObjStart], a
	ld b, a
	ld a, [hl] ; past the last
	sub b
	srl a
	srl a ; entries
	cp 4 + 1
	jr c, .count_ok
	ld a, 4
.count_ok
	and a
	ret z
	ld [wSilObjEntries], a
	; this object's silhouette slot
	ld b, 0
	ld hl, wSilStructSlot
	add hl, bc
	ld a, [hl]
	and a
	ret z
	dec a
	ld [wSilGroupSlot], a
	call SilMatchIcon
	ret c
	call SilReadEntries
	jr nz, .draw
	ld a, [wSilDirty]
	and a
	jr nz, .draw
	; unchanged: its cells and tiles are already right, but its tiles still go out with the rest
	ld a, [wSilCur]
	jr SilNoteRendered
.draw
	ld a, TRUE
	ld [wSilAnyDrawn], a
	call SilBuildGrids
	jmp SilApplyIcon

SilNoteRendered:
; a = an icon record that has tiles in staging
	inc a
	ld b, a
	ld a, [wSilRendered]
	cp b
	ret nc
	ld a, b
	ld [wSilRendered], a
	ret

SilMatchIcon:
; Find the record of object wSilObjStruct, or a free one. Out: wSilCur; carry if there is no room.
	xor a
	ld [wSilCur], a
.find
	call SilCurIconPtr
	ld a, [hli] ; SILICON_ACTIVE
	and a
	jr z, .find_next
	ld a, [wSilObjStruct]
	cp [hl] ; SILICON_STRUCT
	jr nz, .find_next
	ld de, SILICON_MATCHED - SILICON_STRUCT
	add hl, de
	ld [hl], TRUE
	and a
	ret

.find_next
	ld hl, wSilCur
	inc [hl]
	ld a, [hl]
	cp SIL_MAX_ICONS
	jr nz, .find

	; a new icon
	xor a
	ld [wSilCur], a
.free
	call SilCurIconPtr
	ld a, [hl]
	and a
	jr z, .got_free
	ld hl, wSilCur
	inc [hl]
	ld a, [hl]
	cp SIL_MAX_ICONS
	jr nz, .free
	scf
	ret

.got_free
	push hl
	ld bc, SILICON_LENGTH
	xor a
	call ByteFill ; no cells shown, and a key nothing matches
	pop hl
	ld a, TRUE
	ld [hli], a ; SILICON_ACTIVE
	ld a, [wSilObjStruct]
	ld [hli], a ; SILICON_STRUCT
	inc hl
	inc hl
	ld [hl], TRUE ; SILICON_MATCHED
	ld de, SILICON_KEY - SILICON_MATCHED
	add hl, de
	ld [hl], $ff ; never a real y
	and a
	ret

SilReadEntries:
; Copy the object's OAM entries, in background pixels, into its record's key (y, x, mask tile,
; attributes, then the count). Returns nz if they changed.
	call SilCurIconPtr
	ld de, SILICON_KEY
	add hl, de
	ld d, h
	ld e, l ; de = the key
	ld a, [wSilObjStart]
	ld l, a
	ld h, HIGH(wShadowOAM)
	assert LOW(wShadowOAM) == 0
	xor a
	ld [wSilChanged], a
	ldh a, [hSCY]
	sub 16
	ld [wSilTemp + 0], a
	ldh a, [hSCX]
	sub 8
	ld [wSilTemp + 1], a
	ld a, [wSilObjEntries]
	ld b, a
.entry
	ld a, [wSilTemp + 0]
	add [hl] ; y
	inc hl
	call .Store
	ld a, [wSilTemp + 1]
	add [hl] ; x
	inc hl
	call .Store
	ld a, [hli] ; tile
	ld c, a
	ld a, [hli] ; attributes
	push hl
	ld h, HIGH(SilTileMask)
	bit B_OAM_BANK1, a
	jr z, .vram0
	inc h
.vram0
	ld l, c
	ld c, a
	ld a, [hl]
	call .Store
	ld a, c
	call .Store
	pop hl
	dec b
	jr nz, .entry
	ld a, [wSilObjEntries]
	call .Store
	ld a, [wSilChanged]
	and a
	ret

.Store:
; [de] = a, noting a change; de++. Keeps bc, hl.
	push bc
	ld c, a
	ld a, [de]
	cp c
	jr z, .same
	ld a, c
	ld [de], a
	ld a, TRUE
	ld [wSilChanged], a
.same
	inc de
	pop bc
	ret

SilBuildGrids:
; From the record's key: the window (wSilBCX, wSilBCY), and the masks plotted into the grids.
; The four sprite tiles of a mon icon form a 16x16 block, so it is put together unshifted first
; (wSilCompNormal, wSilCompBehind: 16 rows of 2 bytes), then shifted into the grids in one pass.
	call SilCurIconPtr
	ld de, SILICON_KEY
	add hl, de
	push hl
	; the smallest y and x among the entries (all within 16)
	ld a, [hli]
	ld [wSilY0], a
	ld a, [hld]
	ld [wSilX0], a
	xor a
	ld [wSilMinDY], a
	ld [wSilMinDX], a
	ld a, [wSilObjEntries]
	ld b, a
.min_loop
	ld a, [wSilY0]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [wSilMinDY]
	call .Min
	ld [wSilMinDY], a
	ld a, [wSilX0]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [wSilMinDX]
	call .Min
	ld [wSilMinDX], a
	inc hl
	inc hl
	dec b
	jr nz, .min_loop
	ld a, [wSilMinDY]
	ld c, a
	ld a, [wSilY0]
	add c
	ld [wSilY0], a ; now the block's top
	and %11111000
	rrca
	rrca
	rrca
	ld [wSilBCY], a
	ld a, [wSilMinDX]
	ld c, a
	ld a, [wSilX0]
	add c
	ld [wSilX0], a ; now the block's left
	and %11111000
	rrca
	rrca
	rrca
	ld [wSilBCX], a

	; clear the composites
	ld hl, wSilCompNormal
	assert wSilCompBehind == wSilCompNormal + 32
	xor a
	ld [wSilAnyBehind], a
rept 64
	ld [hli], a
endr

	; this slot's masks
	ld a, [wSilGroupSlot]
	add a
	ld e, a
	ld d, 0
	ld hl, SilMaskPointers
	add hl, de
	ld a, [hli]
	ld [wSilMaskBase], a
	ld a, [hl]
	ld [wSilMaskBase + 1], a

	; each entry into its quarter of the block
	pop hl ; the key
	ld a, [wSilObjEntries]
	ld [wSilPlotLeft], a
.entry_loop
	ld a, [wSilY0]
	ld b, a
	ld a, [hli]
	sub b ; 0 or 8
	and %00001000
	add a ; * 2: the quarter's first row, in bytes
	ld c, a
	ld a, [wSilX0]
	ld b, a
	ld a, [hli]
	sub b
	and %00001000
	jr z, .left
	inc c ; the right column
.left
	ld a, [hli] ; mask tile
	ld e, a
	ld a, [hli]
	ld [wSilAttr], a
	push hl
	; de = wSilCompNormal or wSilCompBehind + c
	ld b, 0
	ld hl, wSilCompNormal
	bit B_OAM_PRIO, a
	jr z, .got_comp
	ld hl, wSilCompBehind
	ld a, TRUE
	ld [wSilAnyBehind], a
.got_comp
	add hl, bc
	push hl
	; hl = this slot's masks + mask tile * 8
	ld d, 0
	sla e
	sla e
	sla e
	ld a, [wSilMaskBase]
	ld l, a
	ld a, [wSilMaskBase + 1]
	ld h, a
	add hl, de
	pop de
	; eight rows, two bytes apart, flipped as the sprite is drawn
	ld a, [wSilAttr]
	ld c, a
	bit B_OAM_YFLIP, c
	jr z, .no_yflip
	ld a, e
	add 7 * 2
	ld e, a
	adc d
	sub e
	ld d, a
.no_yflip
	ld b, 8
.row
	ld a, [hli]
	bit B_OAM_XFLIP, c
	jr z, .no_xflip
	push hl
	ld h, HIGH(SilBitReverse)
	ld l, a
	ld a, [hl]
	pop hl
.no_xflip
	ld [de], a
	inc de
	inc de
	bit B_OAM_YFLIP, c
	jr z, .next_row
	dec de
	dec de
	dec de
	dec de
.next_row
	dec b
	jr nz, .row
	pop hl
	ld a, [wSilPlotLeft]
	dec a
	ld [wSilPlotLeft], a
	jr nz, .entry_loop

	; shift the composites into the grids
	ld a, [wSilX0]
	and %111
	add HIGH(SilShiftRight)
	ld [wSilRPage], a
	ld bc, wSilCompNormal
	ld hl, wSilGridNormal
	call .Shift
	ld a, [wSilAnyBehind]
	and a
	ret z
	ld bc, wSilCompBehind
	ld hl, wSilGridBehind
	; fallthrough

.Shift:
; Write 16 rows of 2 bytes at bc into the grid at hl, shifted right by wSilX0 % 8 and down by
; wSilY0 % 8; the grid's other rows are cleared.
	push hl
	xor a
rept SIL_GRID_SIZE
	ld [hli], a
endr
	pop hl
	ld a, [wSilY0]
	and %111
	ld e, a
	add a
	add e ; * SIL_GRID_ROW
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, 16
	ld [wSilRowCounter], a
.shift_row
	; right byte first, so its spill can be ORed into the middle
	ld a, [bc] ; left byte of the row
	inc bc
	ld e, a
	ld a, [wSilRPage]
	ld d, a
	ld a, [de] ; left >> shift
	ld [hli], a
	ld a, d
	add HIGH(SilShiftLeft) - HIGH(SilShiftRight)
	ld d, a
	ld a, [de] ; what spills from the left byte
	ld [hl], a
	ld a, [bc] ; right byte of the row
	inc bc
	ld e, a
	ld a, [wSilRPage]
	ld d, a
	ld a, [de] ; right >> shift
	or [hl]
	ld [hli], a
	ld a, d
	add HIGH(SilShiftLeft) - HIGH(SilShiftRight)
	ld d, a
	ld a, [de]
	ld [hli], a
	ld a, [wSilRowCounter]
	dec a
	ld [wSilRowCounter], a
	jr nz, .shift_row
	ret

.Min:
; a = signed min(a, c); keeps bc, hl
	push de
	ld d, a
	xor $80
	ld e, a
	ld a, c
	xor $80
	cp e
	ld a, c
	jr c, .min_done
	ld a, d
.min_done
	pop de
	ret

SilApplyIcon:
; Draw icon wSilCur at wSilBCX, wSilBCY from the grids, and queue its cell changes.
	call SilCurIconPtr
	ld a, l
	ld [wSilRecPtr], a
	ld a, h
	ld [wSilRecPtr + 1], a
	; did the window move?
	inc hl
	inc hl ; SILICON_CX
	ld a, [wSilBCX]
	sub [hl]
	ld b, a
	inc hl
	ld a, [wSilBCY]
	sub [hl]
	or b
	ld [wSilMoved], a
	; the window's top-left in wTilemap
	ld a, [wSilAnchorCol]
	ld b, a
	ld a, [wSilBCX]
	sub b
	and %11111
	ld [wSilScreenCol], a
	ld a, [wSilAnchorRow]
	ld b, a
	ld a, [wSilBCY]
	sub b
	and %11111
	ld [wSilScreenRow], a
	; this icon's first private tile
	ld a, [wSilCur]
	ld b, a
	add a
	add a
	add a
	add b ; * 9
	ld [wSilIconFirst], a
	xor a
	ld [wSilOldGone], a
	; each window row's offset into wTilemap, or $ff if it is off screen
	ld hl, wSilRowOfs
	ld a, [wSilScreenRow]
	ld c, 3
.row_ofs
	push af
	and %11111
	cp SCREEN_HEIGHT
	jr c, .row_on
	ld a, $ff
	ld [hli], a
	ld [hli], a
	jr .row_next
.row_on
	push hl
	ld l, a
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de ; * 5
	add hl, hl
	add hl, hl ; * 20
	ld d, h
	ld e, l
	pop hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
.row_next
	pop af
	inc a
	dec c
	jr nz, .row_ofs

	xor a
	ld [wSilCellK], a
	ld [wSilCellR], a
	ld [wSilCellC], a
.cell_loop
	ld a, [wSilCellK]
	ld e, a
	ld d, 0
	ld hl, wSilNewMode
	add hl, de
	ld [hl], 0
	; any mask in this cell? (8 rows, SIL_GRID_ROW apart)
	ld a, [wSilCellR]
	swap a
	rrca ; * 8
	ld l, a
	add a
	add l ; * 24
	ld l, a
	ld a, [wSilCellC]
	add l
	ld e, a
	ld hl, wSilGridNormal
	add hl, de
	ld a, l
	ld [wSilCellMask], a
	ld a, h
	ld [wSilCellMask + 1], a
	ld bc, SIL_GRID_ROW
	xor a
rept 8
	or [hl]
	add hl, bc
endr
	ld [wSilTemp], a
	ld a, [wSilAnyBehind]
	and a
	jr z, .no_behind
	ld hl, wSilGridBehind
	add hl, de
	ld a, [wSilTemp]
rept 8
	or [hl]
	add hl, bc
endr
	ld [wSilTemp], a
.no_behind
	ld a, [wSilTemp]
	and a
	jmp z, .cell_empty

	; its place in wTilemap
	ld a, [wSilCellC]
	ld b, a
	ld a, [wSilScreenCol]
	add b
	and %11111
	cp SCREEN_WIDTH
	jmp nc, .cell_empty
	ld e, a
	ld a, [wSilCellR]
	add a
	add LOW(wSilRowOfs)
	ld l, a
	adc HIGH(wSilRowOfs)
	sub l
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc h
	jmp z, .cell_empty ; $ff: off screen
	dec h
	ld d, 0
	add hl, de
	push hl
	ld de, wTilemap
	add hl, de
	ld a, [hl]
	ld [wSilCellTile], a
	pop hl
	ld de, wAttrmap
	add hl, de
	ld a, [hl]
	ld [wSilCellAttr], a

	; the original pixels
	ld c, a
	ld a, [wSilCellTile]
	ld b, a
	call SilGetSource
	jr c, .cell_empty
	ld [wSilSrcBank], a
	ld a, l
	ld [wSilSrcPtr], a
	ld a, h
	ld [wSilSrcPtr + 1], a

	; draw it into staging: wSilStaging + (icon * 9 + cell) * 16
	ld a, [wSilIconFirst]
	ld hl, wSilCellK
	add [hl]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, wSilStaging
	add hl, de
	ld d, h
	ld e, l
	call SilRenderCell

	; remember it
	ld a, [wSilCellK]
	ld e, a
	ld d, 0
	ld hl, wSilNewMode
	add hl, de
	ld [hl], 1
	ld hl, wSilNewTile
	add hl, de
	ld a, [wSilCellTile]
	ld [hl], a
	ld hl, wSilNewAttr
	add hl, de
	ld a, [wSilCellAttr]
	ld [hl], a

	; the cell already points at its private tile if the window hasn't moved and it did last frame
	ld a, [wSilMoved]
	and a
	jr nz, .queue
	ld a, [wSilRecPtr]
	add SILICON_MODE
	ld l, a
	ld a, [wSilRecPtr + 1]
	adc 0
	ld h, a
	add hl, de
	ld a, [hl]
	and a
	jr nz, .cell_next
.queue
	ld a, [wSilIconFirst]
	ld hl, wSilCellK
	add [hl]
	add SIL_PRIVATE_FIRST
	ld b, a
	ld a, [wSilCellAttr]
	or 1 << B_OAM_BANK1 ; the same bit in BG attributes
	ld c, a
	push bc
	call SilCellCoords
	call SilCellAddress ; de
	pop bc
	call SilAddListEntry
	jr .cell_next

.cell_empty
	; a cell shown privately last frame that isn't now needs putting back
	ld a, [wSilRecPtr]
	add SILICON_MODE
	ld l, a
	ld a, [wSilRecPtr + 1]
	adc 0
	ld h, a
	ld a, [wSilCellK]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	ld a, [wSilOldGone]
	or b
	ld [wSilOldGone], a ; nonzero if so

.cell_next
	ld hl, wSilCellC
	inc [hl]
	ld a, [hl]
	cp 3
	jr c, .same_row
	ld [hl], 0
	ld hl, wSilCellR
	inc [hl]
.same_row
	ld hl, wSilCellK
	inc [hl]
	ld a, [hl]
	cp SIL_CELLS
	jmp nz, .cell_loop

	; put back old cells nothing covers now, then keep the new ones
	ld a, [wSilMoved]
	ld hl, wSilOldGone
	or [hl]
	call nz, SilRestoreOldCells
	ld a, [wSilRecPtr]
	ld l, a
	ld a, [wSilRecPtr + 1]
	ld h, a
	inc hl
	inc hl ; SILICON_CX
	ld a, [wSilBCX]
	ld [hli], a
	ld a, [wSilBCY]
	ld [hli], a ; hl = SILICON_MATCHED
	ld de, SILICON_MODE - SILICON_MATCHED
	add hl, de
	ld de, wSilNewMode
	ld b, SIL_CELLS * 3
	assert wSilNewTile == wSilNewMode + SIL_CELLS && wSilNewAttr == wSilNewTile + SIL_CELLS
	assert SILICON_TILE == SILICON_MODE + SIL_CELLS && SILICON_ATTR == SILICON_TILE + SIL_CELLS
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .copy
	ld a, [wSilCur]
	jmp SilNoteRendered

SilRestoreOldCells:
; Queue the original tile for every cell icon wSilCur showed privately last frame, unless the new
; window (wSilBCX, wSilBCY, wSilNewMode) covers it privately again.
	call SilCurIconPtr
	ld a, l
	ld [wSilRecPtr], a
	ld a, h
	ld [wSilRecPtr + 1], a
	xor a
	ld [wSilCellK], a
.loop
	ld a, [wSilRecPtr]
	ld l, a
	ld a, [wSilRecPtr + 1]
	ld h, a
	ld a, [wSilCellK]
	add SILICON_MODE
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
	; the old cell's coordinates
	ld a, [wSilRecPtr]
	ld l, a
	ld a, [wSilRecPtr + 1]
	ld h, a
	inc hl
	inc hl
	ld a, [hli] ; SILICON_CX
	ld b, a
	ld c, [hl] ; SILICON_CY
	ld a, [wSilCellK]
	call SilAddCellOffset ; b, c += this cell's column and row
	; covered by the new window?
	ld a, [wSilBCX]
	ld d, a
	ld a, b
	sub d
	and %11111
	cp 3
	jr nc, .restore
	ld e, a
	ld a, [wSilBCY]
	ld d, a
	ld a, c
	sub d
	and %11111
	cp 3
	jr nc, .restore
	ld d, a
	add a
	add d
	add e ; row * 3 + column
	add LOW(wSilNewMode)
	ld l, a
	adc HIGH(wSilNewMode)
	sub l
	ld h, a
	ld a, [hl]
	and a
	jr nz, .next
.restore
	call SilCellAddress ; de
	ld a, [wSilRecPtr]
	ld l, a
	ld a, [wSilRecPtr + 1]
	ld h, a
	ld a, [wSilCellK]
	add SILICON_TILE
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	ld a, l
	add SIL_CELLS
	ld l, a
	adc h
	sub l
	ld h, a
	ld c, [hl] ; SILICON_ATTR
	call SilAddListEntry
.next
	ld hl, wSilCellK
	inc [hl]
	ld a, [hl]
	cp SIL_CELLS
	jr nz, .loop
	ret

SilCellCoords:
; b, c = background cell of grid cell wSilCellK in the new window
	ld a, [wSilBCX]
	ld b, a
	ld a, [wSilBCY]
	ld c, a
	ld a, [wSilCellK]
	; fallthrough
SilAddCellOffset:
; b += a % 3, c += a / 3, both wrapped to 32
	ld d, 0
.div
	cp 3
	jr c, .got
	sub 3
	inc d
	jr .div
.got
	add b
	and %11111
	ld b, a
	ld a, c
	add d
	and %11111
	ld c, a
	ret

SilCellAddress:
; de = vBGMap0 + c * 32 + b
	ld a, c
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, b
	add l
	ld l, a
	ld de, vBGMap0
	add hl, de
	ld d, h
	ld e, l
	ret

SilRenderCell:
; Draw the source tile (wSilSrcBank:wSilSrcPtr) with this cell's masks (wSilCellMask, rows
; SIL_GRID_ROW apart) painted in as color 3, into de. wSilCellAttr gives its flips and priority.
	ld a, [wSilAnyBehind]
	and a
	jmp nz, SilRenderCellSlow
	ld a, [wSilCellAttr]
	and OAM_XFLIP | OAM_YFLIP | OAM_PRIO ; the same bits in BG attributes
	jmp nz, SilRenderCellSlow
	ld a, [wSilSrcBank]
	cp BANK(@)
	jr nz, SilRenderCellSlow
	; the usual case: unflipped, nothing behind the background, pixels in this bank
	ld a, [wSilCellMask]
	ld c, a
	ld a, [wSilCellMask + 1]
	ld b, a
	ld a, [wSilSrcPtr]
	ld l, a
	ld a, [wSilSrcPtr + 1]
	ld h, a
rept 8
	ld a, [bc]
	or [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [bc]
	or [hl]
	ld [de], a
	inc hl
	inc de
	inc bc
	inc bc
	inc bc
endr
	ret

SilRenderCellSlow:
; Any cell: flipped, with a sprite behind the background, or with pixels in another bank.
	push de
	ld a, [wSilSrcPtr]
	ld l, a
	ld a, [wSilSrcPtr + 1]
	ld h, a
	ld a, [wSilSrcBank]
	ld de, wSilSrc
	ld bc, TILE_SIZE
	call FarCopyBytes
	pop de
	push de
	ld hl, wSilSrc
	ld bc, TILE_SIZE
	call CopyBytes
	pop de
	xor a
	ld [wSilRowCounter], a
.row
	; b = normal mask, c = behind mask for this screen row
	ld a, [wSilRowCounter]
	ld l, a
	add a
	add l ; * SIL_GRID_ROW
	ld l, a
	ld a, [wSilCellMask]
	add l
	ld l, a
	ld a, [wSilCellMask + 1]
	adc 0
	ld h, a
	ld b, [hl]
	push de
	ld de, SIL_GRID_SIZE
	add hl, de
	pop de
	ld c, [hl]
	ld a, [wSilCellAttr]
	bit B_OAM_XFLIP, a ; the cell is drawn mirrored, so mirror the masks into tile space
	jr z, .no_xflip
	ld h, HIGH(SilBitReverse)
	ld l, b
	ld b, [hl]
	ld l, c
	ld c, [hl]
.no_xflip
	; hl = de + tile row * 2
	ld a, [wSilRowCounter]
	ld l, a
	ld a, [wSilCellAttr]
	bit B_OAM_YFLIP, a
	ld a, l
	jr z, .no_yflip
	cpl
	and %111
.no_yflip
	add a
	add e
	ld l, a
	adc d
	sub l
	ld h, a
	; m = priority ? (normal | behind) & color0 : normal | (behind & color0)
	ld a, [hli]
	or [hl]
	cpl ; color 0 pixels
	push hl
	ld l, a
	ld a, [wSilCellAttr]
	bit B_OAM_PRIO, a
	jr z, .normal_priority
	ld a, b
	or c
	and l
	jr .got_mask
.normal_priority
	ld a, c
	and l
	or b
.got_mask
	pop hl
	ld b, a
	dec hl
	ld a, [hl]
	or b
	ld [hli], a
	ld a, [hl]
	or b
	ld [hl], a
	ld hl, wSilRowCounter
	inc [hl]
	ld a, [hl]
	cp 8
	jr nz, .row
	ret

; The VBlank list -------------------------------------------------------------------------------

SilClearList:
	ld a, LOW(wSilList)
	ld [wSilListPtr], a
	ld a, HIGH(wSilList)
	ld [wSilListPtr + 1], a
	xor a
	ld [wSilSendTiles], a
	ret

SilAddListEntry:
; de = background map address, b = tile, c = attributes
	ld a, [wSilListPtr]
	ld l, a
	ld a, [wSilListPtr + 1]
	ld h, a
	ld a, BANK(wSilList)
	ldh [rWBK], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, BANK(wSilIcons)
	ldh [rWBK], a
	ld a, l
	ld [wSilListPtr], a
	ld a, h
	ld [wSilListPtr + 1], a
	ret

SilFinishList:
; Hand the tiles and the list to SilhouetteVBlank, if there is anything to do.
	ld a, [wSilListPtr]
	sub LOW(wSilList)
	ld l, a
	ld a, [wSilListPtr + 1]
	sbc HIGH(wSilList)
	ld h, a
	srl h
	rr l
	srl h
	rr l ; entries
	ld a, BANK(wSilListCount)
	ldh [rWBK], a
	ld a, l
	ld [wSilListCount], a
	ld a, BANK(wSilIcons)
	ldh [rWBK], a
	ld a, [wSilSendTiles]
	or l
	ret z
	ld a, TRUE
	ld [wSilPending], a
	ret

SilGetSource:
; in: b = tile id, c = attributes of a background cell
; out: a:hl = its 16 bytes of pixels; carry if this cell can't be drawn
	bit B_OAM_BANK1, c
	jr nz, .vram1
	ld a, b
	cp $7f ; $7f is the text space; $80+ in bank 0 is the font and sprites
	jr nc, .fail
	cp $0a
	jr c, .vram0
	cp $0a + ROOF_LENGTH
	jr nc, .vram0
	; a map group's roof?
	push bc
	ld a, [wSilGroup]
	ld e, a
	ld d, 0
	ld hl, MapGroupRoofs
	add hl, de
	ld a, BANK(MapGroupRoofs)
	call GetFarByte
	pop bc
	cp -1
	jr z, .vram0
	push bc
	ld hl, Roofs
	ld bc, ROOF_LENGTH * TILE_SIZE
	call AddNTimes
	pop bc
	ld a, b
	sub $0a
	call .AddTiles
	ld a, BANK(Roofs)
	and a
	ret

.vram0
	ld hl, SilJohtoVTiles2
	ld a, b
	jr .tileset

.vram1
	ld a, b
	cp (SilJohtoVTiles5End - SilJohtoVTiles5) / TILE_SIZE
	jr nc, .fail
	ld hl, SilJohtoVTiles5
.tileset
	call .AddTiles
	ld a, BANK(SilJohtoVTiles2)
	and a
	ret

.fail
	scf
	ret

.AddTiles:
; hl += a * 16
	push bc
	ld c, a
	ld b, 0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	pop bc
	ret

; Masks -----------------------------------------------------------------------------------------

SilKeepFollowerMask::
; farcall hands the callee's registers back, so keep the caller's here.
	push af
	push bc
	push de
	push hl
	call _SilKeepFollowerMask
	pop hl
	pop de
	pop bc
	pop af
	ret

_SilKeepFollowerMask:
; The follower's mask has just been expanded into wDecompressScratch like any sprite. Keep its
; first bitplane until SilRegisterMask learns which VRAM slot the follower lands in.
	ldh a, [rWBK]
	push af
	ld hl, wDecompressScratch
	ld de, wSilStaging
	ld c, SIL_MASK_SIZE
.loop
	ld a, BANK(wDecompressScratch)
	ldh [rWBK], a
	ld a, [hli]
	inc hl ; skip the second bitplane
	ld b, a
	ld a, BANK(wSilStaging)
	ldh [rWBK], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ld a, TRUE
	ld [wSilPendingMask], a
	pop af
	ldh [rWBK], a
	ret

SilRegisterMask::
; farcall hands the callee's registers back, so keep the caller's here.
	push af
	push bc
	push de
	push hl
	call _SilRegisterMask
	pop hl
	pop de
	pop bc
	pop af
	ret

_SilRegisterMask:
; A sprite has just been built in wDecompressScratch for slot hUsedSpriteTile. Give the slot a
; mask if the sprite has one, or take away a mask a previous sprite there had.
	ldh a, [rWBK]
	push af
	ld a, BANK(wSpriteFlags)
	ldh [rWBK], a
	ld a, [wSpriteFlags]
	and 1 << 5 ; VRAM bank 1
	ld d, 0
	jr z, .bank0
	inc d
.bank0
	ldh a, [hUsedSpriteTile]
	and $7f
	ld e, a
	ld a, BANK(wSilSlots)
	ldh [rWBK], a
	; find the slot for this VRAM position, or a free one
	call .FindSlot ; hl = slot, carry if none
	jr c, .done
	ldh a, [hUsedSpriteIndex]
	cp SPRITE_FOLLOWER
	jr nz, .not_follower
	ld a, [wSilPendingMask]
	and a
	jr z, .clear
	xor a
	ld [wSilPendingMask], a
	call .Claim
	ld hl, wSilStaging
	ld bc, SIL_MASK_SIZE
	call CopyBytes
	jr .done

.not_follower
	ld a, [wSilTestMons]
	and a
	jr z, .clear
	ldh a, [hUsedSpriteIndex]
	sub SPRITE_OW_MON
	cp NUM_OW_MON_SLOTS
	jr nc, .clear
	; performance test: the mask is the icon's own black pixels (both bitplanes set)
	call .Claim
	ld hl, wDecompressScratch
	ld c, SIL_MASK_SIZE
.black_loop
	ld a, BANK(wDecompressScratch)
	ldh [rWBK], a
	ld a, [hli]
	and [hl]
	inc hl
	ld b, a
	ld a, BANK(wSilSlots)
	ldh [rWBK], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .black_loop
	jr .done

.clear
	ld a, [hl]
	and a
	jr z, .done
	ld [hl], 0 ; SILSLOT_USED
	; the icons drawn from it go when SilhouetteUpdate next misses them in OAM
.done
	call SilRebuildStructSlots
	pop af
	ldh [rWBK], a
	ret


.FindSlot:
; in: d = bank, e = base. out: hl = the slot already holding this position, else a free one;
; carry if neither
	ld hl, wSilSlots
	ld b, SIL_MAX_SLOTS
.find
	push hl
	ld a, [hli] ; SILSLOT_USED
	and a
	jr z, .find_next
	ld a, [hli] ; SILSLOT_BANK
	cp d
	jr nz, .find_next
	ld a, [hl] ; SILSLOT_BASE
	cp e
	jr nz, .find_next
	pop hl
	and a
	ret

.find_next
	pop hl
	inc hl
	inc hl
	inc hl
	dec b
	jr nz, .find
	ld hl, wSilSlots
	ld b, SIL_MAX_SLOTS
.free
	ld a, [hl]
	and a
	ret z ; "and a" cleared carry
	inc hl
	inc hl
	inc hl
	dec b
	jr nz, .free
	scf
	ret

.Claim:
; Mark slot hl used for bank d, base e; de = its mask buffer.
	ld [hl], TRUE
	inc hl
	ld [hl], d
	inc hl
	ld [hl], e
	dec hl
	dec hl
	; which slot is it?
	ld a, l
	sub LOW(wSilSlots)
	ld b, 0
.div
	and a
	jr z, .got
	sub SILSLOT_LENGTH
	inc b
	jr .div
.got
	ld a, b
	ld hl, wSilMasks
	ld bc, SIL_MASK_SIZE
	call AddNTimes
	ld d, h
	ld e, l
	ret

SilRebuildStructSlots:
; wSilStructSlot: for each object VRAM slot (12 tiles each; the first FIRST_VRAM1_OBJECT_STRUCT
; in bank 0, the rest in bank 1), the silhouette slot + 1 drawing from it, or 0; and the same as
; bits in wSilStructMask, for SilObjectStart. Staging may have held a mask, so redraw everything.
	ld a, TRUE
	ld [wSilDirty], a
	xor a
	ld [wSilStructMask], a
	ld [wSilStructMask + 1], a
	ld hl, wSilStructSlot
	ld bc, NUM_OBJECT_STRUCTS
	call ByteFill
	ld hl, wSilSlots
	ld c, 0
.slot
	ld a, [hli] ; SILSLOT_USED
	and a
	jr z, .skip2
	ld a, [hli] ; SILSLOT_BANK
	ld b, a
	ld a, [hli] ; SILSLOT_BASE
	ld d, 0
.div
	cp 12
	jr c, .got
	sub 12
	inc d
	jr .div
.got
	ld a, b
	and a
	ld a, d
	jr z, .bank0
	add FIRST_VRAM1_OBJECT_STRUCT
.bank0
	cp NUM_OBJECT_STRUCTS
	jr nc, .next
	push hl
	push bc
	ld e, a
	ld d, 0
	ld hl, wSilStructSlot
	add hl, de
	ld a, c
	inc a
	ld [hl], a
	; the bit
	ld hl, wSilStructMask
	ld a, e
	cp 8
	jr c, .low_byte
	inc hl
	sub 8
.low_byte
	ld b, a
	ld a, 1
	inc b
.bit
	dec b
	jr z, .got_bit
	add a
	jr .bit
.got_bit
	or [hl]
	ld [hl], a
	pop bc
	pop hl
	jr .next

.skip2
	inc hl
	inc hl
.next
	inc c
	ld a, c
	cp SIL_MAX_SLOTS
	jr nz, .slot
	ret

; Follower art ----------------------------------------------------------------------------------

SilSelectFollowerArt::
; farcall hands the callee's registers back, so keep the caller's here.
	push af
	push bc
	push de
	push hl
	call _SilSelectFollowerArt
	pop hl
	pop de
	pop bc
	pop af
	ret

_SilSelectFollowerArt:
; Decide whether the follower uses four-color art, and if so leave its graphics, mask and colors
; in WRAM0 for the sprite loader and the palette code.
	ldh a, [rWBK]
	push af
	xor a
	ld [wSilFollowerArt], a
	ld a, [wFollowerSpriteID]
	and a
	jr z, .done
	call GetPokemonIndexFromID ; hl = species
	ld de, SilArtTable
	ld a, [wSilForceArt]
	and a
	jr nz, .found
.search
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a ; bc = this entry's species
	dec de
	and c
	inc a
	jr z, .done ; -1 ends the table
	ld a, b
	cp h
	jr nz, .next
	ld a, c
	cp l
	jr z, .found
.next
	push hl
	ld hl, SILART_LENGTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
	jr .search

.found
	inc de
	inc de ; past the species
	ld a, BANK(SilArtTable)
	ld [wSilArtBank], a
	ld hl, wSilArtPtr
	assert wSilMaskPtr == wSilArtPtr + 2
	ld b, 2 * 2
.ptrs
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .ptrs
	; normal or shiny colors
	push de
	ld a, BANK(wPartyMon1Form)
	ldh [rWBK], a
	ld a, [wFollowerPartyNum]
	dec a
	ld hl, wPartyMon1Form
	call GetPartyLocation
	ld a, [hl]
	pop de
	and SHINY_MASK
	jr z, .normal
	ld hl, 3 * 2
	add hl, de
	ld d, h
	ld e, l
.normal
	ld hl, wSilFollowerPal
	ld b, 3 * 2
.colors
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .colors
	ld a, TRUE
	ld [wSilFollowerArt], a
.done
	pop af
	ldh [rWBK], a
	ret

SilWriteFollowerPalette::
; farcall hands the callee's registers back, so keep the caller's here.
	push af
	push bc
	push de
	push hl
	call _SilWriteFollowerPalette
	pop hl
	pop de
	pop bc
	pop af
	ret

_SilWriteFollowerPalette:
; Write the follower's four-color palette to de: white and its three colors, with no black --
; the black shows through from the background. Night and unlit caves are handled the way
; CopySpritePal handles a mon's two colors.
	push de
	; b = 0 day, 1 night, 2 darkness
	ld b, 0
	call GetMapTimeOfDay
	or ~IN_DARKNESS
	inc a
	jr nz, .not_dark
	ld a, [wStatusFlags]
	bit STATUSFLAGS_FLASH_F, a
	jr nz, .not_dark
	ld a, [wPalFlags]
	bit USE_DAYTIME_PAL_F, a
	jr nz, .not_dark
	ld b, 2
	jr .got_mode

.not_dark
	ld a, [wPalFlags]
	bit USE_DAYTIME_PAL_F, a
	jr nz, .got_mode
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	cp NITE_F
	jr nz, .got_mode
	ld b, 1
.got_mode
	; the three colors, adjusted, into wSilTempPal
	ld a, b
	ld [wSilColor3], a ; the mode, for now
	ld hl, wSilFollowerPal
	ld de, wSilTempPal
	ld c, 3
.color
	push bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	ld a, [wSilColor3]
	and a
	jr z, .store
	dec a
	jr nz, .dark
	call .Darken
	jr .store

.dark
	; an unlit cave: the characters' flat silhouette colors (the first, then the darker one)
	pop hl
	push hl
	ld a, l
	sub LOW(wSilFollowerPal + 2)
	ld hl, DarknessOBPalette + COLOR_SIZE
	jr z, .got_dark
	ld hl, DarknessOBPalette + 2 * COLOR_SIZE
.got_dark
	push de
	ld a, BANK(DarknessOBPalette)
	call GetFarWord
	pop de
	ld b, h
	ld c, l
.store
	pop hl
	ld a, c
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	pop bc
	dec c
	jr nz, .color

	pop hl ; the destination
	ldh a, [rWBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rWBK], a
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hli], a
	ld de, wSilTempPal
	ld c, 3 * 2
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copy
	pop af
	ldh [rWBK], a
	ret

.Darken:
; in: bc = a 15-bit color. out: bc, darkened to night brightness (as CopySpritePal does).
	ld a, c
	and %00011111
	srl a
	ld l, a ; red
	ld a, c
	rlca
	rlca
	rlca
	and %00000111
	ld h, a
	ld a, b
	and %00000011
	add a
	add a
	add a
	or h
	srl a
	ld h, a ; green
	ld a, b
	rrca
	rrca
	and %00011111
	ld d, a
	rrca
	rrca
	rrca
	and %00011111
	ld e, a
	ld a, d
	sub e
	ld d, a ; blue
	ld a, h
	and %00000111
	rrca
	rrca
	rrca
	or l
	ld c, a
	ld a, h
	rrca
	rrca
	rrca
	and %00011111
	ld l, a
	ld a, d
	add a
	add a
	or l
	ld b, a
	ret

SilMaskPointers:
for sil_n, SIL_MAX_SLOTS
	dw wSilMasks + sil_n * SIL_MASK_SIZE
endr

; Data ------------------------------------------------------------------------------------------

SilArtTable:
; species, art (8 tiles, black drawn as 0), mask (8 tiles, black as 3), normal colors, shiny colors
	dw BULBASAUR
	dw SilBulbasaurArt, SilBulbasaurMask
INCLUDE "gfx/followers/bulbasaur_pal.asm"
	dw -1

; Built from gfx/followers/bulbasaur.png by plans/follower_four_color_harness/make_art.py (spike)
SilBulbasaurArt:  INCBIN "gfx/followers/bulbasaur_art.bin"
SilBulbasaurMask: INCBIN "gfx/followers/bulbasaur_mask.bin"

; The Johto tileset, uncompressed, for the original pixels under each icon. Spike only: every
; supported tileset would need its copy (or a WRAM one).
SilJohtoVTiles2:: INCBIN "gfx/tilesets/johto.2bpp.vtiles2"
SilJohtoVTiles5:: INCBIN "gfx/tilesets/johto.2bpp.vtiles5"
SilJohtoVTiles5End::


SECTION "Silhouette Tables", ROMX, ALIGN[8]

SilTileStruct:
; OAM tile -> the object VRAM slot whose tiles it is, or $ff: bank 0, then (+$100) bank 1
for sil_t, 256
	if sil_t < $80
		DEF sil_tt = sil_t
	else
		DEF sil_tt = sil_t - $80
	endc
	if sil_tt < FIRST_VRAM1_OBJECT_STRUCT * 12
		db sil_tt / 12
	else
		db $ff
	endc
endr
for sil_t, 256
	if sil_t < $40
		DEF sil_tt = sil_t
	elif sil_t < $80
		DEF sil_tt = sil_t - $40
	else
		DEF sil_tt = $ff
	endc
	if sil_tt < (NUM_OBJECT_STRUCTS - FIRST_VRAM1_OBJECT_STRUCT) * 12
		db FIRST_VRAM1_OBJECT_STRUCT + sil_tt / 12
	else
		db $ff
	endc
endr

SilTileMask:
; OAM tile -> its tile in a 24-tile silhouette mask (standing 0-11, walking 12-23)
for sil_t, 256
	if sil_t < $80
		db sil_t % 12
	else
		db 12 + (sil_t - $80) % 12
	endc
endr
for sil_t, 256
	if sil_t < $40
		db sil_t % 12
	elif sil_t < $80
		db 12 + (sil_t - $40) % 12
	else
		db 0
	endc
endr

SilShiftRight:
; SilShiftRight + n * $100: every byte shifted right by n
for sil_n, 8
	for value, 256
		db value >> sil_n
	endr
endr

SilShiftLeft:
; SilShiftLeft + n * $100: what spills out of the right side when shifting right by n
for sil_n, 8
	for value, 256
		db (value << (8 - sil_n)) & $ff
	endr
endr

SilBitReverse:
for value, 256
	DEF reversed = 0
	for bitnum, 8
		if value & (1 << bitnum)
			REDEF reversed = reversed | (1 << (7 - bitnum))
		endc
	endr
	db reversed
endr
