import pandas as pd
import numpy as np

# Create matrices of size (100, 3) filled with -1
calendar_fert  = np.full((100, 3), -1, dtype=np.float64)
calendar_Ndep  = np.full((100, 3), -1, dtype=np.float64)
calendar_prunT = np.full((100, 3), -1, dtype=np.float64)
calendar_thinT = np.full((100, 3), -1, dtype=np.float64)

NMAXDAYS = 60000

def read_weather_BASFOR(y, d, n, f):
    """
    Reads weather data from file `f` and extracts a simulation period.

    Parameters:
    - y: starting year (e.g., 1900)
    - d: starting day-of-year (e.g., 1)
    - n: number of days to extract
    - f: file path to the weather data file

    Returns:
    - A NumPy array of shape (60000, 7) where the first n rows contain the
      following columns: year, doy, GR, T, RAIN, WN, VP.
    """
    # Read the file assuming whitespace-delimited values and a header line.
    df_weather = pd.read_csv(f, sep=r'\s+', header=0, dtype=np.float64)
    
    # Find the first row where the year is at least y
    row_start = 0
    while df_weather.iloc[row_start]['year'] < y:
        row_start += 1

    # Further adjust row_start to find the first row where doy is at least d
    while df_weather.iloc[row_start]['doy'] < d:
        row_start += 1

    # Extract n rows starting from row_start
    df_weather_sim = df_weather.iloc[row_start:row_start+n]

    # Create a matrix with fixed size and 7 columns
    NWEATHER = 7
    matrix_weather = np.zeros((NMAXDAYS, NWEATHER), dtype=np.float64)

    # Assign values from the dataframe into the NumPy array
    # Columns order: year, doy, GR, T, RAIN, WN, VP
    matrix_weather[:n, 0] = df_weather_sim['year'].values
    matrix_weather[:n, 1] = df_weather_sim['doy'].values
    matrix_weather[:n, 2] = df_weather_sim['GR'].values
    matrix_weather[:n, 3] = df_weather_sim['T'].values
    matrix_weather[:n, 4] = df_weather_sim['RAIN'].values
    matrix_weather[:n, 5] = df_weather_sim['WN'].values
    matrix_weather[:n, 6] = df_weather_sim['VP'].values

    return matrix_weather

outputNames = [
 "Time"             , "year"           , "doy"             ,
 "AC"               , "dCLold"         , "dCLsenNdef"      , "dLAIold"             ,
 "dNLdeath"         , "dNLlitt"        , "LAI"             , "LAIcrit"             ,
 "LAIsurv"          , "NL"             , "NLsurv"          , "NLsurvMIN"           ,
 "recycNLold"       , "retrNLMAX"      ,
 "CL"               , "Cwood"          , "CLBS"            , "CR"                  ,
 "CRES"             , "WC"             , "CLITT"           , "CSOM"                ,
 "Csoil"            , "Nsoil"          , "DBH"             , "H"                   ,
 "Rsoil"            , "NEE_gCm2d"      , "GPP_gCm2d"       , "Reco_gCm2d"          ,
 "ET_mmd"           , "NemissionN2O"   , "NemissionNO"     ]
  
outputUnits = [
  "(y)"             , ""               , ""                ,
  "(m2 AC m-2)"     , "(kg C m-2 d-1)" , "(kg C m-2 d-1)"  , "(m2 leaf m-2 AC d-1)",
  "(kg N m-2 d-1)"  , "(kg N m-2 d-1)" , "(m2 leaf m-2 AC)", "(m2 leaf m-2 AC)"    ,
  "(m2 leaf m-2 AC)", "(kg N m-2)"     , "(kg N m-2 AC)"   , "(kg N m-2 AC)"       ,
  "(kg N m-2 d-1)"  , "(kg N m-2 d-1)" ,
  "(kg C m-2)"      , "(kg C m-2)"     , "(kg C m-2)"      , "(kg C m-2)"          ,
  "(kg C m-2)"      , "(m3 m-3)"       , "(kg C m-2)"      , "(kg C m-2)"          ,
  "(kg C m-2)"      , "(kg N m-2)"     , "(m)"             , "(m)"                 ,
  "(kg C m-2 d-1)"  , "(g C m-2 d-1)"  , "(g C m-2 d-1)"   , "(g C m-2 d-1)"       ,
  "(mm d-1)"        , "(kg N m-2 d-1)" , "(kg N m-2 d-1)" ]
  
NOUT = len(outputNames)