; Swarms
; Each row says which mon swarms, in which form, where, and which encounters it replaces.
; Entries correspond to the SWARM_* constants and must stay in that order.
;
; Route 35 and Dark Cave Violet Entrance belong to the two vanilla swarms and host no others: Arnie's
; and Anthony's calls announce their swarm without checking it started, which is only safe because
; nothing else can already hold those maps.
;
; A swarm does not bring its own encounter table. It substitutes into the map's own slots
; (SWARM_GRASS_SLOTS / SWARM_WATER_SLOTS), keeping the level of whichever slot it displaces, so
; a swarm is route-appropriate wherever it is put and a row can be moved without retuning.

SwarmTable::
	table_width SWARM_ENTRY_LENGTH, SwarmTable
	swarm_def DUNSPARCE, PLAIN_FORM,        DARK_CAVE_VIOLET_ENTRANCE, SWARM_GRASS
	swarm_def YANMA,     PLAIN_FORM,        ROUTE_35,                  SWARM_GRASS
; From here on, the Collection Guild's radio station picks one row a day (DailySwarmBroadcast).
	swarm_def MACHOP,    MACHOP_RB_FORM,    ROUTE_45,                  SWARM_GRASS
	swarm_def TENTACOOL, TENTACOOL_RB_FORM, VERMILION_CITY,            SWARM_WATER ; after the Elite Four
	assert_table_length NUM_SWARMS
