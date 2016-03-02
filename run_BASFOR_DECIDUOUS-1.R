## 1. INITIALISATION ##
   source('initialisation/initialise_BASFOR_DECIDUOUS-1.R')
   
## 2. RUNNING ##
   output <- run_model()

## 3. PRINTING AND PLOTTING ##
   print(format(output[NDAYS,which(outputNames=="H")],digits=15))
   plot_output(vars=outputNames[4:17])
   plot_output(vars=outputNames[18:32])
