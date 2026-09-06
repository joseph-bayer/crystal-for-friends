_UpdatePlayerSprite::
	call GetPlayerSprite
	ld a, [wUsedSprites]
	ldh [hUsedSpriteIndex], a
	ld a, [wUsedSprites + 1]
	ldh [hUsedSpriteTile], a
	ld hl, wSpriteFlags
	res 5, [hl]
	jmp GetUsedSprite

LoadStandingSpritesGFX: ; mobile
	ld hl, wSpriteFlags
	ld a, [hl]
	push af
	res SPRITES_SKIP_STANDING_GFX_F, [hl]
	set SPRITES_SKIP_WALKING_GFX_F, [hl]
	call LoadUsedSpritesGFX
	pop af
	ld [wSpriteFlags], a
	ret

LoadWalkingSpritesGFX: ; mobile
	ld hl, wSpriteFlags
	ld a, [hl]
	push af
	set SPRITES_SKIP_STANDING_GFX_F, [hl]
	res SPRITES_SKIP_WALKING_GFX_F, [hl]
	call LoadUsedSpritesGFX
	pop af
	ld [wSpriteFlags], a
	ret

GetPlayerSprite:
; Get Chris or Kris's sprite.
	ld hl, ChrisStateSprites
	ld a, [wPlayerSpriteSetupFlags]
	bit PLAYERSPRITESETUP_FEMALE_TO_MALE_F, a
	jr nz, .go
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .go
	ld hl, KrisStateSprites

.go
	ld a, [wPlayerState]
	ld c, a
.loop
	ld a, [hli]
	cp c
	jr z, .good
	inc hl
	cp -1
	jr nz, .loop

; Any player state not in the array defaults to Chris's sprite.
	xor a ; ld a, PLAYER_NORMAL
	ld [wPlayerState], a
	ld a, SPRITE_CHRIS
	jr .finish

.good
	ld a, [hl]

.finish
	ld [wUsedSprites + 0], a
	ld [wPlayerSprite], a
	ld [wPlayerObjectSprite], a
	ret

INCLUDE "data/sprites/player_sprites.asm"

RefreshSprites::
	push hl
	push de
	push bc
	call GetPlayerSprite
	xor a
	ldh [hUsedSpriteIndex], a
	call ReloadSpriteIndex
	call LoadMiscTiles
	jmp PopBCDEHL

ReloadSpriteIndex::
; Reloads sprites using hUsedSpriteIndex.
; Used to reload variable sprites
	ld hl, wObjectStructs
	ld de, OBJECT_LENGTH
	push bc
	ldh a, [hUsedSpriteIndex]
	ld b, a
	xor a
.loop
	ldh [hObjectStructIndex], a
	ld a, [hl]
	and a
	jr z, .done
	bit 7, b
	jr z, .continue
	cp b
	jr nz, .done
.continue
	push hl
	call GetSpriteVTile
	pop hl
	push hl
	inc hl
	inc hl
	ld [hl], a
	pop hl
.done
	add hl, de
	ldh a, [hObjectStructIndex]
	inc a
	cp NUM_OBJECT_STRUCTS
	jr nz, .loop
	pop bc
	ret

LoadUsedSpritesGFX:
	ld a, MAPCALLBACK_SPRITES
	call RunMapCallback
	call GetUsedSprites
; fallthrough
LoadMiscTiles:
	ld a, [wSpriteFlags]
	bit SPRITES_SKIP_WALKING_GFX_F, a
	ret nz

	ld c, EMOTE_POKE_BALL
	call LoadEmote

	ld c, EMOTE_SHADOW
	call LoadEmote
	call GetMapEnvironment
	call CheckOutdoorMap
	ld c, EMOTE_GRASS_RUSTLE
	jr z, .outdoor
	ld c, EMOTE_BOULDER_DUST
.outdoor
	jmp LoadEmote

SafeGetSprite:
	push hl
	call GetSprite
	pop hl
	ret

GetSprite::
	call GetFollowingSprite
	ret c
	call GetMonSprite
	ret c

	ld hl, OverworldSprites + SPRITEDATA_ADDR
	dec a
	ld c, a
	ld b, 0
	ld a, NUM_SPRITEDATA_FIELDS
	rst AddNTimes
	; load the address into de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	; load the length into c
	ld a, [hli]
	swap a
	ld c, a
	; load the sprite bank into both b and h
	ld b, [hl]
	ld a, [hli]
	; load the sprite type into l
	ld l, [hl]
	ld h, a
	ret

GetMonSprite:
; Return carry if a monster sprite was loaded.

	cp SPRITE_POKEMON
	jr c, .Normal
	cp SPRITE_DAY_CARE_MON_1
	jr z, .BreedMon1
	cp SPRITE_DAY_CARE_MON_2
	jr z, .BreedMon2
	cp SPRITE_VARS
	jr nc, .Variable
	jr .pokemon_sprite

.Normal:
	and a
	ret

.pokemon_sprite:
	sub SPRITE_POKEMON
	ld e, a
	ld d, 0
	ld hl, SpriteMons
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetPokemonIDFromIndex
	jr .Mon

.BreedMon1
	ld a, [wBreedMon1Species]
	ld d, 1
	jr .Mon

.BreedMon2
	ld a, [wBreedMon2Species]
	ld d, 2

.Mon:
	ld e, a
	and a
	jr z, .NoBreedmon

	farcall LoadOverworldMonIcon

	lb hl, 0, WALKING_SPRITE
	scf
	ret

.Variable:
	sub SPRITE_VARS
	ld e, a
	ld d, 0
	ld hl, wVariableSprites
	add hl, de
	ld a, [hl]
	and a
	jr nz, GetMonSprite

.NoBreedmon:
	ld a, WALKING_SPRITE
	lb hl, 0, WALKING_SPRITE
	and a
	ret

GetFirstAliveMon::
; Returns the species ID of the first party mon with HP > 0 in a
; and its 1-based party slot in d. Falls back to the first mon.
; Returns a = 0 if the party is empty.
	ld a, [wPartyCount]
	and a
	ret z
	inc a
	ld d, 1
	ld e, a
	ld bc, wPartyMon1
.loop
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	push de
	ld d, a
	ld a, [hl]
	or d
	pop de
	jr nz, .got_mon_struct
	inc d
	ld a, d
	cp e
	jr z, .none
	ld hl, PARTYMON_STRUCT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	jr .loop
.none
	ld d, 1
	ld a, [wPartySpecies]
	ret
.got_mon_struct
	ld a, [bc]
	ret

SetFollowerFromParty::
; Picks the follower from the party and locks its 8-bit ID so the
; 16-bit conversion table can't evict it while it's on screen.
; Returns a = species ID (0 if the party is empty).
	call GetFirstAliveMon
	and a
	ret z
	ld [wFollowerSpriteID], a
	ld l, LOCKED_MON_ID_FOLLOWER
	call LockPokemonID
	ld a, d
	ld [wFollowerPartyNum], a
	ld a, [wFollowerSpriteID]
	ret

GetFollowingSprite:
	cp SPRITE_FOLLOWER
	jr z, .follower
	and a ; not the follower; let GetMonSprite deal with this sprite id
	ret

.follower
	call SetFollowerFromParty
	and a
; No party (or no living mon): there is no follower sprite to load. SPRITE_FOLLOWER has no
; OverworldSprites entry, so fall back rather than running off the end of the table.
	jr z, GetMonSprite.NoBreedmon
	; fallthrough

; A party menu icon is 8 tiles: two 2x2 frames, each stored top-left, top-right, bottom-left,
; bottom-right. An overworld sprite wants 12 standing tiles - facing down at $00, up at $04,
; left/right at $08 - followed by the same 12 walking tiles at +$80. Copying frame 1 into all
; three standing facings and frame 2 into all three walking facings makes the engine's own walk
; cycle alternate the icon's two frames, whichever way the follower is facing.
DEF FOLLOWER_ICON_FRAME_SIZE EQU 4 tiles
DEF FOLLOWER_ICON_FACINGS    EQU 3

GetFollowerIconSprite:
; in: a = the follower's species ID
; out: the GetSprite contract - de = graphics, b = bank, c = tile count, l = sprite type, carry set
	push af
	ld a, [wFollowerPartyNum]
	dec a ; wFollowerPartyNum is 1-based
	ld hl, wPartyMon1Form
	call GetPartyLocation
	ld a, [hl]
	ld [wForm], a ; LoadOverworldMonIcon reads this for cosmetic forms and Unown letters
	pop af
	ld e, a
	ld d, 0 ; not a day-care mon, so wForm above is used as-is
	farcall LoadOverworldMonIcon ; de = icon graphics, b = its bank, c = 8 tiles

	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a

	ld h, d
	ld l, e ; hl = icon frame 1
	ld a, b ; a = icon bank
	ld de, wDecompressScratch
	call .CopyFrameToEachFacing ; frame 1 becomes every standing facing
	ld bc, FOLLOWER_ICON_FRAME_SIZE
	add hl, bc ; hl = icon frame 2
	call .CopyFrameToEachFacing ; frame 2 becomes every walking facing

; Every facing holds the same artwork, so mirror the down-facing copies. Walking towards the camera
; then reads as a different pose from walking away, rather than the two being identical.
	ld hl, wDecompressScratch
	call .MirrorFrameInPlace
	ld hl, wDecompressScratch + FOLLOWER_ICON_FACINGS * FOLLOWER_ICON_FRAME_SIZE
	call .MirrorFrameInPlace

	pop af
	ldh [rSVBK], a

	ldh a, [hROMBank]
	ld b, a ; the graphics are in WRAM now, so any valid bank will do for Get2bpp
	ld de, wDecompressScratch
	ld c, FOLLOWER_ICON_FACINGS * 4
	lb hl, 0, WALKING_SPRITE
	scf
	ret

.CopyFrameToEachFacing:
; in: a = bank, hl = one 2x2 frame, de = destination
; out: de advanced past the block, a and hl unchanged
	push hl
	ld c, FOLLOWER_ICON_FACINGS
.loop
	push bc
	push hl
	push af
	ld bc, FOLLOWER_ICON_FRAME_SIZE
	call FarCopyBytes ; copies bc bytes from a:hl to de, advancing de
	pop af
	pop hl
	pop bc
	dec c
	jr nz, .loop
	pop hl
	ret

.MirrorFrameInPlace:
; in: hl = one 2x2 frame in WRAM, stored top-left, top-right, bottom-left, bottom-right
; Mirrors it horizontally: the two columns swap, and every byte's bits are reversed.
	push hl
	ld d, h
	ld e, l ; de = top-left
	ld bc, TILE_SIZE
	add hl, bc ; hl = top-right
	call .SwapAndReverseTiles
	pop hl
	push hl
	ld bc, TILE_SIZE * 2
	add hl, bc
	ld d, h
	ld e, l ; de = bottom-left
	ld bc, TILE_SIZE
	add hl, bc ; hl = bottom-right
	call .SwapAndReverseTiles
	pop hl
	ret

.SwapAndReverseTiles:
; in: hl and de each point at one 2bpp tile in WRAM; swaps them, reversing each byte
	ld c, TILE_SIZE
.swap_loop
	ld a, [de]
	call .ReverseBits
	ld b, a
	ld a, [hl]
	call .ReverseBits
	ld [de], a
	ld a, b
	ld [hli], a
	inc de
	dec c
	jr nz, .swap_loop
	ret

.ReverseBits:
; in: a = a byte. out: a = that byte with its bits in the opposite order.
	push bc
	ld b, a
	ld c, 0
	ld a, 8
.reverse_loop
	rl b ; the top bit of b falls out into carry...
	rr c ; ...and lands in the bottom of c, one place further each time
	dec a
	jr nz, .reverse_loop
	ld a, c
	pop bc
	ret

_DoesSpriteHaveFacings::
; Checks to see whether we can apply a facing to a sprite.
; Returns carry unless the sprite is a Pokemon or a Still Sprite.
	cp SPRITE_FOLLOWER
	jr z, .follower
	cp SPRITE_POKEMON
	jr nc, .only_down

	push hl
	push bc
	ld hl, OverworldSprites + SPRITEDATA_TYPE
	dec a
	ld c, a
	ld b, 0
	ld a, NUM_SPRITEDATA_FIELDS
	rst AddNTimes
	ld a, [hl]
	pop bc
	pop hl
	cp STILL_SPRITE
	jr nz, .only_down
	scf
	ret

.follower
	ld a, WALKING_SPRITE

.only_down
	and a
	ret

_GetSpritePalette::
	ld a, c
	cp SPRITE_FOLLOWER
	jr z, .follower
	call GetMonSprite
	jr c, .is_pokemon

	ld hl, OverworldSprites + SPRITEDATA_PALETTE
	dec a
	ld c, a
	ld b, 0
	ld a, NUM_SPRITEDATA_FIELDS
	rst AddNTimes
	ld c, [hl]
	ret

.is_pokemon
	xor a
	ld c, a
	ret

.follower
; The follower uses its party menu icon palette (already shiny-aware),
; mapped onto an overworld palette.
	call SetFollowerFromParty
	and a
	jr z, .is_pokemon
	push de
	ld e, a
	ld a, [wCurPartySpecies]
	push af
	ld a, e
	ld [wCurPartySpecies], a
	ld a, [wFollowerPartyNum]
	dec a
	ld hl, wPartyMon1Form
	call GetPartyLocation
	farcall GetMenuMonIconPalette ; a = PAL_ICON_*
	ld e, a
	pop af
	ld [wCurPartySpecies], a
	ld d, 0
	ld hl, FollowingPalLookupTable
	add hl, de
	ld c, [hl]
	pop de
	ret

FollowingPalLookupTable:
; maps PAL_ICON_* (party menu icon palettes) to PAL_OW_* (overworld palettes)
	db PAL_OW_RED    ; PAL_ICON_RED
	db PAL_OW_BLUE   ; PAL_ICON_BLUE
	db PAL_OW_GREEN  ; PAL_ICON_GREEN
	db PAL_OW_BROWN  ; PAL_ICON_BROWN
	db PAL_OW_PINK   ; PAL_ICON_PINK
	db PAL_OW_GRAY   ; PAL_ICON_GRAY
	db PAL_OW_TEAL   ; PAL_ICON_TEAL
	db PAL_OW_PURPLE ; PAL_ICON_PURPLE

AddSpriteGFX:
; Add any new sprite ids to a list of graphics to be loaded.
; Return carry if the list is full.

	push hl
	push bc
	ld b, a
	ld hl, wUsedSprites + 2
	ld c, SPRITE_GFX_LIST_CAPACITY - 1
.loop
	ld a, [hl]
	cp b
	jr z, .exists
	and a
	jr z, .new
	inc hl
	inc hl
	dec c
	jr nz, .loop

	pop bc
	pop hl
	scf
	ret

.exists
	pop bc
	pop hl
	and a
	ret

.new
	ld [hl], b
	pop bc
	pop hl
	and a
	ret

GetSpriteLength:
; Return the length of sprite type a in tiles.

	cp WALKING_SPRITE
	jr z, .AnyDirection
	cp STANDING_SPRITE
	jr z, .AnyDirection
	cp STILL_SPRITE
	jr z, .OneDirection

	ld a, 12
	ret

.AnyDirection:
	ld a, 12
	ret

.OneDirection:
	ld a, 4
	ret

GetUsedSprites:
	ld hl, wUsedSprites
	ld c, SPRITE_GFX_LIST_CAPACITY

.loop
	ld a, [wSpriteFlags]
	res SPRITES_VRAM_BANK_0_F, a
	ld [wSpriteFlags], a

	ld a, [hli]
	and a
	ret z
	ldh [hUsedSpriteIndex], a

	ld a, [hli]
	ldh [hUsedSpriteTile], a

	bit 7, a ; tiles $80+ are in VRAM bank 0
	jr z, .dont_set

	ld a, [wSpriteFlags]
	set SPRITES_VRAM_BANK_0_F, a
	ld [wSpriteFlags], a

.dont_set
	push bc
	push hl
	call GetUsedSprite
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

GetUsedSprite::
	ldh a, [hUsedSpriteIndex]
	call SafeGetSprite
	ldh a, [hUsedSpriteTile]
	call .GetTileAddr
	push hl
	push de
	push bc
	ld a, [wSpriteFlags]
	bit SPRITES_SKIP_STANDING_GFX_F, a
	call z, .CopyToVram
	pop bc
	ld l, c
	ld h, $0
rept 4
	add hl, hl
endr
	pop de
	add hl, de
	ld d, h
	ld e, l
	pop hl

	ld a, [wSpriteFlags]
	bit SPRITES_SKIP_WALKING_GFX_F, a
	ret nz

	ldh a, [hUsedSpriteIndex]
	call _DoesSpriteHaveFacings
	ret c

	ld a, [wSpriteFlags]
	bit 5, a
	ld a, h
	jr nz, .vram1
	add 4
.vram1
	add 4
	ld h, a
; fallthrough
.CopyToVram:
	ldh a, [rVBK]
	push af
	ld a, [wSpriteFlags]
	and 1 << 5
	swap a
	rra
	ldh [rVBK], a
; the follower's sprite is decompressed into wDecompressScratch (WRAMX)
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	call Get2bpp
	pop af
	ldh [rSVBK], a
	pop af
	ldh [rVBK], a
	ret

.GetTileAddr:
; Return the address of tile (a) in (hl).
	and $7f
	swap a
	ld l, a
	and $f
	ld h, a
	xor l
	add LOW(vTiles0)
	ld l, a
	ld a, h
	adc HIGH(vTiles0)
	ld h, a
	ret

LoadEmote::
; Get the address of the pointer to emote c.
	ld a, c
	ld bc, EMOTE_LENGTH
	ld hl, Emotes
	rst AddNTimes
; Load the emote address into de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
; load the length of the emote (in tiles) into c
	ld a, [hli]
	ld c, a
	swap c
; load the emote pointer bank into b
	ld a, [hli]
	ld b, a
; load the VRAM destination into hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
; if the emote has a length of 0, do not proceed (error handling)
	ld a, c
	and a
	ret z
	jmp Get2bpp

INCLUDE "data/sprites/emotes.asm"

INCLUDE "data/sprites/sprite_mons.asm"

INCLUDE "data/sprites/sprites.asm"
