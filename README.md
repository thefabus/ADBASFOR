# ADBASFOR
EnzymeAD differentiated BASFOR model with PyTorch compatible Python package.

1. Open the VSCode Dev Container. The docker build might take a while.

2. Run R script: `Rscript run_BASFOR_CONIFEROUS-1.R`

3. Compile shared library `./compile_BASFOR_llvm_CONIFEROUS.sh`

4. Check out the notebooks in `notebooks`

5. Optional: build python wheel: `python -m build --wheel`. You find it in `dist/`.  
If you are having problems installing it or importing it after install in a different environment, try matching the build environment more closely by inspecting the `.devcontainer/Dockerfile`, e.g.:  
    - Ubuntu version
    - LLVM version and source
    - Python version


# BASFOR
The BASic FORest model, BASFOR, is a process-based model for forest biogeochemistry which simulates the C-, N- and water-cycles.
For a quick start with the model, open the User Guide (file 'BASFOR2015_USER_GUIDE.docx' in directory 'doc') and follow the examples in Chapter 2.
