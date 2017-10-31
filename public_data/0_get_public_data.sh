#!/bin/bash

set -o errexit
set -o nounset

# Inoue et al. 2017
mkdir -p Inoue2017
cd Inoue2017
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

# Ulirsch et al. 2016
mkdir -p Ulirsch2016
cd Ulirsch2016
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE87nnn/GSE87711/suppl/GSE87711_RBC_MPRA_minP_raw.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE87nnn/GSE87711/suppl/GSE87711_design_barcodes.txt.gz
cd ..

# Kheradpour et al. 2013
mkdir -p Kheradpour2013
cd Kheradpour2013
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825352/suppl/GSM825352_HepG2_mRNA_Rep1_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825353/suppl/GSM825353_HepG2_mRNA_Rep2_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825356/suppl/GSM825356_Plasmid_Rep1_counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM825nnn/GSM825357/suppl/GSM825357_Plasmid_Rep2_counts.txt.gz
cd ..

# Melnikov et al. 2012
mkdir -p Melnikov2012
cd Melnikov2012
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792099/suppl/GSM792099_CRE_Single_100uM_Rep1_mRNA.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792100/suppl/GSM792100_CRE_Single_100uM_Rep1_Plasmid.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792101/suppl/GSM792101_CRE_Single_100uM_Rep2_mRNA.counts.txt.gz
wget -nv -nc ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM792nnn/GSM792102/suppl/GSM792102_CRE_Single_100uM_Rep2_Plasmid.counts.txt.gz
cd ..
