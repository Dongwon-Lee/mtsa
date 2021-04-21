#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed

EXPNAME=${INDIR}/mtsa_tew16.m60.t10.e0

${MTSA} build2 -m 60 -t 10 -n ${EXPNAME} \
    tew16_mtsa_input.tot50.txt

${MTSA} train -M 2048 -T 4 -n ${EXPNAME}
