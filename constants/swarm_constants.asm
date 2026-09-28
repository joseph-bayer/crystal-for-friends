; Swarms
; One row of SwarmTable (data/wild/swarms.asm) per constant, in the same order.
;
; The ids are 1-based because wActiveSwarms stores them directly and uses 0 for an empty slot.

; Which encounters a swarm replaces. A grass swarm never touches a map's surf slots or its
; swimming overworld mon, and a water swarm never touches its grass ones. Fishing is a separate
; mechanism (wFishingSwarmFlag) and is not swarmed either way.
	const_def
	const SWARM_GRASS ; 0
	const SWARM_WATER ; 1

	const_def 1
; The two vanilla swarms, kept because their phone calls still start them. They are enumerated
; first so that FIRST_STUDIED_SWARM can exclude them from the Collection Guild's milestones
; without a flag on every row.
	const SWARM_DUNSPARCE ; 1
	const SWARM_YANMA     ; 2
DEF FIRST_STUDIED_SWARM EQU const_value
; Everything below counts towards the Guild. Append only -- the Guild's record is a bitfield
; indexed by these ids, so inserting a row would shift every later player's progress.
	const SWARM_MACHOP_RB    ; 3
	const SWARM_TENTACOOL_RB ; 4
DEF NUM_SWARMS EQU const_value - 1

DEF MAX_ACTIVE_SWARMS EQU 3 ; Arnie's call, Anthony's call, and the radio's daily roll

; How much of a swarming map's encounters the swarm takes. It substitutes into the map's own
; slots rather than bringing a table of its own, and those slots have fixed odds (see
; data/wild/probabilities.asm), so the rate is expressed as which slots it takes. The assert
; beside each probability table checks the masks still add up to this if either is retuned.
; For comparison: the vanilla Dunsparce swarm was 40%, and Yanma's 30%.
DEF SWARM_ENCOUNTER_RATE EQU 60 ; percent
DEF SWARM_GRASS_SLOTS EQU %00000011 ; slots 0-1, 30% + 30%
DEF SWARM_WATER_SLOTS EQU %00000001 ; slot 0, 60%

; Set to TRUE to make every swarm mon shiny in a _DEBUG build, grass and overworld alike. Only
; the swarm's own mon are affected, so the route's other mon double as a control.
DEF SWARM_DEBUG_FORCE_SHINY EQU FALSE

; After a battle against a swarm's wandering mon, a rerolled mon that would respawn within this
; many tiles of the player is left out of that reload. 0 is the player's own tile, which is all
; the instant-battle hazard needs -- a battle only starts from the same tile
; (OW_MON_TRIGGER_DISTANCE). Wider would often suppress the very mon you just fought, since it
; had wandered close to its own spawn point.
DEF SWARM_RESPAWN_MARGIN EQU 0
