MACRO mon_prob
; percent, index
	db \1, \2 * 3
	DEF MON_PROB_THRESHOLD_\2 = \1 ; for assert_swarm_share
ENDM

MACRO assert_swarm_share
; Checks that the slots a swarm takes from the table just defined add up to
; SWARM_ENCOUNTER_RATE, so retuning the rate or a mask can't drift out of step silently.
;\1: the number of slots in that table
;\2: the mask of slots a swarm takes from it
	DEF _swarm_share = 0
	DEF _prev_threshold = 0
	FOR _slot, \1
		if (\2) & (1 << _slot)
			DEF _swarm_share += MON_PROB_THRESHOLD_{d:_slot} - _prev_threshold
		endc
		DEF _prev_threshold = MON_PROB_THRESHOLD_{d:_slot}
	ENDR
	assert _swarm_share == SWARM_ENCOUNTER_RATE, \
		"\2 takes {d:_swarm_share}% of encounters, not SWARM_ENCOUNTER_RATE ({d:SWARM_ENCOUNTER_RATE}%)"
ENDM

GrassMonProbTable:
	table_width 2
	mon_prob 30,  0 ; 30% chance
	mon_prob 60,  1 ; 30% chance
	mon_prob 80,  2 ; 20% chance
	mon_prob 90,  3 ; 10% chance
	mon_prob 95,  4 ;  5% chance
	mon_prob 99,  5 ;  4% chance
	mon_prob 100, 6 ;  1% chance
	assert_table_length NUM_GRASSMON
	assert_swarm_share NUM_GRASSMON, SWARM_GRASS_SLOTS

WaterMonProbTable:
	table_width 2
	mon_prob 60,  0 ; 60% chance
	mon_prob 90,  1 ; 30% chance
	mon_prob 100, 2 ; 10% chance
	assert_table_length NUM_WATERMON
	assert_swarm_share NUM_WATERMON, SWARM_WATER_SLOTS
