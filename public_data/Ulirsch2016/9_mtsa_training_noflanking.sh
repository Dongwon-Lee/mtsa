#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed

EXPNAME=${INDIR}/mtsa_uli16.m100.t5.e0

echo "building training data from control..."
${MTSA} build -m 100 -t 5 -n ${EXPNAME} \
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

${MTSA} train -M 2048 -T 4 -n ${EXPNAME}
