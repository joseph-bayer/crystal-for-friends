OverworldWildMons:
; Which Pokemon wander which route, and how likely each is.
;
; Separate from data/wild/johto_grass.asm on purpose. The species overlap but nothing else does:
; these have their own odds, a shorter list, a chance of nobody appearing at all, and per-entry
; forms and perks that a grass encounter has no field for. Seeding a route's roster from its grass
; table is a starting point, not a reason to share one.
;
; Read by RollOverworldMons, which runs from HandleNewMap -- so a route rerolls when you leave and
; come back, and holds still through battles and menus.
;
; ow_wildmon is weight, species, level, form, perks. Weights are out of 100 within their time of
; day; a block that adds to less than 100 simply falls through to its last entry more often.

	def_ow_wildmons ROUTE_29
	db 2 ; how many can be out at once -- one SPRITE_OW_MON_n object each
	db 99 percent ; the chance each one shows up
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

	def_ow_wildmons CHERRYGROVE_CITY
	db 1 ; how many can be out at once
	db 99 percent ; the chance it shows up
; Seeded from the water encounter table for Cherrygrove -- Tentacool and Tentacruel -- with a
; Surfing Pikachu as the rare one, since a form on the water is the thing worth looking at.
	; morn
	ow_wildmon 45, TENTACOOL,  10, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 15, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 10, PIKACHU,    15, PIKACHU_SURF_FORM, OW_PERK_EXTRA_SHINY, SURF
	; day
	ow_wildmon 45, TENTACOOL,  10, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 15, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 10, PIKACHU,    15, PIKACHU_SURF_FORM, OW_PERK_EXTRA_SHINY, SURF
	; nite
	ow_wildmon 45, TENTACOOL,  10, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 30, TENTACOOL,  15, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 15, TENTACRUEL, 20, PLAIN_FORM, OW_PERK_EXTRA_SHINY, NO_MOVE
	ow_wildmon 10, PIKACHU,    15, PIKACHU_SURF_FORM, OW_PERK_EXTRA_SHINY, SURF
	end_ow_wildmons

	db -1 ; end of table
