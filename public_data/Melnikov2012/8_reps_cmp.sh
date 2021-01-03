#!/bin/bash

set -o errexit
set -o nounset

OUTDIR=reps_cmp
mkdir -p $OUTDIR

CNTSC=../../scripts/extract_count_data_melnikov12.py
MTSA=../../bin/mtsa.py

echo "1. processing raw mrna data for each replicate..."
python ${CNTSC} raw_data/GSM792099_CRE_Single_100uM_Rep1_mRNA.counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts_rep1.txt 

python ${CNTSC} raw_data/GSM792101_CRE_Single_100uM_Rep2_mRNA.counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts_rep2.txt 

echo "2. normalize mrna reads for each replicate..."
EXPNAME=processed/mtsa_mel12.m1000.t5.e5
${MTSA} normalize -n ${EXPNAME} \
    -l CTAGA -r AGATC \
    ${OUTDIR}/mpra_mrna_counts_rep1.txt \
    processed/mpra_tags.txt \
    ${OUTDIR}/mpra_mrna_counts_rep1.norm.txt

${MTSA} normalize -n ${EXPNAME} \
    -l CTAGA -r AGATC \
    ${OUTDIR}/mpra_mrna_counts_rep2.txt \
    processed/mpra_tags.txt \
    ${OUTDIR}/mpra_mrna_counts_rep2.norm.txt
