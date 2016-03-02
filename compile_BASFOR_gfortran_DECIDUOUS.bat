rem Compilation that prepares a BC for deciduous forest
gfortran -x f95-cpp-input -Ddeciduous -O3 -c -fdefault-real-8 model\parameters.f90 model\environment.f90 model\management.f90 model\tree.f90 model\belowgroundres.f90 model\soil.f90 model\set_params.f90 model\BASFOR.f90
gfortran -shared -o BASFOR_decid.DLL parameters.o environment.o management.o tree.o belowgroundres.o soil.o set_params.o BASFOR.o

del *.o
del *.mod

pause