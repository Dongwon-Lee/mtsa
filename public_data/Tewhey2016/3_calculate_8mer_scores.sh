#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
KMERF=../8mers.txt


EXPNAME=${INDIR}/mtsa_tew16.m60.t10
${MTSA} predict -n ${EXPNAME} ${KMERF} ${EXPNAME}.8mers.txt

EXPNAME=${INDIR}/mtsa_tew16_NA19239.m60.t10
${MTSA} predict -n ${EXPNAME} ${KMERF} ${EXPNAME}.8mers.txt
