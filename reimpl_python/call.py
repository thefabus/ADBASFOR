import ctypes
import numpy as np

from general import NMAXDAYS

def call_BASFOR_C(params, matrix_weather, calendar_fert, calendar_ndep,
                  calendar_prunt, calendar_thint, ndays, nout, y):
    """
    Call the BASFOR_C Fortran routine via ctypes.
    
    Parameters:
      params         - 1D numpy array, shape (100,), dtype=np.float64
      matrix_weather - 2D numpy array, shape (ndays, 7), dtype=np.float64
      calendar_fert  - 2D numpy array, shape (100, 3), dtype=np.float64
      calendar_ndep  - 2D numpy array, shape (100, 3), dtype=np.float64
      calendar_prunt - 2D numpy array, shape (100, 3), dtype=np.float64
      calendar_thint - 2D numpy array, shape (100, 3), dtype=np.float64
      y              - 2D numpy array, shape (ndays, nout), dtype=np.float64
                       (This array must be preallocated; its contents will be
                        overwritten by BASFOR_C.)
    """

    params = np.pad(params, (0, max(0, 100 - len(params))), mode='constant', constant_values=0)
    
    # Ensure the arrays are Fortran-ordered (column-major) since Fortran expects that.
    params = np.asfortranarray(params, dtype=np.float64)
    matrix_weather = np.asfortranarray(matrix_weather, dtype=np.float64)
    calendar_fert = np.asfortranarray(calendar_fert, dtype=np.float64)
    calendar_ndep = np.asfortranarray(calendar_ndep, dtype=np.float64)
    calendar_prunt = np.asfortranarray(calendar_prunt, dtype=np.float64)
    calendar_thint = np.asfortranarray(calendar_thint, dtype=np.float64)
    y = np.asfortranarray(y, dtype=np.float64)
    
    # Load the shared library (adjust the library name/path as needed)
    lib = ctypes.CDLL("../BASFOR_conif.so")
    
    # Set the argument types for the BASFOR_C routine.
    # The Fortran subroutine accepts pointers (as c_void_p) and two integers.
    lib.BASFOR_C.argtypes = [
        ctypes.c_void_p,  # params_ptr
        ctypes.c_void_p,  # matrix_weather_ptr
        ctypes.c_void_p,  # calendar_fert_ptr
        ctypes.c_void_p,  # calendar_ndep_ptr
        ctypes.c_void_p,  # calendar_prunt_ptr
        ctypes.c_void_p,  # calendar_thint_ptr
        ctypes.c_int,     # ndays
        ctypes.c_int,     # nout
        ctypes.c_void_p   # y_ptr
    ]
    
    assert params.dtype == np.float64
    assert matrix_weather.dtype == np.float64
    assert calendar_fert.dtype == np.float64
    assert calendar_ndep.dtype == np.float64
    assert calendar_prunt.dtype == np.float64
    assert calendar_thint.dtype == np.float64
    assert y.dtype == np.float64

    def assert_eq(a, b):
        assert a == b, f"Assertion failed: {a} != {b}"

    assert_eq(params.shape, (100,))
    assert_eq(matrix_weather.shape, (NMAXDAYS, 7))
    assert_eq(calendar_fert.shape, (100, 3))
    assert_eq(calendar_ndep.shape, (100, 3))
    assert_eq(calendar_prunt.shape, (100, 3))
    assert_eq(calendar_thint.shape, (100, 3))
    assert_eq(y.shape, (ndays, nout))

    # Get pointers to the data of each array.
    params_ptr = params.ctypes.data_as(ctypes.c_void_p)
    matrix_weather_ptr = matrix_weather.ctypes.data_as(ctypes.c_void_p)
    calendar_fert_ptr = calendar_fert.ctypes.data_as(ctypes.c_void_p)
    calendar_ndep_ptr = calendar_ndep.ctypes.data_as(ctypes.c_void_p)
    calendar_prunt_ptr = calendar_prunt.ctypes.data_as(ctypes.c_void_p)
    calendar_thint_ptr = calendar_thint.ctypes.data_as(ctypes.c_void_p)
    y_ptr = y.ctypes.data_as(ctypes.c_void_p)
    
    # Call the Fortran routine. This call updates y in place.
    lib.BASFOR_C(params_ptr, matrix_weather_ptr, calendar_fert_ptr,
                 calendar_ndep_ptr, calendar_prunt_ptr, calendar_thint_ptr,
                 ndays, nout, y_ptr)

    # y now contains the output from BASFOR_C.
    return y

def call_dBASFOR_C(params, matrix_weather, calendar_fert, calendar_ndep,
                  calendar_prunt, calendar_thint, ndays, nout, dy):
    """
    Call the BASFOR_C Fortran routine via ctypes.
    
    Parameters:
      params         - 1D numpy array, shape (100,), dtype=np.float64
      matrix_weather - 2D numpy array, shape (ndays, 7), dtype=np.float64
      calendar_fert  - 2D numpy array, shape (100, 3), dtype=np.float64
      calendar_ndep  - 2D numpy array, shape (100, 3), dtype=np.float64
      calendar_prunt - 2D numpy array, shape (100, 3), dtype=np.float64
      calendar_thint - 2D numpy array, shape (100, 3), dtype=np.float64
      y              - 2D numpy array, shape (ndays, nout), dtype=np.float64
                       (This array must be preallocated; its contents will be
                        overwritten by BASFOR_C.)
    """

    params = np.pad(params, (0, max(0, 100 - len(params))), mode='constant', constant_values=0)
    
    # Ensure the arrays are Fortran-ordered (column-major) since Fortran expects that.
    params = np.asfortranarray(params, dtype=np.float64)
    matrix_weather = np.asfortranarray(matrix_weather, dtype=np.float64)
    calendar_fert = np.asfortranarray(calendar_fert, dtype=np.float64)
    calendar_ndep = np.asfortranarray(calendar_ndep, dtype=np.float64)
    calendar_prunt = np.asfortranarray(calendar_prunt, dtype=np.float64)
    calendar_thint = np.asfortranarray(calendar_thint, dtype=np.float64)
    dy = np.asfortranarray(dy, dtype=np.float64)
    
    # Load the shared library (adjust the library name/path as needed)
    lib = ctypes.CDLL("../BASFOR_conif.so")
    
    # Set the argument types for the BASFOR_C routine.
    # The Fortran subroutine accepts pointers (as c_void_p) and two integers.
    lib.BASFOR_C.argtypes = [
        ctypes.c_void_p,  # params_ptr
        ctypes.c_void_p,  # params_ptr
        ctypes.c_void_p,  # matrix_weather_ptr
        ctypes.c_void_p,  # matrix_weather_ptr
        ctypes.c_void_p,  # calendar_fert_ptr
        ctypes.c_void_p,  # calendar_fert_ptr
        ctypes.c_void_p,  # calendar_ndep_ptr
        ctypes.c_void_p,  # calendar_ndep_ptr
        ctypes.c_void_p,  # calendar_prunt_ptr
        ctypes.c_void_p,  # calendar_prunt_ptr
        ctypes.c_void_p,  # calendar_thint_ptr
        ctypes.c_void_p,  # calendar_thint_ptr
        ctypes.c_int,     # ndays
        ctypes.c_int,     # nout
        ctypes.c_void_p,   # y_ptr
        ctypes.c_void_p   # y_ptr
    ]
    
    assert params.dtype == np.float64
    assert matrix_weather.dtype == np.float64
    assert calendar_fert.dtype == np.float64
    assert calendar_ndep.dtype == np.float64
    assert calendar_prunt.dtype == np.float64
    assert calendar_thint.dtype == np.float64
    assert dy.dtype == np.float64

    def assert_eq(a, b):
        assert a == b, f"Assertion failed: {a} != {b}"

    assert_eq(params.shape, (100,))
    assert_eq(matrix_weather.shape, (NMAXDAYS, 7))
    assert_eq(calendar_fert.shape, (100, 3))
    assert_eq(calendar_ndep.shape, (100, 3))
    assert_eq(calendar_prunt.shape, (100, 3))
    assert_eq(calendar_thint.shape, (100, 3))
    assert_eq(dy.shape, (ndays, nout))

    dparams = np.zeros_like(params)
    dmatrix_weather = np.zeros_like(matrix_weather)
    dcalendar_fert = np.zeros_like(calendar_fert)
    dcalendar_ndep = np.zeros_like(calendar_ndep)
    dcalendar_prunt = np.zeros_like(calendar_prunt)
    dcalendar_thint = np.zeros_like(calendar_thint)
    y = np.zeros_like(dy)

    # Get pointers to the data of each array.
    params_ptr = params.ctypes.data_as(ctypes.c_void_p)
    matrix_weather_ptr = matrix_weather.ctypes.data_as(ctypes.c_void_p)
    calendar_fert_ptr = calendar_fert.ctypes.data_as(ctypes.c_void_p)
    calendar_ndep_ptr = calendar_ndep.ctypes.data_as(ctypes.c_void_p)
    calendar_prunt_ptr = calendar_prunt.ctypes.data_as(ctypes.c_void_p)
    calendar_thint_ptr = calendar_thint.ctypes.data_as(ctypes.c_void_p)
    y_ptr = y.ctypes.data_as(ctypes.c_void_p)

    dparams_ptr = dparams.ctypes.data_as(ctypes.c_void_p)
    dmatrix_weather_ptr = dmatrix_weather.ctypes.data_as(ctypes.c_void_p)
    dcalendar_fert_ptr = dcalendar_fert.ctypes.data_as(ctypes.c_void_p)
    dcalendar_ndep_ptr = dcalendar_ndep.ctypes.data_as(ctypes.c_void_p)
    dcalendar_prunt_ptr = dcalendar_prunt.ctypes.data_as(ctypes.c_void_p)
    dcalendar_thint_ptr = dcalendar_thint.ctypes.data_as(ctypes.c_void_p)
    dy_ptr = dy.ctypes.data_as(ctypes.c_void_p)
    
    lib.dBASFOR_C(
        params_ptr,
        dparams_ptr,
        matrix_weather_ptr, 
        dmatrix_weather_ptr, 
        calendar_fert_ptr,
        dcalendar_fert_ptr,
        calendar_ndep_ptr, 
        dcalendar_ndep_ptr, 
        calendar_prunt_ptr, 
        dcalendar_prunt_ptr, 
        calendar_thint_ptr,
        dcalendar_thint_ptr,
        ndays, nout, 
        y_ptr,
        dy_ptr
    )

    grads = (dparams, dmatrix_weather, dcalendar_fert, dcalendar_ndep, dcalendar_prunt, dcalendar_thint, dy)

    return grads

def submit(fn, *args, **kwargs):
    from loky import get_reusable_executor
    executor = get_reusable_executor(max_workers=1)
    def wrap():
        return fn(*args, **kwargs)
    output = executor.submit(wrap).result()
    executor.shutdown()
    return output
