#!/bin/bash

set -o errexit
set -o nounset

TAGSC=../../scripts/extract_tag_data_melnikov12.py
CNTSC=../../scripts/extract_count_data_melnikov12.py

OUTDIR=processed
mkdir -p ${OUTDIR}

echo "processing raw_data..."
python ${TAGSC} raw_data/GSM792100_CRE_Single_100uM_Rep1_Plasmid.counts.txt.gz \
    >${OUTDIR}/mpra_tags.txt

python ${CNTSC} raw_data/GSM792100_CRE_Single_100uM_Rep1_Plasmid.counts.txt.gz raw_data/GSM792102_CRE_Single_100uM_Rep2_Plasmid.counts.txt.gz \
    >${OUTDIR}/mpra_dna_counts.txt 

python ${CNTSC} raw_data/GSM792099_CRE_Single_100uM_Rep1_mRNA.counts.txt.gz raw_data/GSM792101_CRE_Single_100uM_Rep2_mRNA.counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts.txt 
