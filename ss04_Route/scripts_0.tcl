##############################
# Setup
##############################
set STAGE 05_route
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

#setNanoRouteMode -quiet -routeBottomRoutingLayer default

setDesignMode -topRoutingLayer 5
setDesignMode -bottomRoutingLayer 2

#setDesignMode -topRoutingLayer 7
#setDesignMode -bottomRoutingLayer 1

setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
setNanoRouteMode -routeExpAdvancedPinAccess 2
setNanoRouteMode -drouteUseMultiCutViaEffort default

routeDesign -globalDetail

saveDesign SAVED/${STAGE}.invs

timeDesign -postRoute        -pathReports -slackReports -numPaths 1000 -prefix croc_postRoute -outDir ./rpt/${STAGE}/${STAGE}_setup
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 1000 -prefix  croc_postRoute -outDir ./rpt/${STAGE}/${STAGE}_hold
# run checkers
checkPlace > rpt/${STAGE}/checkPlace.rpt