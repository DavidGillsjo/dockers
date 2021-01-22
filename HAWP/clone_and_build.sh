#!/bin/bash
git clone git@github.com:cherubicXN/hawp.git
mkdir hawp/outputs
python3 google_drive.py 1VP0M7O-6ng461y_VWznMFuqKw2efH-aD hawp/outputs/hawp.zip
cd hawp/outputs && unzip hawp.zip
cd hawp && python3 setup.py build_ext --inplace

#After this, run
#export PYTHONPATH=<your_path_to_hawp>
