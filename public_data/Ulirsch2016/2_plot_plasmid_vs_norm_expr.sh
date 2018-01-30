#!/bin/bash

set -o errexit
set -o nounset

SCRIPT=../../scripts/plot_dna_vs_nexpr.R

# data from Ulirsch et al. 2016
echo "evaluating control data"
Rscript ${SCRIPT} \
    processed/mpra_dna_counts.txt \
    processed/mpra_mrna_counts.txt \
    processed/dna_vs_nexpr.pdf

echo "evaluating GATA data"
Rscript ${SCRIPT} \
    processed_gata/mpra_dna_counts.txt \
    processed_gata/mpra_mrna_counts.txt \
    processed_gata/dna_vs_nexpr.pdf
