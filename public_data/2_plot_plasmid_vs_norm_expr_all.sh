#!/bin/bash

set -o errexit
set -o nounset

# data from Inoue et al. 2017
echo "Inoue et al. 2017 (MT)"
Rscript ../scripts/plot_dna_vs_nexpr.R \
    Inoue2017_processed/mpra_dna_counts_mt.txt \
    Inoue2017_processed/mpra_mrna_counts_mt.txt \
    Inoue2017_processed/dna_vs_nexpr_mt.pdf

echo "Inoue et al. 2017 (WT)"
Rscript ../scripts/plot_dna_vs_nexpr.R \
    Inoue2017_processed/mpra_dna_counts_wt.txt \
    Inoue2017_processed/mpra_mrna_counts_wt.txt \
    Inoue2017_processed/dna_vs_nexpr_wt.pdf

echo "Inoue et al. 2017 (combined)"
Rscript ../scripts/plot_dna_vs_nexpr.R \
    Inoue2017_processed/mpra_dna_counts.txt \
    Inoue2017_processed/mpra_mrna_counts.txt \
    Inoue2017_processed/dna_vs_nexpr.pdf

# data from Ulirsch et al. 2016
echo "Ulirsch et al. 2016 (control)"
Rscript ../scripts/plot_dna_vs_nexpr.R \
    Ulirsch2016_processed/mpra_dna_counts.txt \
    Ulirsch2016_processed/mpra_mrna_counts.txt \
    Ulirsch2016_processed/dna_vs_nexpr.pdf

# data from Kheradpour et al. 2013
echo "Kheradpour et al. 2013"
Rscript ../scripts/plot_dna_vs_nexpr.R \
    Kheradpour2013_processed/mpra_dna_counts.txt \
    Kheradpour2013_processed/mpra_mrna_counts.txt \
    Kheradpour2013_processed/dna_vs_nexpr.pdf

# data from Melnikov et al. 2012
echo "Melnikov et al. 2012"
Rscript ../scripts/plot_dna_vs_nexpr.R \
    Melnikov2012_processed/mpra_dna_counts.txt \
    Melnikov2012_processed/mpra_mrna_counts.txt \
    Melnikov2012_processed/dna_vs_nexpr.pdf
