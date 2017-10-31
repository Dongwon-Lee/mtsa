#!/bin/bash

set -o errexit
set -o nounset

# Inoue et al. 2017
echo "building training data from Inoue2017..."
INDIR=Inoue2017_processed
../bin/mtsa.py build -m 100 -t 10 -l AATTC -r CATTG -n ${INDIR}/mtsa_ino17.m100.t10.e5\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

# Ulirsch et al. 2016
echo "building training data from Ulirsch2016..."
INDIR=Ulirsch2016_processed
../bin/mtsa.py build -m 100 -t 5 -l CTAGA -r AGATC -n ${INDIR}/mtsa_uli16.m100.t5.e5\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

# Kheradpour et al. 2013
echo "building training data from Kheradpour2013..."
INDIR=Kheradpour2013_processed
../bin/mtsa.py build -m 500 -t 5 -l CTAGA -r AGATC -n ${INDIR}/mtsa_khe13.m500.t5.e5\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt

# Melnikov et al. 2012
echo "building training data from Melnikov2012..."
INDIR=Melnikov2012_processed
../bin/mtsa.py build -m 1000 -t 5 -l CTAGA -r AGATC -n ${INDIR}/mtsa_mel12.m1000.t5.e5\
    ${INDIR}/mpra_dna_counts.txt ${INDIR}/mpra_mrna_counts.txt ${INDIR}/mpra_tags.txt
