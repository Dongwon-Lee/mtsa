#!/bin/bash

mkdir -p processed

# 1. generate input
Rscript ../../scripts/preproc_Kwasnieski2014_supdata2_noflanking.R

# 2. run MTSA training
python ../../bin/mtsa.py train -T 1 -n processed/mtsa_kwa14.t4.e0
