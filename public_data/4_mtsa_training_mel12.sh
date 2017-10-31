#!/bin/bash

set -o errexit
set -o nounset

DATADIR=Melnikov2012_processed
../bin/mtsa.py train -n ${DATADIR}/mtsa_mel12.m1000.t5.e5
