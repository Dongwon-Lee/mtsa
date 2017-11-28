#!/bin/bash

set -o errexit
set -o nounset

EXPNAME=Melnikov2012_processed/mtsa_mel12.m1000.t5.e5
../bin/mtsa.py train -T 4 -n ${EXPNAME}
