MACRO npctrade
; dialog set, requested mon, offered mon, nickname, dvs, item, OT ID, OT name, gender requested
	db \1
	dw \2, \3
	db \4, \5, \6
	dw \7
	shift
	dw \7
	db \8, \9
	db 0
ENDM

NPCTrades:
; entries correspond to NPCTRADE_* constants
	table_width NPCTRADE_STRUCT_LENGTH
	npctrade TRADE_DIALOGSET_COLLECTOR, ABRA,       MACHOP,     "MUSCLE@@@@@", $37, $66, GOLD_BERRY,   37460, "MIKE@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_COLLECTOR, BELLSPROUT, ONIX,       "ROCKY@@@@@@", $96, $66, HARD_STONE,   48926, "KYLE@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_HAPPY,     KRABBY,     VOLTORB,    "VOLTY@@@@@@", $98, $88, MAGNET,       29189, "TIM@@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_GIRL,      DODRIO,     MR__MIME,  	"DORIS@@@@@@", $77, $66, TWISTEDSPOON,  00283, "EMY@@@@@", TRADE_GENDER_FEMALE
	npctrade TRADE_DIALOGSET_NEWBIE,    XATU,       HAUNTER,    "PAUL@@@@@@@", $96, $86, MYSTERYBERRY, 15616, "CHRIS@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_GIRL,      CHANSEY,    AERODACTYL, "AEROY@@@@@@", $96, $66, GOLD_BERRY,   26491, "KIM@@@@@", TRADE_GENDER_EITHER
	npctrade TRADE_DIALOGSET_COLLECTOR, DUGTRIO,    MAGNETON,   "MAGGIE@@@@@", $96, $66, METAL_COAT,   50082, "FOREST@@", TRADE_GENDER_EITHER
if DEF(_DEBUG)
; Reaches the trade screen on demand, running the same path Mike and the others do. NPCTrade
; waives the already-traded gate and the species check for this entry, so it takes any party mon
; and can be repeated -- which makes the requested species below unused.
	npctrade TRADE_DIALOGSET_COLLECTOR, ABRA,       DRAGONITE,  "DEBUGMON@@@", $96, $66, LEFTOVERS,    00001, "DEBUG@@@", TRADE_GENDER_EITHER
endc
	assert_table_length NUM_NPC_TRADES
