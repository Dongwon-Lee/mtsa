#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_mel12.m1000.t5.e5

${MTSA} train -T 4 -n ${EXPNAME}
