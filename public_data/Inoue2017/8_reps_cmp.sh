#!/bin/bash

set -o errexit
set -o nounset

OUTDIR=reps_cmp
mkdir -p $OUTDIR

CNTSC=../../scripts/extract_count_data_inoue17.py
MTSA=../../bin/mtsa.py
TAGF=processed/mpra_tags.txt

echo "1. processing raw mrna data for each replicate..."

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221108_MT1-RNA.tsv.gz \
    >${OUTDIR}/mpra_mrna_counts_rep1.txt

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221110_MT2-RNA.tsv.gz \
    >${OUTDIR}/mpra_mrna_counts_rep2.txt

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221112_MT3-RNA.tsv.gz \
    >${OUTDIR}/mpra_mrna_counts_rep3.txt

echo "2. normalize mrna reads for each replicate..."
EXPNAME=processed/mtsa_ino17.m50.t10.e5
for R in `seq 3`; do
    ${MTSA} normalize -n ${EXPNAME} \
        -l AATTC -r CATTG \
        ${OUTDIR}/mpra_mrna_counts_rep${R}.txt \
        processed/mpra_tags.txt \
        ${OUTDIR}/mpra_mrna_counts_rep${R}.norm.txt
done
