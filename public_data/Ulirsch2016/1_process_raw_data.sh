#!/bin/bash

set -o errexit
set -o nounset

TAGSC=../../scripts/extract_tag_data_ulirsch16.py
CNTSC=../../scripts/extract_count_data_ulirsch16.py

OUTDIR=processed
mkdir -p ${OUTDIR}
TAGF=${OUTDIR}/mpra_tags.txt

echo "processing raw_data..."

python ${TAGSC} raw_data/GSE87711_design_barcodes.txt.gz >${TAGF}

python ${CNTSC} ${TAGF} raw_data/GSE87711_RBC_MPRA_minP_raw.txt.gz K562_minP_DNA1,K562_minP_DNA2 \
    >${OUTDIR}/mpra_dna_counts.txt

# control mRNA counts
python ${CNTSC} ${TAGF} \
    raw_data/GSE87711_RBC_MPRA_minP_raw.txt.gz K562_CTRL_minP_RNA1,K562_CTRL_minP_RNA2,K562_CTRL_minP_RNA3,K562_CTRL_minP_RNA4,K562_CTRL_minP_RNA5,K562_CTRL_minP_RNA6 \
    >${OUTDIR}/mpra_mrna_counts.txt

# GATA mRNA counts
python ${CNTSC} ${TAGF} \
    raw_data/GSE87711_RBC_MPRA_minP_raw.txt.gz K562_GATA1_minP_RNA1,K562_GATA1_minP_RNA2,K562_GATA1_minP_RNA3,K562_GATA1_minP_RNA4 \
    >${OUTDIR}/mpra_mrna_counts_gata.txt
