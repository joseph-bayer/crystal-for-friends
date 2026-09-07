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

INCLUDE "data/maps/overworld_mons.asm"
