CanLearnTMHMMove:
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wBaseTMHM
	push hl

	ld a, [wPutativeTMHMMove]
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	ld hl, TMHMMoves
.loop
	ld a, [hli]
	or [hl]
	jr z, .end
	dec hl
	ld a, [hli]
	cp c
	ld a, [hli]
	jr nz, .loop
	cp b
	jr nz, .loop

	ld a, l
	sub LOW(TMHMMoves + 2)
	rrca
	ld c, a
	pop hl
	ld b, CHECK_FLAG
	push de
	ld d, 0
	predef SmallFarFlagAction
	pop de
	ret

.end
	pop hl
	ld c, 0
	ret

CanUseFieldMoveByLearning::
; For CheckPartyMove: can field move [wPutativeTMHMMove] be used by a mon that only *learns* it?
; Only the HMs and Rock Smash. An HM needs its HM in the pack (HMs are never used up). Rock Smash
; needs TM08 to have been received once: TMs are used up when taught, so a count would lapse.
; out: carry if not
	ld a, [wPutativeTMHMMove]
	call GetMoveIndexFromID
	ld a, l
	cp LOW(ROCK_SMASH)
	jr nz, .not_rock_smash
	ld a, h
	cp HIGH(ROCK_SMASH)
	jr nz, .not_rock_smash
	ld de, EVENT_GOT_TM08_ROCK_SMASH
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret nz
	scf
	ret

.not_rock_smash
	ld a, [wPutativeTMHMMove]
	call IsHMMove
	ccf
	ret c ; not an HM, so it has to be known
; Find its slot in TMHMMoves, which is also its slot in wTMsHMs.
	ld a, [wPutativeTMHMMove]
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	ld hl, TMHMMoves
	ld e, 0
.loop
	ld a, [hli]
	cp c
	ld a, [hli]
	jr nz, .next
	cp b
	jr z, .found
.next
	inc e
	jr .loop

.found
	ld d, 0
	ld hl, wTMsHMs
	add hl, de
	ld a, [hl]
	and a
	ret nz ; own it
	scf
	ret

GetTMHMMove:
	ld a, [wTempTMHM]
	dec a
	add a
	ld hl, TMHMMoves
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetMoveIDFromIndex
	ld [wTempTMHM], a
	ret

INCLUDE "data/moves/tmhm_moves.asm"
