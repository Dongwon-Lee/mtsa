#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed

bunzip2 -c tew16_mtsa_input.tot50.txt.bz2 >tew16_mtsa_input.tot50.txt

EXPNAME=${INDIR}/mtsa_tew16.m60.t10
${MTSA} build2 -m 60 -t 10 -l CTAGA -r AGATC -n ${EXPNAME} \
    tew16_mtsa_input.tot50.txt

bunzip2 -c tew16_NA19239_mtsa_input.tot50.txt.bz2 >tew16_NA19239_mtsa_input.tot50.txt

EXPNAME=${INDIR}/mtsa_tew16_NA19239.m60.t10
${MTSA} build2 -m 60 -t 10 -l CTAGA -r AGATC -n ${EXPNAME} \
    tew16_NA19239_mtsa_input.tot50.txt
