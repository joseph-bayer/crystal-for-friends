	object_const_def
	const APRICORNFORESTOUTSIDE_SAILOR

ApricornForestOutside_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, ApricornForestOutsideShorePadCallback

ApricornForestOutsideShorePadCallback:
; A warp to the Clearing, unlocked once the Clearing has sent the player out here at least once.
	readmem wPrevMapGroup
	ifnotequal GROUP_APRICORN_FOREST_CLEARING, .check
	readmem wPrevMapNumber
	ifnotequal MAP_APRICORN_FOREST_CLEARING, .check
	setevent EVENT_APRICORN_FOREST_CLEARING_SHORTCUT
.check
	checkevent EVENT_APRICORN_FOREST_CLEARING_SHORTCUT
	iffalse .done
	changeblock 10, 8, $24 ; warp pad
.done
	endcallback

ApricornForestOutsideSailorScript:
	faceplayer
	opentext
	writetext ApricornForestOutsideSailorAskText
	yesorno
	iffalse .Stay
	writetext ApricornForestOutsideSailorSetSailText
	waitbutton
	closetext
	farscall MysteryIslandCrossingScript
	setmapscene CIANWOOD_CITY, SCENE_CIANWOODCITY_ARRIVE_FROM_ISLAND
	warpfacing UP, CIANWOOD_CITY, 29, 36
	end

.Stay:
	writetext ApricornForestOutsideSailorStayText
	waitbutton
	closetext
	end

ApricornForestOutsideSailorAskText:
	text "Ready to head back"
	line "to CIANWOOD?"

	para "Once you leave,"
	line "you may not be"

	para "able to come back"
	line "for a while."
	done

ApricornForestOutsideSailorSetSailText:
	text "Then let's set"
	line "sail!"
	done

ApricornForestOutsideSailorStayText:
	text "Take your time."
	line "I'll be here."
	done

ApricornForestOutside_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; The two-wide cave mouth, into the forest's bottom-right corner.
	warp_event 15,  5, APRICORN_FOREST, 1
	warp_event 16,  5, APRICORN_FOREST, 2
; The shore pad, block (5, 4). Only reachable once the callback above has drawn it.
	warp_event 10,  8, APRICORN_FOREST_CLEARING, 3

	def_coord_events

	def_bg_events

	def_object_events
	object_event 13,  9, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ApricornForestOutsideSailorScript, -1
