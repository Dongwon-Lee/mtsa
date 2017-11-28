#!/bin/bash

set -o errexit
set -o nounset

INDIR=Melnikov2012_processed
OUTDIR=tag_expr_cmp_mel12

mkdir -p $OUTDIR

# split data into two groups: one for training, the other for evaluation
cut -f 1,4- ${INDIR}/mpra_dna_counts.txt >${OUTDIR}/dna_tr.txt
cut -f 1,4- ${INDIR}/mpra_mrna_counts.txt >${OUTDIR}/mrna_tr.txt
cut -f 1,4- ${INDIR}/mpra_tags.txt >${OUTDIR}/tag_tr.txt
cut -f 2-3 ${INDIR}/mpra_dna_counts.txt >${OUTDIR}/dna_te.txt
cut -f 2-3 ${INDIR}/mpra_mrna_counts.txt >${OUTDIR}/mrna_te.txt
cut -f 2 ${INDIR}/mpra_tags.txt |sed 's/\(.*\)/CTAGA\1AGATC/g' >${OUTDIR}/tags_col1.txt
cut -f 3 ${INDIR}/mpra_tags.txt |sed 's/\(.*\)/CTAGA\1AGATC/g' >${OUTDIR}/tags_col2.txt

# build data
EXPNAME=${OUTDIR}/mtsa_mel12_tr.m1000.t5.e5
../bin/mtsa.py build -m 1000 -t 5 -l CTAGA -r AGATC -n ${EXPNAME}\
    ${OUTDIR}/dna_tr.txt ${OUTDIR}/mrna_tr.txt ${OUTDIR}/tag_tr.txt

# model training with default parameter
../bin/mtsa.py train -n ${EXPNAME}

# predicting effects of the held-out tags
../bin/mtsa.py predict -T 4 -n ${EXPNAME} ${OUTDIR}/tags_col1.txt ${OUTDIR}/tags_col1_score.txt
../bin/mtsa.py predict -T 4 -n ${EXPNAME} ${OUTDIR}/tags_col2.txt ${OUTDIR}/tags_col2_score.txt
