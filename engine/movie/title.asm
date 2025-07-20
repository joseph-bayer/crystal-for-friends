_TitleScreen:
	call ClearBGPalettes
	call ClearSprites
	call ClearTilemap

; Turn BG Map update off
	xor a
	ldh [hBGMapMode], a

; Reset timing variables
	ld hl, wJumptableIndex
	ld [hli], a ; wJumptableIndex
	ld [hli], a ; wTitleScreenSelectedOption
	ld [hli], a ; wTitleScreenTimer
	ld [hl], a  ; wTitleScreenTimer + 1

; Turn LCD off
	call DisableLCD

; VRAM bank 1
	ld a, 1
	ldh [rVBK], a

; Decompress running Suicune gfx
	ld hl, TitleSuicuneGFX
	ld de, vTiles1
	call Decompress

; Clear screen palettes
	hlbgcoord 0, 0
	ld bc, 20 * TILEMAP_WIDTH
	xor a
	rst ByteFill

; Fill tile palettes:

; BG Map 1:

; line 0 (copyright)
	hlbgcoord 0, 0, vBGMap1
	ld bc, TILEMAP_WIDTH
	ld a, 7 ; palette
	rst ByteFill

; BG Map 0:

; Apply logo gradient:

; lines 3-4
	hlbgcoord 0, 3
	ld bc, 2 * TILEMAP_WIDTH
	ld a, 2
	rst ByteFill
; line 5
	hlbgcoord 0, 5
	ld bc, TILEMAP_WIDTH
	ld a, 3
	rst ByteFill
; line 6
	hlbgcoord 0, 6
	ld bc, TILEMAP_WIDTH
	ld a, 4
	rst ByteFill
; line 7
	hlbgcoord 0, 7
	ld bc, TILEMAP_WIDTH
	ld a, 5
	rst ByteFill
; lines 8-9
	hlbgcoord 0, 8
	ld bc, 2 * TILEMAP_WIDTH
	ld a, 6
	rst ByteFill

; 'CRYSTAL VERSION'
	hlbgcoord 5, 9
	ld bc, 11 ; length of version text
	ld a, 1
	rst ByteFill

; Suicune gfx
	hlbgcoord 0, 12
	ld bc, 6 * TILEMAP_WIDTH ; the rest of the screen
	ld a, 0 | OAM_BANK1
	rst ByteFill

; Back to VRAM bank 0
	xor a
	ldh [rVBK], a

; Decompress logo
	ld hl, TitleLogoGFX
	ld de, vTiles1
	call Decompress

; Decompress background crystal
	ld hl, TitleCrystalGFX
	ld de, vTiles0
	call Decompress

; Clear screen tiles
	hlbgcoord 0, 0
	ld bc, 64 * TILEMAP_WIDTH
	ld a, " "
	rst ByteFill

; Draw Pokemon logo
	hlcoord 0, 3
	lb bc, 7, 20
	lb de, $80, 20
	call DrawTitleGraphic

; Draw copyright text
	hlbgcoord 3, 0, vBGMap1
	lb bc, 1, 13
	lb de, $c, 16
	call DrawTitleGraphic

; Initialize running Suicune?
	ld d, $0
	call LoadSuicuneFrame

; Initialize background crystal
	call InitializeBackground

; Update palette colors
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a

	ld hl, TitleScreenPalettes
	ld de, wBGPals1
	ld bc, 16 palettes
	rst CopyBytes

	ld hl, TitleScreenPalettes
	ld de, wBGPals2
	ld bc, 16 palettes
	rst CopyBytes

	pop af
	ldh [rWBK], a

; LY/SCX trickery starts here

	; a = [rWBK]
	push af
	ld a, BANK(wLYOverrides)
	ldh [rWBK], a

; Make sure the LYOverrides buffer is empty
	ld hl, wLYOverrides
	xor a
	ld bc, wLYOverridesEnd - wLYOverrides
	rst ByteFill

; Let LCD Stat know we're messing around with SCX
	ld hl, rIE
	set B_IE_STAT, [hl]
	ld a, LOW(rSCX)
	ldh [hLCDCPointer], a

	pop af
	ldh [rWBK], a

; Reset audio
	call ChannelsOff
	call EnableLCD

; Set sprite size to 8x16
	ldh a, [rLCDC]
	set B_LCDC_OBJ_SIZE, a
	ldh [rLCDC], a

	ld a, +112
	ldh [hSCX], a
	ld a, 8
	ldh [hSCY], a
	ld a, 7
	ldh [hWX], a
	ld a, -112
	ldh [hWY], a

	ld a, TRUE
	ldh [hCGBPalUpdate], a

; Update BG Map 0 (bank 0)
	ldh [hBGMapMode], a

	xor a
	ld [wSuicuneFrame], a

; Play starting sound effect
	call SFXChannelsOff
	ld de, SFX_TITLE_SCREEN_ENTRANCE
	jmp PlaySFX

SuicuneFrameIterator:
	ld hl, wSuicuneFrame
	ld a, [hl]
	ld c, a
	inc [hl]

; Only do this once every eight frames
	and %111
	ret nz

	ld a, c
	and %11000
	add a
	swap a
	ld e, a
	ld d, 0
	ld hl, .Frames
	add hl, de
	ld d, [hl]
	xor a
	ldh [hBGMapMode], a
	call LoadSuicuneFrame
	ld a, $1
	ldh [hBGMapMode], a
	ld a, $3
	ldh [hBGMapThird], a
	ret

.Frames:
	db $80 ; vTiles3 tile $80
	db $88 ; vTiles3 tile $88
	db $00 ; vTiles5 tile $00
	db $08 ; vTiles5 tile $08

LoadSuicuneFrame:
	hlcoord 6, 12
	ld b, 6
.bgrows
	ld c, 8
.col
	ld a, d
	ld [hli], a
	inc d
	dec c
	jr nz, .col
	ld a, SCREEN_WIDTH - 8
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, 8
	add d
	ld d, a
	dec b
	jr nz, .bgrows
	ret

DrawTitleGraphic:
; input:
;   hl: draw location
;   b: height
;   c: width
;   d: tile to start drawing from
;   e: number of tiles to advance for each bgrows
.bgrows
	push de
	push bc
	push hl
.col
	ld a, d
	ld [hli], a
	inc d
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	pop de
	ld a, e
	add d
	ld d, a
	dec b
	jr nz, .bgrows
	ret

InitializeBackground:
	ld hl, wShadowOAMSprite00
	lb de, -$22, $0
	ld c, 5
.loop
	push bc
	call .InitColumn
	pop bc
	ld a, $10
	add d
	ld d, a
	dec c
	jr nz, .loop
	ret

.InitColumn:
	lb bc, $40, $6
.loop2
	ld a, d
	ld [hli], a ; y
	ld a, b
	ld [hli], a ; x
	add $8
	ld b, a
	ld a, e
	ld [hli], a ; tile id
	inc e
	inc e
	ld a, 0 | OAM_PRIO
	ld [hli], a ; attributes
	dec c
	jr nz, .loop2
	ret

AnimateTitleCrystal:
; Move the title screen crystal downward until it's fully visible

; Stop at y=6
; y is really from the bottom of the sprite, which is two tiles high
	ld hl, wShadowOAMSprite00YCoord
	ld a, [hl]
	cp 6 + 2 * TILE_WIDTH
	ret z

; Move all 30 parts of the crystal down by 2
	ld c, 30
.loop
	ld a, [hl]
	add 2
	ld [hli], a ; y
rept OBJ_SIZE - 1
	inc hl
endr
	dec c
	jr nz, .loop

	ret

TitleSuicuneGFX:
INCBIN "gfx/title/suicune.2bpp.lz"

TitleLogoGFX:
INCBIN "gfx/title/logo.2bpp.lz"

TitleCrystalGFX:
INCBIN "gfx/title/crystal.2bpp.lz"

TitleScreenPalettes:
INCLUDE "gfx/title/title.pal"
