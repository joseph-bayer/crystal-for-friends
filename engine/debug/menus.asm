if DEF(_DEBUG)

; The three debug NPCs in the player's room (maps/PlayersHouse2F.asm), here for room in that bank.
; Each top menu leads to tools that are unchanged: the ones that expect the text box still open
; (Hidden Power, the lab items, the Open League, the animation viewer) are jumped to with it open;
; the ones that open their own close it first.

DebugStoryScript::
; The Scientist: ELM's lab (the beasts menu's FORCE SHINY covers the starters too), the beasts and
; Unown, the Open League, swarms, and the Rocket Base.
	faceplayer
	opentext
	writetext DebugStoryText
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .ElmsLab
	ifequal 2, .Beasts
	ifequal 3, .EliteFourLineup
	ifequal 4, .Swarms
	ifequal 5, .RocketBase
	closetext
	end

.ElmsLab:
	loadmenu .LabMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .ReplayLab
	ifequal 2, .SkipTheft
	closetext
	end

.ReplayLab:
	farsjump PlayersHouseDebugLabItems.ReplayLab

.SkipTheft:
	farsjump PlayersHouseDebugLabItems.SkipTheft

.Beasts:
	closetext
	farsjump PlayersHouseDebugBeastsScript

.EliteFourLineup:
	farsjump DebugEliteFourLineupScript

.Swarms:
	closetext
	farsjump DebugSwarmScript

.RocketBase:
	closetext
	farsjump PlayersHouseDebugWarperScript

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 11
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 6 ; items
	db "ELM'S LAB@"
	db "BEASTS@"
	db "E4 LINEUP@"
	db "SWARMS@"
	db "ROCKET BASE@"
	db "CANCEL@"

.LabMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 16, 7
	dw .LabMenuData
	db 1 ; default option

.LabMenuData:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "REPLAY LAB@"
	db "SKIP THE THEFT@"
	db "CANCEL@"

DebugBattlesScript::
; The Super Nerd: test battles and the trade screen.
	faceplayer
	opentext
	writetext DebugBattlesText
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .HPBattles
	ifequal 2, .BrockPic
	ifequal 3, .Trade
	closetext
	end

.HPBattles:
	farsjump PlayersHouseDebugHPBattlesScript

.BrockPic:
	closetext
	farsjump PlayersHouseDebugTrainerPicScript

.Trade:
	closetext
	farsjump PlayersHouseDebugTraderScript

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 9
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "HP BATTLES@"
	db "BROCK PIC@"
	db "TRADE@"
	db "CANCEL@"

DebugToolsScript::
; The Youngster: the phone, Hidden Power, the HM party and the animation viewer.
	faceplayer
	opentext
	writetext DebugToolsText
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Phone
	ifequal 2, .HPTools
	ifequal 3, .LearnersParty
	ifequal 4, .AnimViewer
	closetext
	end

.Phone:
	closetext
	farsjump DebugPhoneScript

.HPTools:
	farsjump PlayersHouseDebugHPToolsScript

.LearnersParty:
	farsjump PlayersHouseDebugLabItems.LearnersParty

.AnimViewer:
	farsjump DebugAnimViewerScript

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 16, 11
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 5 ; items
	db "PHONE@"
	db "HP TOOLS@"
	db "LEARNERS PARTY@"
	db "ANIM VIEWER@"
	db "CANCEL@"

DebugStoryText:
	text "DEBUG: story."
	done

DebugBattlesText:
	text "DEBUG: battles."
	done

DebugToolsText:
	text "DEBUG: tools."
	done

endc
