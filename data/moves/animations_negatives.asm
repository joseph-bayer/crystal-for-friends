BattleAnimationsNegatives::
	dw BattleAnim_FutureSightForesaw
	dw BattleAnim_HeldItemTrigger
	dw BattleAnim_InSun
	dw BattleAnim_InRain
	dw BattleAnim_ThrowPokeBall
	dw BattleAnim_SendOutMon
	dw BattleAnim_ReturnMon
	dw BattleAnim_Confused
	dw BattleAnim_Slp
	dw BattleAnim_Brn
	dw BattleAnim_Psn
	dw BattleAnim_Sap
	dw BattleAnim_Frz
	dw BattleAnim_Par
	dw BattleAnim_InLove
	dw BattleAnim_InSandstorm
	dw BattleAnim_InNightmare
	dw BattleAnim_InWhirlpool
	dw BattleAnim_Miss
	dw BattleAnim_EnemyDamage
	dw BattleAnim_EnemyStatDown
	dw BattleAnim_PlayerStatDown
	dw BattleAnim_PlayerDamage
	dw BattleAnim_Wobble
	dw BattleAnim_Shake
	dw BattleAnim_HitConfusion
.IndirectEnd::

BattleAnim_Miss:
	anim_ret

BattleAnim_HeldItemTrigger:
	anim_1gfx BATTLE_ANIM_GFX_BUBBLE
	anim_sound 0, 0, SFX_FULL_HEAL
	anim_bgeffect BATTLE_BG_EFFECT_FADE_MON_TO_LIGHT_REPEATING, $0, BG_EFFECT_USER, $40
	anim_call BattleAnim_Recover_branch
	anim_incbgeffect BATTLE_BG_EFFECT_FADE_MON_TO_LIGHT_REPEATING
	anim_ret

BattleAnim_SendOutMon:
	anim_if_param_equal $1, .Shiny
	anim_1gfx BATTLE_ANIM_GFX_SMOKE
	anim_sound 0, 0, SFX_BALL_POOF
	anim_obj BATTLE_ANIM_OBJ_BALL_POOF, 44, 96, $0
	anim_wait 4
	anim_bgeffect BATTLE_BG_EFFECT_ENTER_MON, $0, BG_EFFECT_USER, $0
	anim_wait 32
	anim_ret

.Shiny:
	anim_1gfx BATTLE_ANIM_GFX_SPEED
	anim_bgeffect BATTLE_BG_EFFECT_FLASH_INVERTED, $0, $4, $3
	anim_call BattleAnimSub_BGCycleOBPalsGrayAndYellow_$2
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $0
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $8
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $10
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $18
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $20
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $28
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $30
	anim_wait 4
	anim_sound 0, 0, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_SHINY, 48, 96, $38
	anim_wait 32
	anim_ret

BattleAnim_ReturnMon:
	anim_sound 0, 0, SFX_BALL_POOF
BattleAnimSub_Return:
	anim_bgeffect BATTLE_BG_EFFECT_RETURN_MON, $0, BG_EFFECT_USER, $0
	anim_wait 32
	anim_ret

BattleAnim_Confused:
	anim_1gfx BATTLE_ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_KINESIS
	anim_obj BATTLE_ANIM_OBJ_CHICK, 44, 64, $15
	anim_obj BATTLE_ANIM_OBJ_CHICK, 44, 64, $aa
	anim_obj BATTLE_ANIM_OBJ_CHICK, 44, 64, $bf
	anim_wait 96
	anim_ret

BattleAnim_Slp:
	anim_1gfx BATTLE_ANIM_GFX_STATUS
	anim_sound 0, 0, SFX_TAIL_WHIP
.loop
	anim_obj BATTLE_ANIM_OBJ_ASLEEP, 64, 80, $0
	anim_wait 40
	anim_loop 3, .loop
	anim_wait 32
	anim_ret

BattleAnim_Brn:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_1gfx BATTLE_ANIM_GFX_FIRE
.loop
	anim_sound 0, 0, SFX_BURN
	anim_obj BATTLE_ANIM_OBJ_BURNED, 56, 88, $10
	anim_wait 4
	anim_loop 3, .loop
	anim_wait 6
	anim_ret

BattleAnim_Psn:
	anim_1gfx BATTLE_ANIM_GFX_POISON
	anim_sound 0, 0, SFX_POISON
	anim_obj BATTLE_ANIM_OBJ_SKULL, 64, 56, $0
	anim_wait 8
	anim_sound 0, 0, SFX_POISON
	anim_obj BATTLE_ANIM_OBJ_SKULL, 48, 56, $0
	anim_wait 8
	anim_ret

BattleAnim_Sap:
	anim_setobjpal PAL_BATTLE_OB_YELLOW, PAL_BTLCUSTOM_LIME
	anim_bgeffect BATTLE_BG_EFFECT_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $6, $0
	anim_1gfx BATTLE_ANIM_GFX_CHARGE
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj BATTLE_ANIM_OBJ_ABSORB, 128, 48, $2
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj BATTLE_ANIM_OBJ_ABSORB, 136, 64, $3
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj BATTLE_ANIM_OBJ_ABSORB, 136, 32, $4
	anim_wait 16
	anim_ret

BattleAnim_Frz:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ICE
	anim_1gfx BATTLE_ANIM_GFX_ICE
	anim_obj BATTLE_ANIM_OBJ_FROZEN, 48, 112, $0
	anim_sound 0, 0, SFX_SHINE
	anim_wait 16
	anim_sound 0, 0, SFX_SHINE
	anim_wait 16
	anim_ret

BattleAnim_Par:
	anim_1gfx BATTLE_ANIM_GFX_STATUS
	anim_call BattleAnimSub_BGCycleOBPalsGrayAndYellow_$2
	anim_sound 0, 0, SFX_ZAP_CANNON
	anim_obj BATTLE_ANIM_OBJ_PARALYZED, 20, 90, $42
	anim_obj BATTLE_ANIM_OBJ_PARALYZED, 76, 90, $c2
	anim_wait 32
	anim_ret

BattleAnim_InLove:
	anim_1gfx BATTLE_ANIM_GFX_OBJECTS
	anim_sound 0, 0, SFX_LICK
	anim_obj BATTLE_ANIM_OBJ_HEART, 64, 76, $0
	anim_wait 32
	anim_sound 0, 0, SFX_LICK
	anim_obj BATTLE_ANIM_OBJ_HEART, 36, 72, $0
	anim_wait 32
	anim_ret

BattleAnim_InNightmare:
	anim_1gfx BATTLE_ANIM_GFX_ANGELS
	anim_sound 0, 0, SFX_BUBBLEBEAM
	anim_obj BATTLE_ANIM_OBJ_IN_NIGHTMARE, 68, 80, $0
	anim_wait 40
	anim_ret

BattleAnim_HitConfusion:
	anim_1gfx BATTLE_ANIM_GFX_HIT
	anim_sound 0, 0, SFX_POUND
	anim_obj BATTLE_ANIM_OBJ_HIT, 44, 96, $0
	anim_wait 16
	anim_ret

BattleAnim_EnemyDamage:
.loop
	anim_bgeffect BATTLE_BG_EFFECT_HIDE_MON, $0, BG_EFFECT_TARGET, $0
	anim_wait 5
	anim_bgeffect BATTLE_BG_EFFECT_SHOW_MON, $0, BG_EFFECT_TARGET, $0
	anim_wait 5
	anim_loop 3, .loop
	anim_ret

BattleAnim_EnemyStatDown:
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect BATTLE_BG_EFFECT_VIBRATE_MON, $0, BG_EFFECT_TARGET, $0
	anim_wait 40
	anim_jump BattleAnim_ShowMon_1

BattleAnim_PlayerStatDown:
	anim_call BattleAnim_UserObj_1Row
	anim_bgeffect BATTLE_BG_EFFECT_WOBBLE_PLAYER, $0, $0, $0
	anim_wait 40
	anim_jump BattleAnim_ShowMon_1

BattleAnim_PlayerDamage:
	anim_bgeffect BATTLE_BG_EFFECT_SHAKE_SCREEN_Y, $20, $2, $20
	anim_wait 40
	anim_ret

BattleAnim_Wobble:
	anim_bgeffect BATTLE_BG_EFFECT_WOBBLE_SCREEN, $0, $0, $0
	anim_wait 40
	anim_ret

BattleAnim_Shake:
	anim_bgeffect BATTLE_BG_EFFECT_SHAKE_SCREEN_X, $20, $2, $40
	anim_wait 40
	anim_ret

BattleAnim_Recover_branch:
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $30
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $31
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $32
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $33
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $34
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $35
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $36
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $37
	anim_wait 64
	anim_ret

BattleAnimSub_Drain:
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj BATTLE_ANIM_OBJ_ABSORB, 128, 48, $2
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj BATTLE_ANIM_OBJ_ABSORB, 136, 64, $3
	anim_wait 6
	anim_sound 6, 3, SFX_WATER_GUN
	anim_obj BATTLE_ANIM_OBJ_ABSORB, 136, 32, $4
	anim_wait 6
	anim_ret

BattleAnimSub_SoftboiledHeal:
.loop
	anim_obj BATTLE_ANIM_OBJ_RECOVER, 44, 88, $20
	anim_wait 8
	anim_loop 8, .loop
	anim_wait 128
	anim_incbgeffect BATTLE_BG_EFFECT_FADE_MON_TO_LIGHT_REPEATING
	anim_ret

BattleAnimSub_WrapBind:
	anim_wait 8
	anim_sound 6, 2, SFX_MENU
	anim_obj BATTLE_ANIM_OBJ_BIND1, 132, 48, $0
	anim_wait 8
	anim_sound 0, 1, SFX_BIND
	anim_incobj 1
	anim_incobj 2
	anim_incobj 3
	anim_wait 64
	anim_ret

BattleAnim_InSandstorm:
	anim_1gfx BATTLE_ANIM_GFX_POWDER
	anim_obj BATTLE_ANIM_OBJ_SANDSTORM, 88, 0, $0
	anim_wait 8
	anim_obj BATTLE_ANIM_OBJ_SANDSTORM, 72, 0, $1
	anim_wait 8
	anim_obj BATTLE_ANIM_OBJ_SANDSTORM, 56, 0, $2
.loop
	anim_sound 0, 1, SFX_MENU
	anim_wait 8
	anim_loop 16, .loop
	anim_wait 8
	anim_ret

BattleAnim_IntensifiedHeal:
	anim_bgeffect BATTLE_BG_EFFECT_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $0, $0
	anim_jump BattleAnimSub_Glimmer2

BattleAnim_WeakenedHeal:
	anim_jump BattleAnimSub_Glimmer

BattleAnim_InRain:
	anim_1gfx BATTLE_ANIM_GFX_WATER
	anim_bgp $f8
	anim_obp0 $7c
	anim_sound 0, 1, SFX_RAIN_DANCE
	anim_obj BATTLE_ANIM_OBJ_RAIN, 88, 0, $0
	anim_wait 8
	anim_obj BATTLE_ANIM_OBJ_RAIN, 88, 0, $1
	anim_wait 8
	anim_obj BATTLE_ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 128
	anim_ret

BattleAnim_InSun:
	anim_1gfx BATTLE_ANIM_GFX_WATER
	anim_bgp $90
	anim_sound 0, 1, SFX_MORNING_SUN
	anim_obj BATTLE_ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj BATTLE_ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 8
	anim_obj BATTLE_ANIM_OBJ_RAIN, 88, 0, $2
	anim_wait 128
	anim_ret

BattleAnim_FutureSightForesaw:
	anim_1gfx BATTLE_ANIM_GFX_SHINE
	anim_bgeffect BATTLE_BG_EFFECT_CYCLE_MID_OBPALS_GRAY_AND_YELLOW, $0, $0, $0
	anim_sound 0, 0, SFX_RAGE
	anim_obj BATTLE_ANIM_OBJ_FORESIGHT, 64, 88, $0
	anim_bgeffect BATTLE_BG_EFFECT_FADE_MON_TO_LIGHT_REPEATING, $0, BG_EFFECT_USER, $30
	anim_wait 64
	anim_incbgeffect BATTLE_BG_EFFECT_FADE_MON_TO_LIGHT_REPEATING
	anim_wait 8
	anim_ret

BattleAnimSub_EyeBeams:
	anim_sound 6, 2, SFX_LEER
	anim_obj BATTLE_ANIM_OBJ_LEER, 72, 84, $0
	anim_obj BATTLE_ANIM_OBJ_LEER, 64, 80, $0
	anim_obj BATTLE_ANIM_OBJ_LEER, 88, 76, $0
	anim_obj BATTLE_ANIM_OBJ_LEER, 80, 72, $0
	anim_obj BATTLE_ANIM_OBJ_LEER, 104, 68, $0
	anim_obj BATTLE_ANIM_OBJ_LEER, 96, 64, $0
	anim_obj BATTLE_ANIM_OBJ_LEER, 120, 60, $0
	anim_obj BATTLE_ANIM_OBJ_LEER, 112, 56, $0
	anim_obj BATTLE_ANIM_OBJ_LEER_TIP, 130, 54, $0
	anim_obj BATTLE_ANIM_OBJ_LEER_TIP, 122, 50, $0
	anim_ret

BattleAnimSub_WarpAway:
	anim_sound 0, 0, SFX_WARP_TO
	anim_obj BATTLE_ANIM_OBJ_WARP, 44, 108, $0
	anim_obj BATTLE_ANIM_OBJ_WARP, 44, 100, $0
	anim_obj BATTLE_ANIM_OBJ_WARP, 44, 92, $0
	anim_obj BATTLE_ANIM_OBJ_WARP, 44, 84, $0
	anim_obj BATTLE_ANIM_OBJ_WARP, 44, 76, $0
	anim_obj BATTLE_ANIM_OBJ_WARP, 44, 68, $0
	anim_obj BATTLE_ANIM_OBJ_WARP, 44, 60, $0
	anim_ret

BattleAnimSub_Beam:
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj BATTLE_ANIM_OBJ_BEAM, 64, 92, $0
	anim_wait 4
	anim_sound 0, 0, SFX_HYPER_BEAM
	anim_obj BATTLE_ANIM_OBJ_BEAM, 80, 84, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj BATTLE_ANIM_OBJ_BEAM, 96, 76, $0
	anim_wait 4
	anim_sound 0, 1, SFX_HYPER_BEAM
	anim_obj BATTLE_ANIM_OBJ_BEAM, 112, 68, $0
	anim_obj BATTLE_ANIM_OBJ_BEAM_TIP, 126, 62, $0
	anim_ret

BattleAnimSub_Explosion1:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 32, 64, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 64, 104, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 32, 104, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 64, 64, $0
	anim_wait 5
	anim_sound 0, 0, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 48, 84, $0
	anim_ret

BattleAnimSub_Explosion2:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 148, 32, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 116, 72, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 148, 72, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 116, 32, $0
	anim_wait 5
	anim_sound 0, 1, SFX_EGG_BOMB
	anim_obj BATTLE_ANIM_OBJ_EXPLOSION1, 132, 52, $0
	anim_ret

BattleAnimSub_Sound:
	anim_obj BATTLE_ANIM_OBJ_SOUND, 64, 76, $0
	anim_obj BATTLE_ANIM_OBJ_SOUND, 64, 88, $1
	anim_obj BATTLE_ANIM_OBJ_SOUND, 64, 100, $2
	anim_ret

BattleAnimSub_Fire:
	anim_setobjpal PAL_BATTLE_OB_RED, PAL_BTLCUSTOM_FIRE
	anim_sound 0, 1, SFX_EMBER
.loop
	anim_obj BATTLE_ANIM_OBJ_BURNED, 136, 56, $10
	anim_obj BATTLE_ANIM_OBJ_BURNED, 136, 56, $90
	anim_wait 4
	anim_loop 4, .loop
	anim_ret

BattleAnimSub_Ice:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_ICE
	anim_sound 0, 1, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_ICE, 128, 42, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_ICE, 144, 70, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_ICE, 120, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_ICE, 152, 56, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_ICE, 144, 42, $0
	anim_wait 6
	anim_sound 0, 1, SFX_SHINE
	anim_obj BATTLE_ANIM_OBJ_ICE, 128, 70, $0
	anim_ret

BattleAnimSub_Sludge:
.loop
	anim_sound 0, 1, SFX_TOXIC
	anim_obj BATTLE_ANIM_OBJ_SLUDGE, 132, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj BATTLE_ANIM_OBJ_SLUDGE, 116, 72, $0
	anim_wait 8
	anim_sound 0, 1, SFX_TOXIC
	anim_obj BATTLE_ANIM_OBJ_SLUDGE, 148, 72, $0
	anim_wait 8
	anim_loop 5, .loop
	anim_wait 48
	anim_ret

BattleAnimSub_Acid:
.loop
	anim_sound 6, 2, SFX_BUBBLEBEAM
	anim_obj BATTLE_ANIM_OBJ_ACID, 64, 84, $10
	anim_wait 5
	anim_loop 8, .loop
	anim_ret

BattleAnimSub_Metallic:
	anim_sound 0, 0, SFX_SHINE
	anim_bgeffect BATTLE_BG_EFFECT_FADE_MON_TO_BLACK, $0, BG_EFFECT_USER, $40
	anim_wait 8
	anim_obj BATTLE_ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 32
	anim_obj BATTLE_ANIM_OBJ_HARDEN, 48, 84, $0
	anim_wait 64
	anim_incbgeffect BATTLE_BG_EFFECT_FADE_MON_TO_BLACK
	anim_ret

BattleAnimSub_SandOrMud:
.loop
	anim_sound 6, 2, SFX_MENU
	anim_obj BATTLE_ANIM_OBJ_SAND, 64, 92, $4
	anim_wait 4
	anim_loop 8, .loop
	anim_wait 32
	anim_ret

BattleAnimSub_Glimmer:
	anim_sound 0, 0, SFX_METRONOME
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 44, 64, $0
	anim_wait 5
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 24, 96, $0
	anim_wait 5
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 56, 104, $0
	anim_wait 21
	anim_ret

BattleAnimSub_Glimmer2:
	anim_sound 0, 0, SFX_METRONOME
.loop
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 24, 64, $0
	anim_wait 5
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 56, 104, $0
	anim_wait 5
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 24, 104, $0
	anim_wait 5
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 56, 64, $0
	anim_wait 5
	anim_obj BATTLE_ANIM_OBJ_GLIMMER, 40, 84, $0
	anim_wait 5
	anim_loop 2, .loop
	anim_wait 16
	anim_ret

BattleAnimSub_Focus:
.loop
	anim_sound 0, 0, SFX_SWORDS_DANCE
	anim_obj BATTLE_ANIM_OBJ_FOCUS, 44, 108, $6
	anim_wait 2
	anim_obj BATTLE_ANIM_OBJ_FOCUS, 36, 108, $6
	anim_wait 2
	anim_obj BATTLE_ANIM_OBJ_FOCUS, 52, 108, $8
	anim_wait 2
	anim_obj BATTLE_ANIM_OBJ_FOCUS, 28, 108, $8
	anim_wait 2
	anim_obj BATTLE_ANIM_OBJ_FOCUS, 60, 108, $6
	anim_wait 2
	anim_obj BATTLE_ANIM_OBJ_FOCUS, 20, 108, $8
	anim_wait 2
	anim_obj BATTLE_ANIM_OBJ_FOCUS, 68, 108, $8
	anim_wait 2
	anim_ret

BattleAnimSub_QuickAttack:
	anim_obj BATTLE_ANIM_OBJ_SPEED_LINE, 24, 88, $2
	anim_obj BATTLE_ANIM_OBJ_SPEED_LINE, 32, 88, $1
	anim_obj BATTLE_ANIM_OBJ_SPEED_LINE, 40, 88, $0
	anim_obj BATTLE_ANIM_OBJ_SPEED_LINE, 48, 88, $80
	anim_obj BATTLE_ANIM_OBJ_SPEED_LINE, 56, 88, $81
	anim_obj BATTLE_ANIM_OBJ_SPEED_LINE, 64, 88, $82
	anim_ret

BattleAnimSub_Agility:
	anim_setobjpal PAL_BATTLE_OB_BLUE, PAL_BTLCUSTOM_WATER
	anim_obj BATTLE_ANIM_OBJ_AGILITY, 8, 24, $10
	anim_obj BATTLE_ANIM_OBJ_AGILITY, 8, 48, $2
	anim_obj BATTLE_ANIM_OBJ_AGILITY, 8, 88, $8
	anim_wait 4
	anim_obj BATTLE_ANIM_OBJ_AGILITY, 8, 32, $6
	anim_obj BATTLE_ANIM_OBJ_AGILITY, 8, 56, $c
	anim_obj BATTLE_ANIM_OBJ_AGILITY, 8, 80, $4
	anim_obj BATTLE_ANIM_OBJ_AGILITY, 8, 104, $e
	anim_ret

BattleAnimSub_Punch:
	anim_obj BATTLE_ANIM_OBJ_PUNCH_SHAKE, 136, 56, $43
	anim_ret

BattleAnimSub_BGCycleOBPalsGrayAndYellow_$2:
	anim_bgeffect BATTLE_BG_EFFECT_CYCLE_OBPALS_GRAY_AND_YELLOW, $0, $2, $0
	anim_ret

BattleAnim_TargetObj_1Row:
	anim_battlergfx_2row
	anim_bgeffect BATTLE_BG_EFFECT_BATTLEROBJ_1ROW, $0, BG_EFFECT_TARGET, $0
	anim_wait 6
	anim_ret

BattleAnim_TargetObj_2Row:
	anim_battlergfx_1row
	anim_bgeffect BATTLE_BG_EFFECT_BATTLEROBJ_2ROW, $0, BG_EFFECT_TARGET, $0
	anim_wait 6
	anim_ret

BattleAnim_ShowMon_0:
	anim_wait 1
	anim_bgeffect BATTLE_BG_EFFECT_SHOW_MON, $0, BG_EFFECT_TARGET, $0
	anim_wait 5
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_UserObj_1Row:
	anim_battlergfx_2row
	anim_bgeffect BATTLE_BG_EFFECT_BATTLEROBJ_1ROW, $0, BG_EFFECT_USER, $0
	anim_wait 6
	anim_ret

BattleAnim_UserObj_2Row:
	anim_battlergfx_1row
	anim_bgeffect BATTLE_BG_EFFECT_BATTLEROBJ_2ROW, $0, BG_EFFECT_USER, $0
	anim_wait 4
	anim_ret

BattleAnim_ShowMon_1:
	anim_wait 1
	anim_bgeffect BATTLE_BG_EFFECT_SHOW_MON, $0, BG_EFFECT_USER, $0
	anim_wait 4
	anim_incobj 1
	anim_wait 1
	anim_ret

BattleAnim_InWhirlpool:
	anim_1gfx BATTLE_ANIM_GFX_WIND
	anim_bgeffect BATTLE_BG_EFFECT_WHIRLPOOL, $0, $0, $0
	anim_sound 0, 1, SFX_SURF
.loop
	anim_obj BATTLE_ANIM_OBJ_GUST, 132, 72, $0
	anim_wait 6
	anim_loop 6, .loop
	anim_incbgeffect BATTLE_BG_EFFECT_WHIRLPOOL
	anim_wait 1
	anim_ret

BattleAnim_ThrowPokeBall:
	anim_if_param_item_equal NO_ITEM, .TheTrainerBlockedTheBall
	anim_if_param_item_equal MASTER_BALL, .MasterBall
	anim_if_param_item_equal ULTRA_BALL, .UltraBall
	anim_if_param_item_equal GREAT_BALL, .GreatBall
	; any other ball
	anim_2gfx BATTLE_ANIM_GFX_POKE_BALL, BATTLE_ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 68, 92, $40
	anim_wait 36
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj BATTLE_ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 16
	anim_jump .Shake

.TheTrainerBlockedTheBall:
	anim_2gfx BATTLE_ANIM_GFX_POKE_BALL, BATTLE_ANIM_GFX_HIT
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL_BLOCKED, 64, 92, $20
	anim_wait 20
	anim_obj BATTLE_ANIM_OBJ_HIT_YFIX, 112, 40, $0
	anim_wait 32
	anim_ret

.UltraBall:
	anim_2gfx BATTLE_ANIM_GFX_POKE_BALL, BATTLE_ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 68, 92, $40
	anim_wait 36
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj BATTLE_ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 16
	anim_jump .Shake

.GreatBall:
	anim_2gfx BATTLE_ANIM_GFX_POKE_BALL, BATTLE_ANIM_GFX_SMOKE
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 68, 92, $40
	anim_wait 36
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj BATTLE_ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 16
	anim_jump .Shake

.MasterBall:
	anim_3gfx BATTLE_ANIM_GFX_POKE_BALL, BATTLE_ANIM_GFX_SMOKE, BATTLE_ANIM_GFX_SPEED
	anim_sound 6, 2, SFX_THROW_BALL
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 64, 92, $20
	anim_wait 36
	anim_obj BATTLE_ANIM_OBJ_POKE_BALL, 136, 65, $0
	anim_setobj $2, $7
	anim_wait 16
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj BATTLE_ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 24
	anim_sound 0, 1, SFX_MASTER_BALL
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $30
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $31
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $32
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $33
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $34
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $35
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $36
	anim_obj BATTLE_ANIM_OBJ_MASTER_BALL_SPARKLE, 136, 56, $37
	anim_wait 64
.Shake:
	anim_bgeffect BATTLE_BG_EFFECT_RETURN_MON, $0, BG_EFFECT_TARGET, $0
	anim_wait 8
	anim_incobj 2
	anim_wait 16
	anim_sound 0, 1, SFX_CHANGE_DEX_MODE
	anim_incobj 1
	anim_wait 32
	anim_sound 0, 1, SFX_BALL_BOUNCE
	anim_wait 32
	anim_wait 32
	anim_wait 32
	anim_wait 8
	anim_setvar $0
.Loop:
	anim_wait 48
	anim_checkpokeball
	anim_if_var_equal $1, .Click
	anim_if_var_equal $2, .BreakFree
	anim_incobj 1
	anim_sound 0, 1, SFX_BALL_WOBBLE
	anim_jump .Loop

.Click:
	anim_keepspritesandoam
	anim_ret

.BreakFree:
	anim_setobj $1, $b
	anim_sound 0, 1, SFX_BALL_POOF
	anim_obj BATTLE_ANIM_OBJ_BALL_POOF, 136, 64, $10
	anim_wait 2
	anim_bgeffect BATTLE_BG_EFFECT_ENTER_MON, $0, BG_EFFECT_TARGET, $0
	anim_wait 32
	anim_ret
