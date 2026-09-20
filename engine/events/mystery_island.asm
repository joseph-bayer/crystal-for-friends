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
	turnobject PLAYER, LEFT ; he lands you at (11, 4) and stands at (10, 4)
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

