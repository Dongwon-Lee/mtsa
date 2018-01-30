#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_uli16.m100.t5.e5
KMERF=../8mers.txt

if [[ -f $KMERF ]]; then
    echo "$KMERF is found."
else
    echo "$KMERF is not found. creating..."
    ../../scripts/gen_kmers.py 8 8mers.txt
fi

# control
${MTSA} predict -n ${EXPNAME} ${KMERF} ${EXPNAME}.8mers.txt

# GATA
EXPNAME=${INDIR}/mtsa_uli16_gata.m100.t5.e5
${MTSA} predict -n ${EXPNAME} ${KMERF} ${EXPNAME}.8mers.txt
