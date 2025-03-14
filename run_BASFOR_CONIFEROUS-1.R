## 1. INITIALISATION ##
   source('initialisation/initialise_BASFOR_CONIFEROUS-1.R')
   
## 2. RUNNING ##
   output <- run_model()
   
## 3. PRINTING AND PLOTTING ##
   print(format(output[NDAYS,which(outputNames=="H")],digits=15))
   plot_output(vars=outputNames[4:17])
   plot_output(vars=outputNames[18:32])

   write.table(output, "output_R.csv", sep = ",", row.names = FALSE, col.names = FALSE, quote = FALSE)
