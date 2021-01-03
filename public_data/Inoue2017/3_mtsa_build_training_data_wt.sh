#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_ino17_wt.m50.t10.e5

${MTSA} build -m 50 -t 10 -l AATTC -r CATTG -n ${EXPNAME} \
    ${INDIR}/mpra_dna_counts_wt.txt ${INDIR}/mpra_mrna_counts_wt.txt ${INDIR}/mpra_tags.txt
