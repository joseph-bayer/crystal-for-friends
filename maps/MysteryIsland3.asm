	object_const_def
	const MYSTERYISLAND3_SAILOR

MysteryIsland3_MapScripts:
	def_scene_scripts

	def_callbacks

MysteryIsland3SailorScript:
	faceplayer
	opentext
	writetext MysteryIsland3SailorAskText
	yesorno
	iffalse .Stay
	writetext MysteryIsland3SailorSetSailText
	waitbutton
	closetext
	farscall MysteryIslandCrossingScript
	setmapscene CIANWOOD_CITY, SCENE_CIANWOODCITY_ARRIVE_FROM_ISLAND
	warpfacing UP, CIANWOOD_CITY, 29, 36
	end

.Stay:
	writetext MysteryIsland3SailorStayText
	waitbutton
	closetext
	end

MysteryIsland3SailorAskText:
	text "Ready to head back"
	line "to CIANWOOD?"

	para "Once you leave,"
	line "you may not be"

	para "able to come back"
	line "for a while."
	done

MysteryIsland3SailorSetSailText:
	text "Then let's set"
	line "sail!"
	done

MysteryIsland3SailorStayText:
	text "Take your time."
	line "I'll be here."
	done

MysteryIsland3_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
	object_event 10,  4, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, MysteryIsland3SailorScript, -1
