##############################
# Setup
##############################
#global STAGE 02_place_opt
set STAGE 02_place_opt_v1

set report_dir rpt
set stage_rpt ${report_dir}/${STAGE}
#
#if {![info exist $report_dir]} {exec mkdir $report_dir}
if {[glob -nocomplain $stage_rpt] == ""} {exec mkdir $stage_rpt}

source /ictc/student_data/duyhuong_0108/fn_prj_here/data/scripts/common/common_settings.tcl ;#
source /ictc/student_data/duyhuong_0108/fn_prj_here/data/scripts/common/user_settings.tcl ;#
source /ictc/student_data/duyhuong_0108/fn_prj_here/data/scripts/common/config.tcl
##############################
##############################
## Placement
##############################

place_opt_design

#place_design
#
#timeDesign -preCTS -pathReports -slackReports -numPaths 1000 -prefix place_opt -outDir ./rpt/${STAGE}
#
#saveDesign SAVED/${STAGE}.invs
#return

# set use cell and change drive
setDontUse sg13g2_inv_16 false
setDontUse sg13g2_buf_16 false

#dbget [dbget head.libCells.name sg13g2_buf_16 -p].dontUse

# check legality
#checkPlace

setTieHiLoMode -reset
setTieHiLoMode -cell {sg13g2_tiehi sg13g2_tielo} -maxFanOut 10 -honorDontTouch false -createHierPort false
addTieHiLo -cell {sg13g2_tiehi sg13g2_tielo} -prefix TIE

saveDesign SAVED/${STAGE}.invs
timeDesign -preCTS -pathReports -slackReports -numPaths 1000 -prefix croc_place -outDir ./rpt/${STAGE}/${STAGE}_setup