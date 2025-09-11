; CheckPokemonIsSpecies
; Input: hl = 16-bit species index to check for (e.g., PIKACHU, CHARIZARD, etc.)
; Output: z flag set if Pokemon matches the species, nz if not
; Uses: [wCurPartyMon] to determine which Pokemon to check
; Preserves: bc, de
CheckPokemonIsSpecies:
	push bc
	push de
	
	; Save the target species index
	ld b, h
	ld c, l
	
	; Get the current Pokemon's species
	ld hl, wPartyMon1Species
	ld a, [wCurPartyMon]
	push bc
	call GetPartyLocation
	pop bc
	ld a, [hl]  ; Get the 8-bit species ID
	
	; Convert species ID to 16-bit index for comparison
	push bc
	call GetPokemonIndexFromID
	pop bc
	
	; Compare with target species (hl now contains the Pokemon's index)
	ld a, l
	cp c          ; Compare low byte
	jr nz, .not_match
	ld a, h
	cp b          ; Compare high byte
	jr nz, .not_match

	; Species matches
	pop de
	pop bc
	xor a         ; Set z flag
	ret
	
.not_match
	; Species doesn't match
	pop de
	pop bc
	ld a, 1       ; Clear z flag
	ret

; CheckPokemonKnowsMove
; Input: hl = 16-bit move index to check for (e.g., SURF, FLY, etc.)
; Output: z flag set if Pokemon knows the move, nz if not
; Uses: [wCurPartyMon] to determine which Pokemon to check
; Preserves: bc, de
CheckPokemonKnowsMove:
	push bc
	push de
	
	; Convert 16-bit move index to 8-bit move ID for comparison
	push hl
	call GetMoveIDFromIndex
	ld b, a  ; Store target move ID in b
	pop hl
	
	; Get pointer to the Pokemon's moves
	push bc
	ld hl, wPartyMon1Species
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld bc, MON_MOVES
	add hl, bc
	pop bc
	
	; Check all 4 moves
	ld c, NUM_MOVES
.check_move_loop
	ld a, [hli]
	cp b
	jr z, .knows_move
	dec c
	jr nz, .check_move_loop
	
	; Pokemon doesn't know the move
	pop de
	pop bc

	; Clear z flag
	ld a, 1       
	and a

	ret

.knows_move
	; Pokemon knows the move
	pop de
	pop bc
	xor a         ; Set z flag
	ret

; CheckPokemonFormIsPlain
; Input: none
; Output: z flag set if Pokemon's form is 0 (plain/default), nz if not
; Uses: [wCurPartyMon] to determine which Pokemon to check
; Preserves: bc, de, hl
CheckPokemonFormIsPlain:
	push bc
	push de
	push hl
	
	; Get pointer to the Pokemon's form
	ld hl, wPartyMon1Species
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld bc, MON_FORM
	add hl, bc
	
	; Check if form is 0
	ld a, [hl]
	and a
	jr z, .is_plain
	
	; Form is not 0 (not plain)
	pop hl
	pop de
	pop bc
	ld a, 1       ; Clear z flag
	ret

.is_plain
	; Form is 0 (plain)
	pop hl
	pop de
	pop bc
	xor a         ; Set z flag
	ret

