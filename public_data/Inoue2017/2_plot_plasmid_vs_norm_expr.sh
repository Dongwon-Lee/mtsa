#!/bin/bash

set -o errexit
set -o nounset

SCRIPT=../../scripts/plot_dna_vs_nexpr.R
# data from Inoue et al. 2017
echo "Inoue et al. 2017 (MT)"
Rscript ${SCRIPT} \
    processed/mpra_dna_counts.txt \
    processed/mpra_mrna_counts.txt \
    processed/dna_vs_nexpr_ino17.pdf

echo "Inoue et al. 2017 (WT)"
Rscript ${SCRIPT} \
    processed/mpra_dna_counts_wt.txt \
    processed/mpra_mrna_counts_wt.txt \
    processed/dna_vs_nexpr_ino17_wt.pdf
