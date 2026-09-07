OverworldMonObjects:
; What each map's SPRITE_OW_MON_* objects stand for.
;
; Vanilla had 35 hand-drawn overworld Pokemon sprites, so any other species standing in a room
; borrowed the nearest one available -- Blackthorn's Dratini was an Ekans, Mr. Fuji's Psyduck a
; Rhydon, Route 39's Miltank a herd of Tauros. CSE draws overworld Pokemon from their party menu
; icons, which exist for all 251 species and every cosmetic form, so the artwork was never the
; problem. Only the one-byte sprite id was, and SPRITE_OW_MON_* replaces it with a slot number.
;
; Entries are positional: the first ow_mon under a map fills SPRITE_OW_MON_1, the second _2, and
; so on. Objects may share a slot -- the four Route 39 Miltank and the six Rocket Base Electrode
; each declare one entry between them.
;
; Read by GetOverworldMonSlot. The form byte takes a cosmetic form, SHINY_MASK, or both.

	ow_mon_map BLACKTHORN_DRAGON_SPEECH_HOUSE
	ow_mon DRATINI,    PLAIN_FORM

	ow_mon_map CELADON_CITY
	ow_mon POLIWRATH,  PLAIN_FORM

	ow_mon_map CELADON_MANSION_1F
	ow_mon MEOWTH,     PLAIN_FORM
	ow_mon NIDORAN_F,  PLAIN_FORM

	ow_mon_map CERULEAN_CITY
	ow_mon SLOWBRO,    PLAIN_FORM

	ow_mon_map CERULEAN_TRADE_SPEECH_HOUSE
	ow_mon KANGASKHAN, PLAIN_FORM

	ow_mon_map CHARCOAL_KILN
	ow_mon FARFETCH_D, PLAIN_FORM

	ow_mon_map COPYCATS_HOUSE_1F
	ow_mon BLISSEY,    PLAIN_FORM

	ow_mon_map COPYCATS_HOUSE_2F
	ow_mon DODRIO,     PLAIN_FORM

	ow_mon_map GOLDENROD_DEPT_STORE_B1F
	ow_mon MACHOKE,    PLAIN_FORM

	ow_mon_map ILEX_FOREST
	ow_mon FARFETCH_D, PLAIN_FORM

	ow_mon_map INDIGO_PLATEAU_POKECENTER_1F
	ow_mon ABRA,       PLAIN_FORM

; The Red Gyarados. The battle has always been shiny -- BATTLETYPE_FORCESHINY sets SHINY_MASK in
; wEnemyMonForm -- but until now the thing standing in the lake could not be told so, and was
; painted with the shared overworld red instead.
	ow_mon_map LAKE_OF_RAGE
	ow_mon GYARADOS,   PLAIN_FORM | SHINY_MASK

	ow_mon_map MAHOGANY_MART_1F
	ow_mon DRAGONITE,  PLAIN_FORM

	ow_mon_map MR_FUJIS_HOUSE
	ow_mon PSYDUCK,    PLAIN_FORM
	ow_mon NIDORINO,   PLAIN_FORM
	ow_mon PIDGEY,     PLAIN_FORM

	ow_mon_map NATIONAL_PARK
	ow_mon PERSIAN,    PLAIN_FORM

	ow_mon_map OLIVINE_LIGHTHOUSE_6F
	ow_mon AMPHAROS,   PLAIN_FORM ; Amphy

	ow_mon_map PEWTER_NIDORAN_SPEECH_HOUSE
	ow_mon NIDORAN_M,  PLAIN_FORM

	ow_mon_map POKEMON_FAN_CLUB
	ow_mon BAYLEEF,    PLAIN_FORM

	ow_mon_map RADIO_TOWER_4F
	ow_mon MEOWTH,     PLAIN_FORM

	ow_mon_map ROUTE_28_STEEL_WING_HOUSE
	ow_mon FEAROW,     PLAIN_FORM

	ow_mon_map ROUTE_30
	ow_mon RATTATA,    PLAIN_FORM ; Joey's and Mikey's, one slot between them

	ow_mon_map ROUTE_39
	ow_mon MILTANK,    PLAIN_FORM ; the herd, four objects on one slot

	ow_mon_map ROUTE_39_BARN
	ow_mon MILTANK,    PLAIN_FORM ; Moomoo

	ow_mon_map TEAM_ROCKET_BASE_B2F
	ow_mon DRAGONITE,  PLAIN_FORM ; Lance's
	ow_mon ELECTRODE,  PLAIN_FORM ; all six of them

	ow_mon_map TEAM_ROCKET_BASE_B3F
	ow_mon MURKROW,    PLAIN_FORM

	ow_mon_map VIOLET_NICKNAME_SPEECH_HOUSE
	ow_mon PIDGEY,     PLAIN_FORM

	ow_mon_map VIRIDIAN_NICKNAME_SPEECH_HOUSE
	ow_mon SPEAROW,    PLAIN_FORM ; Speary
	ow_mon RATTATA,    PLAIN_FORM ; Rattey

	db -1 ; end of table
