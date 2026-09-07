if DEF(_DEBUG)

; Sweep only the species that have cosmetic forms, every form of each, instead of walking the
; dex. Every mon stored then exercises the form path -- what to reach for when checking whether a
; problem is form-related rather than volume-related.
DEF FILL_PC_FORM_SPECIES_ONLY EQU 0

; Stop after this many mons, whichever mode is running, or 0 for no limit. Useful for keeping a
; sweep inside one box, or one past it, to separate "breaks on forms" from "breaks on a second
; box". The budget lives in a single register, so it cannot exceed a byte -- a full-dex sweep is
; 268 mons and has to run uncapped rather than with a cap that would silently wrap.
DEF FILL_PC_MAX_MONS EQU 0
assert FILL_PC_MAX_MONS < $100, "the mon budget is kept in one register; use 0 for no limit"

; Unown's 26 letters differ in shape, not color -- Unown has no entry in
; CosmeticFormPalettePointersTable, so every letter reads the same two colors. For reviewing
; palettes they are 25 identical slots, and PlayersHouse2F records that gifting Unown before the
; Ruins of Alph puzzle is done can crash. So the sweep leaves them out. Set this to 1 to get all
; 26 when testing icon *graphics* rather than colors.
DEF FILL_PC_ALL_UNOWN_LETTERS EQU 0

; The span of the dex to sweep, inclusive, when FILL_PC_FORM_SPECIES_ONLY is off.
DEF FILL_PC_FIRST_SPECIES EQU 1
DEF FILL_PC_LAST_SPECIES  EQU NUM_POKEMON
assert FILL_PC_FIRST_SPECIES >= 1, "the sweep range starts at species index 1"
assert FILL_PC_LAST_SPECIES <= NUM_POKEMON, "the sweep range ends at NUM_POKEMON"

; Give each species every cosmetic form rather than only its default. Ignored when
; FILL_PC_FORM_SPECIES_ONLY is on, since the forms are the whole point of that mode.
DEF FILL_PC_INCLUDE_FORMS EQU 1

FillPCWithEveryForm::
; Put mons into the PC in order, so their icon and follower palettes can be reviewed side by
; side. Reach it with
;   callasm FillPCWithEveryForm
; from a debug script. What it sweeps depends on the switches above.
;
; These go straight into the boxes regardless of how full the party is. The PC holds
; NUM_BOXES * MONS_PER_BOX = 300 mons across MONDB_ENTRIES * 2 = 320 database entries, but the
; allocator rescans the database for every mon and falls back to FlushStorageSystem when it runs
; short, so a large sweep is slow rather than instant.
;
; It calls SendMonIntoBox rather than GivePoke, which would print "was sent to BILL's PC" and
; offer a nickname prompt for every one of them. That also means no gift shiny roll, so the
; sweep is a clean set of normal colors.
if FILL_PC_MAX_MONS
	ld b, FILL_PC_MAX_MONS ; b is the budget throughout, and survives .StoreOne on the stack
endc
if FILL_PC_FORM_SPECIES_ONLY
	ld hl, .FormCounts
.species_loop
	ld a, [hli]
	ld d, a ; species index; NUM_POKEMON fits in a byte, so the high byte is always zero
	inc hl
	and a
	ret z ; the terminator
	ld a, [hli]
	ld c, a ; c = how many forms this species has

	ld e, 0
.form_loop
	push hl
	push bc
	call .StoreOne
	pop bc
	pop hl
	ret nc ; the storage system is full
if FILL_PC_MAX_MONS
	dec b
	ret z ; the budget is spent
endc

	inc e
	ld a, c
	cp e
	jr nz, .form_loop
	jr .species_loop

else
	ld d, FILL_PC_FIRST_SPECIES
.species_loop
if !FILL_PC_ALL_UNOWN_LETTERS
	ld a, d
	cp LOW(UNOWN) ; PlayersHouse2F records that storing Unown this early can crash
	jr z, .next_species
endc
	ld e, 0
.form_loop
	push bc
	call .StoreOne
	pop bc
	ret nc ; the storage system is full
if FILL_PC_MAX_MONS
	dec b
	ret z ; the budget is spent
endc

	push bc
	ld l, d
	ld h, 0
	call .GetFormCount
	pop bc
	inc e
	cp e
	jr nz, .form_loop

.next_species
	inc d
	ld a, d
	cp FILL_PC_LAST_SPECIES + 1
	jr nz, .species_loop
	ret
endc

.StoreOne:
; in: d = species index, e = cosmetic form. Returns carry if the mon was stored. Preserves de.
	push de
	ld l, d
	ld h, 0
	call GetPokemonIDFromIndex ; hl = index, out a = the 8-bit handle the box wants
	ld [wCurPartySpecies], a
	ld [wTempEnemyMonSpecies], a
	xor a
	ld [wMonType], a ; PARTYMON, the state GivePoke builds a mon in
	ld [wCurItem], a
	ld a, 5
	ld [wCurPartyLevel], a
	pop de

	push de
	farcall LoadEnemyMon ; SendMonIntoBox builds the box mon out of wEnemyMon
	pop de

; SendMonIntoBox takes the stored form from wEnemyMonForm, so set it here rather than correcting
; it afterwards. Re-running UpdateStorageBoxMonFromTemp to fix the form would erase and reallocate
; the database entry SendMonIntoBox just made. This is also the fix for a gifted Unown's wrong
; letter -- GivePoke stamps wForm after the fact and hits exactly that problem.
	push de
	ld a, e
	ld [wEnemyMonForm], a
	farcall SendMonIntoBox
	pop de
	ret

if !FILL_PC_FORM_SPECIES_ONLY
.GetFormCount:
; in: hl = species index. out: a = how many forms to sweep, at least 1. Preserves de.
; Every other per-form table is indexed by species and says nothing about its own length, so the
; counts live here rather than being derived from one of them.
if !FILL_PC_INCLUDE_FORMS
	ld a, 1
	ret
else
	push de
	ld de, .FormCounts
.lookup_loop
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	or c
	jr z, .no_forms ; the terminator
	ld a, c
	cp l
	jr nz, .next_entry
	ld a, b
	cp h
	jr nz, .next_entry
	ld a, [de]
	pop de
	ret

.next_entry
	inc de ; step over the count
	jr .lookup_loop

.no_forms
	ld a, 1
	pop de
	ret
endc
endc

.FormCounts:
; Ordered so a one-box budget still reaches every species here. Magikarp leads because it is the
; one species LoadEnemyMon has a form branch for -- a DV reroll loop that jumps backwards -- so
; if the sweep is going to die on a form, it dies first. Smeargle trails because it has the most
; forms and is the one worth truncating.
	dwb MAGIKARP, NUM_MAGIKARP_FORMS ; 3, running total 3
	dwb PIKACHU,  NUM_PIKACHU_FORMS  ; 4, running total 7
	dwb SCYTHER,  NUM_SCYTHER_FORMS  ; 3, running total 10
	dwb SCIZOR,   NUM_SCIZOR_FORMS   ; 3, running total 13
	dwb PINSIR,   NUM_PINSIR_FORMS   ; 3, running total 16
	dwb SHUCKLE,  NUM_SHUCKLE_FORMS  ; 3, running total 19
	dwb SMEARGLE, NUM_SMEARGLE_FORMS ; 6, and the budget stops it after the first
if FILL_PC_ALL_UNOWN_LETTERS
	dwb UNOWN,    NUM_UNOWN
endc
	dw 0

GiveDebugDolls::
; Unlock the Pokemon dolls whose species have cosmetic forms, so the doll objects in the player's
; room can be used to see what form a SPRITE_POKEMON map object actually draws. Reach it with
;   callasm GiveDebugDolls
; then place one from the PC's Decoration menu -- it resolves through SPRITE_DOLL_1 / SPRITE_DOLL_2
; into the SpriteMons entry for that species.
;
; The test: make a Pikachu with a cosmetic form your follower, then look at the Pikachu doll. The
; map object path leaves wForm alone, so if the doll comes out surfing or flying rather than plain,
; the follower's form byte leaked into it.
	ld hl, .Flags
.loop
	ld a, [hli]
	cp -1
	ret z
	ld c, a
	push hl
	farcall SetSpecificDecorationFlag
	pop hl
	jr .loop

.Flags:
	db DECOFLAG_PIKACHU_DOLL      ; four forms, and the plain icon is unmistakable
	db DECOFLAG_SURF_PIKACHU_DOLL ; its own sprite, not a SpriteMons entry -- the control
	db DECOFLAG_MAGIKARP_DOLL     ; three size forms
	db DECOFLAG_UNOWN_DOLL        ; 26 letters, so any leak is obvious
	db -1

endc
