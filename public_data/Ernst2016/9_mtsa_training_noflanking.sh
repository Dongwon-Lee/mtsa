#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_ern16.m2000.t5.e0

#1. HepG2
${MTSA} build -m 2000 -t 5 -n ${EXPNAME}\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

${MTSA} train -M 2048 -T 4 -n ${EXPNAME}


#2. K562
EXPNAME2=${INDIR}/mtsa_ern10_k562.m2000.t5.e0

${MTSA} build -m 2000 -t 5 -n ${EXPNAME2}\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts_k562.txt ${INDIR}/mpra_tags.txt

${MTSA} train -M 2048 -T 4 -n ${EXPNAME2}
