; Overworld wild Pokemon: the mon that wander a route and start a *wild* battle when you step
; beside them. See docs/plan_overworld_wild_mon.md.

; wOverworldMonEncounters entries.
; The whole encounter -- species, form, shininess, level, DVs, held item -- is rolled once when the
; map is entered, and the battle reads it back instead of rolling again. That is the point of the
; struct: without it the overworld sprite and the battle roll separately and disagree, and a mon
; that looked ordinary in the grass turns up shiny once the battle starts.
rsreset
DEF OW_MON_SPECIES rw ; 0 ; a 16-bit index; 0 means the slot is empty
DEF OW_MON_FORM    rb ; 2 ; a cosmetic form, optionally | SHINY_MASK
DEF OW_MON_LEVEL   rb ; 3
DEF OW_MON_DVS     rw ; 4
DEF OW_MON_ITEM    rb ; 6 ; an 8-bit item ID
DEF OW_MON_PERKS   rb ; 7 ; OW_PERK_* flags, kept so a perk can still act during the battle
; A 16-bit move *index*, not an 8-bit ID: IDs are handed out from a recycled table and can be
; evicted between the roll and the battle, and the roll can be minutes old.
DEF OW_MON_MOVE    rw ; 8 ; NO_MOVE for none
DEF OW_MON_ENCOUNTER_LENGTH EQU _RS

; How close you have to get. Zero means the same tile: you walk *onto* one rather than up to it,
; which is why they do not block the player.
;
; It was 1, and that read badly. An object's map coordinates update when its step begins, not when
; the sprite arrives, so a wandering mon setting off towards you counted as adjacent while it was
; still visibly a tile away, and the battle started before it had moved. Standing on the tile has
; no such gap -- the player's own step has finished by the time the check runs.
DEF OW_MON_TRIGGER_DISTANCE EQU 0

; Per-entry perks, set in the area tables.
; shift_const, so each perk gets both a value for the tables (1, 2, 4, ...) and a matching _F bit
; number for the code. A plain 1, 2, 3 enumeration reads fine in the data and is a trap in the
; engine: `bit OW_PERK_EXTRA_SHINY, a` against value 2 tests bit 2, which is never the bit that
; was set, so the perk silently never fires and every mon rolls the ordinary odds.
	const_def
	shift_const OW_PERK_ALWAYS_ITEM ; skip the held item roll and always hold one
	shift_const OW_PERK_EXTRA_SHINY ; a better shiny rate again, on top of the one they all get

; Area tables (see data/wild/overworld_mons.asm). Fixed width, like the grass tables, so a time of
; day can be indexed rather than walked.
DEF NUM_OW_WILDMON EQU 4 ; choices per time of day
rsreset
DEF OW_WILDMON_WEIGHT  rb ; 0 ; out of 100 within its time of day
DEF OW_WILDMON_SPECIES rw ; 1
DEF OW_WILDMON_LEVEL   rb ; 3
DEF OW_WILDMON_FORM    rb ; 4
DEF OW_WILDMON_PERKS   rb ; 5
DEF OW_WILDMON_MOVE    rw ; 6 ; an extra move it always knows, or NO_MOVE
DEF OW_WILDMON_LENGTH EQU _RS

; map id, how many can be out at once, the chance each one shows up, then morn/day/nite rosters
DEF OW_WILDDATA_LENGTH EQU 2 + 1 + 1 + NUM_OW_WILDMON * OW_WILDMON_LENGTH * 3
