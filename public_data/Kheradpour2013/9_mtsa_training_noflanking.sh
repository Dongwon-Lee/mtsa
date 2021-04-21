#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_khe13.m500.t5.e0

${MTSA} build -m 500 -t 5 -n ${EXPNAME}\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

${MTSA} train -M 2048 -T 4 -n ${EXPNAME}
