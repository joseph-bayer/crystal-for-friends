; Shipwreck Beach (maps/ShipwreckBeach.asm): its dig spots, and what a dig gives.
; The spots' event flags are EVENT_SHIPWRECK_DIG_SPOT_1.. in constants/event_flags.asm.

DEF SHIPWRECK_DIG_SPOTS      EQU 10 ; candidate spots on the island
DEF SHIPWRECK_SPOTS_PER_TRIP EQU 3  ; how many of them hold something each trip

; Blocks for a dig spot: the sand block with an X in its top-left quarter, which is the square every
; spot is on.
DEF SHIPWRECK_X_BLOCK    EQU $34
DEF SHIPWRECK_SAND_BLOCK EQU $01
