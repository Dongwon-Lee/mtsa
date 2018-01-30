#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_khe13.m500.t5.e5

${MTSA} train -M 2048 -T 4 -n ${EXPNAME}
