#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
KMERF=../8mers.txt

if [[ -f $KMERF ]]; then
    echo "$KMERF is found."
else
    echo "$KMERF is not found. creating..."
    ../../scripts/gen_kmers.py 8 8mers.txt
fi

EXPNAME=${INDIR}/mtsa_ern16.m2000.t5.e5
${MTSA} predict -n ${EXPNAME} ${KMERF} ${EXPNAME}.8mers.txt

EXPNAME2=${INDIR}/mtsa_ern16_k562.m2000.t5.e5
${MTSA} predict -n ${EXPNAME2} ${KMERF} ${EXPNAME2}.8mers.txt
