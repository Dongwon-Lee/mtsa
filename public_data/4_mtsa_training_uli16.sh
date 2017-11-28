#!/bin/bash

set -o errexit
set -o nounset

EXPNAME=Ulirsch2016_processed/mtsa_uli16.m100.t5.e5
../bin/mtsa.py train -M 2048 -T 4 -n ${EXPNAME}
