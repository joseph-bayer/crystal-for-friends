; copy bc bytes from hl to de
_CopyBytes::
	inc b ; we bail the moment b hits 0, so include the last run

	srl c
	jr nc, .skip1
	ld a, [hli]
	ld [de], a
	inc de

.skip1
	srl c
	jr nc, .skip2
rept 2
	ld a, [hli]
	ld [de], a
	inc de
endr

.skip2
	jr z, .next
.loop
rept 4
	ld a, [hli]
	ld [de], a
	inc de
endr

	dec c
	jr nz, .loop

.next
	dec b
	ret z

	ld c, $40
	jr .loop

SwapBytes::
; swap bc bytes between hl and de
.Loop:
	; stash [hl] away on the stack
	ld a, [hl]
	push af

	; copy a byte from [de] to [hl]
	ld a, [de]
	ld [hli], a

	; retrieve the previous value of [hl]; put it in [de]
	pop af
	ld [de], a
	inc de

	; handle loop stuff
	dec bc
	ld a, b
	or c
	jr nz, .Loop
	ret

_ByteFill::
; fill bc bytes with the value of a, starting at hl
	inc b ; we bail the moment b hits 0, so include the last run
	srl c
	jr nc, .skip1
	ld [hli], a

.skip1
	srl c
	jr nc, .skip2
	ld [hli], a
	ld [hli], a

.skip2
	jr z, .next
.loop
rept 4
	ld [hli], a
endr
	dec c
	jr nz, .loop

.next
	dec b
	ret z

	ld c, $40
	jr .loop

; retrieve a single byte from a:hl, and return it in a.
GetFarByte::
	; bankswitch to new bank
	ldh [hTempBank], a
	ldh a, [hROMBank]
	push af
	ldh a, [hTempBank]
	rst Bankswitch

	; get byte from new bank
	ld a, [hl]
	ldh [hFarByte], a

	; bankswitch to previous bank
	pop af
	rst Bankswitch

	; return retrieved value in a
	ldh a, [hFarByte]
	ret

GetFarWord::
; retrieve a word from a:hl, and return it in hl.
	; bankswitch to new bank
	ldh [hTempBank], a
	ldh a, [hROMBank]
	push af
	ldh a, [hTempBank]
	rst Bankswitch

	; get word from new bank, put it in hl
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; bankswitch to previous bank and return
	pop af
	rst Bankswitch
	ret

FarCopyColorWRAM::
	ld a, BANK("GBC Video")
	; fallthrough
FarCopyWRAM::
; copy bc bytes from hl to a:de
	ldh [hTempBank], a
	ldh a, [rWBK]
	push af
	ldh a, [hTempBank]
	ldh [rWBK], a

	rst CopyBytes

	pop af
	ldh [rWBK], a
	ret

GetFarWRAMByte::
; retrieve a single byte from a:hl, and return it in a.
	ldh [hTempBank], a
	ldh a, [rWBK]
	push af
	ldh a, [hTempBank]
	ldh [rWBK], a
	ld a, [hl]
	ldh [hFarByte], a
	pop af
	ldh [rWBK], a
	ldh a, [hFarByte]
	ret
