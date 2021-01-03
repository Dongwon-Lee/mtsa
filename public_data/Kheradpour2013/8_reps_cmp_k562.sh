#!/bin/bash

set -o errexit
set -o nounset

OUTDIR=reps_cmp
mkdir -p $OUTDIR

CNTSC=../../scripts/extract_count_data_melnikov12.py
MTSA=../../bin/mtsa.py

echo "1. processing raw mrna data for each replicate..."
python ${CNTSC} raw_data/GSM825354_K562_mRNA_Rep1_counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts_k562_rep1.txt 

python ${CNTSC} raw_data/GSM825355_K562_mRNA_Rep2_counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts_k562_rep2.txt 

echo "2. normalize mrna reads for each replicate..."
EXPNAME=processed/mtsa_khe13_k562.m500.t5.e5
${MTSA} normalize -n ${EXPNAME} \
    -l CTAGA -r AGATC \
    ${OUTDIR}/mpra_mrna_counts_k562_rep1.txt \
    processed/mpra_tags.txt \
    ${OUTDIR}/mpra_mrna_counts_k562_rep1.norm.txt

${MTSA} normalize -n ${EXPNAME} \
    -l CTAGA -r AGATC \
    ${OUTDIR}/mpra_mrna_counts_k562_rep2.txt \
    processed/mpra_tags.txt \
    ${OUTDIR}/mpra_mrna_counts_k562_rep2.norm.txt
