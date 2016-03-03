## MCMC chain length ##
   nChain                   <- as.integer(100)

## PRIOR ##
   file_prior               <- 'parameters/parameters_BC_CONIFEROUS-1.2.txt'
   
## INITIALISATION FILES FOR THE DIFFERENT CALIBRATION SITES ##
   sitesettings_files       <- c('initialisation/initialise_BASFOR_CONIFEROUS-1.R',
                                 'initialisation/initialise_BASFOR_CONIFEROUS-2.R')

## DATA FILES ##
   sitedata_ancillary_files <- c('data/data_ancillary_CONIFEROUS-1.txt',
                                 'data/data_ancillary_CONIFEROUS-2.txt')
   sitedata_annual_files    <- c('',
                                 '')
   sitedata_daily_files     <- c('data/data_daily_CONIFEROUS-1.txt',
                                 'data/data_daily_CONIFEROUS-2.txt')
   sitedata_EC_files        <- c('data/data_EC_CONIFEROUS-1.txt',
                                 'data/data_EC_CONIFEROUS-2.txt')

## PROPOSAL TUNING FACTOR  
   fPropTuning              <- 0.1 # This factor is used to modify Gelman's
                                   # suggested average step length, which is
                                   # equal to 2.38^2 / np_BC and seems too big
   
## GENERAL INITIALISATION FOR MCMC
   source('BC/BC_BASFOR_MCMC_init_general.R')
