	object_const_def
	const SILVERCAVEOUTSIDE_WILD_MON_1
	const SILVERCAVEOUTSIDE_WILD_MON_2
	const SILVERCAVEOUTSIDE_WILD_MON_3
	const SILVERCAVEOUTSIDE_WILD_MON_4

SilverCaveOutside_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, SilverCaveOutsideFlypointCallback

SilverCaveOutsideFlypointCallback:
	setflag ENGINE_FLYPOINT_SILVER_CAVE
	endcallback

MtSilverPokecenterSign:
	jumpstd PokecenterSignScript

MtSilverSign:
	jumptext MtSilverSignText

SilverCaveOutsideHiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_SILVER_CAVE_OUTSIDE_HIDDEN_FULL_RESTORE

MtSilverSignText:
	text "MT.SILVER"
	done

SilverCaveOutside_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23, 19, SILVER_CAVE_POKECENTER_1F, 1
	warp_event 18, 11, SILVER_CAVE_ROOM_1, 1

	def_coord_events

	def_bg_events
	bg_event 24, 19, BGEVENT_READ, MtSilverPokecenterSign
	bg_event 17, 13, BGEVENT_READ, MtSilverSign
	bg_event  9, 25, BGEVENT_ITEM, SilverCaveOutsideHiddenFullRestore

	def_object_events
; Wandering Pokemon. The species, form, shininess, level, DVs and held item are all rolled by
; RollOverworldMons when the map is entered; the sprite id only names which rolled slot this is.
; Palette 0 so they take the mon's own colors. Slots run static, then grass, then water -- the
; order RollOverworldMons fills them in -- so these have to stay numbered that way.
; The event flag is -1: whether one is standing here is decided by whether its slot holds a
; rolled mon, not by a flag.
; one on the water.
	object_event 24, 24, SPRITE_OW_MON_1, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 17, 18, SPRITE_OW_MON_2, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 19, 21, SPRITE_OW_MON_3, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 17, 27, SPRITE_OW_MON_4, SPRITEMOVEDATA_SWIM_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
