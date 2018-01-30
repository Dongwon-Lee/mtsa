#!/bin/bash

set -o errexit
set -o nounset

# Melnikov et al. 2012
mkdir -p raw_data
cd raw_data
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792099/suppl/GSM792099_CRE_Single_100uM_Rep1_mRNA.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792100/suppl/GSM792100_CRE_Single_100uM_Rep1_Plasmid.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792101/suppl/GSM792101_CRE_Single_100uM_Rep2_mRNA.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792102/suppl/GSM792102_CRE_Single_100uM_Rep2_Plasmid.counts.txt.gz
cd ..
