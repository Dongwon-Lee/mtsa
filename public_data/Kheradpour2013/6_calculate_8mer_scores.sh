#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_khe13.m500.t5.e5
KMERF=../8mers.txt

if [[ -f $KMERF ]]; then
    echo "$KMERF is found."
else
    echo "$KMERF is not found. creating..."
    ../../scripts/gen_kmers.py 8 8mers.txt
fi

${MTSA} predict -n ${EXPNAME} ${KMERF} ${EXPNAME}.8mers.txt
