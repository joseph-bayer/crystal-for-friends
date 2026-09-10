	object_const_def
	const SILVERCAVEROOM1_POKE_BALL1
	const SILVERCAVEROOM1_POKE_BALL2
	const SILVERCAVEROOM1_POKE_BALL3
	const SILVERCAVEROOM1_POKE_BALL4
	const SILVERCAVEROOM1_WILD_MON_1
	const SILVERCAVEROOM1_WILD_MON_2
	const SILVERCAVEROOM1_WILD_MON_3
	const SILVERCAVEROOM1_WILD_MON_4

SilverCaveRoom1_MapScripts:
	def_scene_scripts

	def_callbacks

SilverCaveRoom1MaxElixer:
	itemball MAX_ELIXER

SilverCaveRoom1Protein:
	itemball PROTEIN

SilverCaveRoom1EscapeRope:
	itemball ESCAPE_ROPE

SilverCaveRoom1UltraBall:
	itemball ULTRA_BALL

SilverCaveRoom1HiddenDireHit:
	hiddenitem DIRE_HIT, EVENT_SILVER_CAVE_ROOM_1_HIDDEN_DIRE_HIT

SilverCaveRoom1HiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_SILVER_CAVE_ROOM_1_HIDDEN_ULTRA_BALL

SilverCaveRoom1_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 33, SILVER_CAVE_OUTSIDE, 2
	warp_event 15,  1, SILVER_CAVE_ROOM_2, 1

	def_coord_events

	def_bg_events
	bg_event 16, 23, BGEVENT_ITEM, SilverCaveRoom1HiddenDireHit
	bg_event 17, 12, BGEVENT_ITEM, SilverCaveRoom1HiddenUltraBall

	def_object_events
	object_event  4,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilverCaveRoom1MaxElixer, EVENT_SILVER_CAVE_ROOM_1_MAX_ELIXER
	object_event 15, 29, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilverCaveRoom1Protein, EVENT_SILVER_CAVE_ROOM_1_PROTEIN
	object_event  5, 30, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilverCaveRoom1EscapeRope, EVENT_SILVER_CAVE_ROOM_1_ESCAPE_ROPE
	object_event  7, 18, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilverCaveRoom1UltraBall, EVENT_SILVER_CAVE_ROOM_1_ULTRA_BALL
; Wandering Pokemon. The species, form, shininess, level, DVs and held item are all rolled by
; RollOverworldMons when the map is entered; the sprite id only names which rolled slot this is.
; Palette 0 so they take the mon's own colors. Slots run static, then grass, then water -- the
; order RollOverworldMons fills them in -- so these have to stay numbered that way.
; The event flag is -1: whether one is standing here is decided by whether its slot
; holds a rolled mon, not by a flag.
	object_event 16,  9, SPRITE_OW_MON_1, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event  8,  2, SPRITE_OW_MON_2, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event  4, 15, SPRITE_OW_MON_3, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 12, 29, SPRITE_OW_MON_4, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
