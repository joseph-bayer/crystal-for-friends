; TODO: LoadOverworldMonIcon is gone. It had updated logic for cosmetic forms. We'll need to find where that needs to be reimplemented.

SetMenuMonColor:
	push hl
	push de
	push bc
	push af

	ld a, [wTempIconSpecies]
	ld [wCurPartySpecies], a
	call GetMenuMonPalette
	ld hl, wShadowOAMSprite00Attributes
	jr _ApplyMenuMonColor

SetMenuMonColor_NoShiny:
	push hl
	push de
	push bc
	push af

	ld a, [wTempIconSpecies]
	ld [wCurPartySpecies], a
	and a
	call GetMenuMonPalette_PredeterminedShininess
	ld hl, wShadowOAMSprite00Attributes
	jr _ApplyMenuMonColor

LoadPartyMenuMonColors:
	push hl
	push de
	push bc
	push af

	ld a, [wPartyCount]
	sub c
	ld [wCurPartyMon], a
	ld e, a
	ld d, 0

	ld hl, wPartyMon1Item
	call GetPartyLocation
	ld a, [hl]
	ld [wCurIconMonHasItemOrMail], a

	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld a, MON_FORM
	call GetPartyParamLocation
	call GetMenuMonPalette
	ld hl, wShadowOAMSprite00Attributes
	push af
	ld a, [wCurPartyMon]
	swap a
	ld d, 0
	ld e, a
	add hl, de
	pop af

	ld de, 4
	ld [hl], a ; top left
	add hl, de
	ld [hl], a ; top right
	add hl, de
	push hl
	add hl, de
	ld [hl], a ; bottom right
	pop hl
	ld d, a
	ld a, [wCurIconMonHasItemOrMail]
	and a
	ld a, PAL_OW_RED ; item or mail color
	jr nz, .ok
	ld a, d
.ok
	ld [hl], a ; bottom left
	jr _FinishMenuMonColor

_ApplyMenuMonColor:
	ld c, 4
	ld de, 4
.loop
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	; fallthrough
_FinishMenuMonColor:
	jmp PopAFBCDEHL

GetMonPalInBCDE:
; Sets BCDE to mon icon palette.
; Input: c = species, b = shininess (1=true, 0=false)
	ld a, c
	call GetPokemonIndexFromID
	dec hl
	ld d, h
	ld e, l

	ld hl, MonMenuIconPals

	; This sets z if mon is shiny.
	dec b
	ld b, 0
	add hl, de
	ld a, [hl]
	jr z, .shiny
	swap a
.shiny
	and $f

	; Now we have the target color. Get the palette (+ 2 to avoid white).
	ld hl, PartyMenuOBPals + 2
	ld bc, 1 palettes
	rst AddNTimes

	push hl
	ld a, BANK(PartyMenuOBPals)
	call GetFarWord
	ld b, h
	ld c, l
	pop hl
	inc hl
	inc hl
	ld a, BANK(PartyMenuOBPals)
	call GetFarWord
	ld d, h
	ld e, l
	ret

GetMenuMonPalette:
	ld c, l
	ld b, h
	farcall CheckShininess
GetMenuMonPalette_PredeterminedShininess:
	push af
	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID
	dec hl
	ld b, h
	ld c, l
	ld hl, MonMenuIconPals
	add hl, bc
	ld e, [hl]
	pop af
	ld a, e
	jr c, .shiny
	swap a
.shiny
	and $f
	ret

LoadMenuMonIcon:
	push hl
	push de
	push bc
	call .LoadIcon
	jmp PopBCDEHL

.LoadIcon:
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
; entries correspond to MONICON_* constants
	dw PartyMenu_InitAnimatedMonIcon    ; MONICON_PARTYMENU
	dw NamingScreen_InitAnimatedMonIcon ; MONICON_NAMINGSCREEN
	dw MoveList_InitAnimatedMonIcon     ; MONICON_MOVES
	dw Trade_LoadMonIconGFX             ; MONICON_TRADE
	dw Mobile_InitAnimatedMonIcon       ; MONICON_MOBILE1
	dw Mobile_InitPartyMenuBGPal71      ; MONICON_MOBILE2
	dw Unused_GetPartyMenuMonIcon       ; MONICON_UNUSED

Unused_GetPartyMenuMonIcon:
	call InitPartyMenuIcon
	call .GetPartyMonItemGFX
	jmp SetPartyMonIconAnimSpeed

.GetPartyMonItemGFX:
	push bc
	ldh a, [hObjectStructIndex]
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	pop bc
	ld a, [hl]
	and a
	jr z, .no_item
	push hl
	push bc
	ld d, a
	farcall ItemIsMail
	pop bc
	pop hl
	jr c, .not_mail
	ld a, $06
	jr .got_tile
.not_mail
	ld a, $05
	; fallthrough

.no_item
	ld a, $04
.got_tile
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ret

Mobile_InitAnimatedMonIcon:
	call PartyMenu_InitAnimatedMonIcon
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_FUNC_NULL
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], 9 * TILE_WIDTH
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], 9 * TILE_WIDTH
	ret

Mobile_InitPartyMenuBGPal71:
	call InitPartyMenuIcon
	call SetPartyMonIconAnimSpeed
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_FUNC_NULL
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], 3 * TILE_WIDTH
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], 12 * TILE_WIDTH
	ld a, c
	ld [wc608], a
	ld a, b
	ld [wc608 + 1], a
	ret

PartyMenu_InitAnimatedMonIcon:
	call InitPartyMenuIcon
	call .SpawnItemIcon
	jr SetPartyMonIconAnimSpeed

.SpawnItemIcon:
	push bc
	ldh a, [hObjectStructIndex]
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	rst AddNTimes
	pop bc
	ld a, [hl]
	and a
	ret z
	push hl
	push bc
	ld d, a
	farcall ItemIsMail
	pop bc
	pop hl
	; a = carry ? SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_MAIL : SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_ITEM
	assert SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_MAIL + 1 == SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_ITEM
	sbc a
	add SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_ITEM
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ret

InitPartyMenuIcon:
	call LoadPartyMenuMonColors
	ld a, [wCurIconTile]
	push af
	ldh a, [hObjectStructIndex]
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wCurIcon], a

	ld a, MON_FORM
	call GetPartyParamLocation
	ld a, [hl]
	ld [wForm], a

	call GetMemIconGFX
	ldh a, [hObjectStructIndex]
; y coord
	add a
	add a
	add a
	add a
	add $1c
	ld d, a
; x coord
	ld e, $10
; type is partymon icon
	ld a, SPRITE_ANIM_OBJ_PARTY_MON
	call _InitSpriteAnimStruct
	pop af
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a
	ret

SetPartyMonIconAnimSpeed:
	push bc
	ldh a, [hObjectStructIndex]
	ld b, a
	call .getspeed
	ld a, b
	pop bc
	ld hl, SPRITEANIMSTRUCT_DURATIONOFFSET
	add hl, bc
	ld [hl], a
	rlca
	rlca
	ld hl, SPRITEANIMSTRUCT_VAR2
	add hl, bc
	ld [hl], a
	ret

.getspeed
	farcall PlacePartymonHPBar
	call GetHPPal
	ld e, d
	ld d, 0
	ld hl, .speeds
	add hl, de
	ld b, [hl]
	ret

.speeds
	db $00 ; HP_GREEN
	db $40 ; HP_YELLOW
	db $80 ; HP_RED

NamingScreen_InitAnimatedMonIcon:
	ld hl, wTempMonForm
	call SetMenuMonColor
	ld a, [wTempIconSpecies]
	ld [wCurIcon], a
	ld a, [wTempMonForm]
	ld [wForm], a
	xor a
	call GetIconGFX
	depixel 4, 4, 4, 0
	ld a, SPRITE_ANIM_OBJ_PARTY_MON
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_FUNC_NULL
	ret

MoveList_InitAnimatedMonIcon:
	ld a, MON_FORM
	call GetPartyParamLocation
	call SetMenuMonColor
	ld a, [wTempIconSpecies]
	ld [wCurIcon], a
	; Put the mon's form in wForm
	ld a, MON_FORM
	call GetPartyParamLocation
	ld a, [hl]
	ld [wForm], a
	xor a
	call GetIconGFX
	lb de, 3 * TILE_WIDTH + 2, 4 * TILE_WIDTH + 4
	ld a, SPRITE_ANIM_OBJ_PARTY_MON
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_FUNC_NULL
	ret

; TODO: update trademon to populate form
Trade_LoadMonIconGFX:
	; hl = wPlayerTrademonDVs or wOTTrademonDVs
	ld h, b
	ld l, c
	ld a, [wTempIconSpecies]
	ld [wCurPartySpecies], a
	ld [wCurIcon], a
	call GetMenuMonPalette
	add a
	add a
	add a
	ld e, a
	farcall SetSecondOBJPalette
	ld a, $62
	ld [wCurIconTile], a
	jr GetMemIconGFX

GetSpeciesIcon:
; Load species icon into VRAM at tile a
	push de
	ld a, MON_FORM
	call GetPartyParamLocation
	call SetMenuMonColor
	ld a, [wTempIconSpecies]
	ld [wCurIcon], a

	; Put the mon's form in wForm
	ld a, MON_FORM
	call GetPartyParamLocation
	ld a, [hl]
	ld [wForm], a
	pop de
	ld a, e
	jr GetIconGFX

FlyFunction_GetMonIcon:
	push de
	ld a, [wTempIconSpecies]
	ld [wCurIcon], a

	; Put the mon's form in wForm
	ld a, MON_FORM
	call GetPartyParamLocation
	ld a, [hl]
	ld [wForm], a
	pop de

	ld a, e
	call GetIcon_a
; todo: made up this label location... fix this!
; fallthrough
SetOWFlyMonColor:
	; Edit the OBJ 0 palette so that the cursor Pokémon has the right colors.
	ld a, MON_FORM
	call GetPartyParamLocation
	call GetMenuMonPalette
	add a
	add a
	add a
	ld e, a
	farjp SetFirstOBJPalette

GetMemIconGFX:
	ld a, [wCurIconTile]
GetIconGFX:
	call GetIcon_a
	ld de, 8 tiles
	add hl, de
	ld de, HeldItemIcons
	lb bc, BANK(HeldItemIcons), 2
	call GetGFXUnlessMobile
	ld a, [wCurIconTile]
	add 10
	ld [wCurIconTile], a
	ret

HeldItemIcons:
INCBIN "gfx/stats/mail.2bpp"
INCBIN "gfx/stats/item.2bpp"

GetIcon_a:
; Load icon graphics into VRAM starting from tile a.
	ld l, a
	ld h, 0

; TODO: handle eggs
; TODO: handle unown
; TODO: handle pikachu
GetIcon:
; Load icon graphics into VRAM starting from tile hl.

; One tile is 16 bytes long.
; Multiply hl by 16 (2^4) by shifting left 4 times
; This converts tile number to byte offset
rept 4
	add hl, hl          ; Shift left once (multiply by 2)
endr

	ld de, vTiles0      ; Load base address of VRAM tile data
	add hl, de          ; Add offset to get final VRAM destination
	push hl             ; Save VRAM destination address
	ld a, [wCurIcon]    ; Load current icon species number
	push hl             ; Save VRAM destination again

	push af             ; Save species number
	dec a               ; Convert species number to 0-based index

	ld hl, FollowingSpritePointers  ; Point to sprite pointer table

	ld d, 0             ; Clear high byte of index
	ld e, a             ; Put icon index in e
	add hl, de          ; Add index to pointer table base
	add hl, de          ; Each entry is 3 bytes, so add index twice more
	add hl, de          ; (total: index * 3)
	; TODO: do we actually need to assert this anymore?
	assert BANK(FollowingSpritePointers) == BANK(UnownFollowingSpritePointers), \
			"FollowingSpritePointers Bank is not equal to UnownFollowingSpritePointers"
	ld a, BANK(FollowingSpritePointers)  ; Load bank containing sprite pointers
	push af             ; Save bank number
	call GetFarByte     ; Read first byte (bank of compressed data)
	ld b, a             ; Store bank in b
	inc hl              ; Move to next byte
	pop af              ; Restore pointer table bank
	call GetFarWord     ; Read 2-byte address of compressed data

	ldh a, [rSVBK]      ; Save current WRAM bank
	push af             ; Save it on stack
	ld a, BANK(wDecompressScratch)  ; Switch to decompression buffer bank
	ldh [rSVBK], a      ; Set new WRAM bank

	push bc             ; Save compressed data bank
	ld a, b             ; Get compressed data bank
	ld de, wDecompressScratch  ; Point to decompression buffer
	call FarDecompress  ; Decompress sprite data
	pop bc              ; Restore registers
	ld de, wDecompressScratch  ; Point to decompressed data

	pop af              ; Restore original WRAM bank
	ldh [rSVBK], a      ; Set it back

	ld c, 4             ; Load 4 tiles worth of data
	pop af              ; Restore original species number

	pop hl              ; Restore VRAM destination address

	push bc             ; Save tile count
	call GetGFXUnlessMobile  ; Copy first 4 tiles to VRAM
	ld bc, 16 * 4       ; Calculate size of 4 tiles (64 bytes)
	add hl, bc          ; Move VRAM pointer to next position
	push hl             ; Save new VRAM position
	ld h, d             ; Copy decompressed data pointer to hl
	ld l, e
	ld de, 16 * 4 * 3   ; Skip 3 frames worth of tiles in source data
	add hl, de          ; Move to 4th frame of animation
	ld d, h             ; Copy new source pointer back to de
	ld e, l
	pop hl              ; Restore VRAM destination
	pop bc              ; Restore tile count
	call GetGFXUnlessMobile  ; Copy another 4 tiles to VRAM

	pop hl              ; Clean up stack (restore original hl)
	ret                 ; Return to caller

GetGFXUnlessMobile:
	ld a, [wLinkMode]
	cp LINK_MOBILE
	jp nz, .not_mobile
	jp Get2bppViaHDMA

.not_mobile
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a

	call Request2bpp

	pop af
	ldh [rSVBK], a
	ret


GetStorageIcon_a:
; Load frame 1 icon graphics into VRAM starting from tile a
	ld l, a ; no-optimize hl|bc|de = a * 16 (rept)
	ld h, 0
rept 4
	add hl, hl
endr
	ld de, vTiles0
	add hl, de
	; fallthrough
GetStorageIcon:
	push hl
	ld a, [wCurIcon]
	call _LoadOverworldMonIcon
	ld c, 4
	pop hl
	farjp BillsPC_SafeGet2bpp

FreezeMonIcons:
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
	ld a, [wMenuCursorY]
	ld d, a
.loop
	ld a, [hl]
	and a
	jr z, .next
	cp d
	ld a, SPRITE_ANIM_FUNC_NULL
	jr nz, .ok
	ld a, SPRITE_ANIM_FUNC_PARTY_MON_SWITCH
.ok
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], a
	pop hl

.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

UnfreezeMonIcons:
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
.loop
	ld a, [hl]
	and a
	jr z, .next
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_FUNC_PARTY_MON
	pop hl
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

HoldSwitchmonIcon:
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
	ld a, [wSwitchMon]
	ld d, a
.loop
	ld a, [hl]
	and a
	jr z, .next
	cp d
	ld a, SPRITE_ANIM_FUNC_PARTY_MON_SELECTED
	jr nz, .join_back
	ld a, SPRITE_ANIM_FUNC_PARTY_MON_SWITCH
.join_back
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], a
	pop hl
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

INCLUDE "data/pokemon/menu_mon_pals.asm"