; TODO: pass NPC name and an MG_NPC ID to script

; NPC Mystery Gift Screen
; This file implements an NPC-triggered mystery gift screen that can be called from the overworld

NPCMysteryGiftScreen::
	; Stop updating Sprite positions and set all bg palettes to black/empty
	call DisableSpriteUpdates
	call ClearBGPalettes
	
	; Clear the screen and set up the mystery gift layout
	call ClearTilemap ; fill entire screen tilemap with blank tiles
	call ClearSprites ; remove all sprites form the screen (NPCs, player, boulders, etc)
	call WaitBGMap ; Wait for GB video hardware to finish drawing cleared screen
	
  ; Load border graphics, decorative frame, and call the CGB palette layout system.
	call InitMysteryGiftLayout
	
  ; Walking sprites have likely overwritten the font in VRAM, so lets load that back in
	call LoadStandardFont

	; Display custom text for NPC interaction
	hlcoord 3, 8
	ld de, .NPCMysteryGiftText
	rst PlaceString
	call WaitBGMap

  ; Set up palettes
	ld b, SCGB_MYSTERY_GIFT ; load mystery gift layout id into B
	call GetSGBLayout ; Applies the CGB color palette layout (sets up attribute map and loads palettes)
	call SetDefaultBGPAndOBP ; sets default bg and object palettes for non-CGB Game Boys (is this necessary?)
	call DelayFrame ; wait one frame for all graphic changes to take effect

.input_loop
	; Handle input
	call .GetInput
	jr c, .exit_screen
	
	; Check for other inputs as needed
	jr .input_loop

.exit_screen
	; Play exit sound
	call PlayClickSFX
	
	; Return to overworld
	call .ReturnToOverworld
	ret

.GetInput
	; Get joypad input
	call GetJoypad
	ldh a, [hJoyPressed]
	
	; Check for B button to exit
	bit B_PAD_B, a
	jr nz, .pressed_b

	ldh a, [hJoyPressed]

  bit B_PAD_A, a
	jr nz, .pressed_a
	
	; Return the input for other processing
	and a ; clear carry flag
	ret

.pressed_b
  jr .MysteryGiftCanceled

.pressed_a
  ; TODO: Check if player has a pending myster gift item with the man on the second floor of the pokecenter
  ; TODO: Check if player has mystery gifted with this NPC today
  ; TODO: Check if player has already mystery gifted with NPCs 5 times today

; fall through

.SendGift:
; update wMysteryGiftPartnerName
  ld hl, MysteryGiftNPCNames ; store pointer to Mystery Gift NPC name table
  ld a, [wScriptVar] ; get the Mystery Gift NPC ID/Index from wScriptVar

  push af
  ; Move to the correct position in the name table
  ld bc, (NAME_LENGTH - 1)
  rst AddNTimes

  ; Copy the NPC name into wMysteryGiftPartnerName
  ld de, wMysteryGiftPartnerName
  ld bc, (NAME_LENGTH - 1)
  rst CopyBytes
  pop af

  call Random
  and 1 ; keep only 1 bit - determines item vs decoration
	jr z, .SentItem
; sent decoration
	call .RandomSample
	ld c, a
	farcall MysteryGiftGetDecoration
	push bc
	farcall CheckAndSetMysteryGiftDecorationAlreadyReceived
	pop bc
	jr nz, .SentItem
; keep the decoration if it wasn't already received
	farcall GetDecorationName_c
	ld h, d
	ld l, e
	ld de, wStringBuffer1
	ld bc, ITEM_NAME_LENGTH
	rst CopyBytes
  ld hl, wPlayerName
  ld bc, NAME_LENGTH
  ld de, wMysteryGiftPlayerName
  rst CopyBytes

	ld hl, .MysteryGiftSentHomeText ; sent decoration to home TODO:
	jr .PrintTextAndExit

.SentItem
  ; Get Item name into wStringBuffer1
  ld a, BANK(sMysteryGiftData)
	call OpenSRAM
  call .RandomSample
  ld c, a
  farcall MysteryGiftGetItem
  ld a, c
	ld [sBackupMysteryGiftItem], a
  ld [sMysteryGiftItem], a
	ld [wNamedObjectIndex], a
	call CloseSRAM
  call GetItemName

  ld hl, .MysteryGiftSentText
  jr .PrintTextAndExit

.MysteryGiftCanceled:
	ld hl, .MysteryGiftCanceledText 
	jr .PrintTextAndExit

.MysteryGiftCanceledText:
	text_far _MysteryGiftCanceledText
	text_end

.MysteryGiftSentText:
	text_far _MysteryGiftSentText
	text_end

.MysteryGiftSentHomeText:
	text_far _MysteryGiftSentHomeText
	text_end

.PrintTextAndExit:
  ; Clear screen so we can just show a textbox
  push hl
  call ClearTilemap
	call WaitBGMap
	ld b, SCGB_DIPLOMA
	call GetSGBLayout
	call SetDefaultBGPAndOBP
  pop hl

	call PrintText
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	scf ; set carry flag to indicate exit
	ret

.ReturnToOverworld
	; Clear the mystery gift screen
	call ClearTilemap
	call ClearSprites
	call ClearBGPalettes
	
	; Restore overworld graphics and state
	call ReloadTilesetAndPalettes ; reload the map's tileset graphics and color palettes for current map data
	call UpdateSprites ; Redraw all sprites on the screen
	call EnableSpriteUpdates ; Reenable sprite updates

	; Set proper palettes for overworld
	ld b, SCGB_MAPPALS
	call GetSGBLayout ; apply standard overworld palette
	call WaitBGMap2 ; wait until graphics are drawn
	farcall LoadOW_BGPal7 ; load the standard overworld text bg palette
	farcall EnableDynPalUpdates ; re-enable automatic palette updates for things like time transitions
	call DelayFrame 
	
	; Re-enable map animations
	ld a, 1
	ldh [hMapAnims], a
	ret

; Determine gift index
; Returns Gift Index in A
.RandomSample
  call Random
  and 1
  jr z, .fiftypercent
  ; common index - 50% chance - index 0-15 
  call Random
  and 15 ; keep the lower 4 bits
  jr .done
.fiftypercent
  call Random
  and 1
  jr z, .twentyfivepercent
  ; uncommon index - 25% chance - index 16-23
  call Random
  and 7 ; keep only lower 3 bits (0-7)
  add $10 ; add 16 to A, so result with be 16-23
  jr .done
.twentyfivepercent
  call Random
  cp 20 percent - 1
  jr z, .fivepercent
  ; rare index - 20% chance - index (24-31)
  call Random
  and 7 ; keep only lower 3 bits (0-7)
  add $18 ; add 24 to A, so result with be 24-31
  jr .done
.fivepercent
  ; super rare index - 5% chance - index 32-33
  call Random
  and 1
  ld a, $20 ; index 32
  jr z, .done
  ld a, $21 ; index 33
.done
  ret

.NPCMysteryGiftText:
	db   "Press A to"
	next "MYSTERY GIFT"
	next "Press B to"
	next "exit screen."
	db   "@"

INCLUDE "data/mystery_gift_npcs/names.asm"