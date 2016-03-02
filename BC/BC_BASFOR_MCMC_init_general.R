## SITE CONDITIONS
   nSites              <- length(sitesettings_files)
   sitelist            <- list()   ; length(sitelist)    <- nSites
   list_params         <- sitelist ; list_matrix_weather <- sitelist
   list_calendar_fert  <- sitelist ; list_calendar_Ndep  <- sitelist
   list_calendar_prunT <- sitelist ; list_calendar_thinT <- sitelist
   list_NDAYS          <- sitelist

   for (s in 1:nSites) {
     source( sitesettings_files[s] )
     list_params        [[s]] <- params         ; list_matrix_weather[[s]] <- matrix_weather
     list_calendar_fert [[s]] <- calendar_fert  ; list_calendar_Ndep [[s]] <- calendar_Ndep
     list_calendar_prunT[[s]] <- calendar_prunT ; list_calendar_thinT[[s]] <- calendar_thinT
	   list_NDAYS         [[s]] <- NDAYS   
   } 
   
## COLUMN NUMBERS FOR SPECIFIC OUTPUTS ##
 # Output column numbers for DAILY data & EC data
   iWCoutput  <- which(outputNames=="WC"       )
   iNEEoutput <- which(outputNames=="NEE_gCm2d")
   iGPPoutput <- which(outputNames=="GPP_gCm2d")
   iEToutput  <- which(outputNames=="ET_mmd"   )

## DATA PROCESSING (daily, EC) ##
   # Properties of data: interval duration for avareaging, NaN-limit,
   # coeffients of variation & column numbers of variable values
   # DAILY data:
   int_daily  <- 30 ; nnamax_daily <- 1 ; cv_daily <- 0.3
   iWCdata    <- 4
   # EC data:
   int_EC     <- 30 ; nnamax_EC    <- 1 ; cv_EC    <- 0.3
   iNEEdata   <- 4  ; iGPPdata     <- 5 ; iETdata  <- 6
   
## ANCILLARY DATA ##
   data_ancillary_index <- sitelist ; data_ancillary_name <- sitelist
   data_ancillary_year  <- sitelist ; data_ancillary_doy  <- sitelist
   data_ancillary_time  <- sitelist
   data_ancillary_value <- sitelist ; data_ancillary_sd   <- sitelist
   for (s in 1:nSites) {
     if (sitedata_ancillary_files[s]!="") {
       dataset_ancillary_s <- read.table(sitedata_ancillary_files[s],header=F,sep="")
       data_ancillary_name [[s]] <- dataset_ancillary_s[,1]
       data_ancillary_year [[s]] <- dataset_ancillary_s[,2]
       data_ancillary_doy  [[s]] <- dataset_ancillary_s[,3]
       data_ancillary_time [[s]] <- data_ancillary_year[[s]] + (data_ancillary_doy[[s]]-0.5)/366
       data_ancillary_value[[s]] <- dataset_ancillary_s[,4]
       data_ancillary_sd   [[s]] <- dataset_ancillary_s[,5]
     # The data_ancillary_index gives the model output number for each ancillary data point
       data_ancillary_index[[s]] <- sapply( 1:length(data_ancillary_name[[s]]), function(i)
                   which( outputNames == data_ancillary_name[[s]][i]) )
     }
   }
   
## ANNUAL DATA ##
   data_annual_index <- sitelist ; data_annual_name <- sitelist
   data_annual_year  <- sitelist ; data_annual_doy  <- sitelist
   data_annual_time  <- sitelist
   data_annual_value <- sitelist ; data_annual_sd   <- sitelist
   for (s in 1:nSites) {
     if (sitedata_annual_files[s]!="") {
       dataset_annual_s <- read.table(sitedata_annual_files[s],header=F,sep="")
       data_annual_name [[s]] <- dataset_annual_s[,1]
       data_annual_year [[s]] <- dataset_annual_s[,2]
       data_annual_doy  [[s]] <- dataset_annual_s[,3]
       data_annual_time [[s]] <- data_annual_year[[s]] + (data_annual_doy[[s]]-0.5)/366
       data_annual_value[[s]] <- dataset_annual_s[,4]
       data_annual_sd   [[s]] <- dataset_annual_s[,5]
     # The data_annual_index gives the model output number for each annual data value
       data_annual_index[[s]] <- sapply( 1:length(data_annual_name[[s]]), function(i)
                   which( outputNames == data_annual_name[[s]][i]) )
     }
   }

## DAILY DATA ##
   i1_WC             <- sitelist
   data_WCmean_year  <- sitelist ; data_WCmean_doy <- sitelist
   data_WCmean_time  <- sitelist
   data_WCmean_value <- sitelist ; data_WCmean_sd  <- sitelist
   for (s in 1:nSites) {
     if (sitedata_daily_files[s]!="") {
       dataset_daily_s        <- read.table(sitedata_daily_files[s],header=F,sep="")
       data_daily_year_s      <- dataset_daily_s[,2]
       data_daily_doy_s       <- dataset_daily_s[,3]
       data_WC_s              <- dataset_daily_s[,iWCdata]
     # WC
       i1_WC_pot              <- seq( 1, length(data_WC_s), int_daily )
       nna_WC                 <- sapply( i1_WC_pot , function(i) sum(is.na(data_WC_s[i:(i+int_daily-1)])) )
       i1_WC[[s]]             <- i1_WC_pot[ which(nna_WC<nnamax_daily) ]
       data_WCmean_year [[s]] <- sapply( i1_WC[[s]], function(i) data_daily_year_s[i] )
       data_WCmean_doy  [[s]] <- sapply( i1_WC[[s]], function(i) data_daily_doy_s[i] )
       data_WCmean_time [[s]] <- data_WCmean_year[[s]] + (data_WCmean_doy[[s]]-0.5)/366
       data_WCmean_value[[s]] <- sapply( i1_WC[[s]], function(i) mean( na.omit(data_WC_s[i:(i+int_daily-1)]) ) )
       sdmin_WC               <- cv_daily * abs(data_WCmean_value[[s]])
       data_WCmean_sd   [[s]] <- sapply( 1:length(sdmin_WC), function(i) max(sdmin_WC[i],1.0) )
     }
   }

## EC DATA ##
   i1_NEE             <- sitelist ; i1_GPP           <- sitelist ; i1_ET <- sitelist
   data_NEEmean_year  <- sitelist ; data_NEEmean_doy <- sitelist
   data_NEEmean_time  <- sitelist
   data_NEEmean_value <- sitelist ; data_NEEmean_sd  <- sitelist
   data_GPPmean_year  <- sitelist ; data_GPPmean_doy <- sitelist
   data_GPPmean_time  <- sitelist
   data_GPPmean_value <- sitelist ; data_GPPmean_sd  <- sitelist
   data_ETmean_year   <- sitelist ; data_ETmean_doy  <- sitelist
   data_ETmean_time   <- sitelist
   data_ETmean_value  <- sitelist ; data_ETmean_sd   <- sitelist
   for (s in 1:nSites) {
     if (sitedata_EC_files[s]!="") {
       dataset_EC_s     <- read.table(sitedata_EC_files[s],header=T,sep="")
       data_EC_year_s   <- dataset_EC_s[,1]
       data_EC_doy_s    <- dataset_EC_s[,2]
       data_NEE_s       <- dataset_EC_s[,iNEEdata]
       data_GPP_s       <- dataset_EC_s[,iGPPdata]
       data_ET_s        <- dataset_EC_s[,iETdata ]
     # NEE
       i1_NEE_pot              <- seq( 1, length(data_NEE_s), int_EC )
       nna_NEE                 <- sapply( i1_NEE_pot, function(i) sum(is.na(data_NEE_s[i:(i+int_EC-1)])) )
       i1_NEE[[s]]             <- i1_NEE_pot[ which(nna_NEE<nnamax_EC) ]
       data_NEEmean_year [[s]] <- sapply( i1_NEE[[s]], function(i) data_EC_year_s[i] )
       data_NEEmean_doy  [[s]] <- sapply( i1_NEE[[s]], function(i) data_EC_doy_s[i] )
       data_NEEmean_time [[s]] <- data_NEEmean_year[[s]] + (data_NEEmean_doy[[s]]-0.5)/366
       data_NEEmean_value[[s]] <- sapply( i1_NEE[[s]], function(i) mean( na.omit(data_NEE_s[i:(i+int_EC-1)]) ) )
       sdmin_NEE               <- cv_EC * abs(data_NEEmean_value[[s]])
       data_NEEmean_sd   [[s]] <- sapply( 1:length(sdmin_NEE), function(i) max(sdmin_NEE[i],1.0) )
     # GPP
       i1_GPP_pot              <- seq( 1, length(data_GPP_s), int_EC )
       nna_GPP                 <- sapply( i1_GPP_pot, function(i) sum(is.na(data_GPP_s[i:(i+int_EC-1)])) )
       i1_GPP[[s]]             <- i1_GPP_pot[ which(nna_GPP<nnamax_EC) ]
       data_GPPmean_year [[s]] <- sapply( i1_GPP[[s]], function(i) data_EC_year_s[i] )
       data_GPPmean_doy  [[s]] <- sapply( i1_GPP[[s]], function(i) data_EC_doy_s[i] )
       data_GPPmean_time [[s]] <- data_GPPmean_year[[s]] + (data_GPPmean_doy[[s]]-0.5)/366
       data_GPPmean_value[[s]] <- sapply( i1_GPP[[s]], function(i) mean( na.omit(data_GPP_s[i:(i+int_EC-1)]) ) )
       sdmin_GPP               <- cv_EC * abs(data_GPPmean_value[[s]])
       data_GPPmean_sd   [[s]] <- sapply( 1:length(sdmin_GPP), function(i) max(sdmin_GPP[i],1.0) )
     # ET
       i1_ET_pot               <- seq( 1, length(data_ET_s), int_EC )
       nna_ET                  <- sapply( i1_ET_pot, function(i) sum(is.na(data_ET_s[i:(i+int_EC-1)])) )
       i1_ET[[s]]              <- i1_ET_pot[ which(nna_ET<nnamax_EC) ]
       data_ETmean_year [[s]]  <- sapply( i1_ET[[s]], function(i) data_EC_year_s[i] )
       data_ETmean_doy  [[s]]  <- sapply( i1_ET[[s]], function(i) data_EC_doy_s[i] )
       data_ETmean_time [[s]]  <- data_ETmean_year[[s]] + (data_ETmean_doy[[s]]-0.5)/366
       data_ETmean_value[[s]]  <- sapply( i1_ET[[s]], function(i) mean( na.omit(data_ET_s[i:(i+int_EC-1)]) ) )
       sdmin_ET                <- cv_EC * abs(data_ETmean_value[[s]])
       data_ETmean_sd   [[s]]  <- sapply( 1:length(sdmin_ET), function(i) max(sdmin_ET[i],1.0) )
     }
   }

## PRIOR DISTRIBUTION FOR THE PARAMETERS ##
   df_params_BC <- read.table( file_prior, header=F, sep="" )
   parname_BC   <-               df_params_BC[,1]
   parmin_BC    <-               df_params_BC[,2]
   parmod_BC    <-               df_params_BC[,3]
   parmax_BC    <-               df_params_BC[,4]
   parsites_BC  <- as.character( df_params_BC[,5] )
   ip_BC        <- match( parname_BC, row.names(df_params) )
   np_BC        <- length(ip_BC)
   
   ip_BC_site   <- sitelist ; icol_pChain_site <- sitelist
   for (p in 1:np_BC) {
     for ( s in 1:nSites ) {
       if( s %in% eval( parse( text = parsites_BC[p] ) ) ) {
         ip_BC_site[[s]]       <- cbind( ip_BC_site[[s]]      , ip_BC[p] )
         icol_pChain_site[[s]] <- cbind( icol_pChain_site[[s]], p        )
       }
     }
   }
 # We scale all parameters by dividing by the mean of the absolute extremes
   sc            <- rowMeans( abs( cbind(parmin_BC,parmax_BC) ) )
   scparmin_BC   <- parmin_BC / sc
   scparmax_BC   <- parmax_BC / sc
   scparmod_BC   <- parmod_BC / sc
 # We use the beta distribution with parameters aa and bb estimated as follows
   aa            <- 1. + 4 * ((scparmod_BC[1:np_BC]-scparmin_BC[1:np_BC]) / 
                              (scparmax_BC[1:np_BC]-scparmin_BC[1:np_BC]))
   bb            <- 6. - aa 

## INITIALISING THE CHAIN ##
   nBurnIn       <- as.integer(nChain/10)
   pChain        <- matrix(0, nrow=nChain, ncol=np_BC)
 # We start the chain at the mode of the prior parameter distribution
   scpValues_BC  <- scparmod_BC ; pChain[1,] <- scpValues_BC
 # Value of the prior at the start of the chain
   pBetaValues   <- (scpValues_BC[1:np_BC] - scparmin_BC[1:np_BC]) / 
                    (scparmax_BC [1:np_BC] - scparmin_BC[1:np_BC])
   logPrior0Beta <- sum( dbeta(pBetaValues,aa,bb,log=T) )
   logPrior0     <- logPrior0Beta
   
## PROPOSAL DISTRIBUTION ##
 # Load library MASS, which has a routine for multivariate normal random number generation
   library(MASS)
   vcovProp    <- matrix(0,np_BC,np_BC)
   stddev_beta <- sqrt( (aa*bb) / ((1+aa+bb)*(aa+bb)**2.) )
   stddev_beta <- stddev_beta * (scparmax_BC[1:np_BC]-scparmin_BC[1:np_BC])
   fPropGelman <- 2.38^2 / np_BC # Proposal scaling factor suggested by Gelman et al. (1996)
   vcovProp    <- diag(stddev_beta^2) * fPropGelman * fPropTuning
   
## LIKELIHOOD FUNCTION ##
   source('BC/fLogL_Sivia.R')
   
## FIRST ITERATION
   list_output                <- sitelist
   list_output_ancillary_rows <- sitelist ; list_output_annual_rows <- sitelist
   list_output_WC_rows        <- sitelist
   list_output_NEE_rows       <- sitelist ; list_output_GPP_rows    <- sitelist
   list_output_ET_rows        <- sitelist
   pValues_BC                 <- scpValues_BC * sc

   for (s in 1:nSites) {
   # Site-specific model initialisation
     params         <- list_params        [[s]] ; matrix_weather <- list_matrix_weather[[s]]
     calendar_fert  <- list_calendar_fert [[s]] ; calendar_Ndep  <- list_calendar_Ndep [[s]] 
     calendar_prunT <- list_calendar_prunT[[s]] ; calendar_thinT <- list_calendar_thinT[[s]]  
  	 NDAYS          <- list_NDAYS         [[s]]   
   # Values of calibration parameters at the start of the chain
     params[ ip_BC_site[[s]] ] <- pValues_BC[ icol_pChain_site[[s]] ]
   # run model for each site and store output in list_output
     output           <- run_model( p     = params        ,
                                    w     = matrix_weather,
                                    calf  = calendar_fert ,
                                    calN  = calendar_Ndep ,
	                                  calpT = calendar_prunT,
                                    caltT = calendar_thinT,
                                    n     = NDAYS          )
     list_output[[s]] <- output

   # Ancillary data for site s
     if (sitedata_ancillary_files[s] != "") {
       ndata_ancillary_s               <- length(data_ancillary_year[[s]])
       list_output_ancillary_rows[[s]] <- sapply( 1:ndata_ancillary_s, function(i) 
         which( output[,2]==data_ancillary_year[[s]][i] &
                output[,3]==data_ancillary_doy[[s]][i] ) )
     }     
   # Annual data for site s  
     if (sitedata_annual_files[s] != "") {
       ndata_annual_s               <- length(data_annual_year[[s]])
       list_output_annual_rows[[s]] <- sapply( 1:ndata_annual_s, function(i) 
         which( output[,2]==data_annual_year[[s]][i] &
                output[,3]==data_annual_doy[[s]][i] ) )
     }
   # Daily data for site s
     if (sitedata_daily_files[s]!="") {
     # WC
       if ( length(i1_WC[[s]])>0 ) {
         ndata_WCmean_s           <- length(data_WCmean_year[[s]])
         list_output_WC_rows[[s]] <- sapply( 1:ndata_WCmean_s, function(i) 
         which( output[,2]==data_WCmean_year[[s]][i] &
                output[,3]==data_WCmean_doy[[s]][i] ) )         
       }
     }     
   # EC data for site s
     if (sitedata_EC_files[s]!="") {
     # NEE_gCm2d
       if ( length(i1_NEE[[s]])>0 ) {
         ndata_NEEmean_s           <- length(data_NEEmean_year[[s]])
         list_output_NEE_rows[[s]] <- sapply( 1:ndata_NEEmean_s, function(i) 
         which( output[,2]==data_NEEmean_year[[s]][i] &
                output[,3]==data_NEEmean_doy[[s]][i] ) )         
       }
     # GPP_gCm2d
       if ( length(i1_GPP[[s]])>0 ) {
         ndata_GPPmean_s           <- length(data_GPPmean_year[[s]])
         list_output_GPP_rows[[s]] <- sapply( 1:ndata_GPPmean_s, function(i) 
         which( output[,2]==data_GPPmean_year[[s]][i] &
                output[,3]==data_GPPmean_doy[[s]][i] ) )         
       }
     # ET_mmd
       if ( length(i1_ET[[s]])>0 ) {
         ndata_ETmean_s           <- length(data_ETmean_year[[s]])
         list_output_ET_rows[[s]] <- sapply( 1:ndata_ETmean_s, function(i) 
         which( output[,2]==data_ETmean_year[[s]][i] &
                output[,3]==data_ETmean_doy[[s]][i] ) )
       }
     }
   }

################################################################################
### DEFINITION OF FUNCTIONS FOR CALCULATING THE LIKELIHOOD
   
   calc_logL_s <- function( s=1, output=output ) {
   # Likelihood of ancillary data for site s  
     if (sitedata_ancillary_files[s]=="") {
       logL_ancillary    <- 0
     } else {
       output_ancillary  <- sapply( 1:length(data_ancillary_name[[s]]), function(i)
         output[ list_output_ancillary_rows[[s]][i], data_ancillary_index[[s]][i] ] )
       logL_ancillary    <- flogL( output_ancillary, data_ancillary_value[[s]],
                                                     data_ancillary_sd   [[s]] )
     }
   # Likelihood of annual data for site s  
     if (sitedata_annual_files[s]=="") {
       logL_annual   <- 0
     } else {
       output_annual <- sapply( 1:length(data_annual_name[[s]]), function(i)
         mean( output[ (list_output_annual_rows[[s]][i]-364):list_output_annual_rows[[s]][i], 
                        data_annual_index[[s]][i] ] ) )
       logL_annual   <- flogL( output_annual, data_annual_value[[s]],
                                              data_annual_sd   [[s]] )
     }
   # Calculation of likelihoods of daily data for site s
     logL_WCmean <- 0
     if (sitedata_daily_files[s]!="") {
     # WC
       if ( length(i1_WC[[s]]) > 0 ) {
         output_WCmean_value <- sapply( list_output_WC_rows[[s]], function(i)
           mean( output[ i:(i+int_daily-1), iWCoutput ] ) )
         logL_WCmean         <- flogL( output_WCmean_value, data_WCmean_value[[s]],
                                                            data_WCmean_sd   [[s]] )
       }
     }          
   # Calculation of likelihoods of EC data for site s
     logL_NEEmean <- 0 ; logL_GPPmean <- 0 ; logL_ETmean <- 0
     if (sitedata_EC_files[s]!="") {
     # NEE_gCm2d
       if ( length(i1_NEE[[s]]) > 0 ) {
         output_NEEmean_value <- sapply( list_output_NEE_rows[[s]], function(i)
           mean( output[ i:(i+int_EC-1), iNEEoutput ] ) )
         logL_NEEmean         <- flogL( output_NEEmean_value, data_NEEmean_value[[s]],
                                                              data_NEEmean_sd   [[s]] )
       }
     # GPP_gCm2d
       if ( length(i1_GPP[[s]]) > 0 ) {
         output_GPPmean_value <- sapply( list_output_GPP_rows[[s]], function(i)
           mean( output[ i:(i+int_EC-1), iGPPoutput ] ) )
         logL_GPPmean         <- flogL( output_GPPmean_value, data_GPPmean_value[[s]],
                                                              data_GPPmean_sd   [[s]] )
       }
     # ET_mmd
       if ( length(i1_ET[[s]]) > 0 ) {
         output_ETmean_value <- sapply( list_output_ET_rows[[s]], function(i)
           mean( output[ i:(i+int_EC-1), iEToutput ] ) )
         logL_ETmean         <- flogL( output_ETmean_value, data_ETmean_value[[s]],
                                                            data_ETmean_sd   [[s]] )
       }
     }
   logL_s <- data.frame(logL_ancillary,logL_annual,logL_WCmean,logL_NEEmean,logL_GPPmean,logL_ETmean)
   return( logL_s )
   }

   calc_sum_logL <- function( list_output = list_output ) {
     sum_logL <- 0
     for (s in 1:nSites) { sum_logL <- sum_logL + sum(calc_logL_s(s,list_output[[s]])) }
   return( sum_logL )
   }

### END OF DEFINITION OF FUNCTIONS FOR CALCULATING THE LIKELIHOOD
################################################################################
   
 # Value of the overall likelihood at the start point of the chain
   logL0        <- calc_sum_logL( list_output )
   
 # The first values for MaxL and MAP parameter vectors
   scparMaxL_BC <- scpValues_BC
   logMaxL      <- logL0
   scparMAP_BC  <- scpValues_BC
   logMAP       <- logPrior0 + logL0
