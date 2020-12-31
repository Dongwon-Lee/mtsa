#!/bin/bash

set -o errexit
set -o nounset

# Kheradpour et al. 2013
mkdir -p raw_data
cd raw_data
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825352/suppl/GSM825352_HepG2_mRNA_Rep1_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825353/suppl/GSM825353_HepG2_mRNA_Rep2_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825354/suppl/GSM825354_K562_mRNA_Rep1_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825355/suppl/GSM825355_K562_mRNA_Rep2_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825356/suppl/GSM825356_Plasmid_Rep1_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825357/suppl/GSM825357_Plasmid_Rep2_counts.txt.gz
cd ..
