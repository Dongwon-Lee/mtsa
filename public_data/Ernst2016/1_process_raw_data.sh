#!/bin/bash

set -o errexit
set -o nounset

TAGSC=../../scripts/extract_tag_data_melnikov12.py
CNTSC=../../scripts/extract_count_data_melnikov12.py

OUTDIR=processed
mkdir -p ${OUTDIR}

echo "processing raw_data..."
python ${TAGSC} raw_data/GSM1831781_PilotDesign_SV40P_Plasmid_Rep1.counts.txt.gz \
    >${OUTDIR}/mpra_tags.txt

python ${CNTSC} raw_data/GSM1831781_PilotDesign_SV40P_Plasmid_Rep1.counts.txt.gz \
    raw_data/GSM1831782_PilotDesign_SV40P_Plasmid_Rep2.counts.txt.gz \
    >${OUTDIR}/mpra_dna_counts.txt 

python ${CNTSC} raw_data/GSM1831777_HepG2_PilotDesign_SV40P_mRNA_Rep1.counts.txt.gz \
    raw_data/GSM1831778_HepG2_PilotDesign_SV40P_mRNA_Rep2.counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts.txt 

python ${CNTSC} raw_data/GSM1831779_K562_PilotDesign_SV40P_mRNA_Rep1.counts.txt.gz \
raw_data/GSM1831780_K562_PilotDesign_SV40P_mRNA_Rep2.counts.txt.gz \
    >${OUTDIR}/mpra_mrna_counts_k562.txt 
