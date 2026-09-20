	object_const_def
	const HIDDENGROVE_SAILOR
	const HIDDENGROVE_MEMBER_1
	const HIDDENGROVE_MEMBER_2
	const HIDDENGROVE_MEMBER_3
	const HIDDENGROVE_MEMBER_4

HiddenGrove_MapScripts:
	def_scene_scripts

	def_callbacks

HiddenGroveSailorScript:
	faceplayer
	opentext
	writetext HiddenGroveSailorAskText
	yesorno
	iffalse .Stay
	writetext HiddenGroveSailorSetSailText
	waitbutton
	closetext
	farscall MysteryIslandCrossingScript
	setmapscene CIANWOOD_CITY, SCENE_CIANWOODCITY_ARRIVE_FROM_ISLAND
	warpfacing UP, CIANWOOD_CITY, 29, 36
	end

.Stay:
	writetext HiddenGroveSailorStayText
	waitbutton
	closetext
	end

HiddenGroveSailorAskText:
	text "Ready to head back"
	line "to CIANWOOD?"

	para "Once you leave,"
	line "you may not be"

	para "able to come back"
	line "for a while."
	done

HiddenGroveSailorSetSailText:
	text "Then let's set"
	line "sail!"
	done

HiddenGroveSailorStayText:
	text "Take your time."
	line "I'll be here."
	done

HiddenGrove_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3, 10, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, HiddenGroveSailorScript, -1
; The population (data/wild/mon_populations.asm). The sprite id names the slot, not a species, and
; the event flag is -1: whether one stands here is decided by its slot. These tiles are the four
; corners of the island's land; the spawn areas will move them once placement exists.
	object_event  7,  7, SPRITE_OW_MON_1, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 22,  7, SPRITE_OW_MON_2, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event  7, 22, SPRITE_OW_MON_3, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 22, 22, SPRITE_OW_MON_4, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
