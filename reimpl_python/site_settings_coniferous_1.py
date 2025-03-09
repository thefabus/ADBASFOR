from general import *

## 1. SITE-SPECIFIC SETTINGS ##
year_start     = 1900
doy_start      = 1
NDAYS          = 40543
file_weather   = '../weather/weather_CONIFEROUS-1.txt'
file_params    = '../parameters/parameters.txt'
parcol         = 1

matrix_weather = read_weather_BASFOR( year_start, doy_start, NDAYS, file_weather )

df_params = pd.read_csv(file_params, sep="\t", header=0, index_col=0)
params = df_params.iloc[:, parcol - 1].to_numpy()

# Fill calendar_Ndep with the provided values
calendar_Ndep[0, :]  = [1700, 200, 3.0 / (365 * 10000)]
calendar_Ndep[1, :]  = [1900, 200, 3.0 / (365 * 10000)]
calendar_Ndep[2, :]  = [1910, 200, 4.7 / (365 * 10000)]
calendar_Ndep[3, :]  = [1920, 200, 6.4 / (365 * 10000)]
calendar_Ndep[4, :]  = [1930, 200, 8.9 / (365 * 10000)]
calendar_Ndep[5, :]  = [1940, 200, 12.4 / (365 * 10000)]
calendar_Ndep[6, :]  = [1950, 200, 17.2 / (365 * 10000)]
calendar_Ndep[7, :]  = [1960, 200, 23.9 / (365 * 10000)]
calendar_Ndep[8, :]  = [1970, 200, 30.9 / (365 * 10000)]
calendar_Ndep[9, :]  = [1980, 200, 35.0 / (365 * 10000)]
calendar_Ndep[10, :] = [1990, 200, 32.2 / (365 * 10000)]
calendar_Ndep[11, :] = [2000, 200, 25.1 / (365 * 10000)]
calendar_Ndep[12, :] = [2010, 200, 21.2 / (365 * 10000)]
calendar_Ndep[13, :] = [2100, 200, 21.2 / (365 * 10000)]

# Fill calendar_thinT with the provided values
calendar_thinT[0, :] = [1925, 1, 0.400]
calendar_thinT[1, :] = [1935, 1, 0.250]
calendar_thinT[2, :] = [1945, 1, 0.250]
calendar_thinT[3, :] = [1955, 1, 0.200]
calendar_thinT[4, :] = [1965, 1, 0.150]
calendar_thinT[5, :] = [1975, 1, 0.400]
calendar_thinT[6, :] = [2006, 1, 0.887]
