extern "C" void BASFOR_C(double *params_ptr, double *matrix_weather_ptr, double *calendar_fert_ptr, 
    double *calendar_ndep_ptr, double *calendar_prunt_ptr, double *calendar_thint_ptr,
    int ndays, int nout, double *y_ptr);

int enzyme_dup;
int enzyme_dupnoneed;
int enzyme_out;
int enzyme_const;

template < typename return_type, typename ... T >
return_type __enzyme_fwddiff(void*, T ... );

template < typename return_type, typename ... T >
return_type __enzyme_autodiff(void*, T ... );

extern "C" void dBASFOR_C(
    double *params_ptr,
    double *dparams_ptr,
    double *matrix_weather_ptr,
    double *dmatrix_weather_ptr,
    double *calendar_fert_ptr,
    double *dcalendar_fert_ptr,
    double *calendar_ndep_ptr,
    double *dcalendar_ndep_ptr,
    double *calendar_prunt_ptr,
    double *dcalendar_prunt_ptr,
    double *calendar_thint_ptr,
    double *dcalendar_thint_ptr,
    int ndays,
    int nout,
    double *y_ptr,
    double *dy_ptr) {

    __enzyme_autodiff<void>((void*)BASFOR_C,
        enzyme_dup, params_ptr, dparams_ptr,
        enzyme_dup, matrix_weather_ptr, dmatrix_weather_ptr,
        enzyme_dup, calendar_fert_ptr, dcalendar_fert_ptr,
        enzyme_dup, calendar_ndep_ptr, dcalendar_ndep_ptr,
        enzyme_dup, calendar_prunt_ptr, dcalendar_prunt_ptr,
        enzyme_dup, calendar_thint_ptr, dcalendar_thint_ptr,
        enzyme_const, ndays,
        enzyme_const, nout,
        enzyme_dupnoneed, y_ptr, dy_ptr
    );
}
