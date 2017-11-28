#!/bin/bash

set -o errexit
set -o nounset

EXPNAME=Kheradpour2013_processed/mtsa_khe13.m500.t5.e5
../bin/mtsa.py train -T 4 -n ${EXPNAME}
