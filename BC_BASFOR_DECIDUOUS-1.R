## 1. INITIALISE MCMC ##
   source('BC/BC_BASFOR_MCMC_init_DECIDUOUS-1.R')

## 2. RUNNING THE MCMC ##
   source('BC/BC_BASFOR_MCMC.R')

## 3. PRINTING AND PLOTTING ##
   source('BC/BC_export_parModes.R')
   source('BC/BC_plot_parameters_traceplots.R')
   source('BC/BC_plot_parameters_priorbeta_histograms.R')
   source('BC/BC_plot_outputs_data.R')

## 4. SAVING WORKSPACE
#    imagefilename <- paste( "BC_BASFOR_DECIDUOUS-1",
#                             format(Sys.time(),"_%H_%M.Rdata"), sep="" )
#    save.image(file=imagefilename)
