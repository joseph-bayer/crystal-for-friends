		object_const_def
	const NEWBARKTOWN_TEACHER
	const NEWBARKTOWN_FISHER
	const NEWBARKTOWN_RIVAL
	; const NEWBARKTOWN_POKEBALL_VENDOR
	; const NEWBARKTOWN_GIFT_TESTER
	; const NEWBARKTOWN_ODD_EGG_VENDOR

NewBarkTown_MapScripts:
	def_scene_scripts
	scene_script NewBarkTownNoop1Scene, SCENE_NEWBARKTOWN_TEACHER_STOPS_YOU
	scene_script NewBarkTownNoop2Scene, SCENE_NEWBARKTOWN_NOOP

	def_callbacks
	callback MAPCALLBACK_NEWMAP, NewBarkTownFlypointCallback

NewBarkTownNoop1Scene:
	end

NewBarkTownNoop2Scene:
	end

NewBarkTownFlypointCallback:
	setflag ENGINE_FLYPOINT_NEW_BARK
	clearevent EVENT_FIRST_TIME_BANKING_WITH_MOM
	endcallback

NewBarkTown_TeacherStopsYouScene1:
	playmusic MUSIC_MOM
	turnobject NEWBARKTOWN_TEACHER, LEFT
	opentext
	writetext Text_WaitPlayer
	waitbutton
	closetext
	turnobject PLAYER, RIGHT
	applymovement NEWBARKTOWN_TEACHER, NewBarkTown_TeacherRunsToYouMovement1
	opentext
	writetext Text_WhatDoYouThinkYoureDoing
	waitbutton
	closetext
	follow NEWBARKTOWN_TEACHER, PLAYER
	applymovement NEWBARKTOWN_TEACHER, NewBarkTown_TeacherBringsYouBackMovement1
	stopfollow
	opentext
	writetext Text_ItsDangerousToGoAlone
	waitbutton
	closetext
	special RestartMapMusic
	end

NewBarkTown_TeacherStopsYouScene2:
	playmusic MUSIC_MOM
	turnobject NEWBARKTOWN_TEACHER, LEFT
	opentext
	writetext Text_WaitPlayer
	waitbutton
	closetext
	turnobject PLAYER, RIGHT
	applymovement NEWBARKTOWN_TEACHER, NewBarkTown_TeacherRunsToYouMovement2
	turnobject PLAYER, UP
	opentext
	writetext Text_WhatDoYouThinkYoureDoing
	waitbutton
	closetext
	follow NEWBARKTOWN_TEACHER, PLAYER
	applymovement NEWBARKTOWN_TEACHER, NewBarkTown_TeacherBringsYouBackMovement2
	stopfollow
	opentext
	writetext Text_ItsDangerousToGoAlone
	waitbutton
	closetext
	special RestartMapMusic
	end

NewBarkTownTeacherScript:
	faceplayer
	opentext
	checkevent EVENT_TALKED_TO_MOM_AFTER_MYSTERY_EGG_QUEST
	iftrue .CallMom
	checkevent EVENT_GAVE_MYSTERY_EGG_TO_ELM
	iftrue .TellMomYoureLeaving
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue .MonIsAdorable
	writetext Text_GearIsImpressive
	waitbutton
	closetext
	end

.MonIsAdorable:
	writetext Text_YourMonIsAdorable
	waitbutton
	closetext
	end

.TellMomYoureLeaving:
	writetext Text_TellMomIfLeaving
	waitbutton
	closetext
	end

.CallMom:
	writetext Text_CallMomOnGear
	waitbutton
	closetext
	end

NewBarkTownFisherScript:
	jumptextfaceplayer Text_ElmDiscoveredNewMon

NewBarkTownRivalScript:
	opentext
	writetext NewBarkTownRivalText1
	waitbutton
	closetext
	turnobject NEWBARKTOWN_RIVAL, LEFT
	opentext
	writetext NewBarkTownRivalText2
	waitbutton
	closetext
	follow PLAYER, NEWBARKTOWN_RIVAL
	applymovement PLAYER, NewBarkTown_RivalPushesYouAwayMovement
	stopfollow
	pause 5
	turnobject NEWBARKTOWN_RIVAL, DOWN
	pause 5
	playsound SFX_TACKLE
	applymovement PLAYER, NewBarkTown_RivalShovesYouOutMovement
	applymovement NEWBARKTOWN_RIVAL, NewBarkTown_RivalReturnsToTheShadowsMovement
	end

; DEBUG: Uncomment here for new NPC to give you pokeballs of each type
; NewBarkTownPokeballVendorScript:
; 	faceplayer
; 	opentext
; 	checkevent EVENT_GOT_STARTER_POKEBALLS
; 	iftrue .AlreadyGotPokeballs
; 	writetext PokeballVendorIntroText
; 	yesorno
; 	iffalse .Refused
; 	writetext PokeballVendorGivingText
; 	waitbutton
	
; 	; Give 20 of each pokeball type
; 	verbosegiveitem MASTER_BALL, 20
; 	verbosegiveitem ULTRA_BALL, 20
; 	verbosegiveitem GREAT_BALL, 20
; 	verbosegiveitem POKE_BALL, 20
; 	verbosegiveitem HEAVY_BALL, 20
; 	verbosegiveitem LEVEL_BALL, 20
; 	verbosegiveitem LURE_BALL, 20
; 	verbosegiveitem FAST_BALL, 20
; 	verbosegiveitem FRIEND_BALL, 20
; 	verbosegiveitem MOON_BALL, 20
; 	verbosegiveitem LOVE_BALL, 20
; 	verbosegiveitem PARK_BALL, 20
	
; 	setevent EVENT_GOT_STARTER_POKEBALLS
; 	writetext PokeballVendorFinishedText
; 	waitbutton
; 	closetext
; 	end

; .AlreadyGotPokeballs:
; 	writetext PokeballVendorAlreadyGaveText
; 	waitbutton
; 	closetext
; 	end

; .Refused:
; 	writetext PokeballVendorRefusedText
; 	waitbutton
; 	closetext
; 	end
; END DEBUG: Uncomment here for new NPC to give you pokeballs of each type

; DEBUG: Uncomment here for new NPC to give you a test gift pokemon
; NewBarkTownGiftTesterScript:
; 	faceplayer
; 	opentext
; 	checkevent EVENT_GOT_TEST_POKEMON
; 	iftrue .AlreadyGotPokemon
; 	writetext GiftTesterIntroText
; 	yesorno
; 	iffalse .Refused
; 	writetext GiftTesterGivingText
; 	waitbutton
	
; 	; This uses the extended givepoke format to force gift behavior
; 	givepoke PIKACHU, 10, MASTER_BALL
	
; 	setevent EVENT_GOT_TEST_POKEMON
; 	writetext GiftTesterGaveText
; 	waitbutton
; 	closetext
; 	end

; .AlreadyGotPokemon:
; 	writetext GiftTesterAlreadyGaveText
; 	waitbutton
; 	closetext
; 	end

; .Refused:
; 	writetext GiftTesterRefusedText
; 	waitbutton
; 	closetext
; 	end
; END DEBUG: Uncomment here for new NPC to give you a test gift pokemon

; DEBUG: Uncomment here for new NPC to give you an Odd Egg
; NewBarkTownOddEggVendorScript:
; 	faceplayer
; 	opentext
; 	checkevent EVENT_GOT_ODD_EGG
; 	iftrue .AlreadyGotOddEgg
; 	writetext OddEggVendorIntroText
; 	yesorno
; 	iffalse .Refused
; 	readvar VAR_PARTYCOUNT
; 	ifequal PARTY_LENGTH, .PartyFull
; 	writetext OddEggVendorGivingText
; 	playsound SFX_KEY_ITEM
; 	waitsfx
; 	special GiveOddEgg
; 	writetext OddEggVendorGotOddEggText
; 	playsound SFX_GET_EGG
; 	waitsfx
; 	writetext OddEggVendorDescribeOddEggText
; 	waitbutton
; 	closetext
; 	setevent EVENT_GOT_ODD_EGG
; 	end

; .PartyFull:
; 	writetext OddEggVendorPartyFullText
; 	waitbutton
; 	closetext
; 	end

; .AlreadyGotOddEgg:
; 	writetext OddEggVendorAlreadyGaveText
; 	waitbutton
; 	closetext
; 	end

; .Refused:
; 	writetext OddEggVendorRefusedText
; 	waitbutton
; 	closetext
; 	end
; END DEBUG: Uncomment here for new NPC to give you an Odd Egg

NewBarkTownSign:
	jumptext NewBarkTownSignText

NewBarkTownPlayersHouseSign:
	jumptext NewBarkTownPlayersHouseSignText

NewBarkTownElmsLabSign:
	jumptext NewBarkTownElmsLabSignText

NewBarkTownElmsHouseSign:
	jumptext NewBarkTownElmsHouseSignText

NewBarkTown_TeacherRunsToYouMovement1:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step_end

NewBarkTown_TeacherRunsToYouMovement2:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	turn_head DOWN
	step_end

NewBarkTown_TeacherBringsYouBackMovement1:
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head LEFT
	step_end

NewBarkTown_TeacherBringsYouBackMovement2:
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head LEFT
	step_end

NewBarkTown_RivalPushesYouAwayMovement:
	turn_head UP
	step DOWN
	step_end

NewBarkTown_RivalShovesYouOutMovement:
	turn_head UP
	fix_facing
	jump_step DOWN
	remove_fixed_facing
	step_end

NewBarkTown_RivalReturnsToTheShadowsMovement:
	step RIGHT
	step_end

Text_GearIsImpressive:
	text "Wow, your #GEAR"
	line "is impressive!"

	para "Did your mom get"
	line "it for you?"
	done

; DEBUG: Uncomment here for new NPC to give you pokeballs of each type
; PokeballVendorIntroText:
; 	text "Hello there, young"
; 	line "trainer!"
	
; 	para "I'm the POKEBALL"
; 	line "VENDOR. I've got a"
; 	cont "special starter kit"
; 	cont "for new trainers!"
	
; 	para "Would you like 20"
; 	line "of each type of"
; 	cont "POKEBALL?"
; 	done

; PokeballVendorGivingText:
; 	text "Excellent! Here's"
; 	line "your starter"
; 	cont "POKEBALL kit!"
; 	done

; PokeballVendorFinishedText:
; 	text "There you go!"
; 	line "20 of each type"
; 	cont "of POKEBALL!"
	
; 	para "Use them wisely"
; 	line "to catch lots of"
; 	cont "#MON!"
; 	done

; PokeballVendorAlreadyGaveText:
; 	text "You already got"
; 	line "your starter"
; 	cont "POKEBALL kit!"
	
; 	para "Good luck on your"
; 	line "#MON journey!"
; 	done

; PokeballVendorRefusedText:
; 	text "No problem! Come"
; 	line "back if you change"
; 	cont "your mind!"
; 	done
; END DEBUG: Uncomment here for new NPC to give you pokeballs of each type

; DEBUG: Uncomment here for new NPC to give you a test gift pokemon
; GiftTesterIntroText:
; 	text "Hey there! I'm"
; 	line "testing the gift"
; 	cont "#MON system!"
	
; 	para "Want a free"
; 	line "PIKACHU to test"
; 	cont "pokeball storage?"
; 	done

; GiftTesterGivingText:
; 	text "Great! Here's your"
; 	line "test PIKACHU!"
; 	done

; GiftTesterGaveText:
; 	text "Check your stats"
; 	line "screen to see what"
; 	cont "ball type it shows!"
	
; 	para "Gift #MON should"
; 	line "show ball type 3!"
; 	done

; GiftTesterAlreadyGaveText:
; 	text "You already got"
; 	line "your test PIKACHU!"
	
; 	para "Check its stats to"
; 	line "see the ball type!"
; 	done

; GiftTesterRefusedText:
; 	text "No worries! Come"
; 	line "back if you want"
; 	cont "to test later!"
; 	done

; GiftTesterOTName:
; 	db "TESTER@"

; GiftTesterPokemonName:
; 	db "TESTPIKA@"
; END DEBUG: Uncomment here for new NPC to give you a test gift pokemon

; DEBUG: Uncomment here for new NPC to give you an Odd Egg
; OddEggVendorIntroText:
; 	text "Hello there, young"
; 	line "trainer!"
	
; 	para "I'm an EGG"
; 	line "researcher who has"
; 	cont "been studying rare"
; 	cont "and unusual EGGS."
	
; 	para "I found this very"
; 	line "peculiar EGG that"
; 	cont "seems different"
; 	cont "from normal ones."
	
; 	para "Would you like to"
; 	line "take care of this"
; 	cont "ODD EGG for me?"
; 	done

; OddEggVendorGivingText:
; 	text "Wonderful! Please"
; 	line "take good care"
; 	cont "of it!"
; 	done

; OddEggVendorGotOddEggText:
; 	text "<PLAYER> received"
; 	line "ODD EGG!"
; 	done

; OddEggVendorDescribeOddEggText:
; 	text "That EGG is very"
; 	line "special indeed."
	
; 	para "I found it while"
; 	line "researching rare"
; 	cont "#MON breeding."
	
; 	para "The #MON inside"
; 	line "might be quite"
; 	cont "unique!"
	
; 	para "Keep it with you"
; 	line "and walk around."
; 	cont "It should hatch"
; 	cont "eventually!"
; 	done

; OddEggVendorPartyFullText:
; 	text "Oh my! Your party"
; 	line "is full!"
	
; 	para "Please make some"
; 	line "room and come"
; 	cont "back to me!"
; 	done

; OddEggVendorAlreadyGaveText:
; 	text "How is that ODD"
; 	line "EGG doing?"
	
; 	para "I hope it hatches"
; 	line "into something"
; 	cont "wonderful for you!"
; 	done

; OddEggVendorRefusedText:
; 	text "Oh, that's a shame."
; 	line "If you change your"
; 	cont "mind, please come"
; 	cont "back anytime!"
; 	done
; END DEBUG: Uncomment here for new NPC to give you an Odd Egg

Text_WaitPlayer:
	text "Wait, <PLAY_G>!"
	done

Text_WhatDoYouThinkYoureDoing:
	text "What do you think"
	line "you're doing?"
	done

Text_ItsDangerousToGoAlone:
	text "It's dangerous to"
	line "go out without a"
	cont "#MON!"

	para "Wild #MON"
	line "jump out of the"

	para "grass on the way"
	line "to the next town."
	done

Text_YourMonIsAdorable:
	text "Oh! Your #MON"
	line "is adorable!"
	cont "I wish I had one!"
	done

Text_TellMomIfLeaving:
	text "Hi, <PLAY_G>!"
	line "Leaving again?"

	para "You should tell"
	line "your mom if you"
	cont "are leaving."
	done

Text_CallMomOnGear:
	text "Call your mom on"
	line "your #GEAR to"

	para "let her know how"
	line "you're doing."
	done

Text_ElmDiscoveredNewMon:
	text "Yo, <PLAYER>!"

	para "I hear PROF.ELM"
	line "discovered some"
	cont "new #MON."
	done

NewBarkTownRivalText1:
	text "<……>"

	para "So this is the"
	line "famous ELM #MON"
	cont "LAB…"
	done

NewBarkTownRivalText2:
	text "…What are you"
	line "staring at?"
	done

NewBarkTownSignText:
	text "NEW BARK TOWN"

	para "The Town Where the"
	line "Winds of a New"
	cont "Beginning Blow"
	done

NewBarkTownPlayersHouseSignText:
	text "<PLAYER>'s House"
	done

NewBarkTownElmsLabSignText:
	text "ELM #MON LAB"
	done

NewBarkTownElmsHouseSignText:
	text "ELM'S HOUSE"
	done

NewBarkTown_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  6,  3, ELMS_LAB, 1
	warp_event 13,  5, PLAYERS_HOUSE_1F, 1
	warp_event  3, 11, PLAYERS_NEIGHBORS_HOUSE, 1
	warp_event 11, 13, ELMS_HOUSE, 1

	def_coord_events
	coord_event  1,  8, SCENE_NEWBARKTOWN_TEACHER_STOPS_YOU, NewBarkTown_TeacherStopsYouScene1
	coord_event  1,  9, SCENE_NEWBARKTOWN_TEACHER_STOPS_YOU, NewBarkTown_TeacherStopsYouScene2

	def_bg_events
	bg_event  8,  8, BGEVENT_READ, NewBarkTownSign
	bg_event 11,  5, BGEVENT_READ, NewBarkTownPlayersHouseSign
	bg_event  3,  3, BGEVENT_READ, NewBarkTownElmsLabSign
	bg_event  9, 13, BGEVENT_READ, NewBarkTownElmsHouseSign

	def_object_events
	object_event  6,  8, SPRITE_TEACHER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, NewBarkTownTeacherScript, -1
	object_event 12,  9, SPRITE_FISHER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, NewBarkTownFisherScript, -1
	object_event  3,  2, SPRITE_RIVAL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, NewBarkTownRivalScript, EVENT_RIVAL_NEW_BARK_TOWN
	; object_event  9,  6, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, NewBarkTownPokeballVendorScript, -1
	; object_event  5, 13, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, NewBarkTownGiftTesterScript, -1
	; object_event  2, 10, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, NewBarkTownOddEggVendorScript, -1
