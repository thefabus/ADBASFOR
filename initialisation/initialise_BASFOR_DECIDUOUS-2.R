## initialise_BASFOR_DECIDUOUS-2.R ##

## 1. SITE-SPECIFIC SETTINGS ##
  year_start     <- as.integer(1900)
  doy_start      <- as.integer(1)
  NDAYS          <- as.integer(40543)
  file_weather   <- 'weather/weather_DECIDUOUS-2.txt'
  file_params    <- 'parameters/parameters.txt'
    parcol       <- 4  
    
## 2. GENERAL INITIALISATION ##
  MODEL_dll <- 'BASFOR_decid.DLL'
  source('initialisation/initialise_BASFOR_general.R')

## 3. WEATHER
   matrix_weather <- read_weather_BASFOR( year_start, doy_start, NDAYS, file_weather )
	
## 4. PARAMETERISATION AND MANAGEMENT ##
   df_params      <- read.table( file_params, header=T, sep="\t", row.names=1 )
   params         <- df_params[,parcol]
   
   calendar_Ndep [ 1, ] <- c( 1700,200,  2.6 / (365 * 10000) )
   calendar_Ndep [ 2, ] <- c( 1900,200,  2.6 / (365 * 10000) )
   calendar_Ndep [ 3, ] <- c( 1910,200,  3.6 / (365 * 10000) )
   calendar_Ndep [ 4, ] <- c( 1920,200,  5.0 / (365 * 10000) )
   calendar_Ndep [ 5, ] <- c( 1930,200,  6.9 / (365 * 10000) )
   calendar_Ndep [ 6, ] <- c( 1940,200,  9.7 / (365 * 10000) )
   calendar_Ndep [ 7, ] <- c( 1950,200, 13.5 / (365 * 10000) )
   calendar_Ndep [ 8, ] <- c( 1960,200, 18.7 / (365 * 10000) )
   calendar_Ndep [ 9, ] <- c( 1970,200, 24.2 / (365 * 10000) )
   calendar_Ndep [10, ] <- c( 1980,200, 27.4 / (365 * 10000) )
   calendar_Ndep [11, ] <- c( 1990,200, 25.2 / (365 * 10000) )
   calendar_Ndep [12, ] <- c( 2000,200, 19.6 / (365 * 10000) )
   calendar_Ndep [13, ] <- c( 2010,200, 16.6 / (365 * 10000) )
   calendar_Ndep [14, ] <- c( 2100,200, 16.6 / (365 * 10000) )
   
   calendar_thinT[ 1, ] <- c( 1925,  1, 0.360 )
   calendar_thinT[ 2, ] <- c( 1935,  1, 0.225 )
   calendar_thinT[ 3, ] <- c( 1945,  1, 0.225 )
   calendar_thinT[ 4, ] <- c( 1955,  1, 0.180 )
   calendar_thinT[ 5, ] <- c( 1965,  1, 0.135 )
   calendar_thinT[ 6, ] <- c( 1975,  1, 0.360 )
   calendar_thinT[ 7, ] <- c( 1995,  1, 0.152 )
   calendar_thinT[ 8, ] <- c( 2007,  1, 0.378 )
      
## 5. CREATE EMPTY MATRIX y FOR MODEL OUTPUT ##
   y              <- matrix(0,NDAYS,NOUT)
