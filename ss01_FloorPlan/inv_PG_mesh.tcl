editDelete -type Special -use POWER
### pg connection for sram ###

globalNetConnect PWR -type pgpin -pin VDDARRAY  -inst * -override
globalNetConnect PWR -type pgpin -pin VDDARRAY! -inst * -override
globalNetConnect PWR -type pgpin -pin VDD!      -inst * -override
globalNetConnect GND -type pgpin -pin VSS!      -inst * -override
# refer for IOPAD pg connection /ictc/teacher_data/ictc_thenguyen/croc/openroad/scripts/power_connect.tcl

#set box [dbShape -output rect [dbGet [dbGet top.insts.cell.baseClass block -p2 ].box ] SIZE 10]
#createRouteBlk -name sram_rblk -layer Metal5 -box $box

deselectAll
selectInst i_croc_soc/i_croc/gen_sram_bank_1__i_sram/gen_512x32x8x1_i_cut
set box_1 [dbShape -output rect [dbGet selected.box ] SIZE 10]
createRouteBlk -name sram_rblk -layer Metal5 -box $box_1

deselectAll
selectInst i_croc_soc/i_croc/gen_sram_bank_0__i_sram/gen_512x32x8x1_i_cut
set box_2 [dbShape -output rect [dbGet selected.box ] SIZE 10]
createRouteBlk -name sram_rblk -layer Metal5 -box $box_2

sroute -connect { blockPin corePin floatingStripe } -layerChangeRange { Metal1 TopMetal2 } -blockPinTarget { nearestRingStripe nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { Metal1 TopMetal2 } -nets {PWR GND} -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { Metal1 TopMetal2 }

setAddStripeNode -reset
setAddStripeNode -stacked_via_top_layer Metal3 -stacked_via_bottom_layer Metal1 -stapling_nets_style side_to_side
addStripe -layer Metal3 -direction vertical -nets {PWR GND} -width 1 -set_to_set_distance 15 -spacing 2 -area {248.16 248.04 1392.0 1392.06}

setAddStripeNode -reset
setAddStripeNode -stacked_via_top_layer Metal4 -stacked_via_bottom_layer Metal3 -stapling_nets_style side_to_side
addStripe -layer Metal4 -direction horizontal -nets {PWR GND} -width 1 -set_to_set_distance 33 -spacing 2 -area {248.16 248.04 1392.0 1392.06}

setAddStripeNode -stacked_via_top_layer Metal5 -stacked_via_bottom_layer Metal4 -stapling_nets_style side_to_side
addStripe -layer Metal5 -direction vertical -nets {PWR GND} -width 1 -set_to_set_distance 15 -spacing 2 -area {248.16 248.04 1392.0 1392.06}
# editDelete -type Special -use POWER -layer {TopMetal1 TopMetal2}
setAddStripeNode -stacked_via_top_layer TopMetal1 -stacked_via_bottom_layer Metal5 -stapling_nets_style side_to_side
addStripe -layer TopMetal1 -direction horizontal -nets {PWR GND} -width 4 -set_to_set_distance 33 -spacing 4 -area {248.16 248.04 1392.0 1392.06}

setAddStripeNode -stacked_via_top_layer TopMetal2 -stacked_via_bottom_layer TopMetal1 -stapling_nets_style side_to_side
addStripe -layer TopMetal2 -direction vertical -nets {PWR GND} -width 4 -set_to_set_distance 30 -spacing 4

#deleteRouteBlk for sram
deleteRouteBlk -name sram_rblk
editPowerVia -nets PWR -add_vias true -top_layer TopMetal1 -area {609.6 191.94 1412.16 464.52} -uda -orthogonal_only
editPowerVia -nets GND -add_vias true -top_layer TopMetal1 -area {609.6 191.94 1412.16 464.52} -uda -orthogonal_only

#set cmd "editPowerVia -nets PWR -add_vias true -top_layer TopMetal1 -area  $box -uda -orthogonal_only"
#eval $cmd
#set cmd "editPowerVia -nets GND -add_vias true -top_layer TopMetal1 -area  $box -uda -orthogonal_only"
#eval $cmd

set cmd "editPowerVia -nets PWR -add_vias true -top_layer TopMetal1 -area  $box_1 -uda -orthogonal_only"
eval $cmd
set cmd "editPowerVia -nets GND -add_vias true -top_layer TopMetal1 -area  $box_1 -uda -orthogonal_only"
eval $cmd

set cmd "editPowerVia -nets PWR -add_vias true -top_layer TopMetal1 -area  $box_2 -uda -orthogonal_only"
eval $cmd
set cmd "editPowerVia -nets GND -add_vias true -top_layer TopMetal1 -area  $box_2 -uda -orthogonal_only"
eval $cmd

###
#verifyPowerVia