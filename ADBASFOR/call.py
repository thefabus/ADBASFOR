import numpy as np
import os
from types import SimpleNamespace

from .general import NMAXDAYS, NOUT

C_SRC = """
void BASFOR_C(double *params, double *matrix_weather,
                double *calendar_fert, double *calendar_ndep,
                double *calendar_prunt, double *calendar_thint,
                int ndays, int nout, double *y);

void dBASFOR_C(double *params, double *dparams,
                double *matrix_weather, double *dmatrix_weather,
                double *calendar_fert, double *dcalendar_fert,
                double *calendar_ndep, double *dcalendar_ndep,
                double *calendar_prunt, double *dcalendar_prunt,
                double *calendar_thint, double *dcalendar_thint,
                int ndays, int nout, double *y, double *dy);
"""

#from basfor_cffi import lib, ffi

_here = os.path.dirname(__file__)
_so_path = os.path.join(_here, "lib", "BASFOR_conif.so")

from cffi import FFI
ffi = FFI()
lib = ffi.dlopen(_so_path)
ffi.cdef(C_SRC)

def assert_eq(a, b):
    assert a == b, f"Assertion failed: {a} != {b}"

def assert_shapes(args: SimpleNamespace):
    args.params = np.pad(args.params, (0, max(0, 100 - len(args.params))), mode='constant', constant_values=0)
    assert_eq(args.params.shape, (100,))
    assert_eq(args.matrix_weather.shape, (NMAXDAYS, 7))
    assert_eq(args.calendar_fert.shape, (100, 3))
    assert_eq(args.calendar_ndep.shape, (100, 3))
    assert_eq(args.calendar_prunt.shape, (100, 3))
    assert_eq(args.calendar_thint.shape, (100, 3))
    assert_eq(args.y.shape, (args.ndays, NOUT))
    assert args.ndays <= NMAXDAYS

def as_fortran(args: SimpleNamespace):
    for k, v in vars(args).items():
        if isinstance(v, np.ndarray):
            setattr(args, k, np.asfortranarray(v, dtype=np.float64))
    return args

def zeros_like(args: SimpleNamespace):
    dargs = SimpleNamespace()
    for k, v in vars(args).items():
        if isinstance(v, np.ndarray):
            setattr(dargs, k, np.zeros_like(v, dtype=np.float64))
    return dargs

def cast(nda):
    return ffi.cast("double *", ffi.from_buffer(nda.T))

def call_BASFOR_C(params, matrix_weather, calendar_fert, calendar_ndep,
                  calendar_prunt, calendar_thint, ndays):
    
    args = SimpleNamespace(**locals())
    args.y = np.zeros((ndays, NOUT), dtype=np.float64)

    assert_shapes(args)
    args = as_fortran(args)
    
    # Call the Fortran function
    lib.BASFOR_C(
        cast(args.params),
        cast(args.matrix_weather),
        cast(args.calendar_fert),
        cast(args.calendar_ndep), 
        cast(args.calendar_prunt), 
        cast(args.calendar_thint),
        ndays, 
        NOUT, 
        cast(args.y)
    )

    return args.y

def call_dBASFOR_C(params, matrix_weather, calendar_fert, calendar_ndep,
                   calendar_prunt, calendar_thint, ndays, y):
    
    args = SimpleNamespace(**locals())

    assert_shapes(args)
    args = as_fortran(args)
    dargs = zeros_like(args)

    y = dargs.y
    dargs.y = args.y
    args.y = y
    
    lib.dBASFOR_C(
        cast(args.params), cast(dargs.params), 
        cast(args.matrix_weather), cast(dargs.matrix_weather),
        cast(args.calendar_fert), cast(dargs.calendar_fert), 
        cast(args.calendar_ndep), cast(dargs.calendar_ndep),
        cast(args.calendar_prunt), cast(dargs.calendar_prunt), 
        cast(args.calendar_thint), cast(dargs.calendar_thint),
        args.ndays, 
        NOUT, 
        cast(args.y), cast(dargs.y)
    )
    
    return (dargs.params, dargs.matrix_weather, dargs.calendar_fert, dargs.calendar_ndep, dargs.calendar_prunt, dargs.calendar_thint)

def submit(fn, *args, **kwargs):
    from loky import get_reusable_executor
    executor = get_reusable_executor(max_workers=1)
    def wrap():
        return fn(*args, **kwargs)
    output = executor.submit(wrap).result()
    executor.shutdown()
    return output
