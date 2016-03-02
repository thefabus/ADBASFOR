## initialise_BASFOR_DECIDUOUS-1.R ##

## 1. SITE-SPECIFIC SETTINGS ##
  year_start     <- as.integer(1869)
  doy_start      <- as.integer(1)
  NDAYS          <- as.integer(51865)
  file_weather   <- 'weather/weather_DECIDUOUS-1.txt'
  file_params    <- 'parameters/parameters.txt'
    parcol       <- 3  
    
## 2. GENERAL INITIALISATION ##
  MODEL_dll <- 'BASFOR_decid.DLL'
  source('initialisation/initialise_BASFOR_general.R')

## 3. WEATHER
   matrix_weather <- read_weather_BASFOR( year_start, doy_start, NDAYS, file_weather )
	
## 4. PARAMETERISATION AND MANAGEMENT ##
   df_params      <- read.table( file_params, header=T, sep="\t", row.names=1 )
   params         <- df_params[,parcol]
   
   calendar_Ndep [ 1, ] <- c( 1800,200,  3   / (365 * 10000) )
   calendar_Ndep [ 2, ] <- c( 1900,200,  3   / (365 * 10000) )
   calendar_Ndep [ 3, ] <- c( 1910,200,  5.1 / (365 * 10000) )
   calendar_Ndep [ 4, ] <- c( 1920,200,  7   / (365 * 10000) )
   calendar_Ndep [ 5, ] <- c( 1930,200,  9.7 / (365 * 10000) )
   calendar_Ndep [ 6, ] <- c( 1940,200, 13.6 / (365 * 10000) )
   calendar_Ndep [ 7, ] <- c( 1950,200, 18.8 / (365 * 10000) )
   calendar_Ndep [ 8, ] <- c( 1960,200, 26.1 / (365 * 10000) )
   calendar_Ndep [ 9, ] <- c( 1970,200, 33.7 / (365 * 10000) )
   calendar_Ndep [10, ] <- c( 1980,200, 38.2 / (365 * 10000) )
   calendar_Ndep [11, ] <- c( 1990,200, 35.2 / (365 * 10000) )
   calendar_Ndep [12, ] <- c( 2000,200, 27.4 / (365 * 10000) )
   calendar_Ndep [13, ] <- c( 2010,200, 23.2 / (365 * 10000) )
   calendar_Ndep [14, ] <- c( 2100,200, 23.2 / (365 * 10000) )
   
   calendar_thinT[ 1, ] <- c( 1894,  1, 0.4   )
   calendar_thinT[ 2, ] <- c( 1904,  1, 0.25  )
   calendar_thinT[ 3, ] <- c( 1914,  1, 0.25  )
   calendar_thinT[ 4, ] <- c( 1924,  1, 0.2   )
   calendar_thinT[ 5, ] <- c( 1934,  1, 0.15  )
   calendar_thinT[ 6, ] <- c( 1944,  1, 0.4   )
   calendar_thinT[ 7, ] <- c( 1964,  1, 0.193 )
   calendar_thinT[ 8, ] <- c( 1994,  1, 0.2   )
   calendar_thinT[ 9, ] <- c( 2003,  1, 0.175 )
      
## 5. CREATE EMPTY MATRIX y FOR MODEL OUTPUT ##
   y              <- matrix(0,NDAYS,NOUT)
