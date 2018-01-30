#!/bin/bash

set -o errexit
set -o nounset

mkdir -p processed

TAGSC=../../scripts/extract_tag_data_inoue17.py
CNTSC=../../scripts/extract_count_data_inoue17.py
TAGF=processed/mpra_tags.txt

echo "processing raw_data..."

python ${TAGSC} raw_data/GSM2221119_liverEnhancer_design.tsv.gz >${TAGF}

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221107_MT1-DNA.tsv.gz raw_data/GSM2221109_MT2-DNA.tsv.gz raw_data/GSM2221111_MT3-DNA.tsv.gz \
    >processed/mpra_dna_counts_mt.txt

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221108_MT1-RNA.tsv.gz raw_data/GSM2221110_MT2-RNA.tsv.gz raw_data/GSM2221112_MT3-RNA.tsv.gz \
    >processed/mpra_mrna_counts_mt.txt

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221113_WT1-DNA.tsv.gz raw_data/GSM2221115_WT2-DNA.tsv.gz raw_data/GSM2221117_WT3-DNA.tsv.gz \
    >processed/mpra_dna_counts_wt.txt

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221114_WT1-RNA.tsv.gz raw_data/GSM2221116_WT2-RNA.tsv.gz raw_data/GSM2221118_WT3-RNA.tsv.gz \
    >processed/mpra_mrna_counts_wt.txt

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221107_MT1-DNA.tsv.gz raw_data/GSM2221109_MT2-DNA.tsv.gz raw_data/GSM2221111_MT3-DNA.tsv.gz \
    raw_data/GSM2221113_WT1-DNA.tsv.gz raw_data/GSM2221115_WT2-DNA.tsv.gz raw_data/GSM2221117_WT3-DNA.tsv.gz \
    >processed/mpra_dna_counts.txt

python ${CNTSC} ${TAGF} \
    raw_data/GSM2221108_MT1-RNA.tsv.gz raw_data/GSM2221110_MT2-RNA.tsv.gz raw_data/GSM2221112_MT3-RNA.tsv.gz \
    raw_data/GSM2221114_WT1-RNA.tsv.gz raw_data/GSM2221116_WT2-RNA.tsv.gz raw_data/GSM2221118_WT3-RNA.tsv.gz \
    >processed/mpra_mrna_counts.txt
