INCLUDE "constants.asm"


SECTION "Evolutions and Attacks", ROMX

; Evos+attacks data structure:
; - Evolution methods:
;    * db EVOLVE_LEVEL, level, species
;    * db EVOLVE_ITEM, used item, species
;    * db EVOLVE_TRADE, held item (or -1 for none), species
;    * db EVOLVE_HAPPINESS, TR_* constant (ANYTIME, MORNDAY, NITE), species
;    * db EVOLVE_STAT, level, ATK_*_DEF constant (LT, GT, EQ), species
; - db 0 ; no more evolutions
; - Learnset (in increasing level order):
;    * db level, move
; - db 0 ; no more level-up moves

INCLUDE "data/pokemon/evos_attacks_pointers.asm"

BulbasaurEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, IVYSAUR
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, GROWL
	dbw 7, LEECH_SEED
	dbw 10, VINE_WHIP
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 20, RAZOR_LEAF
	dbw 25, SWEET_SCENT
	dbw 32, GROWTH
	dbw 39, SYNTHESIS
	dbw 46, SOLARBEAM
	db 0 ; no more level-up moves

IvysaurEvosAttacks:
	dbbw EVOLVE_LEVEL, 32, VENUSAUR
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 7, LEECH_SEED
	dbw 10, VINE_WHIP
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 20, RAZOR_LEAF
	dbw 25, SWEET_SCENT
	dbw 32, GROWTH
	dbw 39, SYNTHESIS
	dbw 46, SOLARBEAM
	db 0 ; no more level-up moves

VenusaurEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, LEECH_SEED
	dbw 1, VINE_WHIP
	dbw 15, POISONPOWDER
	dbw 15, SLEEP_POWDER
	dbw 20, RAZOR_LEAF
	dbw 25, SWEET_SCENT
	dbw 32, GROWTH
	dbw 39, SYNTHESIS
	dbw 45, BODY_SLAM
	dbw 46, SOLARBEAM
	dbw 50, ANCIENTPOWER
	db 0 ; no more level-up moves

CharmanderEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, CHARMELEON
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, GROWL
	dbw 7, EMBER
	dbw 13, SMOKESCREEN
	dbw 15, RAGE
	dbw 19, FLAME_WHEEL
	dbw 24, FIRE_SPIN
	dbw 27, SCARY_FACE
	dbw 34, FLAMETHROWER
	dbw 40, SLASH
	dbw 44, BODY_SLAM
	dbw 48, DRAGON_RAGE
	dbw 52, FIRE_BLAST
	db 0 ; no more level-up moves

CharmeleonEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, CHARIZARD
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, GROWL
	dbw 1, EMBER
	dbw 13, SMOKESCREEN
	dbw 15, RAGE
	dbw 19, FLAME_WHEEL
	dbw 24, FIRE_SPIN
	dbw 27, SCARY_FACE
	dbw 34, FLAMETHROWER
	dbw 40, SLASH
	dbw 44, BODY_SLAM
	dbw 48, DRAGON_RAGE
	dbw 52, FIRE_BLAST
	db 0 ; no more level-up moves

CharizardEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, GROWL
	dbw 1, EMBER
	dbw 1, SMOKESCREEN
	dbw 15, RAGE
	dbw 19, FLAME_WHEEL
	dbw 24, FIRE_SPIN
	dbw 27, SCARY_FACE
	dbw 34, FLAMETHROWER
	dbw 36, WING_ATTACK
	dbw 40, SLASH
	dbw 45, BODY_SLAM
	dbw 48, OUTRAGE
	dbw 52, FIRE_BLAST
	db 0 ; no more level-up moves

SquirtleEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, WARTORTLE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, TAIL_WHIP
	dbw 7, BUBBLE
	dbw 10, WITHDRAW
	dbw 13, WATER_GUN
	dbw 18, BITE
	dbw 23, RAPID_SPIN
	dbw 29, PROTECT
	dbw 35, RAIN_DANCE
	dbw 41, BODY_SLAM
	dbw 47, ICE_BEAM
	dbw 51, SKULL_BASH
	dbw 56, HYDRO_PUMP
	db 0 ; no more level-up moves

WartortleEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, BLASTOISE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, BUBBLE
	dbw 10, WITHDRAW
	dbw 13, WATER_GUN
	dbw 18, BITE
	dbw 23, RAPID_SPIN
	dbw 29, PROTECT
	dbw 35, RAIN_DANCE
	dbw 41, BODY_SLAM
	dbw 47, ICE_BEAM
	dbw 51, SKULL_BASH
	dbw 56, HYDRO_PUMP
	db 0 ; no more level-up moves

BlastoiseEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, BUBBLE
	dbw 1, WITHDRAW
	dbw 13, WATER_GUN
	dbw 18, BITE
	dbw 23, RAPID_SPIN
	dbw 29, PROTECT
	dbw 35, RAIN_DANCE
	dbw 41, BODY_SLAM
	dbw 47, ICE_BEAM
	dbw 51, SKULL_BASH
	dbw 56, HYDRO_PUMP
	db 0 ; no more level-up moves

CaterpieEvosAttacks:
	dbbw EVOLVE_LEVEL, 7, METAPOD
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, STRING_SHOT
	db 0 ; no more level-up moves

MetapodEvosAttacks:
	dbbw EVOLVE_LEVEL, 10, BUTTERFREE
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, TACKLE
	dbw 1, STRING_SHOT
	dbw 7, HARDEN
	db 0 ; no more level-up moves

ButterfreeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 10, CONFUSION
	dbw 12, LEECH_LIFE
	dbw 13, POISONPOWDER
	dbw 14, STUN_SPORE
	dbw 15, SLEEP_POWDER
	dbw 18, SUPERSONIC
	dbw 23, WHIRLWIND
	dbw 28, GUST
	dbw 34, PSYBEAM
	dbw 40, SAFEGUARD
	db 0 ; no more level-up moves

WeedleEvosAttacks:
	dbbw EVOLVE_LEVEL, 7, KAKUNA
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	db 0 ; no more level-up moves

KakunaEvosAttacks:
	dbbw EVOLVE_LEVEL, 10, BEEDRILL
	db 0 ; no more evolutions
	dbw 1, HARDEN
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	dbw 7, HARDEN
	db 0 ; no more level-up moves

BeedrillEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FURY_ATTACK
	dbw 10, PIN_MISSILE
	dbw 10, RAGE
	dbw 12, FOCUS_ENERGY
	dbw 15, TWINEEDLE
	dbw 18, PURSUIT
	dbw 30, SWORDS_DANCE
	dbw 40, AGILITY
	db 0 ; no more level-up moves

PidgeyEvosAttacks:
	dbbw EVOLVE_LEVEL, 18, PIDGEOTTO
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 5, SAND_ATTACK
	dbw 7, GUST
	dbw 13, QUICK_ATTACK
	dbw 19, WHIRLWIND
	dbw 25, WING_ATTACK
	dbw 30, MUD_SLAP
	dbw 42, AGILITY
	dbw 47, SKY_ATTACK
	dbw 55, MIRROR_MOVE
	db 0 ; no more level-up moves

PidgeottoEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, PIDGEOT
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, SAND_ATTACK
	dbw 1, GUST
	dbw 13, QUICK_ATTACK
	dbw 19, WHIRLWIND
	dbw 25, WING_ATTACK
	dbw 30, MUD_SLAP
	dbw 42, AGILITY
	dbw 47, SKY_ATTACK
	dbw 55, MIRROR_MOVE
	db 0 ; no more level-up moves

PidgeotEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, SAND_ATTACK
	dbw 1, GUST
	dbw 1, QUICK_ATTACK
	dbw 19, WHIRLWIND
	dbw 25, WING_ATTACK
	dbw 30, MUD_SLAP
	dbw 36, EXTREMESPEED
	dbw 42, AGILITY
	dbw 47, SKY_ATTACK
	dbw 55, MIRROR_MOVE
	db 0 ; no more level-up moves

RattataEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, RATICATE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 7, QUICK_ATTACK
	dbw 13, HYPER_FANG
	dbw 20, PURSUIT
	dbw 25, FOCUS_ENERGY
	dbw 40, SUPER_FANG
	dbw 45, CRUNCH
	db 0 ; no more level-up moves

RaticateEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 1, QUICK_ATTACK
	dbw 13, HYPER_FANG
	dbw 20, SCARY_FACE
	dbw 25, FOCUS_ENERGY
	dbw 30, PURSUIT
	dbw 40, SUPER_FANG
	dbw 45, CRUNCH
	db 0 ; no more level-up moves

SpearowEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, FEAROW
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, GROWL
	dbw 7, LEER
	dbw 10, FURY_ATTACK
	dbw 15, PURSUIT
	dbw 31, MIRROR_MOVE
	dbw 37, DRILL_PECK
	dbw 43, AGILITY
	db 0 ; no more level-up moves

FearowEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, GROWL
	dbw 1, LEER
	dbw 1, FURY_ATTACK
	dbw 15, PURSUIT
	dbw 31, MIRROR_MOVE
	dbw 37, DRILL_PECK
	dbw 43, AGILITY
	db 0 ; no more level-up moves

EkansEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, ARBOK
	db 0 ; no more evolutions
	dbw 1, WRAP
	dbw 1, LEER
	dbw 9, POISON_STING
	dbw 15, BITE
	dbw 18, ACID
	dbw 25, GLARE
	dbw 27, SLUDGE
	dbw 30, SCREECH
	dbw 36, SLUDGE_BOMB
	dbw 43, HAZE
	db 0 ; no more level-up moves

ArbokEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, WRAP
	dbw 1, LEER
	dbw 1, POISON_STING
	dbw 1, BITE
	dbw 18, ACID
	dbw 22, SUBSTITUTE
	dbw 25, GLARE
	dbw 27, SLUDGE
	dbw 30, SCREECH
	dbw 36, SLUDGE_BOMB
	dbw 43, HAZE
	db 0 ; no more level-up moves

PikachuEvosAttacks:
	dbww EVOLVE_ITEM, THUNDERSTONE, RAICHU
	db 0 ; no more evolutions
	dbw 1, THUNDERSHOCK
	dbw 1, GROWL
	dbw 6, TAIL_WHIP
	dbw 8, THUNDER_WAVE
	dbw 11, QUICK_ATTACK
	dbw 15, DOUBLE_TEAM
	dbw 20, SLAM
	dbw 26, THUNDERBOLT
	dbw 33, AGILITY
	dbw 41, THUNDER
	dbw 50, LIGHT_SCREEN
	db 0 ; no more level-up moves

RaichuEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, THUNDERSHOCK
	dbw 1, GROWL
	dbw 1, TAIL_WHIP
	dbw 1, THUNDER_WAVE
	dbw 11, QUICK_ATTACK
	dbw 15, DOUBLE_TEAM
	dbw 20, SLAM
	dbw 26, THUNDERBOLT
	dbw 33, AGILITY
	dbw 41, THUNDER
	dbw 50, LIGHT_SCREEN
	db 0 ; no more level-up moves

SandshrewEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, SANDSLASH
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, FURY_SWIPES
	dbw 6, DEFENSE_CURL
	dbw 9, MUD_SLAP
	dbw 11, SAND_ATTACK
	dbw 15, ROLLOUT
	dbw 19, METAL_CLAW
	dbw 25, SLASH
	dbw 30, CUT
	dbw 35, SANDSTORM
	dbw 40, EARTHQUAKE
	db 0 ; no more level-up moves

SandslashEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, FURY_SWIPES
	dbw 6, DEFENSE_CURL
	dbw 9, MUD_SLAP
	dbw 11, SAND_ATTACK
	dbw 15, ROLLOUT
	dbw 19, METAL_CLAW
	dbw 22, DIG
	dbw 25, SLASH
	dbw 30, CUT
	dbw 35, SANDSTORM
	dbw 40, EARTHQUAKE
	dbw 48, SPIKE_CANNON
	db 0 ; no more level-up moves

NidoranFEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, NIDORINA
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 8, SCRATCH
	dbw 12, DOUBLE_KICK
	dbw 17, POISON_STING
	dbw 23, TAIL_WHIP
	dbw 30, BITE
	dbw 38, FURY_SWIPES
	db 0 ; no more level-up moves

NidorinaEvosAttacks:
	dbww EVOLVE_ITEM, MOON_STONE, NIDOQUEEN
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, TACKLE
	dbw 1, SCRATCH
	dbw 12, DOUBLE_KICK
	dbw 17, POISON_STING
	dbw 23, TAIL_WHIP
	dbw 30, BITE
	dbw 38, FURY_SWIPES
	db 0 ; no more level-up moves

NidoqueenEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, SCRATCH
	dbw 1, DOUBLE_KICK
	dbw 1, TAIL_WHIP
	dbw 23, BODY_SLAM
	dbw 27, MAGNITUDE
	dbw 36, SLUDGE_BOMB
	db 0 ; no more level-up moves

NidoranMEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, NIDORINO
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, TACKLE
	dbw 8, HORN_ATTACK
	dbw 12, DOUBLE_KICK
	dbw 17, POISON_STING
	dbw 23, FOCUS_ENERGY
	dbw 30, FURY_ATTACK
	dbw 38, HORN_DRILL
	db 0 ; no more level-up moves

NidorinoEvosAttacks:
	dbww EVOLVE_ITEM, MOON_STONE, NIDOKING
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, TACKLE
	dbw 8, HORN_ATTACK
	dbw 12, DOUBLE_KICK
	dbw 17, POISON_STING
	dbw 23, FOCUS_ENERGY
	dbw 30, FURY_ATTACK
	dbw 38, HORN_DRILL
	db 0 ; no more level-up moves

NidokingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, HORN_ATTACK
	dbw 1, DOUBLE_KICK
	dbw 1, POISON_STING
	dbw 23, THRASH
	dbw 27, MAGNITUDE
	dbw 36, SLUDGE_BOMB
	db 0 ; no more level-up moves

ClefairyEvosAttacks:
	dbww EVOLVE_ITEM, MOON_STONE, CLEFABLE
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 1, GROWL
	dbw 6, ENCORE
	dbw 8, SING
	dbw 13, DOUBLESLAP
	dbw 19, MINIMIZE
	dbw 26, DEFENSE_CURL
	dbw 30, METRONOME
	dbw 35, BODY_SLAM
	dbw 43, MOONLIGHT
	dbw 53, LIGHT_SCREEN
	db 0 ; no more level-up moves

ClefableEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 1, GROWL
	dbw 6, ENCORE
	dbw 8, SING
	dbw 13, DOUBLESLAP
	dbw 19, MINIMIZE
	dbw 26, DEFENSE_CURL
	dbw 30, METRONOME
	dbw 35, BODY_SLAM
	dbw 43, MOONLIGHT
	dbw 53, LIGHT_SCREEN
	db 0 ; no more level-up moves

VulpixEvosAttacks:
	dbww EVOLVE_ITEM, FIRE_STONE, NINETALES
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, TAIL_WHIP
	dbw 7, QUICK_ATTACK
	dbw 13, ROAR
	dbw 16, CONFUSE_RAY
	dbw 20, FLAME_WHEEL
	dbw 25, SAFEGUARD
	dbw 32, FLAMETHROWER
	dbw 37, SHADOW_BALL
	dbw 40, SUNNY_DAY
	dbw 45, FIRE_SPIN
	dbw 55, FIRE_BLAST
	db 0 ; no more level-up moves

NinetalesEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, TAIL_WHIP
	dbw 1, QUICK_ATTACK
	dbw 1, ROAR
	dbw 16, CONFUSE_RAY
	dbw 20, FLAME_WHEEL
	dbw 25, SAFEGUARD
	dbw 32, FLAMETHROWER
	dbw 37, SHADOW_BALL
	dbw 40, SUNNY_DAY
	dbw 45, FIRE_SPIN
	dbw 55, FIRE_BLAST
	db 0 ; no more level-up moves

JigglypuffEvosAttacks:
	dbww EVOLVE_ITEM, MOON_STONE, WIGGLYTUFF
	db 0 ; no more evolutions
	dbw 1, SING
	dbw 1, POUND
	dbw 6, DEFENSE_CURL
	dbw 9, CHARM
	dbw 14, DISABLE
	dbw 16, DOUBLESLAP
	dbw 19, ROLLOUT
	dbw 24, LOVELY_KISS
	dbw 29, REST
	dbw 34, BODY_SLAM
	dbw 39, DOUBLE_EDGE
	db 0 ; no more level-up moves

WigglytuffEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SING
	dbw 1, POUND
	dbw 6, DEFENSE_CURL
	dbw 9, CHARM
	dbw 14, DISABLE
	dbw 16, DOUBLESLAP
	dbw 19, ROLLOUT
	dbw 24, LOVELY_KISS
	dbw 29, REST
	dbw 34, BODY_SLAM
	dbw 39, DOUBLE_EDGE
	db 0 ; no more level-up moves

ZubatEvosAttacks:
	dbbw EVOLVE_LEVEL, 22, GOLBAT
	db 0 ; no more evolutions
	dbw 1, LEECH_LIFE
	dbw 5, SUPERSONIC
	dbw 7, GUST
	dbw 12, BITE
	dbw 19, CONFUSE_RAY
	dbw 23, WING_ATTACK
	dbw 27, SLUDGE
	dbw 36, SLUDGE_BOMB
	dbw 42, MEAN_LOOK
	dbw 48, HAZE
	db 0 ; no more level-up moves

GolbatEvosAttacks:
	dbww EVOLVE_HAPPINESS, TR_ANYTIME, CROBAT
	db 0 ; no more evolutions
	dbw 1, SCREECH
	dbw 1, LEECH_LIFE
	dbw 1, SUPERSONIC
	dbw 1, GUST
	dbw 12, BITE
	dbw 19, CONFUSE_RAY
	dbw 22, WING_ATTACK
	dbw 27, SLUDGE
	dbw 36, SLUDGE_BOMB
	dbw 42, MEAN_LOOK
	dbw 48, HAZE
	db 0 ; no more level-up moves

OddishEvosAttacks:
	dbbw EVOLVE_LEVEL, 21, GLOOM
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 7, SWEET_SCENT
	dbw 14, POISONPOWDER
	dbw 16, STUN_SPORE
	dbw 18, SLEEP_POWDER
	dbw 22, MEGA_DRAIN
	dbw 24, ACID
	dbw 32, GIGA_DRAIN
	dbw 35, MOONLIGHT
	dbw 44, PETAL_DANCE
	db 0 ; no more level-up moves

GloomEvosAttacks:
	dbww EVOLVE_ITEM, LEAF_STONE, VILEPLUME
	dbww EVOLVE_ITEM, SUN_STONE, BELLOSSOM
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, SWEET_SCENT
	dbw 1, POISONPOWDER
	dbw 16, STUN_SPORE
	dbw 18, SLEEP_POWDER
	dbw 21, MEGA_DRAIN
	dbw 24, ACID
	dbw 32, GIGA_DRAIN
	dbw 35, MOONLIGHT
	dbw 44, PETAL_DANCE
	db 0 ; no more level-up moves

VileplumeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, SWEET_SCENT
	dbw 1, POISONPOWDER
	dbw 1, STUN_SPORE
	dbw 18, SLEEP_POWDER
	dbw 21, MEGA_DRAIN
	dbw 24, ACID
	dbw 32, GIGA_DRAIN
	dbw 35, MOONLIGHT
	dbw 44, PETAL_DANCE
	db 0 ; no more level-up moves

ParasEvosAttacks:
	dbbw EVOLVE_LEVEL, 24, PARASECT
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 5, ABSORB
	dbw 7, STUN_SPORE
	dbw 13, POISONPOWDER
	dbw 16, MEGA_DRAIN
	dbw 19, LEECH_LIFE
	dbw 24, SPORE
	dbw 31, SLASH
	dbw 36, GROWTH
	dbw 40, GIGA_DRAIN
	db 0 ; no more level-up moves

ParasectEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, ABSORB
	dbw 1, STUN_SPORE
	dbw 13, POISONPOWDER
	dbw 16, MEGA_DRAIN
	dbw 19, LEECH_LIFE
	dbw 24, SPORE
	dbw 31, SLASH
	dbw 36, GROWTH
	dbw 40, GIGA_DRAIN
	db 0 ; no more level-up moves

VenonatEvosAttacks:
	dbbw EVOLVE_LEVEL, 31, VENOMOTH
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, DISABLE
	dbw 1, FORESIGHT
	dbw 9, SUPERSONIC
	dbw 13, LEECH_LIFE
	dbw 17, CONFUSION
	dbw 20, POISONPOWDER
	dbw 28, STUN_SPORE
	dbw 34, PSYBEAM
	dbw 38, SLEEP_POWDER
	dbw 43, SLUDGE_BOMB
	dbw 50, PSYCHIC_M
	db 0 ; no more level-up moves

VenomothEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, DISABLE
	dbw 1, FORESIGHT
	dbw 1, SUPERSONIC
	dbw 13, LEECH_LIFE
	dbw 17, CONFUSION
	dbw 20, POISONPOWDER
	dbw 28, STUN_SPORE
	dbw 31, GUST
	dbw 34, PSYBEAM
	dbw 38, SLEEP_POWDER
	dbw 43, SLUDGE_BOMB
	dbw 50, PSYCHIC_M
	db 0 ; no more level-up moves

DiglettEvosAttacks:
	dbbw EVOLVE_LEVEL, 26, DUGTRIO
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 5, GROWL
	dbw 9, MAGNITUDE
	dbw 17, DIG
	dbw 25, SAND_ATTACK
	dbw 33, SLASH
	dbw 41, EARTHQUAKE
	dbw 49, FISSURE
	db 0 ; no more level-up moves

DugtrioEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TRI_ATTACK
	dbw 1, SCRATCH
	dbw 1, GROWL
	dbw 1, MAGNITUDE
	dbw 17, DIG
	dbw 25, SAND_ATTACK
	dbw 33, SLASH
	dbw 41, EARTHQUAKE
	dbw 49, FISSURE
	db 0 ; no more level-up moves

MeowthEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, PERSIAN
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, GROWL
	dbw 1, BITE
	dbw 20, PAY_DAY
	dbw 28, FAINT_ATTACK
	dbw 33, SLASH
	dbw 38, SCREECH
	dbw 41, FURY_SWIPES
	dbw 46, DOUBLE_EDGE
	db 0 ; no more level-up moves

PersianEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, GROWL
	dbw 1, BITE
	dbw 11, BITE
	dbw 20, PAY_DAY
	dbw 28, FAINT_ATTACK
	dbw 33, SLASH
	dbw 38, SCREECH
	dbw 41, FURY_SWIPES
	dbw 46, DOUBLE_EDGE
	dbw 50, HYPER_BEAM
	db 0 ; no more level-up moves

PsyduckEvosAttacks:
	dbbw EVOLVE_LEVEL, 33, GOLDUCK
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 5, TAIL_WHIP
	dbw 8, WATER_GUN
	dbw 10, DISABLE
	dbw 15, CONFUSION
	dbw 17, BUBBLEBEAM
	dbw 23, SCREECH
	dbw 31, PSYCH_UP
	dbw 37, FURY_SWIPES
	dbw 42, PSYCHIC_M
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

GolduckEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 1, WATER_GUN
	dbw 1, DISABLE
	dbw 15, CONFUSION
	dbw 17, BUBBLEBEAM
	dbw 23, SCREECH
	dbw 31, PSYCH_UP
	dbw 37, FURY_SWIPES
	dbw 42, PSYCHIC_M
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

MankeyEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, PRIMEAPE
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 9, LOW_KICK
	dbw 15, KARATE_CHOP
	dbw 21, FURY_SWIPES
	dbw 27, FOCUS_ENERGY
	dbw 33, SEISMIC_TOSS
	dbw 39, CROSS_CHOP
	dbw 45, SCREECH
	dbw 51, THRASH
	db 0 ; no more level-up moves

PrimeapeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 1, LOW_KICK
	dbw 1, RAGE
	dbw 15, KARATE_CHOP
	dbw 21, FURY_SWIPES
	dbw 27, FOCUS_ENERGY
	dbw 28, RAGE
	dbw 33, SEISMIC_TOSS
	dbw 39, CROSS_CHOP
	dbw 45, SCREECH
	dbw 51, THRASH
	db 0 ; no more level-up moves

GrowlitheEvosAttacks:
	dbww EVOLVE_ITEM, FIRE_STONE, ARCANINE
	db 0 ; no more evolutions
	dbw 1, ROAR
	dbw 1, EMBER
	dbw 5, GROWL
	dbw 9, BITE
	dbw 18, LEER
	dbw 26, FLAME_WHEEL
	dbw 30, TAKE_DOWN
	dbw 35, FLAMETHROWER
	dbw 36, AGILITY
	db 0 ; no more level-up moves

ArcanineEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, AGILITY
	dbw 1, FLAME_WHEEL
	dbw 1, TAKE_DOWN
	dbw 1, BITE
	dbw 20, ROAR
	dbw 45, FLAMETHROWER
	dbw 50, EXTREMESPEED
	db 0 ; no more level-up moves

PoliwagEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, POLIWHIRL
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 5, MIST
	dbw 7, HYPNOSIS
	dbw 10, WATER_GUN
	dbw 14, DOUBLESLAP
	dbw 20, BUBBLEBEAM
	dbw 25, RAIN_DANCE
	dbw 31, BODY_SLAM
	dbw 43, BELLY_DRUM
	dbw 48, HYDRO_PUMP
	db 0 ; no more level-up moves

PoliwhirlEvosAttacks:
	dbww EVOLVE_ITEM, WATER_STONE, POLIWRATH
	dbww EVOLVE_ITEM, KINGS_ROCK, POLITOED
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, MIST
	dbw 1, HYPNOSIS
	dbw 10, WATER_GUN
	dbw 14, DOUBLESLAP
	dbw 20, BUBBLEBEAM
	dbw 25, RAIN_DANCE
	dbw 31, BODY_SLAM
	dbw 43, BELLY_DRUM
	dbw 48, HYDRO_PUMP
	db 0 ; no more level-up moves

PoliwrathEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, MIST
	dbw 1, HYPNOSIS
	dbw 1, SUBMISSION
	dbw 10, WATER_GUN
	dbw 14, DOUBLESLAP
	dbw 20, BUBBLEBEAM
	dbw 25, RAIN_DANCE
	dbw 31, BODY_SLAM
	dbw 35, SUBMISSION
	dbw 43, BELLY_DRUM
	dbw 48, HYDRO_PUMP
	dbw 51, MIND_READER
	db 0 ; no more level-up moves

AbraEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, KADABRA
	db 0 ; no more evolutions
	dbw 1, TELEPORT
	db 0 ; no more level-up moves

KadabraEvosAttacks:
	dbbw EVOLVE_LEVEL, 42, ALAKAZAM
	db 0 ; no more evolutions
	dbw 1, TELEPORT
	dbw 1, KINESIS
	dbw 1, CONFUSION
	dbw 16, CONFUSION
	dbw 18, DISABLE
	dbw 21, PSYBEAM
	dbw 26, RECOVER
	dbw 31, FUTURE_SIGHT
	dbw 38, PSYCHIC_M
	dbw 45, REFLECT
	db 0 ; no more level-up moves

AlakazamEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TELEPORT
	dbw 1, KINESIS
	dbw 1, CONFUSION
	dbw 16, CONFUSION
	dbw 18, DISABLE
	dbw 21, PSYBEAM
	dbw 26, RECOVER
	dbw 31, FUTURE_SIGHT
	dbw 38, PSYCHIC_M
	dbw 45, REFLECT
	db 0 ; no more level-up moves

MachopEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, MACHOKE
	db 0 ; no more evolutions
	dbw 1, LOW_KICK
	dbw 1, LEER
	dbw 7, FOCUS_ENERGY
	dbw 13, KARATE_CHOP
	dbw 19, SEISMIC_TOSS
	dbw 25, FORESIGHT
	dbw 31, VITAL_THROW
	dbw 43, CROSS_CHOP
	dbw 50, SCARY_FACE
	dbw 55, SUBMISSION
	db 0 ; no more level-up moves

MachokeEvosAttacks:
	dbbw EVOLVE_LEVEL, 38, MACHAMP
	db 0 ; no more evolutions
	dbw 1, LOW_KICK
	dbw 1, LEER
	dbw 1, FOCUS_ENERGY
	dbw 13, KARATE_CHOP
	dbw 19, SEISMIC_TOSS
	dbw 25, FORESIGHT
	dbw 31, VITAL_THROW
	dbw 43, CROSS_CHOP
	dbw 50, SCARY_FACE
	dbw 55, SUBMISSION
	db 0 ; no more level-up moves

MachampEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LOW_KICK
	dbw 1, LEER
	dbw 1, FOCUS_ENERGY
	dbw 1, KARATE_CHOP
	dbw 19, SEISMIC_TOSS
	dbw 25, FORESIGHT
	dbw 31, VITAL_THROW
	dbw 43, CROSS_CHOP
	dbw 50, SCARY_FACE
	dbw 55, SUBMISSION
	db 0 ; no more level-up moves

BellsproutEvosAttacks:
	dbbw EVOLVE_LEVEL, 21, WEEPINBELL
	db 0 ; no more evolutions
	dbw 1, VINE_WHIP
	dbw 6, GROWTH
	dbw 11, WRAP
	dbw 15, SLEEP_POWDER
	dbw 17, POISONPOWDER
	dbw 19, STUN_SPORE
	dbw 21, RAZOR_LEAF
	dbw 23, ACID
	dbw 30, SLUDGE
	dbw 33, SWEET_SCENT
	dbw 41, SLUDGE_BOMB
	dbw 45, SLAM
	db 0 ; no more level-up moves

WeepinbellEvosAttacks:
	dbww EVOLVE_ITEM, LEAF_STONE, VICTREEBEL
	db 0 ; no more evolutions
	dbw 1, VINE_WHIP
	dbw 1, GROWTH
	dbw 1, WRAP
	dbw 6, GROWTH
	dbw 11, WRAP
	dbw 15, SLEEP_POWDER
	dbw 17, POISONPOWDER
	dbw 19, STUN_SPORE
	dbw 21, ACID
	dbw 23, RAZOR_LEAF
	dbw 30, SLUDGE
	dbw 33, SWEET_SCENT
	dbw 41, SLUDGE_BOMB
	dbw 45, SLAM
	db 0 ; no more level-up moves

VictreebelEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, VINE_WHIP
	dbw 1, GROWTH
	dbw 1, WRAP
	dbw 1, GROWTH
	dbw 11, WRAP
	dbw 15, SLEEP_POWDER
	dbw 17, POISONPOWDER
	dbw 19, STUN_SPORE
	dbw 21, ACID
	dbw 23, RAZOR_LEAF
	dbw 30, SLUDGE
	dbw 33, SWEET_SCENT
	dbw 41, SLUDGE_BOMB
	dbw 45, SLAM
	db 0 ; no more level-up moves

TentacoolEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, TENTACRUEL
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 6, SUPERSONIC
	dbw 10, BUBBLE
	dbw 12, CONSTRICT
	dbw 16, ACID
	dbw 20, BUBBLEBEAM
	dbw 25, SLUDGE
	dbw 30, WRAP
	dbw 37, BARRIER
	dbw 43, SCREECH
	dbw 49, HYDRO_PUMP
	db 0 ; no more level-up moves

TentacruelEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, SUPERSONIC
	dbw 1, BUBBLE
	dbw 1, CONSTRICT
	dbw 16, ACID
	dbw 20, SLUDGE
	dbw 25, BUBBLEBEAM
	dbw 30, WRAP
	dbw 37, BARRIER
	dbw 42, SLUDGE_BOMB
	dbw 47, SCREECH
	dbw 55, HYDRO_PUMP
	db 0 ; no more level-up moves

GeodudeEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, GRAVELER
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 6, DEFENSE_CURL
	dbw 11, ROCK_THROW
	dbw 16, MAGNITUDE
	dbw 21, SELFDESTRUCT
	dbw 27, HARDEN
	dbw 34, ROLLOUT
	dbw 40, ROCK_SLIDE
	dbw 45, EARTHQUAKE
	dbw 48, EXPLOSION
	db 0 ; no more level-up moves

GravelerEvosAttacks:
	dbbw EVOLVE_LEVEL, 38, GOLEM
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, DEFENSE_CURL
	dbw 1, ROCK_THROW
	dbw 16, MAGNITUDE
	dbw 21, SELFDESTRUCT
	dbw 27, HARDEN
	dbw 34, ROLLOUT
	dbw 40, ROCK_SLIDE
	dbw 45, EARTHQUAKE
	dbw 48, EXPLOSION
	db 0 ; no more level-up moves

GolemEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, DEFENSE_CURL
	dbw 1, ROCK_THROW
	dbw 1, MAGNITUDE
	dbw 21, SELFDESTRUCT
	dbw 27, HARDEN
	dbw 34, ROLLOUT
	dbw 40, ROCK_SLIDE
	dbw 45, EARTHQUAKE
	dbw 48, EXPLOSION
	db 0 ; no more level-up moves

PonytaEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, RAPIDASH
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, GROWL
	dbw 8, TAIL_WHIP
	dbw 11, EMBER
	dbw 17, STOMP
	dbw 20, FLAME_WHEEL
	dbw 25, DOUBLE_KICK
	dbw 33, FLAMETHROWER
	dbw 36, TAKE_DOWN
	dbw 39, FIRE_SPIN
	dbw 45, AGILITY
	dbw 51, FIRE_BLAST
	db 0 ; no more level-up moves

RapidashEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, TAIL_WHIP
	dbw 1, EMBER
	dbw 17, STOMP
	dbw 20, FLAME_WHEEL
	dbw 25, DOUBLE_KICK
	dbw 33, TAKE_DOWN
	dbw 36, FLAMETHROWER
	dbw 39, FIRE_SPIN
	dbw 40, FURY_ATTACK
	dbw 45, AGILITY
	dbw 51, FIRE_BLAST
	db 0 ; no more level-up moves

SlowpokeEvosAttacks:
	dbbw EVOLVE_LEVEL, 37, SLOWBRO
	dbww EVOLVE_ITEM, KINGS_ROCK, SLOWKING
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, TACKLE
	dbw 6, GROWL
	dbw 13, WATER_GUN
	dbw 18, CONFUSION
	dbw 24, DISABLE
	dbw 29, PSYBEAM
	dbw 34, HEADBUTT
	dbw 41, AMNESIA
	dbw 45, PSYCHIC_M
	db 0 ; no more level-up moves

SlowbroEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, WATER_GUN
	dbw 18, CONFUSION
	dbw 24, DISABLE
	dbw 29, PSYBEAM
	dbw 34, HEADBUTT
	dbw 37, WITHDRAW
	dbw 41, AMNESIA
	dbw 45, PSYCHIC_M
	db 0 ; no more level-up moves

MagnemiteEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, MAGNETON
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 6, THUNDERSHOCK
	dbw 11, SUPERSONIC
	dbw 16, SONICBOOM
	dbw 21, THUNDER_WAVE
	dbw 25, SPARK
	dbw 33, SWIFT
	dbw 37, THUNDERBOLT
	dbw 40, LOCK_ON
	dbw 43, SCREECH
	dbw 51, ZAP_CANNON
	db 0 ; no more level-up moves

MagnetonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, THUNDERSHOCK
	dbw 1, SUPERSONIC
	dbw 1, SONICBOOM
	dbw 21, THUNDER_WAVE
	dbw 25, SPARK
	dbw 33, TRI_ATTACK
	dbw 37, THUNDERBOLT
	dbw 40, LOCK_ON
	dbw 43, SCREECH
	dbw 51, ZAP_CANNON
	db 0 ; no more level-up moves

FarfetchDEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 7, SAND_ATTACK
	dbw 13, LEER
	dbw 19, FURY_ATTACK
	dbw 25, SWORDS_DANCE
	dbw 31, AGILITY
	dbw 35, SLASH
	dbw 40, FALSE_SWIPE
	dbw 45, BATON_PASS
	db 0 ; no more level-up moves

DoduoEvosAttacks:
	dbbw EVOLVE_LEVEL, 31, DODRIO
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, PECK
	dbw 9, PURSUIT
	dbw 13, FURY_ATTACK
	dbw 21, TRI_ATTACK
	dbw 27, RAGE
	dbw 38, DRILL_PECK
	dbw 44, AGILITY
	dbw 56, DOUBLE_EDGE
	db 0 ; no more level-up moves

DodrioEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, GROWL
	dbw 1, PURSUIT
	dbw 1, FURY_ATTACK
	dbw 9, PURSUIT
	dbw 13, FURY_ATTACK
	dbw 21, RAGE
	dbw 27, TRI_ATTACK
	dbw 38, DRILL_PECK
	dbw 44, AGILITY
	dbw 56, DOUBLE_EDGE
	db 0 ; no more level-up moves

SeelEvosAttacks:
	dbbw EVOLVE_LEVEL, 34, DEWGONG
	db 0 ; no more evolutions
	dbw 1, HEADBUTT
	dbw 1, GROWL
	dbw 5, WATER_GUN
	dbw 16, AURORA_BEAM
	dbw 21, REST
	dbw 25, BUBBLEBEAM
	dbw 32, TAKE_DOWN
	dbw 40, ICE_BEAM
	dbw 44, SAFEGUARD
	dbw 54, BLIZZARD
	db 0 ; no more level-up moves

DewgongEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HEADBUTT
	dbw 1, GROWL
	dbw 1, WATER_GUN
	dbw 1, AURORA_BEAM
	dbw 21, REST
	dbw 25, BUBBLEBEAM
	dbw 32, TAKE_DOWN
	dbw 40, ICE_BEAM
	dbw 44, SAFEGUARD
	dbw 54, BLIZZARD
	db 0 ; no more level-up moves

GrimerEvosAttacks:
	dbbw EVOLVE_LEVEL, 38, MUK
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, POUND
	dbw 5, HARDEN
	dbw 10, DISABLE
	dbw 16, SLUDGE
	dbw 23, MINIMIZE
	dbw 31, SCREECH
	dbw 38, SLUDGE_BOMB
	dbw 45, ACID_ARMOR
	db 0 ; no more level-up moves

MukEvosAttacks:
	db 0 ; no more evolutions
	; moves are not sorted by level
	dbw 1, POISON_GAS
	dbw 1, POUND
	dbw 1, HARDEN
	dbw 1, DISABLE
	dbw 16, SLUDGE
	dbw 23, MINIMIZE
	dbw 31, SCREECH
	dbw 38, SLUDGE_BOMB
	dbw 45, ACID_ARMOR
	db 0 ; no more level-up moves

ShellderEvosAttacks:
	dbww EVOLVE_ITEM, WATER_STONE, CLOYSTER
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, WITHDRAW
	dbw 9, SUPERSONIC
	dbw 17, AURORA_BEAM
	dbw 25, PROTECT
	dbw 33, LEER
	dbw 35, CLAMP
	dbw 37, ICE_BEAM
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

CloysterEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, WITHDRAW
	dbw 1, SUPERSONIC
	dbw 1, AURORA_BEAM
	dbw 25, PROTECT
	dbw 33, SPIKES
	dbw 35, CLAMP
	dbw 37, ICE_BEAM
	dbw 40, SPIKE_CANNON
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

GastlyEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, HAUNTER
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, LICK
	dbw 6, SMOG
	dbw 8, SPITE
	dbw 13, MEAN_LOOK
	dbw 16, CURSE
	dbw 21, NIGHT_SHADE
	dbw 28, CONFUSE_RAY
	dbw 33, DREAM_EATER
	dbw 36, DESTINY_BOND
	db 0 ; no more level-up moves

HaunterEvosAttacks:
	dbbw EVOLVE_LEVEL, 42, GENGAR
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, LICK
	dbw 1, SMOG
	dbw 8, SPITE
	dbw 13, MEAN_LOOK
	dbw 16, CURSE
	dbw 21, NIGHT_SHADE
	dbw 31, CONFUSE_RAY
	dbw 39, DREAM_EATER
	dbw 42, SHADOW_BALL
	dbw 48, DESTINY_BOND
	db 0 ; no more level-up moves

GengarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HYPNOSIS
	dbw 1, LICK
	dbw 1, SMOG
	dbw 1, SPITE
	dbw 13, MEAN_LOOK
	dbw 16, CURSE
	dbw 21, NIGHT_SHADE
	dbw 31, CONFUSE_RAY
	dbw 39, DREAM_EATER
	dbw 42, SHADOW_BALL
	dbw 48, DESTINY_BOND
	db 0 ; no more level-up moves

OnixEvosAttacks:
	dbww EVOLVE_ITEM, METAL_COAT, STEELIX
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, SCREECH
	dbw 10, BIND
	dbw 12, ROCK_THROW
	dbw 18, DIG
	dbw 23, HARDEN
	dbw 27, RAGE
	dbw 30, ROCK_SLIDE
	dbw 36, SANDSTORM
	dbw 40, EARTHQUAKE
	dbw 49, SLAM
	db 0 ; no more level-up moves

DrowzeeEvosAttacks:
	dbbw EVOLVE_LEVEL, 26, HYPNO
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 1, HYPNOSIS
	dbw 10, DISABLE
	dbw 18, CONFUSION
	dbw 25, HEADBUTT
	dbw 31, POISON_GAS
	dbw 36, MEDITATE
	dbw 40, PSYCHIC_M
	dbw 47, PSYCH_UP
	dbw 54, FUTURE_SIGHT
	db 0 ; no more level-up moves

HypnoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 1, HYPNOSIS
	dbw 1, DISABLE
	dbw 1, CONFUSION
	dbw 25, HEADBUTT
	dbw 31, POISON_GAS
	dbw 38, MEDITATE
	dbw 42, PSYCHIC_M
	dbw 47, PSYCH_UP
	dbw 54, FUTURE_SIGHT
	db 0 ; no more level-up moves

KrabbyEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, KINGLER
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 5, LEER
	dbw 12, VICEGRIP
	dbw 16, HARDEN
	dbw 23, STOMP
	dbw 27, GUILLOTINE
	dbw 29, METAL_CLAW
	dbw 37, PROTECT
	dbw 51, CRABHAMMER
	db 0 ; no more level-up moves

KinglerEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, LEER
	dbw 1, VICEGRIP
	dbw 16, HARDEN
	dbw 23, STOMP
	dbw 27, CRABHAMMER
	dbw 28, METAL_CLAW
	dbw 37, PROTECT
	dbw 44, GUILLOTINE
	dbw 51, CRABHAMMER
	db 0 ; no more level-up moves

VoltorbEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, ELECTRODE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 9, SCREECH
	dbw 17, SONICBOOM
	dbw 19, SPARK
	dbw 23, SELFDESTRUCT
	dbw 29, ROLLOUT
	dbw 34, LIGHT_SCREEN
	dbw 40, THUNDER
	dbw 44, EXPLOSION
	dbw 48, MIRROR_COAT
	db 0 ; no more level-up moves

ElectrodeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, SCREECH
	dbw 1, SONICBOOM
	dbw 1, SPARK
	dbw 23, SELFDESTRUCT
	dbw 29, ROLLOUT
	dbw 34, LIGHT_SCREEN
	dbw 40, THUNDER
	dbw 44, EXPLOSION
	dbw 48, MIRROR_COAT
	db 0 ; no more level-up moves

ExeggcuteEvosAttacks:
	dbww EVOLVE_ITEM, LEAF_STONE, EXEGGUTOR
	db 0 ; no more evolutions
	dbw 1, BARRAGE
	dbw 1, HYPNOSIS
	dbw 7, REFLECT
	dbw 13, LEECH_SEED
	dbw 19, CONFUSION
	dbw 20, MEGA_DRAIN
	dbw 25, STUN_SPORE
	dbw 25, POISONPOWDER
	dbw 28, PSYBEAM
	dbw 32, GIGA_DRAIN
	dbw 37, SLEEP_POWDER
	dbw 42, SOLARBEAM
	dbw 45, PSYCHIC_M
	db 0 ; no more level-up moves

ExeggutorEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GIGA_DRAIN
	dbw 1, BARRAGE
	dbw 1, HYPNOSIS
	dbw 1, REFLECT
	dbw 9, LEECH_SEED
	dbw 13, STOMP
	dbw 17, CONFUSION
	dbw 20, MEGA_DRAIN
	dbw 25, STUN_SPORE
	dbw 25, POISONPOWDER
	dbw 28, PSYBEAM
	dbw 32, EGG_BOMB
	dbw 37, SLEEP_POWDER
	dbw 42, SOLARBEAM
	dbw 45, PSYCHIC_M
	db 0 ; no more level-up moves

CuboneEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, MAROWAK
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 5, TAIL_WHIP
	dbw 8, BONE_CLUB
	dbw 13, HEADBUTT
	dbw 15, FALSE_SWIPE
	dbw 17, LEER
	dbw 21, FOCUS_ENERGY
	dbw 25, BONEMERANG
	dbw 32, RAGE
	dbw 37, THRASH
	dbw 41, BONE_RUSH
	db 0 ; no more level-up moves

MarowakEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, TAIL_WHIP
	dbw 1, BONE_CLUB
	dbw 13, HEADBUTT
	dbw 15, FALSE_SWIPE
	dbw 17, LEER
	dbw 21, FOCUS_ENERGY
	dbw 25, BONEMERANG
	dbw 32, RAGE
	dbw 37, THRASH
	dbw 41, BONE_RUSH
	db 0 ; no more level-up moves

HitmonleeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, DOUBLE_KICK
	dbw 20, MEDITATE
	dbw 20, ROLLING_KICK
	dbw 20, JUMP_KICK
	dbw 21, FOCUS_ENERGY
	dbw 25, FORESIGHT
	dbw 31, MIND_READER
	dbw 36, HI_JUMP_KICK
	dbw 41, ENDURE
	dbw 46, MEGA_KICK
	dbw 51, REVERSAL
	db 0 ; no more level-up moves

HitmonchanEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, COMET_PUNCH
	dbw 20, AGILITY
	dbw 20, PURSUIT
	dbw 20, MACH_PUNCH
	dbw 26, THUNDERPUNCH
	dbw 26, ICE_PUNCH
	dbw 26, FIRE_PUNCH
	dbw 32, MEGA_PUNCH
	dbw 38, DYNAMICPUNCH
	dbw 44, DETECT
	dbw 50, COUNTER
	db 0 ; no more level-up moves

LickitungEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LICK
	dbw 1, WRAP
	dbw 7, SUPERSONIC
	dbw 13, STOMP
	dbw 17, ROLLOUT
	dbw 21, SLAM
	dbw 25, CURSE
	dbw 28, DISABLE
	dbw 32, BODY_SLAM
	dbw 40, BELLY_DRUM
	dbw 43, SCREECH
	db 0 ; no more level-up moves

KoffingEvosAttacks:
	dbbw EVOLVE_LEVEL, 35, WEEZING
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, TACKLE
	dbw 9, SMOG
	dbw 15, SELFDESTRUCT
	dbw 19, SLUDGE
	dbw 23, SMOKESCREEN
	dbw 29, HAZE
	dbw 33, AMNESIA
	dbw 36, SLUDGE_BOMB
	dbw 41, EXPLOSION
	dbw 45, DESTINY_BOND
	db 0 ; no more level-up moves

WeezingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POISON_GAS
	dbw 1, TACKLE
	dbw 1, SMOG
	dbw 1, SELFDESTRUCT
	dbw 19, SLUDGE
	dbw 23, SMOKESCREEN
	dbw 29, HAZE
	dbw 33, AMNESIA
	dbw 35, SLUDGE_BOMB
	dbw 41, EXPLOSION
	dbw 45, DESTINY_BOND
	db 0 ; no more level-up moves

RhyhornEvosAttacks:
	dbbw EVOLVE_LEVEL, 42, RHYDON
	db 0 ; no more evolutions
	dbw 1, HORN_ATTACK
	dbw 1, TAIL_WHIP
	dbw 8, FURY_ATTACK
	dbw 13, STOMP
	dbw 19, ROCK_THROW
	dbw 24, MAGNITUDE
	dbw 31, SCARY_FACE
	dbw 39, EARTHQUAKE
	dbw 44, ROCK_SLIDE
	dbw 51, TAKE_DOWN
	dbw 58, HORN_DRILL
	db 0 ; no more level-up moves

RhydonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HORN_ATTACK
	dbw 1, TAIL_WHIP
	dbw 1, FURY_ATTACK
	dbw 1, STOMP
	dbw 19, ROCK_THROW
	dbw 24, MAGNITUDE
	dbw 31, SCARY_FACE
	dbw 39, EARTHQUAKE
	dbw 44, ROCK_SLIDE
	dbw 51, TAKE_DOWN
	dbw 58, HORN_DRILL
	db 0 ; no more level-up moves

ChanseyEvosAttacks:
	dbww EVOLVE_HAPPINESS, TR_ANYTIME, BLISSEY
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 4, GROWL
	dbw 7, TAIL_WHIP
	dbw 10, SOFTBOILED
	dbw 13, DOUBLESLAP
	dbw 18, MINIMIZE
	dbw 23, SING
	dbw 28, EGG_BOMB
	dbw 33, DEFENSE_CURL
	dbw 40, LIGHT_SCREEN
	dbw 47, DOUBLE_EDGE
	db 0 ; no more level-up moves

TangelaEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONSTRICT
	dbw 4, SLEEP_POWDER
	dbw 10, ABSORB
	dbw 13, POISONPOWDER
	dbw 19, VINE_WHIP
	dbw 22, MEGA_DRAIN
	dbw 25, BIND
	dbw 34, STUN_SPORE
	dbw 37, GIGA_DRAIN
	dbw 46, GROWTH
	db 0 ; no more level-up moves

KangaskhanEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, COMET_PUNCH
	dbw 7, LEER
	dbw 13, BITE
	dbw 19, TAIL_WHIP
	dbw 25, MEGA_PUNCH
	dbw 31, RAGE
	dbw 37, ENDURE
	dbw 40, BODY_SLAM
	dbw 43, DIZZY_PUNCH
	dbw 49, REVERSAL
	db 0 ; no more level-up moves

HorseaEvosAttacks:
	dbbw EVOLVE_LEVEL, 32, SEADRA
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 8, SMOKESCREEN
	dbw 13, LEER
	dbw 18, WATER_GUN
	dbw 22, BUBBLEBEAM
	dbw 29, TWISTER
	dbw 40, AGILITY
	dbw 51, HYDRO_PUMP
	db 0 ; no more level-up moves

SeadraEvosAttacks:
	dbww EVOLVE_ITEM, DRAGON_SCALE, KINGDRA
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, SMOKESCREEN
	dbw 1, LEER
	dbw 1, WATER_GUN
	dbw 22, BUBBLEBEAM
	dbw 29, TWISTER
	dbw 40, AGILITY
	dbw 51, HYDRO_PUMP
	db 0 ; no more level-up moves

GoldeenEvosAttacks:
	dbbw EVOLVE_LEVEL, 28, SEAKING
	db 0 ; no more evolutions
	dbw 1, TAIL_WHIP
	dbw 1, PECK
	dbw 5, WATER_GUN
	dbw 10, SUPERSONIC
	dbw 12, HORN_ATTACK
	dbw 15, WATERFALL
	dbw 20, FLAIL
	dbw 24, FURY_ATTACK
	dbw 30, DRILL_PECK
	dbw 35, MEGAHORN
	dbw 43, HORN_DRILL
	dbw 48, AGILITY
	dbw 53, HYDRO_PUMP
	db 0 ; no more level-up moves

SeakingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TAIL_WHIP
	dbw 1, PECK
	dbw 1, WATER_GUN
	dbw 1, SUPERSONIC
	dbw 12, HORN_ATTACK
	dbw 15, WATERFALL
	dbw 20, FLAIL
	dbw 24, FURY_ATTACK
	dbw 30, DRILL_PECK
	dbw 35, MEGAHORN
	dbw 43, HORN_DRILL
	dbw 48, AGILITY
	dbw 53, HYDRO_PUMP
	db 0 ; no more level-up moves

StaryuEvosAttacks:
	dbww EVOLVE_ITEM, WATER_STONE, STARMIE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, HARDEN
	dbw 7, WATER_GUN
	dbw 13, RAPID_SPIN
	dbw 19, RECOVER
	dbw 25, SWIFT
	dbw 27, LIGHT_SCREEN
	dbw 31, BUBBLEBEAM
	dbw 37, MINIMIZE
	dbw 40, PSYCHIC_M
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

StarmieEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, HARDEN
	dbw 1, WATER_GUN
	dbw 1, RAPID_SPIN
	dbw 19, RECOVER
	dbw 25, SWIFT
	dbw 27, LIGHT_SCREEN
	dbw 31, BUBBLEBEAM
	dbw 34, MINIMIZE
	dbw 37, CONFUSE_RAY
	dbw 40, PSYCHIC_M
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

MrMimeEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BARRIER
	dbw 6, CONFUSION
	dbw 11, SUBSTITUTE
	dbw 16, MEDITATE
	dbw 21, DOUBLESLAP
	dbw 26, LIGHT_SCREEN
	dbw 26, REFLECT
	dbw 31, ENCORE
	dbw 36, PSYBEAM
	dbw 41, BATON_PASS
	dbw 46, SAFEGUARD
	db 0 ; no more level-up moves

ScytherEvosAttacks:
	dbww EVOLVE_ITEM, METAL_COAT, SCIZOR
    db 0 ; no more evolutions
	dbw 1, QUICK_ATTACK
	dbw 1, LEER
	dbw 6, FOCUS_ENERGY
	dbw 12, PURSUIT
	dbw 16, CUT
	dbw 18, FALSE_SWIPE
	dbw 24, AGILITY
	dbw 30, WING_ATTACK
	dbw 36, SLASH
	dbw 42, TWINEEDLE
	dbw 48, DOUBLE_TEAM
	dbw 54, SWORDS_DANCE
    db 0 ; no more level-up moves

JynxEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 1, LICK
	dbw 1, LOVELY_KISS
	dbw 1, POWDER_SNOW
	dbw 13, CONFUSION
	dbw 17, ICY_WIND
	dbw 21, DOUBLESLAP
	dbw 25, ICE_PUNCH
	dbw 34, LOVELY_KISS
	dbw 36, MEAN_LOOK
	dbw 39, PSYCHIC_M
	dbw 41, BODY_SLAM
	dbw 51, PERISH_SONG
	dbw 57, BLIZZARD
	db 0 ; no more level-up moves

ElectabuzzEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, THUNDERSHOCK
	dbw 1, LEER
	dbw 1, QUICK_ATTACK
	dbw 17, SPARK
	dbw 21, LIGHT_SCREEN
	dbw 25, SWIFT
	dbw 30, THUNDERPUNCH
	dbw 36, SCREECH
	dbw 42, THUNDERBOLT
	dbw 52, THUNDER
	db 0 ; no more level-up moves

MagmarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, LEER
	dbw 1, SMOG
	dbw 17, FLAME_WHEEL
	dbw 21, SMOKESCREEN
	dbw 25, POISON_GAS
	dbw 30, FIRE_PUNCH
	dbw 33, SUNNY_DAY
	dbw 41, FLAMETHROWER
	dbw 49, CONFUSE_RAY
	dbw 57, FIRE_BLAST
	db 0 ; no more level-up moves

PinsirEvosAttacks:
    db 0 ; no more evolutions
	dbw 1, VICEGRIP
	dbw 7, FOCUS_ENERGY
	dbw 13, BIND
	dbw 19, SEISMIC_TOSS
	dbw 25, TWINEEDLE
	dbw 27, HARDEN
	dbw 31, GUILLOTINE
	dbw 37, SUBMISSION
	dbw 43, SWORDS_DANCE
	dbw 48, MEGAHORN
    db 0 ; no more level-up moves

TaurosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, TAIL_WHIP
	dbw 8, RAGE
	dbw 13, HORN_ATTACK
	dbw 19, SCARY_FACE
	dbw 23, HEADBUTT
	dbw 26, PURSUIT
	dbw 34, REST
	dbw 43, THRASH
	dbw 48, TAKE_DOWN
	dbw 58, DOUBLE_EDGE
	db 0 ; no more level-up moves

MagikarpEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, GYARADOS
	db 0 ; no more evolutions
	dbw 1, SPLASH
	dbw 15, TACKLE
	dbw 30, FLAIL
	db 0 ; no more level-up moves

GyaradosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 20, BITE
	dbw 20, GUST
	dbw 22, LEER
	dbw 25, DRAGON_RAGE
	dbw 30, THRASH
	dbw 35, TWISTER
	dbw 40, HYDRO_PUMP
	dbw 45, RAIN_DANCE
	dbw 50, HYPER_BEAM
	db 0 ; no more level-up moves

LaprasEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, WATER_GUN
	dbw 1, GROWL
	dbw 1, SING
	dbw 8, MIST
	dbw 15, BODY_SLAM
	dbw 20, ICY_WIND
	dbw 22, CONFUSE_RAY
	dbw 29, PERISH_SONG
	dbw 36, ICE_BEAM
	dbw 43, RAIN_DANCE
	dbw 50, SAFEGUARD
	dbw 57, HYDRO_PUMP
	db 0 ; no more level-up moves

DittoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TRANSFORM
	db 0 ; no more level-up moves

EeveeEvosAttacks:
	dbww EVOLVE_ITEM, THUNDERSTONE, JOLTEON
	dbww EVOLVE_ITEM, WATER_STONE, VAPOREON
	dbww EVOLVE_ITEM, FIRE_STONE, FLAREON
	dbww EVOLVE_HAPPINESS, TR_MORNDAY, ESPEON
	dbww EVOLVE_HAPPINESS, TR_NITE, UMBREON
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 8, SAND_ATTACK
	dbw 12, GROWL
	dbw 16, DOUBLE_KICK
	dbw 20, BITE
	dbw 23, QUICK_ATTACK
	dbw 30, BATON_PASS
	dbw 36, TAKE_DOWN
	db 0 ; no more level-up moves

VaporeonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 8, SAND_ATTACK
	dbw 12, GROWL
	dbw 16, DOUBLE_KICK
	dbw 20, WATER_GUN
	dbw 23, QUICK_ATTACK
	dbw 26, BUBBLEBEAM
	dbw 30, BITE
	dbw 36, AURORA_BEAM
	dbw 42, ACID_ARMOR
	dbw 47, HAZE
	dbw 52, HYDRO_PUMP
	db 0 ; no more level-up moves

JolteonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 8, SAND_ATTACK
	dbw 12, GROWL
	dbw 16, DOUBLE_KICK
	dbw 20, THUNDERSHOCK
	dbw 23, QUICK_ATTACK
	dbw 26, SPARK
	dbw 30, PIN_MISSILE
	dbw 36, THUNDERBOLT
	dbw 42, THUNDER_WAVE
	dbw 47, AGILITY
	dbw 52, THUNDER
	db 0 ; no more level-up moves

FlareonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 8, SAND_ATTACK
	dbw 12, GROWL
	dbw 16, DOUBLE_KICK
	dbw 20, EMBER
	dbw 23, QUICK_ATTACK
	dbw 26, FLAME_WHEEL
	dbw 30, BITE
	dbw 36, FLAMETHROWER
	dbw 42, FIRE_SPIN
	dbw 47, SMOG
	dbw 52, FIRE_BLAST
	db 0 ; no more level-up moves

PorygonEvosAttacks:
	dbww EVOLVE_ITEM, UP_GRADE, PORYGON2
	db 0 ; no more evolutions
	dbw 1, CONVERSION2
	dbw 1, TACKLE
	dbw 1, CONVERSION
	dbw 9, AGILITY
	dbw 12, PSYBEAM
	dbw 20, RECOVER
	dbw 24, SHARPEN
	dbw 32, LOCK_ON
	dbw 36, TRI_ATTACK
	dbw 44, ZAP_CANNON
	dbw 50, HYPER_BEAM
	db 0 ; no more level-up moves

OmanyteEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, OMASTAR
	db 0 ; no more evolutions
	dbw 1, CONSTRICT
	dbw 1, WITHDRAW
	dbw 7, WATER_GUN
	dbw 11, BITE
	dbw 14, ROCK_THROW
	dbw 18, BUBBLEBEAM
	dbw 23, LEER
	dbw 27, SPIKE_CANNON
	dbw 30, ANCIENTPOWER
	dbw 37, PROTECT
	dbw 46, HYDRO_PUMP
	db 0 ; no more level-up moves

OmastarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONSTRICT
	dbw 1, WITHDRAW
	dbw 1, WATER_GUN
	dbw 1, BITE
	dbw 14, ROCK_THROW
	dbw 18, BUBBLEBEAM
	dbw 23, LEER
	dbw 27, SPIKE_CANNON
	dbw 30, ANCIENTPOWER
	dbw 37, PROTECT
	dbw 46, HYDRO_PUMP
	db 0 ; no more level-up moves

KabutoEvosAttacks:
	dbbw EVOLVE_LEVEL, 40, KABUTOPS
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, HARDEN
	dbw 1, LEER
	dbw 7, ROCK_THROW
	dbw 14, WATER_GUN
	dbw 19, ABSORB
	dbw 25, LEER
	dbw 28, SAND_ATTACK
	dbw 30, ANCIENTPOWER
	dbw 35, MEGA_DRAIN
	dbw 37, ENDURE
	dbw 43, SWORDS_DANCE
	dbw 46, ROCK_SLIDE
	db 0 ; no more level-up moves

KabutopsEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, HARDEN
	dbw 1, ABSORB
	dbw 7, ROCK_THROW
	dbw 14, WATER_GUN
	dbw 19, ABSORB
	dbw 25, LEER
	dbw 28, SAND_ATTACK
	dbw 30, ANCIENTPOWER
	dbw 35, MEGA_DRAIN
	dbw 37, ENDURE
	dbw 40, SLASH
	dbw 43, SWORDS_DANCE
	dbw 46, ROCK_SLIDE
	db 0 ; no more level-up moves

AerodactylEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 8, AGILITY
	dbw 15, BITE
	dbw 22, SUPERSONIC
	dbw 29, ANCIENTPOWER
	dbw 32, WING_ATTACK
	dbw 36, SCARY_FACE
	dbw 40, ROCK_SLIDE
	dbw 43, TAKE_DOWN
	dbw 50, HYPER_BEAM
	db 0 ; no more level-up moves

SnorlaxEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 8, AMNESIA
	dbw 15, DEFENSE_CURL
	dbw 22, BELLY_DRUM
	dbw 29, HEADBUTT
	dbw 36, SNORE
	dbw 36, REST
	dbw 43, BODY_SLAM
	dbw 50, ROLLOUT
	dbw 57, HYPER_BEAM
	db 0 ; no more level-up moves

ArticunoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 1, POWDER_SNOW
	dbw 13, MIST
	dbw 25, AGILITY
	dbw 37, MIND_READER
	dbw 49, ICE_BEAM
	dbw 55, DRILL_PECK
	dbw 61, REFLECT
	dbw 73, BLIZZARD
	dbw 76, SKY_ATTACK
	db 0 ; no more level-up moves

ZapdosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 1, THUNDERSHOCK
	dbw 13, THUNDER_WAVE
	dbw 25, AGILITY
	dbw 37, DETECT
	dbw 49, THUNDERBOLT
	dbw 55, DRILL_PECK
	dbw 61, LIGHT_SCREEN
	dbw 73, THUNDER
	dbw 76, SKY_ATTACK
	db 0 ; no more level-up moves

MoltresEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, WING_ATTACK
	dbw 1, EMBER
	dbw 13, FIRE_SPIN
	dbw 25, AGILITY
	dbw 37, ENDURE
	dbw 49, FLAMETHROWER
	dbw 55, DRILL_PECK
	dbw 61, SAFEGUARD
	dbw 73, FIRE_BLAST
	dbw 76, SKY_ATTACK
	db 0 ; no more level-up moves

DratiniEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, DRAGONAIR
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 5, WRAP
	dbw 8, THUNDER_WAVE
	dbw 15, TWISTER
	dbw 22, DRAGON_RAGE
	dbw 29, SLAM
	dbw 35, AGILITY
	dbw 41, SAFEGUARD
	dbw 45, OUTRAGE
	dbw 54, HYPER_BEAM
	db 0 ; no more level-up moves

DragonairEvosAttacks:
	dbbw EVOLVE_LEVEL, 55, DRAGONITE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 1, WRAP
	dbw 8, THUNDER_WAVE
	dbw 15, TWISTER
	dbw 22, DRAGON_RAGE
	dbw 29, SLAM
	dbw 38, AGILITY
	dbw 47, SAFEGUARD
	dbw 50, OUTRAGE
	dbw 65, HYPER_BEAM
	db 0 ; no more level-up moves

DragoniteEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 1, WRAP
	dbw 1, THUNDER_WAVE
	dbw 15, TWISTER
	dbw 22, DRAGON_RAGE
	dbw 29, SLAM
	dbw 38, AGILITY
	dbw 47, SAFEGUARD
	dbw 55, WING_ATTACK
	dbw 56, OUTRAGE
	dbw 70, HYPER_BEAM
	db 0 ; no more level-up moves

MewtwoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONFUSION
	dbw 1, DISABLE
	dbw 11, BARRIER
	dbw 22, SWIFT
	dbw 33, PSYCH_UP
	dbw 44, FUTURE_SIGHT
	dbw 55, MIST
	dbw 66, PSYCHIC_M
	dbw 77, AMNESIA
	dbw 88, RECOVER
	dbw 99, SAFEGUARD
	db 0 ; no more level-up moves

MewEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 10, TRANSFORM
	dbw 20, MEGA_PUNCH
	dbw 30, METRONOME
	dbw 40, PSYCHIC_M
	dbw 50, ANCIENTPOWER
	db 0 ; no more level-up moves

ChikoritaEvosAttacks:
	dbbw EVOLVE_LEVEL, 16, BAYLEEF
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 6, RAZOR_LEAF
	dbw 9, LEECH_SEED
	dbw 12, REFLECT
	dbw 15, POISONPOWDER
	dbw 21, MEGA_DRAIN
	dbw 23, SYNTHESIS
	dbw 31, BODY_SLAM
	dbw 36, GIGA_DRAIN
	dbw 41, LIGHT_SCREEN
	dbw 45, SOLARBEAM
	dbw 46, SUNNY_DAY
	dbw 50, SAFEGUARD
	db 0 ; no more level-up moves

BayleefEvosAttacks:
	dbbw EVOLVE_LEVEL, 32, MEGANIUM
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, RAZOR_LEAF
	dbw 1, REFLECT
	dbw 15, POISONPOWDER
	dbw 21, MEGA_DRAIN
	dbw 23, SYNTHESIS
	dbw 31, BODY_SLAM
	dbw 36, GIGA_DRAIN
	dbw 41, LIGHT_SCREEN
	dbw 45, SOLARBEAM
	dbw 46, SUNNY_DAY
	dbw 50, SAFEGUARD
	db 0 ; no more level-up moves

MeganiumEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, RAZOR_LEAF
	dbw 1, REFLECT
	dbw 15, POISONPOWDER
	dbw 21, MEGA_DRAIN
	dbw 23, SYNTHESIS
	dbw 31, BODY_SLAM
	dbw 36, GIGA_DRAIN
	dbw 41, LIGHT_SCREEN
	dbw 45, SOLARBEAM
	dbw 46, SUNNY_DAY
	dbw 50, SAFEGUARD
	db 0 ; no more level-up moves

CyndaquilEvosAttacks:
	dbbw EVOLVE_LEVEL, 14, QUILAVA
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 6, SMOKESCREEN
	dbw 7, EMBER
	dbw 16, DEFENSE_CURL
	dbw 21, QUICK_ATTACK
	dbw 24, FLAME_WHEEL
	dbw 32, SWIFT
	dbw 38, FLAMETHROWER
	dbw 50, FIRE_BLAST
	db 0 ; no more level-up moves

QuilavaEvosAttacks:
	dbbw EVOLVE_LEVEL, 36, TYPHLOSION
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 1, SMOKESCREEN
	dbw 1, EMBER
	dbw 16, DEFENSE_CURL
	dbw 21, QUICK_ATTACK
	dbw 24, FLAME_WHEEL
	dbw 32, SWIFT
	dbw 38, FLAMETHROWER
	dbw 50, FIRE_BLAST
	db 0 ; no more level-up moves

TyphlosionEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 1, SMOKESCREEN
	dbw 1, EMBER
	dbw 16, DEFENSE_CURL
	dbw 21, QUICK_ATTACK
	dbw 24, FLAME_WHEEL
	dbw 32, SWIFT
	dbw 38, FLAMETHROWER
	dbw 50, FIRE_BLAST
	db 0 ; no more level-up moves

TotodileEvosAttacks:
	dbbw EVOLVE_LEVEL, 18, CROCONAW
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 7, WATER_GUN
	dbw 12, RAGE
	dbw 21, BITE
	dbw 28, SCARY_FACE
	dbw 37, SLASH
	dbw 45, SCREECH
	dbw 50, HYDRO_PUMP
	dbw 55, CRUNCH
	db 0 ; no more level-up moves

CroconawEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, FERALIGATR
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 1, WATER_GUN
	dbw 1, RAGE
	dbw 21, BITE
	dbw 28, SCARY_FACE
	dbw 37, SLASH
	dbw 45, SCREECH
	dbw 50, HYDRO_PUMP
	dbw 55, CRUNCH
	db 0 ; no more level-up moves

FeraligatrEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 7, WATER_GUN
	dbw 12, RAGE
	dbw 21, BITE
	dbw 28, SCARY_FACE
	dbw 37, SLASH
	dbw 45, SCREECH
	dbw 50, HYDRO_PUMP
	dbw 55, CRUNCH
	db 0 ; no more level-up moves

SentretEvosAttacks:
	dbbw EVOLVE_LEVEL, 15, FURRET
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, DEFENSE_CURL
	dbw 6, QUICK_ATTACK
	dbw 9, THIEF
	dbw 12, FURY_SWIPES
	dbw 16, HEADBUTT
	dbw 20, DIG
	dbw 25, PURSUIT
	dbw 30, EXTREMESPEED
	dbw 35, REST
	dbw 40, AMNESIA
	db 0 ; no more level-up moves

FurretEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, THIEF
	dbw 1, SCRATCH
	dbw 1, TACKLE
	dbw 1, DEFENSE_CURL
	dbw 6, QUICK_ATTACK
	dbw 12, FURY_SWIPES
	dbw 16, HEADBUTT
	dbw 20, DIG
	dbw 25, PURSUIT
	dbw 30, EXTREMESPEED
	dbw 35, REST
	dbw 40, AMNESIA
	dbw 45, DOUBLE_EDGE
	db 0 ; no more level-up moves

HoothootEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, NOCTOWL
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 6, PECK
	dbw 10, FORESIGHT
	dbw 14, HYPNOSIS
	dbw 20, PSYBEAM
	dbw 24, WING_ATTACK
	dbw 28, REFLECT
	dbw 28, LIGHT_SCREEN
	dbw 32, MIRROR_COAT
	dbw 36, TAKE_DOWN
	dbw 40, PSYCHIC_M
	dbw 45, DREAM_EATER
	dbw 50, FUTURE_SIGHT
	db 0 ; no more level-up moves

NoctowlEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, PECK
	dbw 1, FORESIGHT
	dbw 14, HYPNOSIS
	dbw 20, PSYBEAM
	dbw 24, WING_ATTACK
	dbw 28, REFLECT
	dbw 28, LIGHT_SCREEN
	dbw 32, MIRROR_COAT
	dbw 36, TAKE_DOWN
	dbw 40, PSYCHIC_M
	dbw 45, DREAM_EATER
	dbw 50, FUTURE_SIGHT
	db 0 ; no more level-up moves

LedybaEvosAttacks:
	dbbw EVOLVE_LEVEL, 18, LEDIAN
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 6, LEECH_LIFE
	dbw 8, SUPERSONIC
	dbw 15, COMET_PUNCH
	dbw 20, LIGHT_SCREEN
	dbw 20, REFLECT
	dbw 22, SAFEGUARD
	dbw 26, BATON_PASS
	dbw 31, AGILITY
	dbw 36, GIGA_DRAIN
	dbw 42, SWIFT
	dbw 50, DOUBLE_EDGE
	db 0 ; no more level-up moves

LedianEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEECH_LIFE
	dbw 1, SUPERSONIC
	dbw 15, COMET_PUNCH
	dbw 18, LIGHT_SCREEN
	dbw 18, REFLECT
	dbw 24, SAFEGUARD
	dbw 26, BATON_PASS
	dbw 31, AGILITY
	dbw 36, GIGA_DRAIN
	dbw 42, SWIFT
	dbw 50, DOUBLE_EDGE
	db 0 ; no more level-up moves

SpinarakEvosAttacks:
	dbbw EVOLVE_LEVEL, 21, ARIADOS
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	dbw 6, SCARY_FACE
	dbw 9, LEECH_LIFE
	dbw 12, CONSTRICT
	dbw 17, NIGHT_SHADE
	dbw 21, TWINEEDLE
	dbw 25, FURY_SWIPES
	dbw 33, SPIDER_WEB
	dbw 38, GIGA_DRAIN
	dbw 43, PSYCHIC_M
	dbw 47, MEGAHORN
	dbw 53, AGILITY
	db 0 ; no more level-up moves

AriadosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 1, STRING_SHOT
	dbw 1, SCARY_FACE
	dbw 1, LEECH_LIFE
	dbw 12, CONSTRICT
	dbw 17, NIGHT_SHADE
	dbw 21, TWINEEDLE
	dbw 25, FURY_SWIPES
	dbw 33, SPIDER_WEB
	dbw 38, GIGA_DRAIN
	dbw 43, PSYCHIC_M
	dbw 47, MEGAHORN
	dbw 53, AGILITY
	db 0 ; no more level-up moves

CrobatEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCREECH
	dbw 1, LEECH_LIFE
	dbw 1, SUPERSONIC
	dbw 1, GUST
	dbw 12, BITE
	dbw 19, CONFUSE_RAY
	dbw 22, WING_ATTACK
	dbw 27, SLUDGE
	dbw 36, SLUDGE_BOMB
	dbw 42, MEAN_LOOK
	dbw 48, HAZE
	db 0 ; no more level-up moves

ChinchouEvosAttacks:
	dbbw EVOLVE_LEVEL, 27, LANTURN
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, SUPERSONIC
	dbw 5, THUNDER_WAVE
	dbw 11, FLAIL
	dbw 17, WATER_GUN
	dbw 20, SPARK
	dbw 29, CONFUSE_RAY
	dbw 35, THUNDERBOLT
	dbw 40, TAKE_DOWN
	dbw 45, RAIN_DANCE
	dbw 49, THUNDER
	dbw 54, HYDRO_PUMP
	db 0 ; no more level-up moves

LanturnEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, SUPERSONIC
	dbw 1, THUNDER_WAVE
	dbw 11, FLAIL
	dbw 17, WATER_GUN
	dbw 20, SPARK
	dbw 29, CONFUSE_RAY
	dbw 35, THUNDERBOLT
	dbw 40, TAKE_DOWN
	dbw 45, RAIN_DANCE
	dbw 49, THUNDER
	dbw 54, HYDRO_PUMP
	db 0 ; no more level-up moves

PichuEvosAttacks:
	dbww EVOLVE_HAPPINESS, TR_ANYTIME, PIKACHU
	db 0 ; no more evolutions
	dbw 1, THUNDERSHOCK
	dbw 1, CHARM
	dbw 6, TAIL_WHIP
	dbw 8, THUNDER_WAVE
	dbw 11, SWEET_KISS
	db 0 ; no more level-up moves

CleffaEvosAttacks:
	dbww EVOLVE_HAPPINESS, TR_ANYTIME, CLEFAIRY
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 1, CHARM
	dbw 6, ENCORE
	dbw 8, SING
	dbw 13, SWEET_KISS
	db 0 ; no more level-up moves

IgglybuffEvosAttacks:
	dbww EVOLVE_HAPPINESS, TR_ANYTIME, JIGGLYPUFF
	db 0 ; no more evolutions
	dbw 1, SING
	dbw 1, CHARM
	dbw 6, DEFENSE_CURL
	dbw 9, POUND
	dbw 14, SWEET_KISS
	db 0 ; no more level-up moves

TogepiEvosAttacks:
	dbww EVOLVE_HAPPINESS, TR_ANYTIME, TOGETIC
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, CHARM
	dbw 5, METRONOME
	dbw 11, RETURN
	dbw 18, SWEET_KISS
	dbw 25, ENCORE
	dbw 31, SAFEGUARD
	dbw 38, DOUBLE_EDGE
	dbw 43, TRI_ATTACK
	db 0 ; no more level-up moves

TogeticEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GROWL
	dbw 1, CHARM
	dbw 5, METRONOME
	dbw 18, SWEET_KISS
	dbw 25, ENCORE
	dbw 27, WING_ATTACK
	dbw 31, SAFEGUARD
	dbw 38, DOUBLE_EDGE
	dbw 43, TRI_ATTACK
	db 0 ; no more level-up moves

NatuEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, XATU
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, PECK
	dbw 5, CONFUSION
	dbw 10, NIGHT_SHADE
	dbw 20, TELEPORT
	dbw 25, PSYBEAM
	dbw 30, RECOVER
	dbw 35, PSYCHIC_M
	dbw 40, WING_ATTACK
	dbw 45, FUTURE_SIGHT
	dbw 50, CONFUSE_RAY
	db 0 ; no more level-up moves

XatuEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, PECK
	dbw 1, CONFUSION
	dbw 1, NIGHT_SHADE
	dbw 20, TELEPORT
	dbw 25, PSYBEAM
	dbw 30, RECOVER
	dbw 35, PSYCHIC_M
	dbw 40, WING_ATTACK
	dbw 45, FUTURE_SIGHT
	dbw 50, CONFUSE_RAY
	db 0 ; no more level-up moves

MareepEvosAttacks:
	dbbw EVOLVE_LEVEL, 15, FLAAFFY
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 7, THUNDERSHOCK
	dbw 18, THUNDER_WAVE
	dbw 27, COTTON_SPORE
	dbw 39, LIGHT_SCREEN
	dbw 47, THUNDERBOLT
	dbw 55, THUNDER
	db 0 ; no more level-up moves

FlaaffyEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, AMPHAROS
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, THUNDERSHOCK
	dbw 18, THUNDER_WAVE
	dbw 27, COTTON_SPORE
	dbw 39, LIGHT_SCREEN
	dbw 47, THUNDERBOLT
	dbw 55, THUNDER
	db 0 ; no more level-up moves

AmpharosEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, THUNDERSHOCK
	dbw 1, THUNDER_WAVE
	dbw 27, COTTON_SPORE
	dbw 30, THUNDERPUNCH
	dbw 39, LIGHT_SCREEN
	dbw 47, THUNDERBOLT
	dbw 55, THUNDER
	db 0 ; no more level-up moves

BellossomEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, SWEET_SCENT
	dbw 1, POISONPOWDER
	dbw 1, STUN_SPORE
	dbw 18, SLEEP_POWDER
	dbw 21, MEGA_DRAIN
	dbw 24, CHARM
	dbw 32, GIGA_DRAIN
	dbw 35, MOONLIGHT
	dbw 44, PETAL_DANCE
	dbw 50, SOLARBEAM
	db 0 ; no more level-up moves

MarillEvosAttacks:
	dbbw EVOLVE_LEVEL, 18, AZUMARILL
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 3, DEFENSE_CURL
	dbw 6, TAIL_WHIP
	dbw 10, WATER_GUN
	dbw 15, ROLLOUT
	dbw 18, BUBBLEBEAM
	dbw 28, RAIN_DANCE
	dbw 36, DOUBLE_EDGE
	dbw 44, HYDRO_PUMP
	db 0 ; no more level-up moves

AzumarillEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, DEFENSE_CURL
	dbw 1, TAIL_WHIP
	dbw 1, WATER_GUN
	dbw 15, ROLLOUT
	dbw 18, BUBBLEBEAM
	dbw 28, RAIN_DANCE
	dbw 36, DOUBLE_EDGE
	dbw 44, HYDRO_PUMP
	db 0 ; no more level-up moves

SudowoodoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ROCK_THROW
	dbw 1, MIMIC
	dbw 10, FLAIL
	dbw 19, LOW_KICK
	dbw 28, ROCK_SLIDE
	dbw 31, COUNTER
	dbw 36, FAINT_ATTACK
	dbw 46, THRASH
	db 0 ; no more level-up moves

PolitoedEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, MIST
	dbw 1, HYPNOSIS
	dbw 1, PERISH_SONG
	dbw 10, WATER_GUN
	dbw 14, DOUBLESLAP
	dbw 20, BUBBLEBEAM
	dbw 25, RAIN_DANCE
	dbw 31, BODY_SLAM
	dbw 34, PERISH_SONG
	dbw 36, ICE_BEAM
	dbw 40, LIGHT_SCREEN
	dbw 45, HYDRO_PUMP
	dbw 51, SWAGGER
	db 0 ; no more level-up moves

HoppipEvosAttacks:
	dbbw EVOLVE_LEVEL, 18, SKIPLOOM
	db 0 ; no more evolutions
	dbw 1, SPLASH
	dbw 1, GUST
	dbw 3, TACKLE
	dbw 5, SYNTHESIS
	dbw 5, TAIL_WHIP
	dbw 7, ABSORB
	dbw 10, POISONPOWDER
	dbw 14, STUN_SPORE
	dbw 17, SLEEP_POWDER
	dbw 19, MEGA_DRAIN
	dbw 21, LEECH_SEED
	dbw 24, PROTECT
	dbw 31, COTTON_SPORE
	dbw 36, GIGA_DRAIN
	db 0 ; no more level-up moves

SkiploomEvosAttacks:
	dbbw EVOLVE_LEVEL, 27, JUMPLUFF
	db 0 ; no more evolutions
	dbw 1, SPLASH
	dbw 1, GUST
	dbw 1, TACKLE
	dbw 1, SYNTHESIS
	dbw 5, TAIL_WHIP
	dbw 7, ABSORB
	dbw 10, POISONPOWDER
	dbw 14, STUN_SPORE
	dbw 17, SLEEP_POWDER
	dbw 19, MEGA_DRAIN
	dbw 21, LEECH_SEED
	dbw 24, PROTECT
	dbw 31, COTTON_SPORE
	dbw 36, GIGA_DRAIN
	db 0 ; no more level-up moves

JumpluffEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SPLASH
	dbw 1, GUST
	dbw 1, TACKLE
	dbw 1, SYNTHESIS
	dbw 5, TAIL_WHIP
	dbw 7, ABSORB
	dbw 10, POISONPOWDER
	dbw 14, STUN_SPORE
	dbw 17, SLEEP_POWDER
	dbw 19, MEGA_DRAIN
	dbw 21, LEECH_SEED
	dbw 24, PROTECT
	dbw 31, COTTON_SPORE
	dbw 36, GIGA_DRAIN
	db 0 ; no more level-up moves

AipomEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, TAIL_WHIP
	dbw 6, SAND_ATTACK
	dbw 12, BATON_PASS
	dbw 19, LOW_KICK
	dbw 27, SWIFT
	dbw 36, SCREECH
	dbw 46, AGILITY
	db 0 ; no more level-up moves

SunkernEvosAttacks:
	dbww EVOLVE_ITEM, SUN_STONE, SUNFLORA
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 4, GROWTH
	dbw 10, MEGA_DRAIN
	dbw 15, RAZOR_LEAF
	dbw 19, SUNNY_DAY
	dbw 25, SYNTHESIS
	dbw 31, PETAL_DANCE
	dbw 36, SOLARBEAM
	dbw 50, GIGA_DRAIN
	db 0 ; no more level-up moves

SunfloraEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ABSORB
	dbw 1, POUND
	dbw 1, GROWTH
	dbw 10, MEGA_DRAIN
	dbw 15, RAZOR_LEAF
	dbw 19, SUNNY_DAY
	dbw 25, SYNTHESIS
	dbw 31, PETAL_DANCE
	dbw 36, SOLARBEAM
	dbw 50, GIGA_DRAIN
	db 0 ; no more level-up moves

YanmaEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, FORESIGHT
	dbw 7, QUICK_ATTACK
	dbw 13, DOUBLE_TEAM
	dbw 19, WING_ATTACK
	dbw 25, TWINEEDLE
	dbw 30, TWISTER
	dbw 28, DETECT
	dbw 31, SUPERSONIC
	dbw 37, SONICBOOM
	dbw 43, SCREECH
	db 0 ; no more level-up moves

WooperEvosAttacks:
	dbbw EVOLVE_LEVEL, 20, QUAGSIRE
	db 0 ; no more evolutions
	dbw 1, WATER_GUN
	dbw 1, TAIL_WHIP
	dbw 5, MUD_SLAP
	dbw 11, SLAM
	dbw 16, BUBBLEBEAM
	dbw 20, MAGNITUDE
	dbw 23, AMNESIA
	dbw 33, EARTHQUAKE
	dbw 41, RAIN_DANCE
	dbw 51, MIST
	dbw 51, HAZE
	db 0 ; no more level-up moves

QuagsireEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, WATER_GUN
	dbw 1, TAIL_WHIP
	dbw 5, MUD_SLAP
	dbw 11, SLAM
	dbw 16, BUBBLEBEAM
	dbw 20, MAGNITUDE
	dbw 23, AMNESIA
	dbw 33, EARTHQUAKE
	dbw 41, RAIN_DANCE
	dbw 51, MIST
	dbw 51, HAZE
	db 0 ; no more level-up moves

EspeonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 8, SAND_ATTACK
	dbw 12, GROWL
	dbw 16, DOUBLE_KICK
	dbw 20, CONFUSION
	dbw 23, QUICK_ATTACK
	dbw 26, SWIFT
	dbw 30, PSYBEAM
	dbw 36, PSYCHIC_M
	dbw 42, PSYCH_UP
	dbw 47, MORNING_SUN
	dbw 52, REFLECT
	db 0 ; no more level-up moves

UmbreonEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, TAIL_WHIP
	dbw 8, SAND_ATTACK
	dbw 12, GROWL
	dbw 16, DOUBLE_KICK
	dbw 20, PURSUIT
	dbw 23, QUICK_ATTACK
	dbw 26, CONFUSE_RAY
	dbw 30, FAINT_ATTACK
	dbw 36, CURSE
	dbw 42, MEAN_LOOK
	dbw 47, MOONLIGHT
	dbw 52, SCREECH
	db 0 ; no more level-up moves

MurkrowEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PECK
	dbw 11, PURSUIT
	dbw 16, HAZE
	dbw 22, WING_ATTACK
	dbw 26, NIGHT_SHADE
	dbw 31, FAINT_ATTACK
	dbw 36, DRILL_PECK
	dbw 41, MEAN_LOOK
	db 0 ; no more level-up moves

SlowkingEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CURSE
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, WATER_GUN
	dbw 18, CONFUSION
	dbw 24, DISABLE
	dbw 29, PSYBEAM
	dbw 34, HEADBUTT
	dbw 41, SWAGGER
	dbw 45, PSYCHIC_M
	dbw 50, FUTURE_SIGHT
	db 0 ; no more level-up moves

MisdreavusEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PSYWAVE
	dbw 1, GROWL
	dbw 4, NIGHT_SHADE
	dbw 8, SPITE
	dbw 12, CONFUSE_RAY
	dbw 19, MEAN_LOOK
	dbw 24, SCREECH
	dbw 27, SHADOW_BALL
	dbw 32, PSYBEAM
	dbw 36, PAIN_SPLIT
	dbw 41, SING
	dbw 46, PERISH_SONG
	db 0 ; no more level-up moves

UnownEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HIDDEN_POWER
	dbw 1, ANCIENTPOWER
	db 0 ; no more level-up moves

WobbuffetEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, COUNTER
	dbw 1, MIRROR_COAT
	dbw 1, SAFEGUARD
	dbw 1, DESTINY_BOND
	db 0 ; no more level-up moves

GirafarigEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 1, CONFUSION
	dbw 1, STOMP
	dbw 7, CONFUSION
	dbw 13, STOMP
	dbw 20, AGILITY
	dbw 21, PSYBEAM
	dbw 30, BATON_PASS
	dbw 41, PSYCHIC_M
	dbw 46, CRUNCH
	db 0 ; no more level-up moves

PinecoEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, FORRETRESS
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, HARDEN
	dbw 7, PIN_MISSILE
	dbw 12, PROTECT
	dbw 15, MEGA_DRAIN
	dbw 19, TAKE_DOWN
	dbw 22, RAPID_SPIN
	dbw 25, SELFDESTRUCT
	dbw 29, BIDE
	dbw 39, EXPLOSION
	dbw 44, SPIKES
	dbw 54, DOUBLE_EDGE
	db 0 ; no more level-up moves

ForretressEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, HARDEN
	dbw 1, PIN_MISSILE
	dbw 1, PROTECT
	dbw 15, MEGA_DRAIN
	dbw 19, TAKE_DOWN
	dbw 22, RAPID_SPIN
	dbw 25, SELFDESTRUCT
	dbw 29, BIDE
	dbw 33, SPIKE_CANNON
	dbw 39, EXPLOSION
	dbw 44, SPIKES
	dbw 54, DOUBLE_EDGE
	db 0 ; no more level-up moves

DunsparceEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, RAGE
	dbw 1, TACKLE
	dbw 5, DEFENSE_CURL
	dbw 13, GLARE
	dbw 15, DIG
	dbw 18, SPITE
	dbw 26, PURSUIT
	dbw 30, SCREECH
	dbw 33, BODY_SLAM
	db 0 ; no more level-up moves

GligarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POISON_STING
	dbw 6, SAND_ATTACK
	dbw 13, HARDEN
	dbw 16, MUD_SLAP
	dbw 20, QUICK_ATTACK
	dbw 24, WING_ATTACK
	dbw 28, FAINT_ATTACK
	dbw 36, SLASH
	dbw 38, EARTHQUAKE
	dbw 44, SCREECH
	dbw 52, GUILLOTINE
	db 0 ; no more level-up moves

SteelixEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, ROCK_SLIDE
	dbw 1, TACKLE
	dbw 1, SCREECH
	dbw 1, BIND
	dbw 12, ROCK_THROW
	dbw 18, DIG
	dbw 23, HARDEN
	dbw 27, RAGE
	dbw 36, SANDSTORM
	dbw 40, IRON_TAIL
	dbw 45, EARTHQUAKE
	dbw 49, CRUNCH
	db 0 ; no more level-up moves

SnubbullEvosAttacks:
	dbbw EVOLVE_LEVEL, 23, GRANBULL
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, SCARY_FACE
	dbw 4, TAIL_WHIP
	dbw 8, CHARM
	dbw 13, BITE
	dbw 19, LICK
	dbw 23, RAGE
	dbw 28, ROAR
	dbw 39, CRUNCH
	dbw 44, THRASH
	db 0 ; no more level-up moves

GranbullEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, SCARY_FACE
	dbw 4, TAIL_WHIP
	dbw 8, CHARM
	dbw 13, BITE
	dbw 19, LICK
	dbw 23, RAGE
	dbw 28, ROAR
	dbw 39, CRUNCH
	dbw 44, THRASH
	db 0 ; no more level-up moves

QwilfishEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, TACKLE
	dbw 1, POISON_STING
	dbw 6, WATER_GUN
	dbw 10, HARDEN
	dbw 10, MINIMIZE
	dbw 14, SPIKES
	dbw 20, SLUDGE
	dbw 26, PIN_MISSILE
	dbw 30, BUBBLEBEAM
	dbw 32, PROTECT
	dbw 36, TOXIC
	dbw 45, SLUDGE_BOMB
	dbw 50, HYDRO_PUMP
	db 0 ; no more level-up moves

ScizorEvosAttacks:
    db 0 ; no more evolutions
	dbw 1, QUICK_ATTACK
	dbw 1, LEER
	dbw 6, FOCUS_ENERGY
	dbw 12, PURSUIT
	dbw 16, CUT
	dbw 18, FALSE_SWIPE
	dbw 24, DOUBLE_TEAM
	dbw 30, METAL_CLAW
	dbw 36, SLASH
	dbw 42, TWINEEDLE
	dbw 48, SWORDS_DANCE
	dbw 54, AGILITY
    db 0 ; no more level-up moves

ShuckleEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, CONSTRICT
	dbw 1, WITHDRAW
	dbw 7, WRAP
	dbw 10, ACID
	dbw 13, ENCORE
	dbw 19, DEFENSE_CURL
	dbw 21, ROLLOUT
	dbw 23, SAFEGUARD
	dbw 27, SANDSTORM
	dbw 31, ACID_ARMOR
	dbw 34, BIDE
	dbw 37, REST
	dbw 40, PROTECT
	db 0 ; no more level-up moves

HeracrossEvosAttacks:
    db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, LEER
	dbw 5, PIN_MISSILE
	dbw 9, HORN_ATTACK
	dbw 12, ENDURE
	dbw 18, FURY_ATTACK
	dbw 25, COUNTER
	dbw 35, TAKE_DOWN
	dbw 44, REVERSAL
	dbw 45, MEGAHORN
	dbw 50, CROSS_CHOP
    db 0 ; no more level-up moves

SneaselEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 9, QUICK_ATTACK
	dbw 13, FURY_SWIPES
	dbw 17, SCREECH
	dbw 20, ICY_WIND
	dbw 25, FAINT_ATTACK
	dbw 33, ICE_PUNCH
	dbw 38, METAL_CLAW
	dbw 41, AGILITY
	dbw 43, SLASH
	dbw 47, BEAT_UP
	dbw 51, BLIZZARD
	db 0 ; no more level-up moves

TeddiursaEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, URSARING
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 8, LICK
	dbw 15, FURY_SWIPES
	dbw 22, FAINT_ATTACK
	dbw 29, REST
	dbw 34, SNORE
	dbw 39, SLASH
	dbw 45, SUBMISSION
	dbw 50, THRASH
	db 0 ; no more level-up moves

UrsaringEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SCRATCH
	dbw 1, LEER
	dbw 1, LICK
	dbw 1, FURY_SWIPES
	dbw 22, FAINT_ATTACK
	dbw 29, REST
	dbw 34, SNORE
	dbw 39, SLASH
	dbw 45, SUBMISSION
	dbw 50, THRASH
	db 0 ; no more level-up moves

SlugmaEvosAttacks:
	dbbw EVOLVE_LEVEL, 27, MAGCARGO
	db 0 ; no more evolutions
	dbw 1, SMOG
	dbw 8, EMBER
	dbw 13, ROCK_THROW
	dbw 18, HARDEN
	dbw 25, FLAME_WHEEL
	dbw 29, AMNESIA
	dbw 36, FLAMETHROWER
	dbw 41, ROCK_SLIDE
	dbw 46, BODY_SLAM
	dbw 50, FIRE_BLAST
	db 0 ; no more level-up moves

MagcargoEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SMOG
	dbw 1, EMBER
	dbw 1, ROCK_THROW
	dbw 1, HARDEN
	dbw 25, FLAME_WHEEL
	dbw 29, AMNESIA
	dbw 36, FLAMETHROWER
	dbw 41, ROCK_SLIDE
	dbw 46, BODY_SLAM
	dbw 50, EARTHQUAKE
	dbw 56, FIRE_BLAST
	db 0 ; no more level-up moves

SwinubEvosAttacks:
	dbbw EVOLVE_LEVEL, 33, PILOSWINE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 8, POWDER_SNOW
	dbw 14, MUD_SLAP
	dbw 18, ENDURE
	dbw 21, ICY_WIND
	dbw 28, TAKE_DOWN
	dbw 39, EARTHQUAKE
	dbw 42, MIST
	dbw 50, BLIZZARD
	dbw 55, AMNESIA
	db 0 ; no more level-up moves

PiloswineEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, HORN_ATTACK
	dbw 1, POWDER_SNOW
	dbw 1, ENDURE
	dbw 1, MUD_SLAP
	dbw 21, ICY_WIND
	dbw 28, TAKE_DOWN
	dbw 33, FURY_ATTACK
	dbw 39, EARTHQUAKE
	dbw 42, MIST
	dbw 50, BLIZZARD
	dbw 55, AMNESIA
	db 0 ; no more level-up moves

CorsolaEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, BUBBLE
	dbw 7, HARDEN
	dbw 13, WATER_GUN
	dbw 18, ANCIENTPOWER
	dbw 19, RECOVER
	dbw 23, SPIKES
	dbw 25, BUBBLEBEAM
	dbw 31, SPIKE_CANNON
	dbw 37, MIRROR_COAT
	dbw 45, HYDRO_PUMP
	db 0 ; no more level-up moves

RemoraidEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, OCTILLERY
	db 0 ; no more evolutions
	dbw 1, WATER_GUN
	dbw 11, LOCK_ON
	dbw 22, PSYBEAM
	dbw 22, AURORA_BEAM
	dbw 22, BUBBLEBEAM
	dbw 28, FOCUS_ENERGY
	dbw 33, ICE_BEAM
	dbw 44, HYDRO_PUMP
	dbw 55, HYPER_BEAM
	db 0 ; no more level-up moves

OctilleryEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, WATER_GUN
	dbw 11, CONSTRICT
	dbw 22, PSYBEAM
	dbw 22, AURORA_BEAM
	dbw 22, BUBBLEBEAM
	dbw 25, OCTAZOOKA
	dbw 28, FOCUS_ENERGY
	dbw 33, ICE_BEAM
	dbw 44, HYDRO_PUMP
	dbw 55, HYPER_BEAM
	db 0 ; no more level-up moves

DelibirdEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, PRESENT
	db 0 ; no more level-up moves

MantineEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, BUBBLE
	dbw 10, SUPERSONIC
	dbw 18, BUBBLEBEAM
	dbw 20, CONFUSE_RAY
	dbw 25, WING_ATTACK
	dbw 30, TAKE_DOWN
	dbw 40, AGILITY
	dbw 45, MIRROR_COAT
	dbw 49, HYDRO_PUMP
	db 0 ; no more level-up moves

SkarmoryEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, PECK
	dbw 13, SAND_ATTACK
	dbw 17, SPIKES
	dbw 19, SWIFT
	dbw 25, AGILITY
	dbw 28, WING_ATTACK
	dbw 31, STEEL_WING
	dbw 37, FURY_ATTACK
	dbw 41, DRILL_PECK
	db 0 ; no more level-up moves

	HoundourEvosAttacks:
	dbbw EVOLVE_LEVEL, 24, HOUNDOOM
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, EMBER
	dbw 7, ROAR
	dbw 12, BITE
	dbw 17, SMOG
	dbw 22, FLAME_WHEEL
	dbw 30, FAINT_ATTACK
	dbw 39, FLAMETHROWER
	dbw 48, CRUNCH
	db 0 ; no more level-up moves
	
HoundoomEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, EMBER
	dbw 1, ROAR
	dbw 1, BITE
	dbw 17, SMOG
	dbw 22, FLAME_WHEEL
	dbw 30, FAINT_ATTACK
	dbw 39, FLAMETHROWER
	dbw 48, CRUNCH
	db 0 ; no more level-up moves

KingdraEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BUBBLE
	dbw 1, SMOKESCREEN
	dbw 1, LEER
	dbw 1, WATER_GUN
	dbw 22, BUBBLEBEAM
	dbw 29, TWISTER
	dbw 36, DRAGONBREATH
	dbw 40, AGILITY
	dbw 51, HYDRO_PUMP
	db 0 ; no more level-up moves

PhanpyEvosAttacks:
	dbbw EVOLVE_LEVEL, 25, DONPHAN
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 1, GROWL
	dbw 7, MUD_SLAP
	dbw 9, DEFENSE_CURL
	dbw 14, MAGNITUDE
	dbw 17, FLAIL
	dbw 25, TAKE_DOWN
	dbw 33, ROLLOUT
	dbw 36, ENDURE
	dbw 40, EARTHQUAKE
	dbw 48, DOUBLE_EDGE
	db 0 ; no more level-up moves

DonphanEvosAttacks:
	db 0 ; no more evolutionsFras
	dbw 1, HORN_ATTACK
	dbw 1, GROWL
	dbw 1, MUD_SLAP
	dbw 1, DEFENSE_CURL
	dbw 14, MAGNITUDE
	dbw 17, FLAIL
	dbw 25, FURY_ATTACK
	dbw 33, ROLLOUT
	dbw 36, RAPID_SPIN
	dbw 40, EARTHQUAKE
	dbw 48, DOUBLE_EDGE
	db 0 ; no more level-up moves

Porygon2EvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SHARPEN
	dbw 1, CONVERSION2
	dbw 1, TACKLE
	dbw 1, CONVERSION
	dbw 9, AGILITY
	dbw 12, PSYBEAM
	dbw 20, RECOVER
	dbw 24, DEFENSE_CURL
	dbw 32, LOCK_ON
	dbw 36, TRI_ATTACK
	dbw 44, ZAP_CANNON
	dbw 50, HYPER_BEAM
	db 0 ; no more level-up moves

StantlerEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 8, LEER
	dbw 13, STOMP
	dbw 15, HYPNOSIS
	dbw 18, CONFUSE_RAY
	dbw 23, PURSUIT
	dbw 28, TAKE_DOWN
	dbw 33, REFLECT
	dbw 37, LIGHT_SCREEN
	dbw 40, DOUBLE_EDGE
	dbw 45, DREAM_EATER
	db 0 ; no more level-up moves

SmeargleEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, SKETCH
	dbw 11, SKETCH
	dbw 21, SKETCH
	dbw 31, SKETCH
	dbw 41, SKETCH
	dbw 51, SKETCH
	dbw 61, SKETCH
	dbw 71, SKETCH
	dbw 81, SKETCH
	dbw 91, SKETCH
	db 0 ; no more level-up moves

TyrogueEvosAttacks:
	dbww EVOLVE_ITEM, BRICK_PIECE, HITMONTOP
	dbbww EVOLVE_STAT, 20, ATK_LT_DEF, HITMONCHAN
	dbbww EVOLVE_STAT, 20, ATK_GT_DEF, HITMONLEE
	db 0 ; no more evolutions
	dbw 1, TACKLE
	db 0 ; no more level-up moves

HitmontopEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, FOCUS_ENERGY
	dbw 20, PURSUIT
	dbw 20, QUICK_ATTACK
	dbw 20, ROLLING_KICK
	dbw 25, RAPID_SPIN
	dbw 31, COUNTER
	dbw 37, AGILITY
	dbw 43, DETECT
	dbw 45, TRIPLE_KICK
	db 0 ; no more level-up moves

SmoochumEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, JYNX
	db 0 ; no more evolutions
	dbw 1, POWDER_SNOW
	dbw 1, LICK
	dbw 1, POUND
	dbw 7, SWEET_KISS
	dbw 17, ICY_WIND
	dbw 21, CONFUSION
	dbw 25, SING
	dbw 30, ICE_PUNCH
	dbw 33, MEAN_LOOK
	dbw 37, PSYCHIC_M
	dbw 45, PERISH_SONG
	dbw 49, BLIZZARD
	db 0 ; no more level-up moves

ElekidEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, ELECTABUZZ
	db 0 ; no more evolutions
	dbw 1, THUNDERSHOCK
	dbw 1, LEER
	dbw 7, QUICK_ATTACK
	dbw 17, SPARK
	dbw 21, LIGHT_SCREEN
	dbw 25, SWIFT
	dbw 30, THUNDERPUNCH
	dbw 36, SCREECH
	dbw 42, THUNDERBOLT
	dbw 52, THUNDER
	db 0 ; no more level-up moves

MagbyEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, MAGMAR
	db 0 ; no more evolutions
	dbw 1, EMBER
	dbw 1, LEER
	dbw 7, SMOG
	dbw 17, FLAME_WHEEL
	dbw 21, SMOKESCREEN
	dbw 25, POISON_GAS
	dbw 30, FIRE_PUNCH
	dbw 33, SUNNY_DAY
	dbw 41, FLAMETHROWER
	dbw 49, CONFUSE_RAY
	dbw 57, FIRE_BLAST
	db 0 ; no more level-up moves

MiltankEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, TACKLE
	dbw 4, GROWL
	dbw 8, DEFENSE_CURL
	dbw 13, STOMP
	dbw 19, MILK_DRINK
	dbw 26, BIDE
	dbw 34, ROLLOUT
	dbw 43, BODY_SLAM
	dbw 53, HEAL_BELL
	dbw 58, DOUBLE_EDGE
	db 0 ; no more level-up moves

BlisseyEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, POUND
	dbw 4, GROWL
	dbw 7, TAIL_WHIP
	dbw 10, SOFTBOILED
	dbw 13, DOUBLESLAP
	dbw 18, MINIMIZE
	dbw 23, SING
	dbw 28, EGG_BOMB
	dbw 33, DEFENSE_CURL
	dbw 40, LIGHT_SCREEN
	dbw 47, DOUBLE_EDGE
	db 0 ; no more level-up moves

RaikouEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, LEER
	dbw 11, SPARK
	dbw 21, QUICK_ATTACK
	dbw 31, THUNDERBOLT
	dbw 41, CRUNCH
	dbw 51, REFLECT
	dbw 61, THUNDER
	db 0 ; no more level-up moves

EnteiEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, LEER
	dbw 11, FLAME_WHEEL
	dbw 21, STOMP
	dbw 31, FLAMETHROWER
	dbw 41, CRUNCH
	dbw 51, LIGHT_SCREEN
	dbw 61, FIRE_BLAST
	dbw 71, SWAGGER
	db 0 ; no more level-up moves

SuicuneEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, BITE
	dbw 1, LEER
	dbw 11, BUBBLEBEAM
	dbw 21, RAIN_DANCE
	dbw 31, ICE_BEAM
	dbw 41, REFLECT
	dbw 51, LIGHT_SCREEN
	dbw 61, HYDRO_PUMP
	dbw 71, MIRROR_COAT
	db 0 ; no more level-up moves

LarvitarEvosAttacks:
	dbbw EVOLVE_LEVEL, 30, PUPITAR
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, BITE
	dbw 8, ROCK_THROW
	dbw 11, SANDSTORM
	dbw 15, SCREECH
	dbw 26, THRASH
	dbw 34, SCARY_FACE
	dbw 40, ROCK_SLIDE
	dbw 50, CRUNCH
	dbw 55, EARTHQUAKE
	dbw 57, HYPER_BEAM
	db 0 ; no more level-up moves

PupitarEvosAttacks:
	dbbw EVOLVE_LEVEL, 55, TYRANITAR
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, BITE
	dbw 1, ROCK_THROW
	dbw 1, SANDSTORM
	dbw 15, SCREECH
	dbw 26, THRASH
	dbw 34, SCARY_FACE
	dbw 40, ROCK_SLIDE
	dbw 50, CRUNCH
	dbw 55, EARTHQUAKE
	dbw 65, HYPER_BEAM
	db 0 ; no more level-up moves

TyranitarEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LEER
	dbw 1, BITE
	dbw 1, ROCK_THROW
	dbw 1, SANDSTORM
	dbw 15, SCREECH
	dbw 26, THRASH
	dbw 34, SCARY_FACE
	dbw 40, ROCK_SLIDE
	dbw 50, CRUNCH
	dbw 55, EARTHQUAKE
	dbw 65, HYPER_BEAM
	db 0 ; no more level-up moves

LugiaEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 11, SAFEGUARD
	dbw 22, RECOVER
	dbw 33, AEROBLAST
	dbw 44, ANCIENTPOWER
	dbw 55, RAIN_DANCE
	dbw 66, HYDRO_PUMP
	dbw 77, WHIRLWIND
	dbw 88, SWIFT
	dbw 99, FUTURE_SIGHT
	db 0 ; no more level-up moves

HoOhEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, GUST
	dbw 11, SAFEGUARD
	dbw 22, RECOVER
	dbw 33, SACRED_FIRE
	dbw 44, ANCIENTPOWER
	dbw 55, SUNNY_DAY
	dbw 66, FIRE_BLAST
	dbw 77, WHIRLWIND
	dbw 88, SWIFT
	dbw 99, FUTURE_SIGHT
	db 0 ; no more level-up moves

CelebiEvosAttacks:
	db 0 ; no more evolutions
	dbw 1, LEECH_SEED
	dbw 1, CONFUSION
	dbw 1, RECOVER
	dbw 10, SAFEGUARD
	dbw 20, MEGA_DRAIN
	dbw 25, ANCIENTPOWER
	dbw 30, PSYBEAM
	dbw 35, GIGA_DRAIN
	dbw 40, PSYCHIC_M
	dbw 45, HEAL_BELL
	dbw 50, BATON_PASS
	dbw 55, FUTURE_SIGHT
	dbw 60, PERISH_SONG
	db 0 ; no more level-up moves
