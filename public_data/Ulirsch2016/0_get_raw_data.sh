#!/bin/bash

set -o errexit
set -o nounset

# Ulirsch et al. 2016
mkdir -p raw_data
cd raw_data
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE87nnn/GSE87711/suppl/GSE87711_RBC_MPRA_minP_raw.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE87nnn/GSE87711/suppl/GSE87711_design_barcodes.txt.gz
cd ..
