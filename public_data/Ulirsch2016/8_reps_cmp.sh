#!/bin/bash

set -o errexit
set -o nounset

OUTDIR=reps_cmp
mkdir -p $OUTDIR

CNTSC=../../scripts/extract_count_data_ulirsch16.py
MTSA=../../bin/mtsa.py
TAGF=processed/mpra_tags.txt

echo "1. processing raw mrna data for each replicate..."
for R in `seq 6`; do
python ${CNTSC} ${TAGF} \
    raw_data/GSE87711_RBC_MPRA_minP_raw.txt.gz K562_CTRL_minP_RNA${R} \
    >${OUTDIR}/mpra_mrna_counts_rep${R}.txt
done

echo "2. normalize mrna reads for each replicate..."
EXPNAME=processed/mtsa_uli16.m100.t5.e5
for R in `seq 6`; do
    ${MTSA} normalize -n ${EXPNAME} \
        -l CTAGA -r AGATC \
        ${OUTDIR}/mpra_mrna_counts_rep${R}.txt \
        processed/mpra_tags.txt \
        ${OUTDIR}/mpra_mrna_counts_rep${R}.norm.txt
done

