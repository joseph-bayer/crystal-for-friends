	object_const_def
	const SILPHCO1F_RECEPTIONIST
	const SILPHCO1F_OFFICER
  const SILPHCO1F_CHARLIE

SilphCo1F_MapScripts:
	def_scene_scripts

	def_callbacks

SilphCoReceptionistScript:
	jumptextfaceplayer SilphCoReceptionistText

SilphCoOfficerScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_UP_GRADE
	iftrue .GotUpGrade
	writetext SilphCoOfficerText
	promptbutton
	verbosegiveitem UP_GRADE
	iffalse .NoRoom
	setevent EVENT_GOT_UP_GRADE
.GotUpGrade:
	writetext SilphCoOfficerText_GotUpGrade
	waitbutton
.NoRoom:
	closetext
	end

SilphCoCharlieScript:
  faceplayer
  opentext
  writetext SilphCoCharlieText_OfferMysteryGiftText
  waitbutton
  closetext
  domysterygift NPC_MYSTERY_GIFT_NPC_CHARLIE
  opentext
  writetext SilphCoCharlieText_ExitText
  waitbutton
  closetext
  end

SilphCoReceptionistText:
	text "Welcome. This is"
	line "SILPH CO.'s HEAD"
	cont "OFFICE BUILDING."
	done

SilphCoOfficerText:
	text "Only employees are"
	line "permitted to go"
	cont "upstairs."

	para "But since you came"
	line "such a long way,"

	para "have this neat"
	line "little souvenir."
	done

SilphCoOfficerText_GotUpGrade:
	text "It's SILPH CO.'s"
	line "latest product."

	para "It's not for sale"
	line "anywhere yet."
	done

SilphCoCharlieText_OfferMysteryGiftText:
  text "The mysteries of"
  line "MYSTERY GIFT..."

  para "Could you help me"
  line "with our research?"
	done

SilphCoCharlieText_ExitText:
  text "This data is"
  line "invaluable!"

  para "Please, come back"
  line "again tomorrow!"
  done

SilphCo1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFFRON_CITY, 7
	warp_event  3,  7, SAFFRON_CITY, 7

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  2, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCoReceptionistScript, -1
	object_event 13,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCoOfficerScript, -1
	object_event 11,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SilphCoCharlieScript, -1
