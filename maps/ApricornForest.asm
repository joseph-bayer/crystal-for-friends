	object_const_def
	const APRICORNFOREST_WILD_MON_1
	const APRICORNFOREST_WILD_MON_2
	const APRICORNFOREST_WILD_MON_3
	const APRICORNFOREST_WILD_MON_4
	const APRICORNFOREST_FRUIT_TREE_RED
	const APRICORNFOREST_FRUIT_TREE_BLU
	const APRICORNFOREST_FRUIT_TREE_BLK
	const APRICORNFOREST_FRUIT_TREE_WHT
	const APRICORNFOREST_FRUIT_TREE_PNK
	const APRICORNFOREST_FRUIT_TREE_GRN
	const APRICORNFOREST_FRUIT_TREE_YLW
	const APRICORNFOREST_NUGGET_1
	const APRICORNFOREST_BERRY
	const APRICORNFOREST_HP_UP

ApricornForest_MapScripts:
	def_scene_scripts

	def_callbacks

ApricornForestFruitTreeRed:
	fruittree FRUITTREE_APRICORN_FOREST_RED

ApricornForestFruitTreeBlu:
	fruittree FRUITTREE_APRICORN_FOREST_BLU

ApricornForestFruitTreeBlk:
	fruittree FRUITTREE_APRICORN_FOREST_BLK

ApricornForestFruitTreeWht:
	fruittree FRUITTREE_APRICORN_FOREST_WHT

ApricornForestFruitTreePnk:
	fruittree FRUITTREE_APRICORN_FOREST_PNK

ApricornForestFruitTreeGrn:
	fruittree FRUITTREE_APRICORN_FOREST_GRN

ApricornForestFruitTreeYlw:
	fruittree FRUITTREE_APRICORN_FOREST_YLW

ApricornForestNugget1:
	itemball NUGGET

ApricornForestBerry:
	itemball BERRY

ApricornForestHPUp:
	itemball HP_UP

ApricornForest_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Right-edge exit in the bottom-right corner, back out to the cave mouth.
	warp_event 13, 53, APRICORN_FOREST_OUTSIDE, 1
	warp_event 12, 53, APRICORN_FOREST_OUTSIDE, 2
; The old south-gate carpet, into the clearing.
	warp_event 13,  5, APRICORN_FOREST_CLEARING, 1
	warp_event 14,  5, APRICORN_FOREST_CLEARING, 2

	def_coord_events

	def_bg_events

	def_object_events
; Wandering wild mon (data/wild/overworld_mons.asm), in the opened bottom-right corner.
	object_event 11, 21, SPRITE_OW_MON_1, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 17,  9, SPRITE_OW_MON_2, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event 25, 23, SPRITE_OW_MON_3, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
	object_event  9, 46, SPRITE_OW_MON_4, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
; Parked on the open ground in the bottom-right corner, all of them, to be placed properly.
	object_event  4, 48, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ApricornForestFruitTreeRed, -1
	object_event 11, 39, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ApricornForestFruitTreeBlu, -1
	object_event  3, 23, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ApricornForestFruitTreeBlk, -1
	object_event 10,  8, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ApricornForestFruitTreeWht, -1
	object_event  7, 26, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ApricornForestFruitTreePnk, -1
	object_event 22, 36, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ApricornForestFruitTreeGrn, -1
	object_event 11, 44, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ApricornForestFruitTreeYlw, -1
	object_event  5, 46, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ApricornForestNugget1, EVENT_APRICORN_FOREST_NUGGET_1
	object_event 11, 29, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ApricornForestBerry, EVENT_APRICORN_FOREST_BERRY
	object_event  8, 18, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ApricornForestHPUp, EVENT_APRICORN_FOREST_HP_UP
