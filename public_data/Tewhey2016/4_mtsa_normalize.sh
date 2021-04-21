#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
KMERF=../8mers.txt


EXPNAME=${INDIR}/mtsa_tew16.m60.t10
${MTSA} normalize2 -n ${EXPNAME} -l CTAGA -r AGATC \
    tew16_mtsa_input.tot50.txt \
    ${INDIR}/tew16_mtsa_input.tot50.norm.txt


EXPNAME=${INDIR}/mtsa_tew16_NA19239.m60.t10
${MTSA} normalize2 -n ${EXPNAME} -l CTAGA -r AGATC \
    tew16_NA19239_mtsa_input.tot50.txt \
    ${INDIR}/tew16_NA19239_mtsa_input.tot50.norm.txt
