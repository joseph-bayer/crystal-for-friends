; The Pokegear map and the Fly map slide from one region to the other, instead of the new one just
; appearing: going to Kanto the map comes in from the right, and going to Johto from the left. The
; header rows at the top (wMapScrollHeaderRows: the Pokegear's card tabs and landmark name, the Fly
; map's Where? bubble) hold still, and change to the new region's once the slide is over.
;
; Both maps already keep two BG maps: BG Map 0 as the background, BG Map 1 as the window, and draw a
; new map into the one not on screen before showing it. The window shows BG Map 1 from screen x
; WX - 7 to the right edge, so with the old map in one and the new map in the other, moving the
; window's edge and the background's scroll together slides them like one strip:
; - from the right, the new map is the window: SCX = s, WX = 167 - s;
; - from the left, the new map is the background: SCX = 160 - s, WX = 7 + s.
; The window always starts at the top of the screen (it draws BG Map 1 from its own top row, so
; starting it lower would push its map down), and WX is set per scanline through wLYOverrides: over
; the whole width on the header's lines, sliding below them. So the header shows BG Map 1's top
; rows; when the new map is the one in BG Map 1, the old header is put back there for the slide.

DEF MAP_SCROLL_WX_LEFT_EDGE EQU 7 ; the window's left edge on the screen's
DEF MAX_MAP_SCROLL_HEADER_ROWS EQU 3

; The old map's header rows, kept while the new map is drawn: tiles, then attributes. In the
; scanline table the slide doesn't use, in BANK(wLYOverrides).
DEF wMapScrollOldHeader EQUS "wLYOverridesBackup"
DEF wMapScrollOldHeaderAttrs EQUS "(wLYOverridesBackup + MAX_MAP_SCROLL_HEADER_ROWS * SCREEN_WIDTH)"
assert 2 * MAX_MAP_SCROLL_HEADER_ROWS * SCREEN_WIDTH <= wLYOverridesBackupEnd - wLYOverridesBackup

MapRegionScroll_Prepare::
; Before drawing the new region for a slide (wMapRegionScroll, wMapScrollHeaderRows): keep the old
; map's header, and make sure the old map is in the BG map the new one won't need. The new map comes
; in from the left in BG Map 0, and from the right in BG Map 1, the window. If the old one is on
; screen in that one, copy it to the other and show that instead, which looks the same. The window
; is on screen when hWY is 0.
	ldh a, [rWBK]
	push af
	ld a, BANK(wLYOverridesBackup)
	ldh [rWBK], a
	ld hl, wTilemap
	ld de, wMapScrollOldHeader
	call .CopyHeaderRows
	ld hl, wAttrmap
	ld de, wMapScrollOldHeaderAttrs
	call .CopyHeaderRows
	pop af
	ldh [rWBK], a

	ld a, [wMapRegionScroll]
	cp MAP_SCROLL_FROM_LEFT
	ldh a, [hWY]
	jr z, .from_left
	and a
	ret nz ; BG Map 0 on screen already
	ld hl, vBGMap0
	ld c, SCREEN_HEIGHT_PX ; then hide the window, showing BG Map 0
	jr .copy

.from_left
	and a
	ret z ; the window, BG Map 1, on screen already
	ld hl, vBGMap1
	ld c, 0 ; then show the window, BG Map 1
.copy
	ld a, l
	ldh [hBGMapAddress], a
	ld a, h
	ldh [hBGMapAddress + 1], a
	push bc
	ld b, 0 ; leave the palettes be
	farcall _SafeCopyTilemapAtOnce ; the screen as it is, tiles and attributes, in one frame
	pop bc
	ld a, c
	ldh [hWY], a
	ret

.CopyHeaderRows:
; the header's rows, from hl to de
	ld a, [wMapScrollHeaderRows]
.copy_row
	push af
	ld bc, SCREEN_WIDTH
	rst CopyBytes
	pop af
	dec a
	jr nz, .copy_row
	ret

MapRegionScroll_Slide::
; Slide in the new map just drawn into the BG map not on screen, if wMapRegionScroll asks for it, and
; leave it on screen: the window over everything for a map from the right, hidden for one from the
; left. Sprites should be hidden first.
	ld a, [wMapRegionScroll]
	and a
	ret z
	ld d, a ; which way
	xor a ; MAP_SCROLL_NONE
	ld [wMapRegionScroll], a
	ld a, [wMapScrollHeaderRows]
	add a
	add a
	add a ; TILE_WIDTH
	dec a ; the override for line n takes effect from line n + 1
	ld [wMapScrollHeaderLastLine], a

	ldh a, [rWBK]
	push af
	ld a, BANK(wLYOverrides) ; LCDGeneric reads it from whatever bank is in
	ldh [rWBK], a
	ldh a, [rIE]
	push af
	set B_IE_STAT, a ; LCDGeneric runs each HBlank, as for the Magnet Train
	ldh [rIE], a

	; the first frame: the old map as it is on screen
	ld a, d
	cp MAP_SCROLL_FROM_LEFT
	jr z, .start_from_left
	; The old map is the background; the new one, the window, waits past the right edge below the
	; header. On the header's lines the window shows the old header, put back in its top rows.
	push de
	ld hl, wMapScrollOldHeader
	ld de, wMapScrollOldHeaderAttrs
	call MapRegionScroll_SetWindowHeader
	pop de
	xor a
	ldh [hSCX], a
	ld e, SCREEN_WIDTH_PX + MAP_SCROLL_WX_LEFT_EDGE
	jr .got_start

.start_from_left
	; the old map is the window, over everything; the new one, the background, waits a screen to its
	; left
	ld a, SCREEN_WIDTH_PX
	ldh [hSCX], a
	ld e, MAP_SCROLL_WX_LEFT_EDGE
.got_start
	ld a, MAP_SCROLL_WX_LEFT_EDGE ; the header's lines: the window over the whole width
	ld hl, wLYOverrides
	ld bc, wLYOverridesEnd - wLYOverrides
	rst ByteFill
	ld a, e ; the window's place below the header
	call .FillBelowHeader
	ld a, MAP_SCROLL_WX_LEFT_EDGE
	ldh [hWX], a
	ld a, LOW(rWX)
	ldh [hLCDCPointer], a
	xor a
	ldh [hWY], a

	ld hl, .Offsets
.frame
	ld a, [hli]
	ld e, a ; how far it has slid
	push hl
	; the background's scroll, taken up at the coming VBlank
	ld a, d
	cp MAP_SCROLL_FROM_LEFT
	jr z, .frame_from_left
	ld a, e
	ldh [hSCX], a
	ld a, SCREEN_WIDTH_PX + MAP_SCROLL_WX_LEFT_EDGE
	sub e ; the window's place below the header
	jr .delay

.frame_from_left
	ld a, SCREEN_WIDTH_PX
	sub e
	ldh [hSCX], a
	ld a, MAP_SCROLL_WX_LEFT_EDGE
	add e ; the window's place below the header
.delay
	push af
	call DelayFrame
	pop af
	; still in VBlank: the lines below the header, for the same frame
	call .FillBelowHeader
	pop hl
	ld a, e
	cp SCREEN_WIDTH_PX
	jr nz, .frame ; until it has slid a whole screen

	; show the new map whole, header and all, then stop overriding once that has been taken up
	ld a, d
	cp MAP_SCROLL_FROM_LEFT
	jr z, .end_from_left
	push de
	ld hl, wTilemap ; the new header, into the window's top rows
	ld de, wAttrmap
	call MapRegionScroll_SetWindowHeader
	pop de
	xor a ; the window, over everything
	jr .got_wy

.end_from_left
	ld a, SCREEN_HEIGHT_PX ; the background: hide the window
.got_wy
	ldh [hWY], a
	xor a
	ldh [hSCX], a
	call DelayFrame
	xor a
	ldh [hLCDCPointer], a

	pop af
	ldh [rIE], a
	pop af
	ldh [rWBK], a
	ret

.FillBelowHeader:
; a = the window's place on every line below the header
	push de
	ld e, a
	ld a, [wMapScrollHeaderLastLine]
	ld c, a
	ld b, 0
	ld hl, wLYOverrides
	add hl, bc
	ld a, SCREEN_HEIGHT_PX
	sub c
	ld c, a ; b = 0
	ld a, e
	rst ByteFill
	pop de
	ret

.Offsets:
; How far the map has slid after each frame: a third of a second, slowing at the end (quadratic
; ease-out). 159 is skipped: it would put the window at WX 166, which glitches on hardware.
	db 15, 30, 44, 57, 70, 81, 92, 102, 111, 120, 127, 134, 140, 145, 150, 153, 156, 158, SCREEN_WIDTH_PX

MapRegionScroll_SetWindowHeader:
; Copy the header's rows into the top of BG Map 1, the window: tiles from hl, attributes from de.
; Each byte waits until VRAM can be written, as the window may be on screen, with interrupts off so
; nothing comes between the wait and the write. Where this is called, every line has the same WX, so
; LCDGeneric missing a few lines changes nothing.
	push de
	di
	xor a
	ldh [rVBK], a
	call .Rows
	pop hl
	ld a, 1
	ldh [rVBK], a
	call .Rows
	xor a
	ldh [rVBK], a
	reti

.Rows:
	ld de, vBGMap1
	ld a, [wMapScrollHeaderRows]
.row
	push af
	ld c, SCREEN_WIDTH
.byte
	ld a, [hli]
	ld b, a
.wait
	ldh a, [rSTAT]
	and STAT_BUSY
	jr nz, .wait
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .byte
	ld a, e
	add TILEMAP_WIDTH - SCREEN_WIDTH
	ld e, a
	adc d
	sub e
	ld d, a
	pop af
	dec a
	jr nz, .row
	ret
