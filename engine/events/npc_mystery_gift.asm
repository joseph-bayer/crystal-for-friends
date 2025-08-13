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
	
	; Check for A button press (could add functionality here)
	bit B_PAD_A, a
	jr nz, .a_pressed
	
	; Check for other inputs as needed
	jr .input_loop

.a_pressed
	; For now, just play a sound and continue
	call PlayClickSFX
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
	
	; Return the input for other processing
	and a ; clear carry flag
	ret

.pressed_b
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

.NPCMysteryGiftText:
	db   "Press A to"
	next "MYSTERY GIFT"
	next "Press B to"
	next "exit screen."
	db   "@"

; Alternative simpler version for direct NPC interaction
SimpleNPCMysteryGift::
	; Even simpler version - just show the screen without text prompts
	call NPCMysteryGiftScreen
	ret

; Special function that can be called from map scripts using "special"
NPCMysteryGiftSpecial::
	; This is the special function for the special pointer table
	call NPCMysteryGiftScreen
	ret
