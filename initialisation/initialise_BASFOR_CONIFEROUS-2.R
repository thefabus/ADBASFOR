## initialise_BASFOR_CONIFEROUS-2.R ##

## 1. SITE-SPECIFIC SETTINGS ##
  year_start     <- as.integer(1910)
  doy_start      <- as.integer(1)
  NDAYS          <- as.integer(36890)
  file_weather   <- 'weather/weather_CONIFEROUS-2.txt'
  file_params    <- 'parameters/parameters.txt'
    parcol       <- 2  
    
## 2. GENERAL INITIALISATION ##
  MODEL_dll <- 'BASFOR_conif.DLL'
  source('initialisation/initialise_BASFOR_general.R')

## 3. WEATHER
   matrix_weather <- read_weather_BASFOR( year_start, doy_start, NDAYS, file_weather )
	
## 4. PARAMETERISATION AND MANAGEMENT ##
   df_params      <- read.table( file_params, header=T, sep="\t", row.names=1 )
   params         <- df_params[,parcol]
   
   calendar_Ndep [ 1, ] <- c( 1900,200, 0.4 / (365 * 10000) )
   calendar_Ndep [ 2, ] <- c( 1910,200, 0.6 / (365 * 10000) )
   calendar_Ndep [ 3, ] <- c( 1920,200, 0.8 / (365 * 10000) )
   calendar_Ndep [ 4, ] <- c( 1930,200, 1.1 / (365 * 10000) )
   calendar_Ndep [ 5, ] <- c( 1940,200, 1.5 / (365 * 10000) )
   calendar_Ndep [ 6, ] <- c( 1950,200, 2.1 / (365 * 10000) )
   calendar_Ndep [ 7, ] <- c( 1960,200, 2.9 / (365 * 10000) )
   calendar_Ndep [ 8, ] <- c( 1970,200, 3.7 / (365 * 10000) )
   calendar_Ndep [ 9, ] <- c( 1980,200, 4.2 / (365 * 10000) )
   calendar_Ndep [10, ] <- c( 1990,200, 3.9 / (365 * 10000) )
   calendar_Ndep [11, ] <- c( 2000,200, 3.0 / (365 * 10000) )
   calendar_Ndep [12, ] <- c( 2010,200, 2.5 / (365 * 10000) )
   calendar_Ndep [13, ] <- c( 2100,200, 2.5 / (365 * 10000) )
   
   calendar_thinT[ 1, ] <- c( 1935,  1, 0.400 )
   calendar_thinT[ 2, ] <- c( 1985,  1, 0.222 )
      
## 5. CREATE EMPTY MATRIX y FOR MODEL OUTPUT ##
   y              <- matrix(0,NDAYS,NOUT)
