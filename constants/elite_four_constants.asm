; The Open League: once the player holds all 16 badges, every Elite Four run is a random
; lineup from a roster.

; Seats, in the order they are fought. wEliteFourLineup holds one E4_ROSTER_* id per seat.
	const_def
	const E4_SEAT_1        ; Will's room
	const E4_SEAT_2        ; Koga's room
	const E4_SEAT_3        ; Bruno's room
	const E4_SEAT_4        ; Karen's room
	const E4_SEAT_CHAMPION ; Lance's room
DEF NUM_E4_SEATS EQU const_value

; The roster (EliteFourRoster, data/events/elite_four_roster.asm). 1-based: a 0 in
; wEliteFourLineup is an empty seat, and an all-zero lineup is one not rolled yet.
	const_def 1
	const E4_ROSTER_WILL
	const E4_ROSTER_KOGA
	const E4_ROSTER_BRUNO
	const E4_ROSTER_KAREN
	const E4_ROSTER_LANCE
	const E4_ROSTER_FALKNER
	const E4_ROSTER_BUGSY
	const E4_ROSTER_WHITNEY
	const E4_ROSTER_MORTY
	const E4_ROSTER_CHUCK
	const E4_ROSTER_JASMINE
	const E4_ROSTER_PRYCE
	const E4_ROSTER_CLAIR
	const E4_ROSTER_BROCK
	const E4_ROSTER_MISTY
	const E4_ROSTER_LT_SURGE
	const E4_ROSTER_ERIKA
	const E4_ROSTER_JANINE
	const E4_ROSTER_SABRINA
	const E4_ROSTER_BLAINE
	const E4_ROSTER_BLUE
	const E4_ROSTER_LORELEI
	const E4_ROSTER_AGATHA
	const E4_ROSTER_GIOVANNI
	const E4_ROSTER_TORU
DEF NUM_E4_ROSTER EQU const_value - 1

; EliteFourRoster entry fields (the e4_roster macro)
rsreset
DEF E4ROSTER_NAME          rw ; for the debug lineup display
DEF E4ROSTER_CLASS         rb ; trainer class
DEF E4ROSTER_ID            rb ; trainer id within the class (data/trainers/parties.asm)
DEF E4ROSTER_NICKNAMES     rw ; a nickname list, or 0
DEF E4ROSTER_FLAGS         rb ; E4_ROSTER_* flags
DEF E4ROSTER_SPRITE        rb ; overworld SPRITE_*
DEF E4ROSTER_PALETTE       rb ; PAL_NPC_*, or 0 for the sprite's own
DEF E4ROSTER_LAYOUT        rb ; E4_LAYOUT_*, its home room
DEF E4ROSTER_PARTNER       rw ; partner Pokemon species, shown beside it in the room
DEF E4ROSTER_PARTNER_FORM  rb
DEF E4ROSTER_BEFORE_TEXT   rb 3 ; dba, before the battle
DEF E4ROSTER_BEATEN_TEXT   rb 3 ; dba, in battle when beaten
DEF E4ROSTER_AFTER_TEXT    rb 3 ; dba, after the battle, and when talked to again
DEF E4ROSTER_HALL_OF_FAME_TEXT rb 3 ; dba or 0: as champion, said in the Hall of Fame instead of the usual speech
DEF E4ROSTER_UNLOCK_EVENT  rw ; an EVENT_* that must be set before it can be rolled, or -1
DEF E4_ROSTER_ENTRY_LENGTH EQU _RS

; Home room layouts (EliteFourRoomLayouts), any of which an Elite Four room can take on. A layout
; is a tileset and blocks, so a new one can bring its own tiles and palette. Every
; layout keeps the rooms' contract: 5x9 blocks, doors at blocks (4, 2) and (4, 14) whose ids $2a
; (wall) and $16 (open door) mean the same in its tileset, and the same warps and object spots.
	const_def
	const E4_LAYOUT_WILL
	const E4_LAYOUT_KOGA
	const E4_LAYOUT_BRUNO
	const E4_LAYOUT_KAREN
DEF NUM_E4_LAYOUTS EQU const_value

; EliteFourRoster flags
	const_def
	const E4_ROSTER_RARE_F        ; only in a run that wins the rare roll (Youngster Joey)
	const E4_ROSTER_NO_CHAMPION_F ; never the champion (the Copycat)
DEF E4_ROSTER_RARE        EQU 1 << E4_ROSTER_RARE_F
DEF E4_ROSTER_NO_CHAMPION EQU 1 << E4_ROSTER_NO_CHAMPION_F

; A rare character is in one run in this many, in a random seat.
DEF E4_RARE_ODDS EQU 50

; Seat balance. A seat sets its holder's levels, DVs and EVs whatever their
; party data says: an Elite Four seat uses the first 5 Pokemon of the list, the champion all 6.
DEF E4_SEAT_TEAM_SIZE     EQU 5
DEF E4_CHAMPION_TEAM_SIZE EQU 6
; Base level per seat; each Pokemon adds its slot's offset (EliteFourSeatLevelOffsets)
DEF E4_SEAT_1_LEVEL   EQU 66
DEF E4_SEAT_2_LEVEL   EQU 67
DEF E4_SEAT_3_LEVEL   EQU 68
DEF E4_SEAT_4_LEVEL   EQU 69
DEF E4_CHAMPION_LEVEL EQU 70
; Every DV is raised to at least this (the champion's are all 15)
DEF E4_SEAT_MIN_DV     EQU 12
DEF E4_CHAMPION_MIN_DV EQU 15
; EVs, the same in every stat (there is no EV total cap)
DEF E4_SEAT_EVS      EQU MAX_EV * 3 / 4 ; seats 1-3
DEF E4_SEAT_4_EVS    EQU MAX_EV
DEF E4_CHAMPION_EVS  EQU MAX_EV
