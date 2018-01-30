#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_ino17.m100.t10.e5

${MTSA} build -m 100 -t 10 -l AATTC -r CATTG -n ${EXPNAME} \
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt
