if DEF(_DEBUG)

; The bedroom's phone debug NPC (maps/PlayersHouse2F.asm). Routines are in engine/phone/phone.asm.

DebugPhoneScript::
; Debug tools for testing the phone (plans/phone_improvements_spec.md, 2.8).
	faceplayer
	opentext
	writetext DebugPhoneText
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .RegisterAll
	ifequal 2, .RingNow
	ifequal 3, .WaitingFlags
	ifequal 4, .Clock
	closetext
	end

.RegisterAll:
	callasm DebugPhoneRegisterAll
	writetext DebugPhoneRegisteredText
	waitbutton
	closetext
	end

.RingNow:
; Skips the call timer and its 50% roll; every other rule for who can call still applies.
	closetext
	callasm DebugPhonePickCaller
	ifequal 1, .NoService
	ifequal 2, .NobodyCanCall
	farsjump Script_ReceivePhoneCall

.NoService:
	opentext
	writetext DebugPhoneNoServiceText
	waitbutton
	closetext
	end

.NobodyCanCall:
	opentext
	writetext DebugPhoneNobodyText
	waitbutton
	closetext
	end

.WaitingFlags:
	loadmenu .WaitingMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .SetRematches
	ifequal 2, .SetItems
	ifequal 3, .ClearWaiting
	closetext
	end

.SetRematches:
	callasm DebugPhoneSetAllRematches
	sjump .FlagsDone

.SetItems:
	callasm DebugPhoneSetAllItems
	; Wade and Wilton's pickups also need to know what they found: the same odds as their calls.
	clearevent EVENT_WADE_HAS_BERRY
	clearevent EVENT_WADE_HAS_PSNCUREBERRY
	clearevent EVENT_WADE_HAS_PRZCUREBERRY
	clearevent EVENT_WADE_HAS_BITTER_BERRY
	random 4
	ifequal 0, .WadeBerry
	ifequal 1, .WadePsnCureBerry
	ifequal 2, .WadePrzCureBerry
	setevent EVENT_WADE_HAS_BITTER_BERRY
	sjump .WiltonBall

.WadeBerry:
	setevent EVENT_WADE_HAS_BERRY
	sjump .WiltonBall

.WadePsnCureBerry:
	setevent EVENT_WADE_HAS_PSNCUREBERRY
	sjump .WiltonBall

.WadePrzCureBerry:
	setevent EVENT_WADE_HAS_PRZCUREBERRY
.WiltonBall:
	clearevent EVENT_WILTON_HAS_ULTRA_BALL
	clearevent EVENT_WILTON_HAS_GREAT_BALL
	clearevent EVENT_WILTON_HAS_POKE_BALL
	random 5
	ifequal 0, .WiltonUltraBall
	random 3
	ifequal 0, .WiltonGreatBall
	setevent EVENT_WILTON_HAS_POKE_BALL
	sjump .FlagsDone

.WiltonUltraBall:
	setevent EVENT_WILTON_HAS_ULTRA_BALL
	sjump .FlagsDone

.WiltonGreatBall:
	setevent EVENT_WILTON_HAS_GREAT_BALL
	sjump .FlagsDone

.ClearWaiting:
	callasm DebugPhoneClearWaitingFlags
.FlagsDone:
	writetext DebugPhoneFlagsText
	waitbutton
	closetext
	end

.Clock:
	loadmenu .ClockMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .SetDay
	ifequal 2, .SetTime
	closetext
	end

.SetDay:
	special SetDayOfWeek
	closetext
	end

.SetTime:
	special RestartClock
	closetext
	end

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 15, 11
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 5 ; items
	db "REGISTER ALL@"
	db "RING NOW@"
	db "WAITING FLAGS@"
	db "CLOCK@"
	db "CANCEL@"

.WaitingMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 15, 9
	dw .WaitingMenuData
	db 1 ; default option

.WaitingMenuData:
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "ALL REMATCHES@"
	db "ALL ITEMS@"
	db "CLEAR ALL@"
	db "CANCEL@"

.ClockMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 15, 7
	dw .ClockMenuData
	db 1 ; default option

.ClockMenuData:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "SET DAY@"
	db "SET TIME@"
	db "CANCEL@"

DebugPhoneText:
	text "DEBUG: phone."
	done

DebugPhoneRegisteredText:
	text "Every contact is"
	line "registered."
	done

DebugPhoneNoServiceText:
	text "No phone service"
	line "here."
	done

DebugPhoneNobodyText:
	text "Nobody can call"
	line "right now."
	done

DebugPhoneFlagsText:
	text "Done."
	done

endc
