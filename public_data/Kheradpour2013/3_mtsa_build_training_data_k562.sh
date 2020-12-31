#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_khe13_k562.m500.t5.e5

${MTSA} build -m 500 -t 5 -l CTAGA -r AGATC -n ${EXPNAME}\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts_k562.txt ${INDIR}/mpra_tags.txt
