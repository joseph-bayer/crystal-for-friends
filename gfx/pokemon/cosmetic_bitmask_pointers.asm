PikachuBitmasksPointers:
	table_width 2
	dw PikachuPlainBitmask
	dw PikachuSurfBitmask
	dw PikachuFlyBitmask
	assert_table_length NUM_PIKACHU_FORMS

ShuckleBitmasksPointers:
	table_width 2
	dw ShucklePlainBitmasks
	dw ShuckleShuckieNeutralBitmasks
	dw ShuckleShuckieHappyBitmasks
	assert_table_length NUM_SHUCKLE_FORMS

UnownBitmasksPointers:
	table_width 2
	dw UnownABitmasks
	dw UnownBBitmasks
	dw UnownCBitmasks
	dw UnownDBitmasks
	dw UnownEBitmasks
	dw UnownFBitmasks
	dw UnownGBitmasks
	dw UnownHBitmasks
	dw UnownIBitmasks
	dw UnownJBitmasks
	dw UnownKBitmasks
	dw UnownLBitmasks
	dw UnownMBitmasks
	dw UnownNBitmasks
	dw UnownOBitmasks
	dw UnownPBitmasks
	dw UnownQBitmasks
	dw UnownRBitmasks
	dw UnownSBitmasks
	dw UnownTBitmasks
	dw UnownUBitmasks
	dw UnownVBitmasks
	dw UnownWBitmasks
	dw UnownXBitmasks
	dw UnownYBitmasks
	dw UnownZBitmasks
	assert_table_length NUM_UNOWN

MagikarpBitmasksPointers:
	table_width 2
	dw MagikarpPlainBitmasks
	dw MagikarpXSBitmasks
	dw MagikarpXLBitmasks
	assert_table_length NUM_MAGIKARP_FORMS