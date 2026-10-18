RollMysteryIsland::
; Choose which island the boat lands on, and remember it, so the same one cannot come up on two
; trips running. The choice is left in wScriptVar for the caller's branch table.
;
; Rolls over one fewer island than there are and then steps over the previous one, rather than
; rerolling until it differs. Same distribution, no loop, and nothing that can hang if the set is
; ever trimmed back.
;
; wMysteryIslandLast holds the island *plus one*. A fresh save starts it at zero, which therefore
; reads as "has never sailed" rather than as "was last on the first island" -- and the latter would
; quietly keep the first island out of the very first trip.
	assert NUM_MYSTERY_ISLANDS_MAPS >= 2, \
		"RollMysteryIsland has nothing to alternate between with fewer than two islands"

	ld a, [wMysteryIslandLast]
	and a
	jr z, .first_trip

	dec a
	ld b, a ; where the boat went last time
	ld a, NUM_MYSTERY_ISLANDS_MAPS - 1
	call RandomRange ; preserves bc
	cp b
	jr c, .chosen
	inc a ; step over last time's island
	jr .chosen

.first_trip
	ld a, NUM_MYSTERY_ISLANDS_MAPS
	call RandomRange

.chosen
	ld [wScriptVar], a
	inc a
	ld [wMysteryIslandLast], a
	ret

if DEF(_DEBUG)
ChooseMysteryIslandFromDebugMenu::
; The debug sailor's menu leaves a 1-based choice in wScriptVar, or 0 if it was cancelled. Turn that
; into the 0-based index RollMysteryIsland would have produced, so everything downstream is the same
; code. Cancelling, or anything out of range, just rolls.
	ld a, [wScriptVar]
	and a
	jr z, RollMysteryIsland ; cancelled, so roll for it after all
	dec a
	cp NUM_MYSTERY_ISLANDS_MAPS
	jr nc, RollMysteryIsland ; and likewise for anything out of range
	ld [wScriptVar], a

; Remember it the way the roll would, so a chosen island still keeps the next one from repeating it.
	inc a
	ld [wMysteryIslandLast], a
	ret

endc

MysteryIslandCrossingScript::
; The crossing itself, in both directions: a cut to black over the surf theme, then the hull
; grounding at the far end. `scall`ed rather than copied into four scripts, so the outbound trip and
; all three ways home stay in step -- Script_end returns to the caller whenever the script stack is
; not empty, which is what makes this a subroutine.
;
; Script_pause counts in units of four frames, so 75 is five seconds. The warp that follows brings
; the far side up on its own: MapSetupScript_Warp ends in LoadMapPalettes, and its InitSound puts
; the destination's own music back.
; The islands carry LANDMARK_SPECIAL so the arrival banner does not name them, and FlyMap reads
; that as "not a real place, use the backup" -- the mechanism Pokecenter 2F and the link rooms
; rely on. Nothing has set the backup since whatever warp last did, so the town map puts you
; wherever that was. warpmod is what maintains it; point it at the port you sailed from.
	warpmod -1, CIANWOOD_CITY
	special FadeOutToBlack
	callasm DisableDynPalUpdates
	callasm MysteryIslandBlackOut
	playmusic MUSIC_SURF
	pause 95
	playsound SFX_HIT_END_OF_EXP_BAR
	waitsfx
	end

MysteryIslandBlackOut::
; special FadeOutToBlack walks the fade table down to its last row, which maps every colour index
; onto its own palette's colour 3. For the object palettes that is already black, which is why the
; sprites look right; for the overworld background palettes it is RGB 07,07,07 -- a dark grey (see
; gfx/tilesets/bg_tiles.pal). Flatten both applied buffers so the crossing is an actual blackout.
;
; Pair this with DisableDynPalUpdates, or the dynamic palette system puts the object palettes back
; and the sprites reappear over the black. The warp clears that again on the far side, through
; MapSetupScript_Warp's closing EnableDynPalUpdatesNoApply.
	assert wOBPals2 == wBGPals2 + 8 palettes, 		"MysteryIslandBlackOut clears both palette buffers in one fill"
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals2)
	ldh [rWBK], a
	ld hl, wBGPals2
	ld bc, 16 palettes
	xor a
	rst ByteFill
	pop af
	ldh [rWBK], a
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

QueueMysteryIslandArrival::
; LoadMemScript runs a script once, the next time the overworld comes up. That is cheaper than
; giving all three islands a scene variable apiece for one piece of text, and it means the line
; lives in one place however many islands there end up being.
	ld b, BANK(MysteryIslandArriveScript)
	ld de, MysteryIslandArriveScript
	farjp LoadMemScript

MysteryIslandArriveScript:
	turnobject PLAYER, LEFT ; he lands you on his right, facing him
	opentext
	writetext MysteryIslandArriveText
	waitbutton
	closetext
	end

MysteryIslandArriveText:
	text "We've arrived!"

	para "Take some time to"
	line "explore. I'll be"
	cont "here taking a nap."
	done


; Shipwreck Beach (maps/ShipwreckBeach.asm). Each trip, SHIPWRECK_SPOTS_PER_TRIP of the island's
; SHIPWRECK_DIG_SPOTS spots hold something, marked with an X: exactly one holds cargo (a held item
; the game otherwise gives only once), and the rest treasure to sell.

	assert EVENT_SHIPWRECK_DIG_SPOT_10 == EVENT_SHIPWRECK_DIG_SPOT_1 + SHIPWRECK_DIG_SPOTS - 1, 		"the shipwreck dig spot flags must be in order"

RollShipwreckBeach::
; The boat sails for the shipwreck beach: clear last trip's spots, pick this trip's, all different,
; and make one of them the cargo spot. The flags and wShipwreckCargoSpot are in the save, so
; battles, menus and continuing keep them.
	ld de, EVENT_SHIPWRECK_DIG_SPOT_1
	ld c, SHIPWRECK_DIG_SPOTS
.clear
	push bc
	push de
	ld b, RESET_FLAG
	call EventFlagAction
	pop de
	pop bc
	inc de
	dec c
	jr nz, .clear

; The last spot picked is the cargo spot: the picks are random, so it is as good as any of them.
	ld b, SHIPWRECK_SPOTS_PER_TRIP
.pick
	push bc
	ld a, SHIPWRECK_DIG_SPOTS
	call RandomRange
	ld [wShipwreckCargoSpot], a ; 0-based for now
	ld hl, EVENT_SHIPWRECK_DIG_SPOT_1
	ld e, a
	ld d, 0
	add hl, de
	ld d, h
	ld e, l
	push de
	ld b, CHECK_FLAG
	call EventFlagAction
	pop de
	ld a, c
	and a
	jr nz, .taken ; picked already, so roll again
	ld b, SET_FLAG
	call EventFlagAction
	pop bc
	dec b
	jr nz, .pick
	ld hl, wShipwreckCargoSpot
	inc [hl] ; 1-based, like the spot numbers
	ret

.taken
	pop bc
	jr .pick

RollShipwreckItem::
; in: wScriptVar = the spot being dug (1-10)
; out: wScriptVar = the item it holds, for `giveitem ITEM_FROM_MEM`: cargo on this trip's cargo
; spot, treasure anywhere else. Rolled each time, so a full bag can turn up something else later.
	ld a, [wShipwreckCargoSpot]
	ld b, a
	ld a, [wScriptVar]
	cp b
	jr nz, .treasure
	ld hl, ShipwreckCargo
	ld a, (ShipwreckCargo.End - ShipwreckCargo) / 2
	jr .pick

.treasure
	ld hl, ShipwreckTreasure
	ld a, (ShipwreckTreasure.End - ShipwreckTreasure) / 2
.pick
	push hl
	call RandomRange
	pop hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetItemIDFromIndex
	ld [wScriptVar], a
	ret

ShipwreckTreasure:
; Treasure to sell, and the ship's rations. Equal odds.
	dw PEARL
	dw BIG_PEARL
	dw STARDUST
	dw STAR_PIECE
	dw NUGGET
	; Silver Leaf and Gold Leaf are out for now; maybe they become a currency of some kind later.
	; dw SILVER_LEAF
	; dw GOLD_LEAF
	dw BERRY_JUICE
.End:

ShipwreckCargo:
; Held items and vitamins the game otherwise gives once or not at all. Nothing from Mystery Gift's
; rare tier; HP Up and PP Up are from its super rare tier, and are here by the owner's choice.
; Equal odds.
	dw LEFTOVERS
	dw FOCUS_BAND
	dw BRIGHTPOWDER
	dw QUICK_CLAW
	dw AMULET_COIN
	dw LUCKY_EGG
	dw CLEANSE_TAG
	dw MYSTIC_WATER
	dw NEVERMELTICE
	dw POLKADOT_BOW
	dw ZINC
	dw PROTEIN
	dw IRON
	dw CARBOS
	dw CALCIUM
	dw HP_UP
	dw PP_UP
.End:
