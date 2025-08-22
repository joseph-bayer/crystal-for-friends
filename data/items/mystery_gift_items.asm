MysteryGiftItems:
  ; Common items (index 0-15)
	dw BERRY          ; 0
	dw PRZCUREBERRY   ; 1
	dw MINT_BERRY     ; 2
	dw ICE_BERRY      ; 3
	dw BURNT_BERRY    ; 4
	dw PSNCUREBERRY   ; 5
	dw GUARD_SPEC     ; 6  TODO: Replace
	dw X_DEFEND       ; 7  TODO: Replace
	dw X_ATTACK       ; 8  TODO: Replace
	dw BITTER_BERRY   ; 9
	dw DIRE_HIT       ; 10 TODO: Replace
	dw X_SPECIAL      ; 11 TODO: Replace
	dw X_ACCURACY     ; 12 TODO: Replace
	dw EON_MAIL       ; 13
	dw MORPH_MAIL     ; 14
	dw MUSIC_MAIL     ; 15
  ; Uncommon items (index 16-23)
	dw MIRACLEBERRY   ; 16
	dw GOLD_BERRY     ; 17
	dw REVIVE         ; 18
	dw WATER_STONE    ; 19
	dw FIRE_STONE     ; 20
	dw LEAF_STONE     ; 21
	dw ELIXER         ; 22
	dw THUNDERSTONE   ; 23
  ; Rare items (index 24-31)
	dw KINGS_ROCK     ; 24
	dw METAL_COAT     ; 25
	dw DRAGON_SCALE   ; 26
	dw UP_GRADE       ; 27
	dw MOON_STONE     ; 28
	dw SUN_STONE      ; 29
	dw MAX_REVIVE     ; 30
	dw SCOPE_LENS     ; 31
  ; Super rare items (index 32-33)
	dw HP_UP          ; 32
	dw PP_UP          ; 33
  ; These might also be intended to obtain in Stadium 2, but did not work due to the broken RNG in that game?
  ; According to BlueMoonFalls and Bulbapedia, the BLUESKY_MAIL and MIRAGE_MAIL were only available via the Mobile Adapter GB in Japan.
	dw RARE_CANDY    ; 34
	dw BLUESKY_MAIL  ; 35
	dw MIRAGE_MAIL   ; 36
.End
