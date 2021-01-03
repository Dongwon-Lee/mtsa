#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_ino17_wt.m50.t10.e5

${MTSA} train -M 8192 -T 4 -n ${EXPNAME}
