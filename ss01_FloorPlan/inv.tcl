##############################
# Setup
##############################
set STAGE 00_init_design
#
setMultiCpuUsage -localCpu $env(CPU_NUM)
# limitations under the License.
setPreference ConstraintUserXGrid 0.1
setPreference ConstraintUserXOffset 0.1
setPreference ConstraintUserYGrid 0.1
setPreference ConstraintUserYOffset 0.1
setPreference SnapAllCorners 1

##############################
source /ictc/student_data/duyhuong_0108/fn_prj_here/input_data/all_lef.tcl
set init_verilog /ictc/student_data/duyhuong_0108/fn_prj_here/input_data/netlist/croc_chip_yosys.v
set init_design_uniquify 1
set init_design_settop 1
set init_top_cell croc_chip
set init_lef_file $init_lef_files
set init_mmmc_file /ictc/student_data/duyhuong_0108/fn_prj_here/input_data/croc_mmmc.view
#set init_mmmc_file /ictc/student_data/share/pd/data/user_setting/backup/croc_mmmc.view
set init_pwr_net {PWR}
set init_gnd_net {GND}

init_design

puts "Done init design. Please check log file if any errors during init design"

puts "REQUEST: Target utilization is 58%! Please adjust core area to achieve this utilization and continue!"

floorPlan -site CoreSite -d 1640 1640 68 68 68 68
#return

# save design
saveDesign SAVED/${STAGE}_init.invs
#
# check library usage
check_library -all_lib_cell -place > rpt/${STAGE}/check_library.rpt

#update name
source data/scripts/common/update_names_format.tcl

####################
# Create row
####################
deleteRow -all
initCoreRow
cutRow

####################
# Create track
####################
add_tracks -offset {Metal1 vert 0 Metal2 horiz 0 Metal3 vert 0 Metal4 horiz 0 Metal5 vert 0 TopMetal1 horiz 0 TopMetal2 vert 0}

####################
# Report utilization
####################
checkFPlan -reportUtil > rpt/${STAGE}/check_library.rpt

####################
# Place Hardmacro
####################
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloTop 10
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloBot 10
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloLeft 10
dbset [dbget top.insts.cell.baseClass  block -p2 ].pHaloRight 10

#placeInstance {i_croc_soc/i_croc/gen_sram_bank[1].i_sram/gen_512x32x8x1.i_cut} -fixed {607.52 248.04}
#placeInstance {i_croc_soc/i_croc/gen_sram_bank[0].i_sram/gen_512x32x8x1.i_cut} -fixed {607.52 386.59}
#i_croc_soc/i_croc/gen_sram_bank[1].i_sram/gen_512x32x8x1.i_cut
#i_croc_soc/i_croc/gen_sram_bank[0].i_sram/gen_512x32x8x1.i_cut

# main
placeInstance {i_croc_soc/i_croc/gen_sram_bank_1__i_sram/gen_512x32x8x1_i_cut} -fixed {593.0 399.24}
placeInstance {i_croc_soc/i_croc/gen_sram_bank_0__i_sram/gen_512x32x8x1_i_cut} -fixed {593.0 259.28}

#i_croc_soc/i_croc/gen_sram_bank_1__i_sram/gen_512x32x8x1_i_cut
#i_croc_soc/i_croc/gen_sram_bank_0__i_sram/gen_512x32x8x1_i_cut

####################
# Check design
####################
checkDesign -all > rpt/${STAGE}/check_design.rpt

####################
# Global Connect
####################
clearGlobalNets
globalNetConnect PWR -type pgpin -pin VDD -inst * -override
globalNetConnect GND -type pgpin -pin VSS -inst * -override

# Boundary rings
#addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer met5 -type core_rings -jog_distance 1.7 -threshold 1.7 -nets {PWR GND} -follow core -layer {top met5 bottom met5 right met4 left met4} -width 4 -spacing 2 -offset 5

####################
# Add endcap
####################
setEndCapMode -prefix ENDCAP -leftEdge sky130_fd_sc_hd__endcap -rightEdge sky130_fd_sc_hd__endcap
addEndCap
# verify end cap
verifyEndCap

####################
### Add PG
####################
source -e -v /ictc/student_data/duyhuong_0108/fn_prj_here/data/scripts/PG/create_pg.tcl
#verify power via
verifyPowerVia

# check open
verify_connectivity -net {PWR GND}

saveDesign SAVED/${STAGE}_PG.invs

####################
# Add Well Tap
####################
addWellTap -cell sky130_fd_sc_hd__tapvpwrvgnd_1 -cellInterval 40 -inRowOffset 25 -prefix WELLTAP

saveDesign SAVED/${STAGE}.invs
source /ictc/student_data/duyhuong_0108/fn_prj_here/data/scripts/utility/report_timing_format.tcl
# report timing
timeDesign -prePlace -pathReports -slackReports -numPaths 1000 -prefix ${STAGE}_prePlace -outDir ./rpt/${STAGE}_prePlace