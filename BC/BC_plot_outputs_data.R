################################################################################
##### FUNCTIONS USED IN THIS SCRIPT

### FUNCTION 'MSE-comp()'
MSE_comp <- function( sims, obs ) {
  mse       <- mean( (sims-obs)^2 )
  mse_bias  <- ( mean(sims) - mean(obs) )^2
  mse_var   <- ( (n-1)/n) * (sd(sims)-sd(obs) )^2
  mse_phase <- 2 * ((n-1)/n) * sd(sims) * sd(obs) * (1-cor(sims,obs))
  return( c(mse_bias,mse_var,mse_phase) )
}

### FUNCTION 'plotl_tsim_q()'
plotl_tsim_q <- function() {
  g_range <- range(outputPriorMode[,p],outputMAP[,p],outputMaxL[,p],q5[,p],q95[,p],ucl,lcl)
  plot( outputPriorMode[,1], outputPriorMode[,p],
        xlab="",ylab="",main=paste(outputNames[p]," ",outputUnits[p],sep=""),
        type='l',col='red',lwd=3,ylim=g_range)
  points( outputMAP [,1], outputMAP [,p], type='l',col='black',lwd=3)
  points( outputMaxL[,1], outputMaxL[,p], type='l',col='blue' ,lwd=2)
  points( q5        [,1], q5        [,p], type='l',col='black',lwd=2, lty=3)
  points( q95       [,1], q95       [,p], type='l',col='black',lwd=2, lty=3)
  points( tobs          , obs           , col='blue',lwd=2,cex=2)
  arrows( tobs, ucl, tobs, lcl, col='blue',lwd=1,angle=90,code=3,length=0.05)
}

### FUNCTION 'plotb_tobs()'
plotb_tobs <- function() {
  g_range <- range(sims_Pri_annual,sims_MaxL_annual,sims_MAP_annual,ucl,lcl)
  plot( tobs, sims_Pri_annual,
        xlab="",ylab="",main=paste(outputNames[p]," ",outputUnits[p],sep=""),
        type='b',col='red',lwd=3,pch=23,ylim=g_range)
  points( tobs, sims_MaxL_annual, type='b',col='blue' ,lwd=2,pch=23)
  points( tobs, sims_MAP_annual, type='b',col='black',lwd=3,pch=23)
  points( tobs, obs,col='blue' ,lwd=2,cex=2)
  arrows(tobs,ucl,tobs,lcl, col='blue' ,lwd=1,angle=90,code=3,length=0.05)
}

### FUNCTION 'plotl_tobs_q()'
plotl_tobs_q <- function() {
  g_range <- range(sims_Pri,sims_MaxL,sims_MAP,obs) ; t_range <- range(tobs)
  plot( tobs, sims_Pri,
        xlab="",ylab="",main=varname,
        type='l',col='red',lwd=3,xlim=t_range,ylim=g_range)
  points( tobs, sims_MaxL, type='l',col='blue' ,lwd=2)
  points( tobs, sims_MAP , type='l',col='black',lwd=3)
  points( tobs, obs, col='blue',lwd=2, cex=2)
  points( q5 [,1], q5 [,isims], type='l',col='black',lwd=2,lty=3)
  points( q95[,1], q95[,isims], type='l',col='black',lwd=2,lty=3)
}

################################################################################

params_BC_ModePrior <-   parmod_BC
params_BC_MAP       <- scparMAP_BC  * sc
params_BC_MaxL      <- scparMaxL_BC * sc

for (s in 1:nSites) {
  params          <- list_params        [[s]] ; matrix_weather <- list_matrix_weather[[s]]
  calendar_fert   <- list_calendar_fert [[s]] ; calendar_Ndep  <- list_calendar_Ndep [[s]] 
  calendar_prunT  <- list_calendar_prunT[[s]] ; calendar_thinT <- list_calendar_thinT[[s]]  
  NDAYS           <- list_NDAYS         [[s]]       
  ip_BC_s         <- ip_BC_site         [[s]]
  icol_pChain_s   <- icol_pChain_site   [[s]]
# Calculate model output for the prior mode
  params[ip_BC_s] <- params_BC_ModePrior[icol_pChain_s]
  outputPriorMode <- run_model( p=params, w=matrix_weather, calf=calendar_fert,
    calN=calendar_Ndep, calpT=calendar_prunT, caltT=calendar_thinT, n=NDAYS )
# Calculate model output for the MAP parameter vector
  params[ip_BC_s] <- params_BC_MAP      [icol_pChain_s]
  outputMAP       <- run_model( p=params, w=matrix_weather, calf=calendar_fert,
    calN=calendar_Ndep, calpT=calendar_prunT, caltT=calendar_thinT, n=NDAYS )
# Calculate model output for the MaxL parameter vector
  params[ip_BC_s] <- params_BC_MaxL     [icol_pChain_s]
  outputMaxL      <- run_model( p=params, w=matrix_weather, calf=calendar_fert,
    calN=calendar_Ndep, calpT=calendar_prunT, caltT=calendar_thinT, n=NDAYS )
# Calculate model output for a sample from the posterior
# Take a sample (of size nSample) from the chain generated using MCMC
  nSample         <- 10
  nStep           <- (nChain-nBurnIn) / nSample
  outputSample    <- array( 0, c(nSample,NDAYS,NOUT) )
  ii              <- 0   
  for (j in seq(nBurnIn+nStep, nChain, nStep)) {
    ii <- ii+1
    params_j           <- pChain[j,] * sc
    params[ip_BC_s]    <- params_j[icol_pChain_s]
    outputSample[ii,,] <- run_model( p=params, w=matrix_weather, calf=calendar_fert,
      calN=calendar_Ndep, calpT=calendar_prunT, caltT=calendar_thinT, n=NDAYS )
  } # end of sample loop
# Analyse the posterior output sample: calculate quantiles 5% and 95% for every int_q days
  int_q <- 30
  q5  <- sapply( 1:NOUT, function(i) sapply(seq(1,NDAYS,int_q),function(j)quantile(outputSample[,j,i],0.05)) )
  q95 <- sapply( 1:NOUT, function(i) sapply(seq(1,NDAYS,int_q),function(j)quantile(outputSample[,j,i],0.95)) )
   
## Create plots
   dev.set()   
   pdf( paste('BC_BASFOR_SITE',s,format(Sys.time(),"_%H_%M.pdf"),sep="") )

   # Ancillary variables
   if (sitedata_ancillary_files[s]!="") {
     outputsMeasured  <- unique(data_ancillary_index[[s]])
     noutputsMeasured <- length(outputsMeasured)
     nrowsPlots       <- ceiling(sqrt(noutputsMeasured))
     ncolsPlots       <- ceiling(noutputsMeasured/nrowsPlots)
     par(mfrow=c(nrowsPlots,ncolsPlots),omi=c(0,0,0.5,0))
     for (p in outputsMeasured) {
       datap   <- which( data_ancillary_name [[s]] == outputNames[p] )
       tobs    <-        data_ancillary_time [[s]][datap]
       obs     <-        data_ancillary_value[[s]][datap]
       ucl     <- obs +  data_ancillary_sd   [[s]][datap]
       lcl     <- obs -  data_ancillary_sd   [[s]][datap]
       plotl_tsim_q()
     }
     mtext("Ancillary variables", side=3, line=0, outer=TRUE, cex=1, font=2)
   }
   
   # Annual variables
   if (sitedata_annual_files[s]!="") {
     plot.new()
     outputsMeasured  <- unique(data_annual_index[[s]])
     noutputsMeasured <- length(outputsMeasured)
     nrowsPlots       <- ceiling(sqrt(noutputsMeasured))
     ncolsPlots       <- ceiling(noutputsMeasured/nrowsPlots)
     par(mfrow=c(nrowsPlots,ncolsPlots),omi=c(0,0,0.5,0))
     for (p in outputsMeasured) {
       datap   <- which( data_annual_name [[s]] == outputNames[p] )
       tobs    <-        data_annual_time [[s]][datap]
       obs     <-        data_annual_value[[s]][datap]
       ucl     <- obs +  data_annual_sd   [[s]][datap]
       lcl     <- obs -  data_annual_sd   [[s]][datap]
       outrows          <- list_output_annual_rows[[s]][datap]
       sims_Pri_annual  <- sapply( outrows, function(i) mean(outputPriorMode[(i-364):i,p]) )
       sims_MaxL_annual <- sapply( outrows, function(i) mean(outputMaxL     [(i-364):i,p]) )
       sims_MAP_annual  <- sapply( outrows, function(i) mean(outputMAP      [(i-364):i,p]) )
       plotb_tobs()
     }
     mtext("Annual variables", side=3, line=0, outer=TRUE, cex=1, font=2)
   }

   # Daily variables

   if (sitedata_daily_files[s]!="") {
     plot.new()
     par(mfrow=c(3,2),omi=c(0,0,0.5,0))
     
   # WCmean
     if ( length(i1_WC[[s]])>0 ) {
       tobs      <- data_WCmean_time[[s]]
       isims     <- iWCoutput
       outrows   <- list_output_WC_rows[[s]]
       varname   <- "WC (m3 m-3)"
       obs       <- data_WCmean_value[[s]]
       n         <- length(obs)
       sims_Pri  <- sapply( outrows, function(i) mean( outputPriorMode[i:(i+int_daily-1),isims] ) )
       sims_MaxL <- sapply( outrows, function(i) mean( outputMaxL[i:(i+int_daily-1),isims] ) )
       sims_MAP  <- sapply( outrows, function(i) mean( outputMAP[i:(i+int_daily-1),isims] ) )
       plotl_tobs_q()
     # MSE-decomposition
       MSE_comp_Prior <- MSE_comp(sims_Pri,obs) ; MSE_comp_MAP <- MSE_comp(sims_MAP,obs)
       barplot(cbind(MSE_comp_Prior,MSE_comp_MAP),
               names.arg=c("Prior","MAP"),
               col=c("darkblue","grey","lightblue"),
               legend.text = c("bias","var","phase"),
               args.legend = list(x="center",cex=0.8,bg='white') )
     }
     mtext("Daily variables", side=3, line=0, outer=TRUE, cex=1, font=2)
   }   
      
   # EC variables
   if (sitedata_EC_files[s]!="") {
     plot.new()
     par(mfrow=c(3,2),omi=c(0,0,0.5,0))
     
   # NEEmean
     if ( length(i1_NEE[[s]])>0 ) {
       tobs      <- data_NEEmean_time[[s]]
       isims     <- iNEEoutput
       outrows   <- list_output_NEE_rows[[s]]
       varname   <- "NEEmean (gC m-2 d-1)"
       obs       <- data_NEEmean_value[[s]]
       n         <- length(obs)
       sims_Pri  <- sapply( outrows, function(i) mean( outputPriorMode[i:(i+int_EC-1),isims] ) )
       sims_MaxL <- sapply( outrows, function(i) mean( outputMaxL[i:(i+int_EC-1),isims] ) )
       sims_MAP  <- sapply( outrows, function(i) mean( outputMAP[i:(i+int_EC-1),isims] ) )
       plotl_tobs_q()
     # MSE-decomposition
       MSE_comp_Prior <- MSE_comp(sims_Pri,obs) ; MSE_comp_MAP <- MSE_comp(sims_MAP,obs)
       barplot(cbind(MSE_comp_Prior,MSE_comp_MAP),
               names.arg=c("Prior","MAP"),
               col=c("darkblue","grey","lightblue"),
               legend.text = c("bias","var","phase"),
               args.legend = list(x="center",cex=0.8,bg='white') )
     }

   # GPPmean
     if ( length(i1_GPP[[s]])>0 ) {
       tobs      <- data_GPPmean_time[[s]]
       isims     <- iGPPoutput
       outrows   <- list_output_GPP_rows[[s]]
       varname   <- "GPPmean (gC m-2 d-1)"
       obs       <- data_GPPmean_value[[s]]
       n         <- length(obs)
       sims_Pri  <- sapply( outrows, function(i) mean( outputPriorMode[i:(i+int_EC-1),isims] ) )
       sims_MaxL <- sapply( outrows, function(i) mean( outputMaxL[i:(i+int_EC-1),isims] ) )
       sims_MAP  <- sapply( outrows, function(i) mean( outputMAP[i:(i+int_EC-1),isims] ) )
       plotl_tobs_q()
     # MSE-decomposition
       MSE_comp_Prior <- MSE_comp(sims_Pri,obs) ; MSE_comp_MAP <- MSE_comp(sims_MAP,obs)
       barplot(cbind(MSE_comp_Prior,MSE_comp_MAP),
               names.arg=c("Prior","MAP"),
               col=c("darkblue","grey","lightblue"),
               legend.text = c("bias","var","phase"),
               args.legend = list(x="center",cex=0.8,bg='white') )
     }

   # ETmean
     if ( length(i1_ET[[s]])>0 ) {
       tobs      <- data_ETmean_time[[s]]
       isims     <- iEToutput
       outrows   <- list_output_ET_rows[[s]]
       varname   <- "ETmean (mm d-1)"
       obs       <- data_ETmean_value[[s]]
       n         <- length(obs)
       sims_Pri  <- sapply( outrows, function(i) mean( outputPriorMode[i:(i+int_EC-1),isims] ) )
       sims_MaxL <- sapply( outrows, function(i) mean( outputMaxL[i:(i+int_EC-1),isims] ) )
       sims_MAP  <- sapply( outrows, function(i) mean( outputMAP[i:(i+int_EC-1),isims] ) )
       plotl_tobs_q()     
     # MSE-decomposition
       MSE_comp_Prior <- MSE_comp(sims_Pri,obs) ; MSE_comp_MAP <- MSE_comp(sims_MAP,obs)
       barplot(cbind(MSE_comp_Prior,MSE_comp_MAP),
               names.arg=c("Prior","MAP"),
               col=c("darkblue","grey","lightblue"),
               legend.text = c("bias","var","phase"),
               args.legend = list(x="center",cex=0.8,bg='white') )
     }
     mtext("EC variables", side=3, line=0, outer=TRUE, cex=1, font=2)
     
   }   

dev.off()
   
}
