#!/bin/bash

set -o errexit
set -o nounset

# Inoue et al. 2017
mkdir -p raw_data
cd raw_data
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221107/suppl/GSM2221107_MT1-DNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221108/suppl/GSM2221108_MT1-RNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221109/suppl/GSM2221109_MT2-DNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221110/suppl/GSM2221110_MT2-RNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221111/suppl/GSM2221111_MT3-DNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221112/suppl/GSM2221112_MT3-RNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221113/suppl/GSM2221113_WT1-DNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221114/suppl/GSM2221114_WT1-RNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221115/suppl/GSM2221115_WT2-DNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221116/suppl/GSM2221116_WT2-RNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221117/suppl/GSM2221117_WT3-DNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221118/suppl/GSM2221118_WT3-RNA.tsv.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2221nnn/GSM2221119/suppl/GSM2221119_liverEnhancer_design.tsv.gz
cd ..
