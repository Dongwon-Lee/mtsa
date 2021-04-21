#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_tew16.m60.t10

${MTSA} train -M 2048 -T 4 -n ${EXPNAME}
