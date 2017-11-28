#!/bin/bash

set -o errexit
set -o nounset

EXPNAME=Inoue2017_processed/mtsa_ino17.m100.t10.e5

../bin/mtsa.py train -M 2048 -T 4 -n ${EXPNAME}
