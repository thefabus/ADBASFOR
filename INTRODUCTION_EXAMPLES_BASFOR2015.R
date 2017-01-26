### EXAMPLES OF SCRIPT-CODE FOR BASFOR
### MvO, 2017-01-24
### This file gives some (sparsely commented) examples of code that can
### be included in R-scripts for working with forest model BASFOR



############### 1. INITIALISING AND CHOOSING OUTPUT VARIABLES FOR LATER ANALYSIS

source("initialisation/initialise_BASFOR_general.R")
vars_analysis <- outputNames[4:20]



############### 2. EXAMPLES FOR CONIFEROUS FOREST

### 2.1 RUNNING AND PLOTTING
source("run_BASFOR_CONIFEROUS-1.R")
plot_output ( head(output,   3), vars_analysis )
output[1:3,4:20]
plot_output ( head(output, 730), vars_analysis )
plot_output ( head(output,3625), vars_analysis )
plot_output ( tail(output,3625), vars_analysis )
plot_output (      output,       vars_analysis )
table_output( output, vars_analysis,
              file_table  = paste( "output_CONIFEROUS-1_", format(Sys.time(),"%H_%M.txt"), sep="" ) ) # THIS PRODUCES A TXT-FILE THAT CAN BE INSPECTED IN EXCEL

### 2.2 SENSITIVITY ANALYSIS
parname_SA    <- "CSOM0"
SA( parname_SA = parname_SA,
    pmult      = c(0.5,1,2),
    vars       = vars_analysis,
    file_init  = "initialisation/initialise_BASFOR_CONIFEROUS-1.R",
    file_plot  = paste("SA_CONIFEROUS-1_",parname_SA,format(Sys.time(),"_%H_%M.pdf"),sep=""),
    file_table = paste("SA_CONIFEROUS-1_",parname_SA,format(Sys.time(),"_%H_%M.txt"),sep="") )
# NOW YOU CAN INSPECT THE TXT-FILE AND PDF-FILE THAT HAVE BEEN PRODUCED

### 2.3 BAYESIAN CALIBRATION FOR MULTIPLE PINE SITES
source("BC_BASFOR_CONIFEROUS-1&2.R")
# NOW YOU CAN INSPECT THE TXT-FILE AND PDF-FILES THAT HAVE BEEN PRODUCED



############### 3. EXAMPLES FOR DECIDUOUS FOREST

### 3.1 RUNNING AND PLOTTING
source("run_BASFOR_DECIDUOUS-1.R")
plot_output ( head(output, 100), vars_analysis )
output[1:100,8:9]
plot_output ( head(output, 365), vars_analysis )
plot_output ( head(output,3625), vars_analysis )
plot_output ( tail(output,3625), vars_analysis )
plot_output (      output,       vars_analysis )
table_output( output, vars_analysis,
              file_table  = paste( "output_DECIDUOUS-1_", format(Sys.time(),"%H_%M.txt"), sep="" ) ) # THIS PRODUCES A TXT-FILE THAT CAN BE INSPECTED IN EXCEL

### 3.2 SENSITIVITY ANALYSIS
SA( parname_SA = parname_SA,
    pmult      = c(0.5,1,2),
    vars       = vars_analysis,
    file_init  = "initialisation/initialise_BASFOR_DECIDUOUS-1.R",
    file_plot  = paste("SA_DECIDUOUS-1_",parname_SA,format(Sys.time(),"_%H_%M.pdf"),sep=""),
    file_table = paste("SA_DECIDUOUS-1_",parname_SA,format(Sys.time(),"_%H_%M.txt"),sep="") )
# NOW YOU CAN INSPECT THE TXT-FILE AND PDF-FILE THAT HAVE BEEN PRODUCED

### 3.3 BAYESIAN CALIBRATION FOR MULTIPLE DECIDUOUS SITES
source("BC_BASFOR_DECIDUOUS-1&2.R")
# NOW YOU CAN INSPECT THE TXT-FILE AND PDF-FILES THAT HAVE BEEN PRODUCED
