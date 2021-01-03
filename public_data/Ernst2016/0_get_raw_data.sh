#!/bin/bash

set -o errexit
set -o nounset

# Ernst et al. 2016
mkdir -p raw_data
cd raw_data
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1831nnn/GSM1831781/suppl/GSM1831781_PilotDesign_SV40P_Plasmid_Rep1.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1831nnn/GSM1831782/suppl/GSM1831782_PilotDesign_SV40P_Plasmid_Rep2.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1831nnn/GSM1831777/suppl/GSM1831777_HepG2_PilotDesign_SV40P_mRNA_Rep1.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1831nnn/GSM1831778/suppl/GSM1831778_HepG2_PilotDesign_SV40P_mRNA_Rep2.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1831nnn/GSM1831779/suppl/GSM1831779_K562_PilotDesign_SV40P_mRNA_Rep1.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1831nnn/GSM1831780/suppl/GSM1831780_K562_PilotDesign_SV40P_mRNA_Rep2.counts.txt.gz
cd ..
