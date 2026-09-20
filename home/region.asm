IsInJohto::
; Return 0 if the player is in Johto, and 1 in Kanto.

	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocationOrBackup

	cp LANDMARK_FAST_SHIP
	jr z, .Johto

	cp KANTO_LANDMARK
	jr nc, .Kanto

.Johto:
	xor a ; JOHTO_REGION
	ret

.Kanto:
	ld a, KANTO_REGION
	ret
