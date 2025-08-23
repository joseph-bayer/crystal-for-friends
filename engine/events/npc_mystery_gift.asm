; NPC Mystery Gift Screen
; This file implements an NPC-triggered mystery gift screen that can be called from the overworld

DoNPCMysteryGift::
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
  jp .MysteryGiftCanceled

.pressed_a
	call .CheckAlreadyGotAGiftFromThatPerson
	ld hl, .MysteryGiftOneADayText ; Only one gift a day per person
	jmp c, .PrintTextAndExit
  ; Check if you have a pending gift
  call GetMysteryGiftBank
  ld a, [sMysteryGiftItem]
  call CloseSRAM
	and a
	jp nz, .GiftWaiting ; If yes, tell player to get it first
; fall through
.SendGift:
  call .AddMysteryGiftPartnerID

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
  farcall CopyMysteryGiftReceivedDecorationsToPC
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

	ld hl, .MysteryGiftSentHomeText ; sent decoration to home
	jp .PrintTextAndExit

.SentItem
  ; Get Item name into wStringBuffer1
  ld a, BANK(sMysteryGiftData)
	call OpenSRAM
  call .RandomSample
  ld c, a
  farcall MysteryGiftGetItem
  ld a, c
  ld [sBackupMysteryGiftItem], a
	ld [wMysteryGiftPlayerBackupItem], a
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

.RetrieveMysteryGiftText:
	text_far _RetrieveMysteryGiftText
	text_end

.MysteryGiftOneADayText:
	text_far _MysteryGiftOneADayText
	text_end

.GiftWaiting:
	ld hl, .RetrieveMysteryGiftText ; receive gift at counter
	jr .PrintTextAndExit

.CheckAlreadyGotAGiftFromThatPerson:
	call GetMysteryGiftBank
	ld a, 0
	ld b, a
	ld a, [wScriptVar] ; HACK: store Mystery Gift NPC ID/Index from wScriptVar in wMysteryGiftPartnerID. Could be an issue if you mystery gift with a real person with a id of 0, 1, 2, 3, etc. (low numbers)
	ld c, a
	ld a, [sNumDailyMysteryGiftPartnerIDs]
	ld d, a
	ld hl, sDailyMysteryGiftPartnerIDs
.loop
	ld a, d
	and a
	jr z, .No
	ld a, [hli]
	cp b
	jr nz, .skip
	ld a, [hl]
	cp c
	jr z, .Yes
.skip
	inc hl
	dec d
	jr .loop
.Yes:
	scf
.No:
	jmp CloseSRAM

.AddMysteryGiftPartnerID:
	call GetMysteryGiftBank
  ld hl, sNumDailyMysteryGiftPartnerIDs
	ld a, [hl]
	inc [hl]
	ld hl, sDailyMysteryGiftPartnerIDs ; could have done "inc hl" instead
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, 0
	ld [hli], a
	ld a, [wScriptVar] ; HACK: store Mystery Gift NPC ID/Index from wScriptVar in sDailyMysteryGiftPartnerIDs. Could be an issue if you mystery gift with a real person with a id of 0, 1, 2, 3, etc. (low numbers)
	ld [hl], a
	jmp CloseSRAM

.PrintTextAndExit:
  ; Clear screen so we can just show a textbox
  push hl
  call ClearTilemap
	call WaitBGMap
	ld b, SCGB_DIPLOMA
	call GetSGBLayout
	call SetDefaultBGPAndOBP
  farcall LoadFonts_NoOAMUpdate ; load font so NPC graphics don't replace border graphics
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