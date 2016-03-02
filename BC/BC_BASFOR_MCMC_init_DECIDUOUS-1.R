## MCMC chain length ##
   nChain                   <- as.integer(100)

## PRIOR ##
   file_prior               <- 'parameters/parameters_BC_DECIDUOUS-1.txt'
   
## INITIALISATION FILES FOR THE DIFFERENT CALIBRATION SITES ##
   sitesettings_files       <- c('initialisation/initialise_BASFOR_DECIDUOUS-1.R')

## DATA FILES ##
   sitedata_ancillary_files <- c('data/data_ancillary_DECIDUOUS-1.txt')
   sitedata_annual_files    <- c('data/data_ANNUAL_DECIDUOUS-1.txt')
   sitedata_daily_files     <- c('data/data_daily_DECIDUOUS-1.txt')
   sitedata_EC_files        <- c('data/data_EC_DECIDUOUS-1.txt')

## PROPOSAL TUNING FACTOR  
   fPropTuning              <- 0.1 # This factor is used to modify Gelman's
                                   # suggested average step length, which is
                                   # equal to 2.38^2 / np_BC and seems too big
   
## GENERAL INITIALISATION FOR MCMC
   source('BC/BC_BASFOR_MCMC_init_general.R')
