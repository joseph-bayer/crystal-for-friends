UpdateUnownDex:
	; DEBUG: complete unown dex
	; ld hl, wUnownDex
	; ld a, 0
	; ld [hli], a
	; ld a, 1
	; ld [hli], a
	; ld a, 2
	; ld [hli], a
	; ld a, 3
	; ld [hli], a
	; ld a, 4
	; ld [hli], a
	; ld a, 5
	; ld [hli], a
	; ld a, 6
	; ld [hli], a
	; ld a, 7
	; ld [hli], a
	; ld a, 8
	; ld [hli], a
	; ld a, 9
	; ld [hli], a
	; ld a, 10
	; ld [hli], a
	; ld a, 11
	; ld [hli], a
	; ld a, 12
	; ld [hli], a
	; ld a, 13
	; ld [hli], a
	; ld a, 14
	; ld [hli], a
	; ld a, 15
	; ld [hli], a
	; ld a, 16
	; ld [hli], a
	; ld a, 17
	; ld [hli], a
	; ld a, 18
	; ld [hli], a
	; ld a, 19
	; ld [hli], a
	; ld a, 20
	; ld [hli], a
	; ld a, 21
	; ld [hli], a
	; ld a, 22
	; ld [hli], a
	; ld a, 23
	; ld [hli], a
	; ld a, 24
	; ld [hli], a
	; ld a, 25
	; ld [hli], a
	; ld a, -1
	; ld [hl], a

	ld a, [wForm]
	and FORM_MASK ; only care about form bits, not shiny bit
	ld c, a
	ld b, NUM_UNOWN
	ld hl, wUnownDex
.loop
	ld a, [hli]
	cp -1
	jr z, .done
	cp c
	ret z
	dec b
	jr nz, .loop
	ret

.done
	dec hl
	ld [hl], c
	inc hl
	ld [hl], -1 ; terminator for counting caught unown. (0 used to be terminator, but now 0 means Unown A is caught after we changed forms to be 0-indexed)
	ret

PrintUnownWord:
	hlcoord 4, 15
	ld bc, 12
	ld a, " "
	rst ByteFill
	ld a, [wDexCurUnownIndex]
	ld e, a
	ld d, 0
	ld hl, wUnownDex
	add hl, de
	ld a, [hl]
	ld e, a
	ld d, 0
	ld hl, UnownWords
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	hlcoord 4, 15
.loop
	ld a, [de]
	cp -1
	ret z
	inc de
	ld [hli], a
	jr .loop

INCLUDE "data/pokemon/unown_words.asm"
