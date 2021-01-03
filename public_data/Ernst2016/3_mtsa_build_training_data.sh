#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_ern16.m2000.t5.e5

${MTSA} build -m 2000 -t 5 -l CTAGA -r AGATC -n ${EXPNAME}\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

EXPNAME2=${INDIR}/mtsa_ern16_k562.m2000.t5.e5

${MTSA} build -m 2000 -t 5 -l CTAGA -r AGATC -n ${EXPNAME2}\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts_k562.txt ${INDIR}/mpra_tags.txt
