#!/bin/bash

set -o errexit
set -o nounset

TAGSC=../../scripts/extract_tag_data_melnikov12.py
CNTSC=../../scripts/extract_count_data_melnikov12.py

OUTDIR=processed
mkdir -p ${OUTDIR}

echo "processing raw_data..."
python ${TAGSC} raw_data/GSM825356_Plasmid_Rep1_counts.txt.gz \
    >${OUTDIR}/mpra_tags.txt

python ${CNTSC} raw_data/GSM825356_Plasmid_Rep1_counts.txt.gz raw_data/GSM825357_Plasmid_Rep2_counts.txt.gz \
    >${OUTDIR}/mpra_dna_counts.txt 

python ${CNTSC} raw_data/GSM825352_HepG2_mRNA_Rep1_counts.txt.gz raw_data/GSM825353_HepG2_mRNA_Rep2_counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts.txt 
