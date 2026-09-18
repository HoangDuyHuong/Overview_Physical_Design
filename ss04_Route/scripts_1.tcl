#
# Setup
##############################
set STAGE 06_route_opt
# limitations under the License.
set central_path data
source ${central_path}/scripts/common/common_settings.tcl
source ${central_path}/scripts/common/user_settings.tcl
source ${central_path}/scripts/common/config.tcl
exec mkdir -p ./rpt/${STAGE}
##############################
#setDontUse sg13g2_inv_16 false
#setDontUse sg13g2_buf_16 false

##############################
# Routing
##############################
setNanoRouteMode -reset
setNanoRouteMode -dbProcessNode 130
setNanoRouteMode -quiet -routeInsertAntennaDiode 1
setNanoRouteMode -quiet -routeAntennaCellName sky130_fd_sc_hd__diode_2
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithSiDriven 1
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
setNanoRouteMode -routeExpAdvancedPinAccess 2
setNanoRouteMode -drouteUseMultiCutViaEffort default

setOptMode -addInstancePrefix ictc_postRoute_setup_
optDesign -postRoute

saveDesign SAVED/${STAGE}_setup.invs

timeDesign -postRoute        -pathReports -slackReports -numPaths 1000 -prefix croc_postRoute -outDir ./rpt/${STAGE}/${STAGE}_setup
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 1000 -prefix  croc_postRoute -outDir ./rpt/${STAGE}/${STAGE}_hold

if 0 {
# fixing hold
setOptMode -addInstancePrefix ictc_postRoute_hold_
optDesign -postRoute -hold

saveDesign SAVED/${STAGE}_setup.invs

timeDesign -postRoute        -pathReports -slackReports -numPaths 1000 -prefix croc_postRoute -outDir ./rpt/${STAGE}/${STAGE}_setup
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 1000 -prefix  croc_postRoute -outDir ./rpt/${STAGE}/${STAGE}_hold
}

saveDesign SAVED/${STAGE}.invs
# run checkers
checkFPlan -reportUtil > rpt/${STAGE}/check_util.rpt
checkPlace > rpt/${STAGE}/checkPlace.rpt
verify_drc -limit 0 > rpt/${STAGE}/verify_drc.rpt

##############################
# Filler insertion
##############################
setFillerMode -core {sg13g2_fill_1 sg13g2_fill_2 sg13g2_fill_4 sg13g2_fill_8} -corePrefix FILLER
addFiller -doDrc false
checkFiller

saveDesign SAVED/${STAGE}_filler.invs
##############################
# Export data
##############################
mkdir -p output
# output DEF
defOut -unit 1000 -usedVia -routing output/${STAGE}/[dbget top.name].def.gz

# Export verilog netlist
saveNetlist  output/${STAGE}/[dbget top.name].v

#Export LEF file
write_lef_abstract -extractBlockObs -cutObsMinSpacing -specifyTopLayer TopMetal2 -5.8 -extractBlockPGPinLayers {TopMetal1 TopMetal2}  output/${STAGE}/[dbget top.name].lef