#!/bin/bash

set -o errexit
set -o nounset

OUTDIR=tag_expr_cmp
MTSA=../../bin/mtsa.py

mkdir -p $OUTDIR


# split data into two groups: one for training, the other for evaluation
python ../../scripts/split_tew16_tags.py \
    tew16_mtsa_input.tot50.txt \
    ${OUTDIR}/mtsa_input_tr.txt \
    ${OUTDIR}/tags1.txt \
    ${OUTDIR}/tags2.txt

cut -f 2 ${OUTDIR}/tags1.txt |sed 's/\(.*\)/CTAGA\1AGATC/g' >${OUTDIR}/tags_col1.txt
cut -f 2 ${OUTDIR}/tags2.txt |sed 's/\(.*\)/CTAGA\1AGATC/g' >${OUTDIR}/tags_col2.txt

# build data
EXPNAME=${OUTDIR}/mtsa_tew16_tr.m60.t10
${MTSA} build2 -m 60 -t 10 -l CTAGA -r AGATC -n ${EXPNAME} \
    ${OUTDIR}/mtsa_input_tr.txt

# model training with default parameter
${MTSA} train -T 4 -M 8000 -n ${EXPNAME}

# predicting effects of the held-out tags
${MTSA} predict -T 4 -n ${EXPNAME} ${OUTDIR}/tags_col1.txt ${OUTDIR}/tags_col1_score.txt
${MTSA} predict -T 4 -n ${EXPNAME} ${OUTDIR}/tags_col2.txt ${OUTDIR}/tags_col2_score.txt
