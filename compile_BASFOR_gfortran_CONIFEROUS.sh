#!/bin/bash

# Compilation that prepares a BC for coniferous forest
gfortran -cpp -std=f2008 -fPIC -O3 -c -fdefault-real-8 model/parameters.f90 model/environment.f90 model/management.f90 model/tree.f90 model/belowgroundres.f90 model/soil.f90 model/set_params.f90 model/BASFOR.f90
gfortran -shared -std=f2008 -o BASFOR_conif.so parameters.o environment.o management.o tree.o belowgroundres.o soil.o set_params.o BASFOR.o -lgfortran

rm *.o
rm *.mod