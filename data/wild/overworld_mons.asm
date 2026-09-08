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

	def_ow_wildmons ROUTE_29
	db 2 ; how many can be out at once -- one SPRITE_OW_MON_n object each
	db 100 percent ; the chance each one shows up
	; morn
	ow_wildmon 30, PIDGEY,   3, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 30, SENTRET,  3, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 25, RATTATA,  3, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 15, HOPPIP,   4, PLAIN_FORM, 0, NO_MOVE
	; day
	ow_wildmon 30, PIDGEY,   3, PLAIN_FORM, 0, PURSUIT ; a real Pidgey egg move, for testing
	ow_wildmon 30, SENTRET,  3, PLAIN_FORM, 0, DOUBLE_EDGE ; and a real Sentret one
	ow_wildmon 25, RATTATA,  3, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 15, HOPPIP,   4, PLAIN_FORM, 0, NO_MOVE
	; nite
	ow_wildmon 40, HOOTHOOT, 3, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 35, RATTATA,  3, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 15, HOOTHOOT, 4, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 10, SENTRET,  4, PLAIN_FORM, 0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_30
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, LEDYBA,      3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, CATERPIE,    3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, CATERPIE,    4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, PIDGEY,      4, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, PIDGEY,      3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, CATERPIE,    3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, CATERPIE,    4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, LEDYBA,      4, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 31, SPINARAK,    3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 32, HOOTHOOT,    3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 21, POLIWAG,     4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 16, HOOTHOOT,    4, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_31
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, LEDYBA,      4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, BELLSPROUT,  4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, CATERPIE,    5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, MAREEP,      5, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, PIDGEY,      4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, CATERPIE,    4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, BELLSPROUT,  5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, MAREEP,      5, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, SPINARAK,    4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, POLIWAG,     4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, BELLSPROUT,  5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, HOOTHOOT,    5, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_32
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, MAREEP,      7, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, WOOPER,      7, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, MAREEP,      5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, EKANS,       6, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, MAREEP,      7, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, WOOPER,      7, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, MAREEP,      5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, EKANS,       6, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, WOOPER,      7, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, ZUBAT,       7, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, WOOPER,      5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, GASTLY,      6, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_33
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, EKANS,       9, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, SPEAROW,     9, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, RATTATA,     8, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, MACHOP,      9, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 42, MACHOP,      9, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 32, EKANS,       9, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 21, RATTATA,     8, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  EKANS,       8, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, ZUBAT,       9, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, EKANS,       9, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, RATTATA,     8, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, MACHOP,      9, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_34
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, MANKEY,     14, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, ABRA,       13, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, SNUBBULL,   14, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, GRIMER,     13, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, MANKEY,     14, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, ABRA,       13, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, SNUBBULL,   14, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, GRIMER,     13, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, DROWZEE,    14, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GRIMER,     13, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, ABRA,       14, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, SNUBBULL,   13, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_35
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, SNUBBULL,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, ABRA,       15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, YANMA,      15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, PIDGEY,     14, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, SNUBBULL,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, PIDGEY,     15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, ABRA,       15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, YANMA,      14, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 36, PSYDUCK,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 32, GROWLITHE,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 21, ABRA,       15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, YANMA,      14, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_36
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, RATTATA,     4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, BELLSPROUT,  4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, PIDGEY,      5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, GROWLITHE,   5, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, RATTATA,     4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, BELLSPROUT,  4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, PIDGEY,      5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, GROWLITHE,   5, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, RATTATA,     4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GASTLY,      4, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, HOOTHOOT,    5, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, HOUNDOUR,    5, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_37
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 52, PIDGEY,     16, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 32, VULPIX,     17, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, PIDGEOTTO,  18, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  VULPIX,     18, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, PIDGEY,     16, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GROWLITHE,  16, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, PIDGEY,     18, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, PIDGEOTTO,  16, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 42, STANTLER,   18, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 32, SPINARAK,   16, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 21, HOOTHOOT,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  NOCTOWL,    19, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_38
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, TAUROS,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, MILTANK,    21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, MAGNEMITE,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, DODUO,      20, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, MAGNEMITE,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, MILTANK,    21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, TAUROS,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, DODUO,      20, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, RATICATE,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, MAGNEMITE,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, MEOWTH,     19, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, NOCTOWL,    21, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_39
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, PONYTA,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, RATICATE,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, MAGNEMITE,  21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, DODUO,      21, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, PONYTA,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, RATICATE,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, MAGNEMITE,  21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, DODUO,      21, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, MEOWTH,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, RATICATE,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, MAGNEMITE,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, NOCTOWL,    20, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_42
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, EKANS,      20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, FEAROW,     20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, GLIGAR,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, RATICATE,   21, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, EKANS,      20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, FEAROW,     20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, GLIGAR,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, RATICATE,   21, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 31, RATICATE,   22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 32, ZUBAT,      20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 21, GLIGAR,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 16, GOLBAT,     22, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_43
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, FURRET,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GIRAFARIG,  22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, FARFETCH_D, 22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, FLAAFFY,    23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, FURRET,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GIRAFARIG,  22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, FARFETCH_D, 22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, FLAAFFY,    23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, VENONAT,    21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GIRAFARIG,  22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, RATICATE,   22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, FLAAFFY,    23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_44
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, TANGELA,    33, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, LICKITUNG,  32, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, WEEPINBELL, 32, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, PIDGEOTTO,  34, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, TANGELA,    33, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, LICKITUNG,  32, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, WEEPINBELL, 32, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, PIDGEOTTO,  34, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, POLIWHIRL,  33, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, LICKITUNG,  32, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, WEEPINBELL, 32, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, POLIWHIRL,  34, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_45
	db 4 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, DONPHAN,    34, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GRAVELER,   34, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, GLIGAR,     31, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, DONPHAN,    35, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 42, DONPHAN,    35, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 32, GRAVELER,   34, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 21, GLIGAR,     31, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  URSARING,   35, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 34, GRAVELER,   35, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, GRAVELER,   34, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, GLIGAR,     31, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, MURKROW,    35, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_46
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the grass encounter table for this map.
	; morn
	ow_wildmon 34, GEODUDE,     2, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, SPEAROW,     2, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, GEODUDE,     3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, RATTATA,     3, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 34, GEODUDE,     2, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 33, SPEAROW,     2, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 22, GEODUDE,     3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 11, PHANPY,      3, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 40, RATTATA,     2, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 30, GEODUDE,     2, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 20, GEODUDE,     3, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, RATTATA,     3, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	db -1 ; end of table


OverworldWildMonsWater:

	def_ow_wildmons CHERRYGROVE_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
	; morn
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM, 0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM, 0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM, 0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM, 0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_32
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, QUAGSIRE,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, QUAGSIRE,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, QUAGSIRE,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_34
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_35
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, PSYDUCK,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, PSYDUCK,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, GOLDUCK,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  GOLDUCK,    23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, PSYDUCK,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, PSYDUCK,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, GOLDUCK,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  GOLDUCK,    23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, PSYDUCK,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, PSYDUCK,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, GOLDUCK,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  GOLDUCK,    23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_40
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, SHELLDER,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 25, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, SHELLDER,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 25, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, SHELLDER,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 25, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_41
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, HORSEA,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MANTINE,    22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  MANTINE,    25, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, HORSEA,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MANTINE,    22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  MANTINE,    25, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, HORSEA,     21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MANTINE,    22, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  MANTINE,    25, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_42
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, REMORAID,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, GOLDEEN,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  SEAKING,    28, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, REMORAID,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, GOLDEEN,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  SEAKING,    28, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, REMORAID,   21, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, GOLDEEN,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, SEAKING,    25, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  SEAKING,    28, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_43
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, MAGIKARP,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, MAGIKARP,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MAGIKARP,   10, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  MAGIKARP,   13, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, MAGIKARP,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, MAGIKARP,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MAGIKARP,   10, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  MAGIKARP,   13, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, MAGIKARP,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, MAGIKARP,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MAGIKARP,   10, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  MAGIKARP,   13, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ROUTE_44
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, POLIWAG,    25, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    24, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  28, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  31, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, POLIWAG,    25, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    24, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  28, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  31, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, POLIWAG,    25, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    24, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  28, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  31, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons CIANWOOD_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons ECRUTEAK_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, POLIWAG,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, POLIWAG,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, POLIWAG,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons OLIVINE_CITY
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons OLIVINE_PORT
	db 1 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, TENTACOOL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, TENTACOOL,  15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, TENTACRUEL, 20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  TENTACRUEL, 23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons VIOLET_CITY
	db 2 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; From the water encounter table for this map.
	; morn
	ow_wildmon 56, POLIWAG,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  23, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 56, POLIWAG,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  23, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 56, POLIWAG,    20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 29, POLIWAG,    15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, POLIWHIRL,  20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 5,  POLIWHIRL,  23, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	def_ow_wildmons LAKE_OF_RAGE
	db 3 ; how many can be out at once
	db 100 percent ; the chance each one shows up
; Magikarp only, by design -- the lake is the Red Gyarados story, and a lake thick with
; Magikarp sells it. Ignores the GYARADOS in the water table on purpose.
	; morn
	ow_wildmon 40, MAGIKARP,   10, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 20, MAGIKARP,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MAGIKARP,   25, PLAIN_FORM,       0, NO_MOVE
	; day
	ow_wildmon 40, MAGIKARP,   10, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 20, MAGIKARP,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MAGIKARP,   25, PLAIN_FORM,       0, NO_MOVE
	; nite
	ow_wildmon 40, MAGIKARP,   10, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 30, MAGIKARP,   15, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 20, MAGIKARP,   20, PLAIN_FORM,       0, NO_MOVE
	ow_wildmon 10, MAGIKARP,   25, PLAIN_FORM,       0, NO_MOVE
	end_ow_wildmons

	db -1 ; end of table
