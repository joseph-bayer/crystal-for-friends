; Which Pokemon wander which map, and how likely each is.
;
; Two tables, grass and water, the way JohtoGrassWildMons and JohtoWaterWildMons are two tables.
; RollOverworldMons runs one pass over each, so a map's grass slots can only draw land mon and its
; water slots only water ones -- a single blended roster put Tentacool in fields.
;
; The slots fill in a fixed order: a map's static mon first (data/maps/overworld_mons.asm), then
; its grass slots, then its water ones. A map's SPRITE_OW_MON_* objects must be numbered to match.
;
; Separate from data/wild/johto_grass.asm on purpose. The species overlap but nothing else does:
; these have their own odds, a shorter list, a chance of nobody appearing at all, and per-entry
; forms and perks that a grass encounter has no field for. Seeding a map's roster from its
; encounter table is a starting point, not a reason to share one.
;
; Read by RollOverworldMons, which runs from HandleNewMap -- so a map rerolls when you leave and
; come back, and holds still through battles and menus.
;
; ow_wildmon is weight, species, level, form, perks, extra move. Weights are out of 100 within
; their time of day; a block adding to less than 100 simply lands on its last entry more often.

OverworldWildMonsGrass:

; =================
; JOHTO - OUTSIDE
; =================

	def_ow_wildmons ROUTE_29
	db 2 ; how many can be out at once -- one SPRITE_OW_MON_n object each
	db 100 percent ; the chance each one shows up
	; morn
	ow_wildmon 50, PIDGEY,      2, PLAIN_FORM, 0,                  PURSUIT ; an egg move, for testing
	ow_wildmon 40, SENTRET,     2, PLAIN_FORM, 0,                  DOUBLE_EDGE ; an egg move, for testing
	ow_wildmon 5,  RATTATA,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  HOPPIP,      3, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 50, PIDGEY,      2, PLAIN_FORM, 0,                  PURSUIT ; an egg move, for testing
	ow_wildmon 40, SENTRET,     2, PLAIN_FORM, 0,                  DOUBLE_EDGE ; an egg move, for testing
	ow_wildmon 5,  RATTATA,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  HOPPIP,      3, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 35, RATTATA,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, HOOTHOOT,    2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, HOOTHOOT,    3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, RATTATA,     3, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_30
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 50, CATERPIE,    3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, LEDYBA,      3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, PIDGEY,      4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, WEEDLE,      3, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 50, CATERPIE,    3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, PIDGEY,      3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, LEDYBA,      4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, WEEDLE,      3, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 45, HOOTHOOT,    3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SPINARAK,    3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, POLIWAG,     4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  ZUBAT,       3, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_31
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, LEDYBA,      4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, BELLSPROUT,  4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, CATERPIE,    5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, MAREEP,      5, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, PIDGEY,      4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, CATERPIE,    4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, BELLSPROUT,  5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, MAREEP,      5, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 34, SPINARAK,    4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, POLIWAG,     4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, BELLSPROUT,  5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, HOOTHOOT,    5, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_32
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 52, MAREEP,      7, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, WOOPER,      7, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, EKANS,       6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  PIDGEY,      7, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 52, MAREEP,      7, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, WOOPER,      7, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, EKANS,       6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  PIDGEY,      7, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 50, WOOPER,      7, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,       7, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, GASTLY,      6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  MAREEP,      7, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_33
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 35, EKANS,       9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SPEAROW,     9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, RATTATA,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, MACHOP,      9, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 40, MACHOP,      9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 35, EKANS,       9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, RATTATA,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  MACHOP,      8, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 35, ZUBAT,       9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, EKANS,       9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, RATTATA,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, MACHOP,      9, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_34
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, MANKEY,     14, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ABRA,       13, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, SNUBBULL,   14, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GRIMER,     13, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, MANKEY,     14, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ABRA,       13, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, SNUBBULL,   14, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GRIMER,     13, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 34, DROWZEE,    14, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, GRIMER,     13, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, ABRA,       14, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, SNUBBULL,   13, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_35
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 33, SNUBBULL,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ABRA,       15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 23, YANMA,      15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, PIDGEY,     14, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 33, SNUBBULL,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, PIDGEY,     15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, ABRA,       15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 12, YANMA,      14, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 35, PSYDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, GROWLITHE,  15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, ABRA,       15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 12, YANMA,      14, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_36
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 35, RATTATA,     4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, BELLSPROUT,  4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, PIDGEY,      5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GROWLITHE,   5, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 35, RATTATA,     4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, BELLSPROUT,  4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, PIDGEY,      5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GROWLITHE,   5, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 35, RATTATA,     4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 35, GASTLY,      4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, HOOTHOOT,    5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, HOUNDOUR,    5, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_37
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 50, PIDGEY,     16, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 35, VULPIX,     17, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, PIDGEOTTO,  18, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  LEDIAN,     18, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 50, PIDGEY,     16, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 35, GROWLITHE,  16, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, PIDGEOTTO,  16, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  STANTLER,   18, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 42, STANTLER,   18, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, SPINARAK,   16, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, HOOTHOOT,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  NOCTOWL,    19, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_38
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, TAUROS,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, MILTANK,    21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MAGNEMITE,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, DODUO,      20, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, MAGNEMITE,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, MILTANK,    21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, TAUROS,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, DODUO,      20, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 30, RATICATE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, MAGNEMITE,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, MEOWTH,     19, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, NOCTOWL,    21, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_39
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, PONYTA,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, RATICATE,   21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MAGNEMITE,  21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, DODUO,      21, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, PONYTA,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, RATICATE,   21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MAGNEMITE,  21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, DODUO,      21, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 40, MEOWTH,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, RATICATE,   21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, MAGNEMITE,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, NOCTOWL,    20, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_42
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 36, FEAROW,     20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, EKANS,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GLIGAR,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, RATICATE,   21, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 36, FEAROW,     20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, EKANS,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GLIGAR,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, RATICATE,   21, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 31, RATICATE,   22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GLIGAR,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 16, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_43
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, FURRET,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, GIRAFARIG,  22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, FARFETCH_D, 22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, FLAAFFY,    23, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, FURRET,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, GIRAFARIG,  22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, FARFETCH_D, 22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, FLAAFFY,    23, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 34, VENONAT,    21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, GIRAFARIG,  22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, RATICATE,   22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, FLAAFFY,    23, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_44
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 31, TANGELA,    33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, LICKITUNG,  32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 26, WEEPINBELL, 32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, PIDGEOTTO,  34, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 31, TANGELA,    33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, LICKITUNG,  32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 26, WEEPINBELL, 32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, PIDGEOTTO,  34, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 40, POLIWHIRL,  33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, LICKITUNG,  32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, WEEPINBELL, 32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  ELECTABUZZ, 36, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_45
	db 4 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 42, DONPHAN,    34, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, GRAVELER,   34, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GLIGAR,     31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  URSARING,   35, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 42, DONPHAN,    35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, GRAVELER,   34, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GLIGAR,     31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  URSARING,   35, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 63, GRAVELER,   35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GLIGAR,     31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, MURKROW,    35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  GOLBAT,     35, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_46
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 50, GEODUDE,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SPEAROW,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, RATTATA,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  PHANPY,      2, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 50, GEODUDE,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SPEAROW,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, PHANPY,      3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, RATTATA,     2, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 40, RATTATA,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GEODUDE,     2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, GEODUDE,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, RATTATA,     3, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons


	def_ow_wildmons RUINS_OF_ALPH_OUTSIDE
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 60, NATU,       21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, NATU,       22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  SMEARGLE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  SMEARGLE,   22, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 60, NATU,       21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, NATU,       22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  SMEARGLE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  SMEARGLE,   22, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 60, NATU,       21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, NATU,       22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  WOOPER,     22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  QUAGSIRE,   22, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

; ===============
; JOHTO - INSIDE
; ===============

	def_ow_wildmons DARK_CAVE_BLACKTHORN_ENTRANCE
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, GEODUDE,    33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, GRAVELER,   35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, URSARING,   35, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 31, GEODUDE,    33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, ZUBAT,      33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GRAVELER,   35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 16, URSARING,   35, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 31, GEODUDE,    33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, ZUBAT,      33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, GRAVELER,   35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 16, WOBBUFFET,  30, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons DARK_CAVE_VIOLET_ENTRANCE
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 51, ZUBAT,       2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 40, GEODUDE,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  TEDDIURSA,   2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 4,  LARVITAR,    2, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 55, ZUBAT,       2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 40, GEODUDE,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 4,  LARVITAR,    2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  DUNSPARCE,   4, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 55, ZUBAT,       2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 40, GEODUDE,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 4,  LARVITAR,    2, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  DUNSPARCE,   4, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ICE_PATH_1F
	db 3 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 30, SWINUB,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,      22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SWINUB,     23, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 30, SWINUB,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,      22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SWINUB,     23, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 30, DELIBIRD,   21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,      22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, DELIBIRD,   23, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ICE_PATH_B1F
	db 3 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 35, SWINUB,     32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 31, JYNX,       33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 24, GOLBAT,     33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SNEASEL,    34, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 35, SWINUB,     32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 31, JYNX,       33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 24, GOLBAT,     33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SNEASEL,    34, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 31, SNEASEL,    33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, DELIBIRD,   32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 29, GOLBAT,     33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, DELIBIRD,   34, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ICE_PATH_B2F_BLACKTHORN_SIDE
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 35, SWINUB,     32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 31, JYNX,       33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 24, GOLBAT,     33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SNEASEL,    34, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 35, SWINUB,     32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 31, JYNX,       33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 24, GOLBAT,     33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SNEASEL,    34, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 35, SNEASEL,    33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, DELIBIRD,   32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, GOLBAT,     33, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, DELIBIRD,   34, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ICE_PATH_B3F
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 40, JYNX,       35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SNEASEL,    34, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, GOLBAT,     35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SWINUB,     36, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 40, JYNX,       35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SNEASEL,    34, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, GOLBAT,     35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SWINUB,     36, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 40, SNEASEL,    34, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, JYNX,       35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, GOLBAT,     35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, DELIBIRD,   36, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ILEX_FOREST
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 31, CATERPIE,    8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, WEEDLE,      8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 26, PARAS,      12, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, ODDISH,     12, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 31, CATERPIE,    8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, WEEDLE,      8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 26, PARAS,      12, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, ODDISH,     12, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 36, ODDISH,     12, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, VENONAT,    12, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, PARAS,      12, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, HOOTHOOT,   12, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons MOUNT_MORTAR_1F_INSIDE
	db 4 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MACHOP,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MACHOP,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MARILL,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons MOUNT_MORTAR_1F_OUTSIDE
	db 4 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MACHOP,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MACHOP,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MARILL,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons MOUNT_MORTAR_2F_INSIDE
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, GRAVELER,   31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, MACHOKE,    32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, GEODUDE,    31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, RATICATE,   30, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, GRAVELER,   31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, MACHOKE,    32, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, GEODUDE,    31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, RATICATE,   30, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 31, GRAVELER,   31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, GEODUDE,    31, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, RATICATE,   30, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 16, GOLBAT,     30, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons MOUNT_MORTAR_B1F
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MACHOP,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MACHOP,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 34, GEODUDE,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, ZUBAT,      20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, MARILL,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, GOLBAT,     22, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SILVER_CAVE_ROOM_1
	db 4 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, GRAVELER,   63, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, URSARING,   64, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, ONIX,       62, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, MAGMAR,     65, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 34, GRAVELER,   63, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 33, URSARING,   64, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 22, ONIX,       62, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 11, MAGMAR,     65, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 45, GOLBAT,     64, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GRAVELER,   63, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, ONIX,       62, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  GOLDUCK,    65, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SILVER_CAVE_ROOM_2
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 31, GOLBAT,     68, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, MACHOKE,    68, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, URSARING,   67, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 16, PARASECT,   66, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 31, GOLBAT,     68, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, MACHOKE,    68, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, URSARING,   67, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 16, PARASECT,   66, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 50, GOLBAT,     68, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GOLDUCK,    68, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, PARASECT,   66, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  MISDREAVUS, 65, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SLOWPOKE_WELL_B1F
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 55, ZUBAT,       5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,       6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWPOKE,    6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  SLOWPOKE,    8, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 55, ZUBAT,       5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,       6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWPOKE,    6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  SLOWPOKE,    8, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 55, ZUBAT,       5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,       6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWPOKE,    6, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  SLOWPOKE,    8, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SLOWPOKE_WELL_B2F
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 50, ZUBAT,      21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,      23, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, SLOWPOKE,   21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  GOLBAT,     23, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 50, ZUBAT,      21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,      23, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, SLOWPOKE,   21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  GOLBAT,     23, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 50, ZUBAT,      21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, ZUBAT,      23, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 15, SLOWPOKE,   21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  GOLBAT,     23, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SPROUT_TOWER_2F
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 40, RATTATA,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, RATTATA,     4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, RATTATA,     5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  RATTATA,     6, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 40, RATTATA,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, RATTATA,     4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, RATTATA,     5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  RATTATA,     6, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 40, RATTATA,     3, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 35, GASTLY,      4, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, RATTATA,     5, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  GASTLY,      6, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons UNION_CAVE_1F
	db 3 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 42, GEODUDE,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, SANDSHREW,   8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, ZUBAT,       9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  CUBONE,      8, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 42, GEODUDE,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, SANDSHREW,   8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, ZUBAT,       9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  CUBONE,      8, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 42, GEODUDE,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 32, SANDSHREW,   8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 21, ZUBAT,       9, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 5,  CUBONE,      8, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons UNION_CAVE_B1F
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 50, ZUBAT,       8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GEODUDE,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, ONIX,        8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, MARILL,      8, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 50, ZUBAT,       8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GEODUDE,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, ONIX,        8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, MARILL,      8, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 50, ZUBAT,       8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, GEODUDE,     8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, ONIX,        8, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, MARILL,      8, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons WHIRL_ISLAND_B1F
	db 4 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 35, GOLBAT,     25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, KRABBY,     26, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, SEEL,       24, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, KRABBY,     27, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 35, GOLBAT,     25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, KRABBY,     26, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 25, SEEL,       24, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, KRABBY,     27, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 40, GOLBAT,     25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, KRABBY,     26, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 20, SEEL,       24, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, KRABBY,     27, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons
	db -1 ; end of table


OverworldWildMonsWater:

; ======================
; JOHTO WATER - OUTSIDE 
; ======================

; Whether a water Pokemon rides on top or sits in the water is a property of the species, not of
; the map: OW_PERK_ON_SURFACE keeps it above the waterline, and leaving the perk off lets
; SPRITEMOVEDATA_SWIM_WANDER_NOCLIP's OVERHEAD bit sink its lower half behind the water tile.
; Quagsire, Wooper, Horsea and Mantine swim in it. Goldeen, Seaking, Magikarp and Shellder float
; on it. Keep new entries consistent with the same species elsewhere.
	def_ow_wildmons CHERRYGROVE_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
	; morn
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_32
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACRUEL, 23, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACRUEL, 23, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACRUEL, 23, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_34
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_35
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, PSYDUCK,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, PSYDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDUCK,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  PSYDUCK,    18, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, PSYDUCK,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, PSYDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDUCK,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  PSYDUCK,    18, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, PSYDUCK,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, PSYDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDUCK,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  PSYDUCK,    18, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_40
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, SHELLDER,   21, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 22, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACRUEL, 25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, SHELLDER,   21, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 22, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACRUEL, 25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, SHELLDER,   21, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 22, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACRUEL, 25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_41
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, HORSEA,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, MANTINE,    22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  MANTINE,    25, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, HORSEA,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, MANTINE,    22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  MANTINE,    25, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, HORSEA,     21, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, MANTINE,    22, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  MANTINE,    25, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_42
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, REMORAID,   21, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, GOLDEEN,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    28, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, REMORAID,   21, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, GOLDEEN,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    28, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, REMORAID,   21, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, GOLDEEN,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    28, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_43
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, MAGIKARP,   20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,   13, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, MAGIKARP,   20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,   13, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, MAGIKARP,   20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,   13, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_44
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, POLIWAG,    25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    24, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  28, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    27, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, POLIWAG,    25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    24, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  28, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    27, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, POLIWAG,    25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    24, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  28, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    27, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons CIANWOOD_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ECRUTEAK_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, POLIWAG,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    18, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, POLIWAG,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    18, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, POLIWAG,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    18, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons OLIVINE_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons OLIVINE_PORT
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, TENTACOOL,  20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  TENTACOOL,  18, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons VIOLET_CITY
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, POLIWAG,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    18, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, POLIWAG,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    18, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, POLIWAG,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, POLIWAG,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  POLIWAG,    18, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons LAKE_OF_RAGE
	db 3 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; Magikarp only, by design -- the lake is the Red Gyarados story, and a lake thick with
; Magikarp sells it. Ignores the GYARADOS in the water table on purpose.
	; morn
	ow_wildmon 40, MAGIKARP,   10, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 20, MAGIKARP,   20, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,   25, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 40, MAGIKARP,   10, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 20, MAGIKARP,   20, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,   25, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 40, MAGIKARP,   10, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 20, MAGIKARP,   20, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,   25, PLAIN_FORM,       OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons


	def_ow_wildmons RUINS_OF_ALPH_OUTSIDE
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, WOOPER,     15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, QUAGSIRE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  QUAGSIRE,   18, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, WOOPER,     15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, QUAGSIRE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  QUAGSIRE,   18, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, WOOPER,     15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, QUAGSIRE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  QUAGSIRE,   18, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons


; ======================
; JOHTO WATER - INSIDE 
; ======================

	def_ow_wildmons DARK_CAVE_BLACKTHORN_ENTRANCE
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,    5, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,    8, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,    5, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,    8, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,    5, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,    8, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons DARK_CAVE_VIOLET_ENTRANCE
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,    5, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,    8, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,    5, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,    8, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, MAGIKARP,   15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MAGIKARP,   10, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 10, MAGIKARP,    5, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  MAGIKARP,    8, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ILEX_FOREST
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, PSYDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, PSYDUCK,    10, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  PSYDUCK,    13, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, PSYDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, PSYDUCK,    10, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  PSYDUCK,    13, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, PSYDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, PSYDUCK,    10, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDUCK,    15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  PSYDUCK,    13, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons MOUNT_MORTAR_2F_INSIDE
	db 3 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, GOLDEEN,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MARILL,     25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    28, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, GOLDEEN,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MARILL,     25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    28, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, GOLDEEN,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MARILL,     25, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    28, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons MOUNT_MORTAR_B1F
	db 3 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, GOLDEEN,    15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MARILL,     20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SEAKING,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    23, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, GOLDEEN,    15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MARILL,     20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SEAKING,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    23, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, GOLDEEN,    15, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, MARILL,     20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SEAKING,    20, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  SEAKING,    23, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SILVER_CAVE_ROOM_2
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, SEAKING,    35, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, GOLDUCK,    35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDEEN,    35, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  GOLDEEN,    38, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; day
	ow_wildmon 59, SEAKING,    35, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, GOLDUCK,    35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDEEN,    35, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  GOLDEEN,    38, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	; nite
	ow_wildmon 59, SEAKING,    35, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 30, GOLDUCK,    35, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, GOLDEEN,    35, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	ow_wildmon 1,  GOLDEEN,    38, PLAIN_FORM, OW_PERK_ON_SURFACE, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SLOWPOKE_WELL_B1F
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, SLOWPOKE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SLOWPOKE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWPOKE,   10, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  SLOWPOKE,   13, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, SLOWPOKE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SLOWPOKE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWPOKE,   10, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  SLOWPOKE,   13, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, SLOWPOKE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SLOWPOKE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWPOKE,   10, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  SLOWPOKE,   13, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons SLOWPOKE_WELL_B2F
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, SLOWPOKE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SLOWPOKE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWBRO,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  SLOWPOKE,   23, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, SLOWPOKE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SLOWPOKE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWBRO,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  SLOWPOKE,   23, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, SLOWPOKE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, SLOWPOKE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, SLOWBRO,    20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  SLOWPOKE,   23, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons

	def_ow_wildmons UNION_CAVE_B1F
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 59, WOOPER,     15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, QUAGSIRE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  QUAGSIRE,   18, PLAIN_FORM, 0,                  NO_MOVE
	; day
	ow_wildmon 59, WOOPER,     15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, QUAGSIRE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  QUAGSIRE,   18, PLAIN_FORM, 0,                  NO_MOVE
	; nite
	ow_wildmon 59, WOOPER,     15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 30, QUAGSIRE,   20, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 10, QUAGSIRE,   15, PLAIN_FORM, 0,                  NO_MOVE
	ow_wildmon 1,  QUAGSIRE,   18, PLAIN_FORM, 0,                  NO_MOVE
	end_ow_wildmons
	db -1 ; end of table
