	object_const_def
	const ROUTE10NORTH_ZAPDOS
	const ROUTE10NORTH_WILD_MON_1

Route10North_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, Route10NorthZapdosCallback

Route10NorthZapdosCallback:
	checkevent EVENT_FOUGHT_ZAPDOS
	iftrue .NoAppear
	readvar VAR_BADGES
	ifequal NUM_BADGES, .Appear
.NoAppear:
	disappear ROUTE10NORTH_ZAPDOS
	endcallback

.Appear:
	appear ROUTE10NORTH_ZAPDOS
	endcallback

Route10NorthZapdosScript:
	faceplayer
	opentext
	writetext Route10NorthZapdosText
	cry ZAPDOS
	pause 15
	closetext
	setevent EVENT_FOUGHT_ZAPDOS
	loadvar VAR_BATTLETYPE, BATTLETYPE_FORCEITEM
	loadwildmon ZAPDOS, 60
	startbattle
	disappear ROUTE10NORTH_ZAPDOS
	reloadmapafterbattle
	special CheckBattleCaughtResult
	iffalse .NotCaught
	setevent EVENT_CAUGHT_ZAPDOS
.NotCaught:
	end

PowerPlantSign:
	jumptext PowerPlantSignText

Route10PokecenterSign:
	jumpstd PokecenterSignScript

Route10NorthZapdosText:
	text "Gyaoo!"
	done

PowerPlantSignText:
	text "KANTO POWER PLANT"
	done

Route10North_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 11,  1, ROUTE_10_POKECENTER_1F, 1
	warp_event  3,  9, POWER_PLANT, 1

	def_coord_events

	def_bg_events
	bg_event  5, 11, BGEVENT_READ, PowerPlantSign
	bg_event 12,  1, BGEVENT_READ, Route10PokecenterSign

	def_object_events
; Wandering Pokemon. The species, form, shininess, level, DVs and held item are all rolled by
; RollOverworldMons when the map is entered; the sprite id only names which rolled slot this is.
; Palette 0 so they take the mon's own colors. Slots run static, then grass, then water -- the
; order RollOverworldMons fills them in -- so these have to stay numbered that way.
; The event flag is -1: whether one is standing here is decided by whether its slot holds a
; rolled mon, not by a flag.
	object_event  4, 11, SPRITE_OW_MON_1, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route10NorthZapdosScript, EVENT_ROUTE_10_NORTH_ZAPDOS
	object_event 11, 10, SPRITE_OW_MON_2, SPRITEMOVEDATA_WANDER_NOCLIP, 2, 2, -1, -1, 0, OBJECTTYPE_WILDMON, 0, ObjectEvent, -1
