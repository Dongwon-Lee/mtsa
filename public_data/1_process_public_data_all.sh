#!/bin/bash

set -o errexit
set -o nounset

mkdir -p Inoue2017_processed
mkdir -p Ulirsch2016_processed
mkdir -p Kheradpour2013_processed
mkdir -p Melnikov2012_processed

echo "processing Inoue2017..."
python ../scripts/extract_tag_data_inoue17.py Inoue2017/GSM2221119_liverEnhancer_design.tsv.gz \
    >Inoue2017_processed/mpra_tags.txt

python ../scripts/extract_count_data_inoue17.py Inoue2017_processed/mpra_tags.txt \
    Inoue2017/GSM2221107_MT1-DNA.tsv.gz Inoue2017/GSM2221109_MT2-DNA.tsv.gz Inoue2017/GSM2221111_MT3-DNA.tsv.gz \
    >Inoue2017_processed/mpra_dna_counts_mt.txt

python ../scripts/extract_count_data_inoue17.py Inoue2017_processed/mpra_tags.txt \
    Inoue2017/GSM2221108_MT1-RNA.tsv.gz Inoue2017/GSM2221110_MT2-RNA.tsv.gz Inoue2017/GSM2221112_MT3-RNA.tsv.gz \
    >Inoue2017_processed/mpra_mrna_counts_mt.txt

python ../scripts/extract_count_data_inoue17.py Inoue2017_processed/mpra_tags.txt \
    Inoue2017/GSM2221113_WT1-DNA.tsv.gz Inoue2017/GSM2221115_WT2-DNA.tsv.gz Inoue2017/GSM2221117_WT3-DNA.tsv.gz \
    >Inoue2017_processed/mpra_dna_counts_wt.txt

python ../scripts/extract_count_data_inoue17.py Inoue2017_processed/mpra_tags.txt \
    Inoue2017/GSM2221114_WT1-RNA.tsv.gz Inoue2017/GSM2221116_WT2-RNA.tsv.gz Inoue2017/GSM2221118_WT3-RNA.tsv.gz \
    >Inoue2017_processed/mpra_mrna_counts_wt.txt

python ../scripts/extract_count_data_inoue17.py Inoue2017_processed/mpra_tags.txt \
    Inoue2017/GSM2221107_MT1-DNA.tsv.gz Inoue2017/GSM2221109_MT2-DNA.tsv.gz Inoue2017/GSM2221111_MT3-DNA.tsv.gz \
    Inoue2017/GSM2221113_WT1-DNA.tsv.gz Inoue2017/GSM2221115_WT2-DNA.tsv.gz Inoue2017/GSM2221117_WT3-DNA.tsv.gz \
    >Inoue2017_processed/mpra_dna_counts.txt

python ../scripts/extract_count_data_inoue17.py Inoue2017_processed/mpra_tags.txt \
    Inoue2017/GSM2221108_MT1-RNA.tsv.gz Inoue2017/GSM2221110_MT2-RNA.tsv.gz Inoue2017/GSM2221112_MT3-RNA.tsv.gz \
    Inoue2017/GSM2221114_WT1-RNA.tsv.gz Inoue2017/GSM2221116_WT2-RNA.tsv.gz Inoue2017/GSM2221118_WT3-RNA.tsv.gz \
    >Inoue2017_processed/mpra_mrna_counts.txt

echo "processing Ulirsch2016..."
python ../scripts/extract_tag_data_ulirsch16.py Ulirsch2016/GSE87711_design_barcodes.txt.gz \
    >Ulirsch2016_processed/mpra_tags.txt

python ../scripts/extract_count_data_ulirsch16.py Ulirsch2016_processed/mpra_tags.txt \
    Ulirsch2016/GSE87711_RBC_MPRA_minP_raw.txt.gz K562_minP_DNA1,K562_minP_DNA2 \
    >Ulirsch2016_processed/mpra_dna_counts.txt

python ../scripts/extract_count_data_ulirsch16.py Ulirsch2016_processed/mpra_tags.txt \
    Ulirsch2016/GSE87711_RBC_MPRA_minP_raw.txt.gz K562_CTRL_minP_RNA1,K562_CTRL_minP_RNA2,K562_CTRL_minP_RNA3,K562_CTRL_minP_RNA4,K562_CTRL_minP_RNA5,K562_CTRL_minP_RNA6 \
    >Ulirsch2016_processed/mpra_mrna_counts.txt

echo "processing Kheradpour2013..."
python ../scripts/extract_tag_data_melnikov12.py Kheradpour2013/GSM825356_Plasmid_Rep1_counts.txt.gz \
    >Kheradpour2013_processed/mpra_tags.txt

python ../scripts/extract_count_data_melnikov12.py \
    Kheradpour2013/GSM825356_Plasmid_Rep1_counts.txt.gz Kheradpour2013/GSM825357_Plasmid_Rep2_counts.txt.gz \
    >Kheradpour2013_processed/mpra_dna_counts.txt 

python ../scripts/extract_count_data_melnikov12.py \
    Kheradpour2013/GSM825352_HepG2_mRNA_Rep1_counts.txt.gz Kheradpour2013/GSM825353_HepG2_mRNA_Rep2_counts.txt.gz \
    >Kheradpour2013_processed/mpra_mrna_counts.txt 

echo "processing Melnikov2012..."
python ../scripts/extract_tag_data_melnikov12.py Melnikov2012/GSM792100_CRE_Single_100uM_Rep1_Plasmid.counts.txt.gz \
    >Melnikov2012_processed/mpra_tags.txt

python ../scripts/extract_count_data_melnikov12.py \
    Melnikov2012/GSM792100_CRE_Single_100uM_Rep1_Plasmid.counts.txt.gz Melnikov2012/GSM792102_CRE_Single_100uM_Rep2_Plasmid.counts.txt.gz \
    >Melnikov2012_processed/mpra_dna_counts.txt 

python ../scripts/extract_count_data_melnikov12.py \
    Melnikov2012/GSM792099_CRE_Single_100uM_Rep1_mRNA.counts.txt.gz Melnikov2012/GSM792101_CRE_Single_100uM_Rep2_mRNA.counts.txt.gz \
    >Melnikov2012_processed/mpra_mrna_counts.txt 
