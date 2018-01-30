#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed

#1. control
EXPNAME=${INDIR}/mtsa_uli16.m100.t5.e5

echo "building training data from control..."
${MTSA} build -m 100 -t 5 -l CTAGA -r AGATC -n ${EXPNAME} \
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

#2. GATA 
EXPNAME=${INDIR}/mtsa_uli16_gata.m100.t5.e5

echo "building training data from GATA..."
${MTSA}  build -m 100 -t 5 -l CTAGA -r AGATC -n ${EXPNAME} \
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts_gata.txt ${INDIR}/mpra_tags.txt
