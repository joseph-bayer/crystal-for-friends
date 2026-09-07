GetOverworldMonSlot::
; Look up what one of this map's SPRITE_OW_MON_* slots stands for.
; in:  a = the slot, 0-based (SPRITE_OW_MON_n - SPRITE_OW_MON)
; out: carry set, hl = the species index and a = the form byte, if the map fills that slot
;      carry clear otherwise, and the caller should draw nothing
;
; The table is scanned rather than cached in WRAM. It is read when an object's graphics are
; loaded -- on map setup, and again as an object scrolls onto the screen -- never per frame, and
; a scan is a few dozen comparisons. Keeping it out of WRAM keeps it out of the save block.
	ld e, a ; the slot wanted

; A rolled encounter beats the static table, which is how a wandering Route 29 Sentret and the
; Blackthorn Dratini come out of the same lookup.
	call GetOverworldMonEncounter
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a ; bc = the rolled species, 0 when nothing has been rolled into this slot
	ld d, [hl] ; and its form
	ld a, b
	or c
	jr z, .static_table
	ld h, b
	ld l, c
	ld a, d
	scf
	ret

.static_table
	ld hl, OverworldMonObjects

.map_loop
	ld a, [hli]
	cp -1
	jr z, .not_found
	ld d, a ; this row's map group
	ld a, [hli]
	ld c, a ; this row's map number
	ld a, [hli]
	ld b, a ; how many mon this row declares

	ld a, [wMapGroup]
	cp d
	jr nz, .skip_row
	ld a, [wMapNumber]
	cp c
	jr z, .found_map

.skip_row
	ld a, b
	and a
	jr z, .map_loop
.skip_loop
	call .NextEntry
	dec b
	jr nz, .skip_loop
	jr .map_loop

.found_map
	ld a, e
	cp b
	jr nc, .not_found ; this map has no entry for that slot
	and a
	jr z, .at_entry
	ld b, a
.walk_loop
	call .NextEntry
	dec b
	jr nz, .walk_loop

.at_entry
	ld a, [hli]
	ld c, a ; species index, low
	ld a, [hli]
	ld b, a ; species index, high
	ld a, [hl] ; the form byte
	ld h, b
	ld l, c
	scf
	ret

.not_found
	and a
	ret

.NextEntry:
	ld a, l
	add OW_MON_SLOT_LENGTH
	ld l, a
	adc h
	sub l
	ld h, a
	ret

SetUpOverworldMonBattle::
; Point the battle at the encounter that was rolled when this mon appeared on the map, instead of
; letting it roll its own. Everything else -- form, shininess, DVs, held item -- LoadEnemyMon reads
; straight out of the struct, which is why the sprite you walked into and the mon you fight match.
	ld a, 1 << 7
	ld [wBattleScriptFlags], a ; a wild battle, the same flag `loadwildmon` sets
	call GetOverworldMonBattleEncounter
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a ; bc = the species index
	inc hl ; the form is read by LoadEnemyMon, not here
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld h, b
	ld l, c
	call GetPokemonIDFromIndex
	ld [wTempWildMonSpecies], a
	ld a, BATTLETYPE_OVERWORLD_MON
	ld [wBattleType], a
	; fallthrough

HidePlayerForOverworldMonBattle:
; Leave the mon alone on screen for the battle transition. DoBattleTransition rebuilds OAM once,
; through InitSprites, which skips any object whose facing reads STANDING -- so the facing is set
; here rather than only the flag, because HandleMapObjects (the thing that would act on the flag)
; does not get another turn between here and the transition.
	ld hl, wPlayerStruct + OBJECT_FLAGS1
	set INVISIBLE_F, [hl]
	ld hl, wPlayerStruct + OBJECT_FACING
	ld [hl], STANDING
	ld hl, wObject1Struct + OBJECT_FLAGS1 ; the follower travels with the player
	set INVISIBLE_F, [hl]
	ld hl, wObject1Struct + OBJECT_FACING
	ld [hl], STANDING
	ret

ShowPlayerAfterOverworldMonBattle:
; The map reload that follows respawns both of them, but clear the flags rather than trusting it.
	ld hl, wPlayerStruct + OBJECT_FLAGS1
	res INVISIBLE_F, [hl]
	ld hl, wObject1Struct + OBJECT_FLAGS1
	res INVISIBLE_F, [hl]
	ret

EndOverworldMonBattle::
; Put hLastTalked back for the `disappear` that follows -- a battle is free to clobber HRAM -- and
; close the encounter out. The slot's data is left alone: the object's event flag is what keeps it
; away until the route is re-entered, and the roll overwrites the slot then anyway.
	call ShowPlayerAfterOverworldMonBattle
	ld a, [wOverworldMonBattleObject]
	ldh [hLastTalked], a
	ld a, [wOverworldMonBattleSlot]
	and a
	ret z
	dec a
	ld e, a
	call GetOverworldMonEncounter
	xor a
	ld [hli], a
	ld [hl], a ; species 0: the slot is empty, which is what keeps the object masked from here on
	ld [wOverworldMonBattleSlot], a
	ret

GetOverworldMonBattleEncounter::
; hl = the encounter the battle now running is against.
	ld a, [wOverworldMonBattleSlot]
	dec a
	ld e, a
	; fallthrough

GetOverworldMonEncounter::
; in:  e = a 0-based slot index
; out: hl = that slot's entry in wOverworldMonEncounters
; Preserves everything else. The caller is responsible for WRAM bank 1 being current.
	push de
	ld l, e
	ld h, 0
	add hl, hl ; *2
	ld d, h
	ld e, l
	add hl, hl ; *4
	add hl, hl ; *8
	add hl, de ; *10
	assert OW_MON_ENCOUNTER_LENGTH == 10, "GetOverworldMonEncounter scales a slot by ten"
	ld de, wOverworldMonEncounters
	add hl, de
	pop de
	ret

ClearOverworldMonEncounters::
; Forget every rolled encounter. Called when a map is entered, immediately before they are rolled
; again, and by the debug tooling.
	ld hl, wOverworldMonEncounters
	ld bc, NUM_OW_MON_SLOTS * OW_MON_ENCOUNTER_LENGTH
	xor a
	rst ByteFill
	ld [wOverworldMonBattleSlot], a
	ld [wOverworldMonShinyPending], a
	ret

INCLUDE "data/maps/overworld_mons.asm"


if DEF(_DEBUG)
; Force this slot shiny every time, or 0 for none. Testing a 1/512 rate by walking in and out of a
; route a few hundred times is not a test; what needs checking is whether the sprite and the battle
; agree about it, and a guaranteed shiny answers that on the first try.
DEF OW_MON_DEBUG_FORCE_SHINY_SLOT EQU 2
assert OW_MON_DEBUG_FORCE_SHINY_SLOT <= NUM_OW_MON_SLOTS, "no such slot to force shiny"
endc

RollOverworldMonsOnContinue::
; The save-load path. MapSetupScript_Continue restores the map objects straight out of the save --
; the wandering mon among them -- but skips HandleNewMap and LoadMapObjects entirely, so nothing
; rolls and nothing masks. The encounters live outside the save block, so what the objects find on
; the other side is whatever was left in WRAM: an empty slot at best, and on a cold boot garbage
; that resolves to no sprite at all, which is why they came back as a man you could not talk to.
;
; Rolling here means a reloaded save gets a fresh route, which is the same thing walking out and
; back gives you.
	call RollOverworldMons
	call UpdateOverworldMonObjectMasks
	; fallthrough

RefreshOverworldMonPalettes:
; The palette state is inside the save block; the encounters are deliberately outside it. So after
; a reload every wandering mon object still carries the palette index it had, and that index still
; holds the colors of the mon that was standing there when the game was saved -- a fresh Tentacool
; wearing the old Pikachu's colors. Re-derive them from the mon standing there now.
	farcall ResetOverworldMonPalettes ; forget which colors were claimed
	farcall InvalidateFollowerPalette ; and free every loaded index from the follower's up
	ld bc, wObjectStructs
	ld d, NUM_OBJECT_STRUCTS
.loop
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	sub SPRITE_OW_MON
	cp NUM_OW_MON_SLOTS
	jr nc, .next
	ld a, [hl]
	call GetSpritePalette ; preserves bc, and re-runs the whole colour lookup for this mon
	ld hl, OBJECT_PAL_INDEX
	add hl, bc
	ld [hl], a

.next
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	dec d
	jr nz, .loop
	farjp CheckForUsedObjPals

RollOverworldMons::
; Decide what is wandering this map. Called from HandleNewMap, which runs on warps, connections and
; fly -- but not on returning from a battle or closing a menu. That is what makes a route reroll
; when you leave and come back, and hold still otherwise.
	call ClearOverworldMonEncounters
	call .FindMap
	ret nc

	ld a, [hli]
	ld [wOverworldMonRollCount], a
	ld a, [hli]
	ld [wOverworldMonRollChance], a

; Step to this time of day's roster.
	ld a, [wTimeOfDay]
	cp EVE_F
	jr nz, .got_daytime
	ld a, NITE_F ; evening shares the night roster, as the grass tables do
.got_daytime
	and a
	jr z, .at_roster
	ld b, a
.daytime_loop
	ld de, NUM_OW_WILDMON * OW_WILDMON_LENGTH
	add hl, de
	dec b
	jr nz, .daytime_loop

.at_roster
	ld a, [wOverworldMonRollCount]
	and a
	ret z
	ld b, a
	ld c, 0 ; the slot being filled
.slot_loop
	push bc
	push hl
	call .RollOneSlot
	pop hl
	pop bc
	inc c
	dec b
	jr nz, .slot_loop
	ret

.RollOneSlot:
; in: hl = this time of day's roster, c = the 0-based slot
	ld a, c
	ld [wOverworldMonRollSlot], a

	call Random
	ld b, a
	ld a, [wOverworldMonRollChance]
	cp b
	ret c ; nobody appears in this slot; it stays empty and its object stays hidden

; Pick an entry by weight, subtracting as we go. A roster adding to less than 100 simply lands on
; its last entry more often, which beats silently picking nothing.
.reroll
	call Random
	cp 100
	jr nc, .reroll
	inc a ; 1 <= a <= 100
	ld b, a
	ld d, NUM_OW_WILDMON - 1
.weight_loop
	ld a, [hl]
	cp b
	jr nc, .got_entry
	ld e, a
	ld a, b
	sub e
	ld b, a
	ld a, l
	add OW_WILDMON_LENGTH
	ld l, a
	adc h
	sub l
	ld h, a
	dec d
	jr nz, .weight_loop

.got_entry
; Copy the roster entry into the buffer. The whole encounter is assembled there and published in
; one copy, so nothing can ever read a half-rolled mon.
	inc hl ; past the weight
	ld de, wOverworldMonRollBuffer + OW_MON_SPECIES
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [wOverworldMonRollBuffer + OW_MON_LEVEL], a
	ld a, [hli]
	ld [wOverworldMonRollBuffer + OW_MON_FORM], a
	ld a, [hli]
	ld [wOverworldMonRollBuffer + OW_MON_PERKS], a
	ld a, [hli]
	ld [wOverworldMonRollBuffer + OW_MON_MOVE], a
	ld a, [hl]
	ld [wOverworldMonRollBuffer + OW_MON_MOVE + 1], a

	call .RollForm
	call .RollDVs
	call .RollItem

	ld a, [wOverworldMonRollSlot]
	ld e, a
	call GetOverworldMonEncounter
	ld d, h
	ld e, l
	ld hl, wOverworldMonRollBuffer
	ld bc, OW_MON_ENCOUNTER_LENGTH
	rst CopyBytes
	ret

.RollForm:
	ld a, [wOverworldMonRollBuffer + OW_MON_FORM]
	and SHINY_MASK
	jr nz, .note_shiny ; the roster asked for one that is always shiny
; if DEF(_DEBUG)
; 	ld a, [wOverworldMonRollSlot]
; 	inc a
; 	cp OW_MON_DEBUG_FORCE_SHINY_SLOT
; 	jr z, .make_shiny
; endc
	ld a, [wOverworldMonRollBuffer + OW_MON_PERKS]
	bit OW_PERK_EXTRA_SHINY_F, a
	jr nz, .extra_shiny

	call Random
	and a
	ret nz ; 255/256 not shiny, the same gate every other shiny roll uses
	ld b, OVERWORLD_MON_SHINY_NUMERATOR
	jr .roll_shiny

.extra_shiny
; Deliberately without the 1/256 gate above. Behind it, no numerator can push the perk past about
; 1/257, so the perk would be a rounding error rather than a reward.
	ld b, OVERWORLD_MON_EXTRA_SHINY_NUMERATOR

.roll_shiny
	call Random
	cp b
	ret nc

.make_shiny
	ld a, [wOverworldMonRollBuffer + OW_MON_FORM]
	or SHINY_MASK
	ld [wOverworldMonRollBuffer + OW_MON_FORM], a

.note_shiny
	ld a, TRUE
	ld [wOverworldMonShinyPending], a
	ret

.RollDVs:
	call Random
	call .FloorNibbles
	ld [wOverworldMonRollBuffer + OW_MON_DVS], a
	call Random
	call .FloorNibbles
	ld [wOverworldMonRollBuffer + OW_MON_DVS + 1], a
	ret

.FloorNibbles:
; in/out: a, with either nibble raised to OVERWORLD_MON_MIN_DV when it fell below it. Half the
; appeal of chasing one of these is that it is worth keeping.
	ld b, a
	and $f0
	cp OVERWORLD_MON_MIN_DV << 4
	jr nc, .high_ok
	ld a, OVERWORLD_MON_MIN_DV << 4
.high_ok
	ld c, a
	ld a, b
	and $0f
	cp OVERWORLD_MON_MIN_DV
	jr nc, .low_ok
	ld a, OVERWORLD_MON_MIN_DV
.low_ok
	or c
	ret

.RollItem:
	ld hl, wOverworldMonRollBuffer + OW_MON_SPECIES
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetPokemonIDFromIndex
	ld [wCurSpecies], a
	call GetBaseData

	ld a, [wOverworldMonRollBuffer + OW_MON_PERKS]
	bit OW_PERK_ALWAYS_ITEM_F, a
	jr nz, .item1
	call Random
	cp OVERWORLD_MON_NO_ITEM_CHANCE
	jr c, .no_item
	call Random
	cp 20 percent ; the same split between the two items a grass encounter uses
	jr c, .item2
.item1
	ld hl, wBaseItem1
	jr .got_item

.item2
	ld hl, wBaseItem2
.got_item
	call GetItemIDFromHL
	jr .store_item

.no_item
	ld a, NO_ITEM
.store_item
	ld [wOverworldMonRollBuffer + OW_MON_ITEM], a
	ret

.FindMap:
; out: carry and hl = this map's row past the map id, or no carry when the map has no roster
	ld hl, OverworldWildMons
.find_loop
	ld a, [hli]
	cp -1
	jr z, .no_row
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [wMapGroup]
	cp b
	jr nz, .skip_row
	ld a, [wMapNumber]
	cp c
	jr nz, .skip_row
	scf
	ret

.skip_row
	ld de, OW_WILDDATA_LENGTH - 2
	add hl, de
	jr .find_loop

.no_row
	and a
	ret

ApplyOverworldMonMove::
; Give the mon the extra move its roster entry named, on top of whatever its level taught it.
; A wild encounter has nowhere to carry a move, which is what makes egg moves on a wandering mon
; worth having at all.
; Called from LoadEnemyMon after FillMoves and before the PP fill, so the move gets its PP free.
	ld a, [wBattleType]
	cp BATTLETYPE_OVERWORLD_MON
	ret nz
	call GetOverworldMonBattleEncounter
	ld de, OW_MON_MOVE
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	or l
	ret z ; the entry asked for nothing
	call GetMoveIDFromIndex
	ld b, a

; Already knows it? Nothing to do -- and quietly doubling a move would be worse than doing nothing.
	ld hl, wEnemyMonMoves
	ld c, NUM_MOVES
.known_loop
	ld a, [hli]
	cp b
	ret z
	dec c
	jr nz, .known_loop

; Otherwise the first empty slot, and failing that the first move -- the one it would soonest have
; replaced by levelling anyway.
	ld hl, wEnemyMonMoves
	ld c, NUM_MOVES
.free_loop
	ld a, [hl]
	and a
	jr z, .place
	inc hl
	dec c
	jr nz, .free_loop
	ld hl, wEnemyMonMoves

.place
	ld [hl], b
	ret

UpdateOverworldMonObjectMasks::
; Hide every wandering-mon object whose slot the roll left empty, and every one whose mon has
; already been battled.
;
; Unmasks the ones that do hold a mon, rather than only masking the empty, so that this is the
; whole truth about a wandering mon's visibility and can be called from anywhere -- including the
; save-load path, where LoadObjectMasks never runs and the saved masks are whatever they were.
;
; Done by writing wObjectMasks directly, from LoadMapObjects and after LoadObjectMasks has rebuilt
; the array from event flags. The obvious mechanism would be to give each object one of the
; EVENT_TEMPORARY_UNTIL_MAP_RELOAD_* flags, which clear on exactly the right boundary -- but all
; eight are already spoken for by Bill's house, the Dragon Shrine, Goldenrod Underground, Kurt's
; house, the ports and a dozen more, and there is no ninth. So the slot being empty *is* the
; hidden state, with no flag standing in for it.
	ld b, 1
	ld de, wMap1Object
.loop
	push de

	ld hl, MAPOBJECT_TYPE
	add hl, de
	ld a, [hl]
	cp OBJECTTYPE_WILDMON
	jr nz, .next

	ld hl, MAPOBJECT_SPRITE
	add hl, de
	ld a, [hl]
	sub SPRITE_OW_MON
	cp NUM_OW_MON_SLOTS
	jr nc, .mask ; an OBJECTTYPE_WILDMON on any other sprite has no encounter behind it
	ld e, a
	push bc
	call GetOverworldMonEncounter
	pop bc
	ld a, [hli]
	or [hl]
	jr nz, .unmask ; the slot holds a mon, so let it be seen

.mask
	ld a, -1 ; masked
	jr .apply

.unmask
	xor a

.apply
	ld hl, wObjectMasks
	ld e, b
	ld d, 0
	add hl, de
	ld [hl], a

.next
	pop de
	ld hl, MAPOBJECT_LENGTH
	add hl, de
	ld d, h
	ld e, l
	inc b
	ld a, b
	cp NUM_OBJECTS
	jr nz, .loop
	ret

INCLUDE "data/wild/overworld_mons.asm"
