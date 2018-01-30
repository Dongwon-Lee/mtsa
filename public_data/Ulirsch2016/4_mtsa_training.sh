#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
EXPNAME=processed/mtsa_uli16.m100.t5.e5
${MTSA} train -M 2048 -T 4 -n ${EXPNAME}
