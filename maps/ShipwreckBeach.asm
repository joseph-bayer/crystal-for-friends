	object_const_def
	const SHIPWRECKBEACH_SAILOR

ShipwreckBeach_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, ShipwreckBeachDigSpotsCallback

; The shipwreck beach's dig spots (constants/mystery_island_constants.asm): the square each one is dug
; from, the same as its bg_event below (keep the two in step), always a block's top-left square. A
; spot holding something today has its block swapped for the X block.
MACRO shipwreck_dig_spot
; \1 = spot number, \2, \3 = its square, the top-left square of its block (where the X is drawn)
	assert \2 % 2 == 0 && \3 % 2 == 0, "dig spot \1 is not on the top-left square of its block"
	DEF SHIPWRECK_SPOT_\1_X EQU \2
	DEF SHIPWRECK_SPOT_\1_Y EQU \3
ENDM
	shipwreck_dig_spot 1,  6, 10
	shipwreck_dig_spot 2, 18,  4
	shipwreck_dig_spot 3, 10, 14
	shipwreck_dig_spot 4, 24,  6
	shipwreck_dig_spot 5, 16, 16
	shipwreck_dig_spot 6, 22, 10
	shipwreck_dig_spot 7,  4, 14
	shipwreck_dig_spot 8, 26, 12
	shipwreck_dig_spot 9, 18, 12
	shipwreck_dig_spot 10, 20, 14

ShipwreckBeachDigSpotsCallback:
; Draw an X on each of this trip's spots not dug yet, however the map was loaded
FOR N, 1, SHIPWRECK_DIG_SPOTS + 1
	checkevent EVENT_SHIPWRECK_DIG_SPOT_{d:N}
	iffalse .no_x_{d:N}
	changeblock SHIPWRECK_SPOT_{d:N}_X, SHIPWRECK_SPOT_{d:N}_Y, SHIPWRECK_X_BLOCK
.no_x_{d:N}
ENDR
	endcallback

FOR N, 1, SHIPWRECK_DIG_SPOTS + 1
ShipwreckBeachDigSpot{d:N}Script:
	checkevent EVENT_SHIPWRECK_DIG_SPOT_{d:N}
	iffalse ShipwreckBeachNothingHereScript
	setval {d:N}
	scall ShipwreckBeachDigScript
	iffalse .done ; the bag was full, so the X stays
	clearevent EVENT_SHIPWRECK_DIG_SPOT_{d:N}
	changeblock SHIPWRECK_SPOT_{d:N}_X, SHIPWRECK_SPOT_{d:N}_Y, SHIPWRECK_SAND_BLOCK
	refreshmap
.done
	end
ENDR

ShipwreckBeachDigScript:
; A spot with something in it: a hidden item, rolled from the pools, found the way HiddenItemScript
; finds one. wScriptVar = TRUE if it went in the bag.
	opentext
	callasm RollShipwreckItem ; wScriptVar: the spot's number in, its item out
	getitemname STRING_BUFFER_3, USE_SCRIPT_VAR
	writetext ShipwreckBeachFoundItemText
	giveitem ITEM_FROM_MEM
	iffalse .bag_full
	specialsound
	itemnotify
	closetext
	setval TRUE
	end

.bag_full
	promptbutton
	writetext ShipwreckBeachNoSpaceText
	waitbutton
	closetext
	setval FALSE
	end

ShipwreckBeachNothingHereScript:
	end

ShipwreckBeachSailorScript:
	faceplayer
	opentext
if DEF(_DEBUG)
	writetext ShipwreckBeachDebugRerollText
	yesorno
	iffalse .ask
	callasm RollShipwreckBeach
	closetext
	reloadmap
	end

.ask
endc
	writetext ShipwreckBeachSailorAskText
	yesorno
	iffalse .Stay
	writetext ShipwreckBeachSailorSetSailText
	waitbutton
	closetext
	farscall MysteryIslandCrossingScript
	setmapscene CIANWOOD_CITY, SCENE_CIANWOODCITY_ARRIVE_FROM_ISLAND
	warpfacing UP, CIANWOOD_CITY, 29, 36
	end

.Stay:
	writetext ShipwreckBeachSailorStayText
	waitbutton
	closetext
	end

ShipwreckBeachFoundItemText:
	text_far _PlayerFoundItemText
	text_end

ShipwreckBeachNoSpaceText:
	text_far _ButNoSpaceText
	text_end

if DEF(_DEBUG)
ShipwreckBeachDebugRerollText:
	text "DEBUG: reroll the"
	line "dig spots?"
	done
endc

ShipwreckBeachSailorAskText:
	text "Ready to head back"
	line "to CIANWOOD?"

	para "Once you leave,"
	line "you may not be"

	para "able to come back"
	line "for a while."
	done

ShipwreckBeachSailorSetSailText:
	text "Then let's set"
	line "sail!"
	done

ShipwreckBeachSailorStayText:
	text "Take your time."
	line "I'll be here."
	done

ShipwreckBeach_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event  6, 10, BGEVENT_READ, ShipwreckBeachDigSpot1Script
	bg_event 18,  4, BGEVENT_READ, ShipwreckBeachDigSpot2Script
	bg_event 10, 14, BGEVENT_READ, ShipwreckBeachDigSpot3Script
	bg_event 24,  6, BGEVENT_READ, ShipwreckBeachDigSpot4Script
	bg_event 16, 16, BGEVENT_READ, ShipwreckBeachDigSpot5Script
	bg_event 22, 10, BGEVENT_READ, ShipwreckBeachDigSpot6Script
	bg_event  4, 14, BGEVENT_READ, ShipwreckBeachDigSpot7Script
	bg_event 26, 12, BGEVENT_READ, ShipwreckBeachDigSpot8Script
	bg_event 18, 12, BGEVENT_READ, ShipwreckBeachDigSpot9Script
	bg_event 20, 14, BGEVENT_READ, ShipwreckBeachDigSpot10Script

	def_object_events
	object_event 13, 17, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ShipwreckBeachSailorScript, -1
