#!/bin/bash

flang-new-$LLVM_VERSION -fPIC -O0 -fdefault-real-8 -cpp -g -S -emit-llvm model/parameters.f90 model/environment.f90 model/management.f90 model/tree.f90 model/belowgroundres.f90 model/soil.f90 model/set_params.f90 model/reset.f90 model/BASFOR.f90
clang++-$LLVM_VERSION -c -emit-llvm -o ADBASFOR.ll model/ADBASFOR.cpp

python3 replace_fortran_contiguous.py BASFOR.ll

llvm-link-$LLVM_VERSION parameters.ll environment.ll management.ll tree.ll belowgroundres.ll soil.ll set_params.ll BASFOR.ll ADBASFOR.ll reset.ll -o merged.bc

opt-$LLVM_VERSION -passes="instcombine,dce" merged.bc -o merged_opt.bc

opt-$LLVM_VERSION merged_opt.bc --load-pass-plugin=/opt/Enzyme/enzyme/build/Enzyme/LLVMEnzyme-$LLVM_VERSION.so -passes=enzyme -o output.ll -S

flang-new-$LLVM_VERSION -shared -std=f2018 -O3 -g -o BASFOR_conif.so output.ll -L /usr/lib/llvm-$LLVM_VERSION/lib

rm *.ll
rm *.bc
rm *.mod
