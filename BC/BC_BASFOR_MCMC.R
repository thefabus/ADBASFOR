## Running the MCMC ##
   nAccepted <- 0
   cat("Iteration","|","% Accepted","|","logPrior0","|","logL0","\n")
   for (j in 2:nChain)
     {
     # Give intermediate output to the screen for tracking the progress of the MCMC
       jint <- min(1000,round(nChain/20))
       if (j%%jint == 0) cat("Iteration",j,"|",round(100*nAccepted/(j-nBurnIn)),"%","|",logPrior0,"|",logL0,"\n")
       
     # Select the candidate parameter vector and calculate its prior probability
       sccandidatepValues_BC <- mvrnorm(n=1, scpValues_BC, vcovProp, tol=1e-6, empirical=FALSE)
       reflectionFromMin     <- pmin( 0., sccandidatepValues_BC-scparmin_BC )
       reflectionFromMax     <- pmax( 0., sccandidatepValues_BC-scparmax_BC )
       sccandidatepValues_BC <- sccandidatepValues_BC - 2.*reflectionFromMin - 2.*reflectionFromMax
       pBetaValues           <- ( sccandidatepValues_BC[1:np_BC] - scparmin_BC[1:np_BC] ) /
                                ( scparmax_BC          [1:np_BC] - scparmin_BC[1:np_BC]   )
       logPrior1Beta         <- sum( dbeta(pBetaValues,aa,bb,log=T) )
       logPrior1             <- logPrior1Beta

     # Unscale parameters, run model and calculate L
       candidatepValues_BC <- sccandidatepValues_BC * sc
       for (s in 1:nSites) {
    		 params         <- list_params        [[s]] ; matrix_weather <- list_matrix_weather[[s]]
         calendar_fert  <- list_calendar_fert [[s]] ; calendar_Ndep <- list_calendar_Ndep[[s]] 
         calendar_prunT <- list_calendar_prunT[[s]] ; calendar_thinT <- list_calendar_thinT[[s]]  
  	     NDAYS          <- list_NDAYS         [[s]]
		     params[ ip_BC_site[[s]] ] <- candidatepValues_BC[ icol_pChain_site[[s]] ]
         output                    <- run_model( p     = params        ,
                                                 w     = matrix_weather,
                                                 calf  = calendar_fert ,
                                                 calN  = calendar_Ndep ,
                                  	             calpT = calendar_prunT,
                                                 caltT = calendar_thinT,
                                                 n     = NDAYS          )
         list_output[[s]] <- output
       }
       logL1 <- calc_sum_logL( list_output )
   
     # Check whether the candidate parameter vector is accepted, and extend the parameter chain.
       if (is.na(logL1)) {
         logalpha <- -Inf
       } else {
         logalpha <- logPrior1 + logL1 - (logPrior0 + logL0)
       }
       if (log(runif(1,0,1)) < logalpha)
         {
           scpValues_BC <- sccandidatepValues_BC
           logPrior0    <- logPrior1
           logL0        <- logL1
           if (logL0 > logMaxL) {
               logMaxL      <- logL0
               scparMaxL_BC <- scpValues_BC }
           if ((logPrior0 + logL0) > logMAP) { 
               logMAP       <- logPrior0 + logL0
               scparMAP_BC  <- scpValues_BC }
           if (j > nBurnIn)
             { 
               nAccepted <- nAccepted + 1
             }
         }
       pChain[j,] <- scpValues_BC
     }