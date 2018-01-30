#!/bin/bash

set -o errexit
set -o nounset

SCRIPT=../../scripts/plot_dna_vs_nexpr.R

Rscript ${SCRIPT} \
    processed/mpra_dna_counts.txt \
    processed/mpra_mrna_counts.txt \
    processed/dna_vs_nexpr.pdf
