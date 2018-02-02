#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../../bin/mtsa.py
BARCODEF=../raw_data/GSE87711_design_barcodes.txt.gz
RAWDATAF=../raw_data/GSE87711_RBC_MPRA_minP_raw.txt.gz
EXPCTRL=../processed/mtsa_uli16.m100.t5.e5
EXPGATA=../processed/mtsa_uli16_gata.m100.t5.e5

# intermediate files...
BCTRLF=barcodes_flattened_ctrl.txt
BGATAF=barcodes_flattened_gata1.txt
CTRLF=mrna_counts_ctrl_only.txt
GATAF=mrna_counts_gata1_only.txt
NORMCTRL=mrna_counts_ctrl_norm.txt
NORMGATA=mrna_counts_gata1_norm.txt
NORMCMBN=mrna_counts_norm_combined_with_header.txt

gunzip -c ${BARCODEF} |cut -f 2|sed 's/,/\
/g' |awk -v OFS="\t" '{print NR, $0,$0,$0,$0,$0,$0}' >${BCTRLF}

gunzip -c ${BARCODEF} |cut -f 2|sed 's/,/\
/g' |awk -v OFS="\t" '{print NR, $0,$0,$0,$0}' >${BGATAF}

gunzip -c ${RAWDATAF} |cut -f 14-19 |awk -v OFS="\t" 'NR>1 {print NR-1, $0}' >${CTRLF}
gunzip -c ${RAWDATAF} |cut -f 20-23 |awk -v OFS="\t" 'NR>1 {print NR-1, $0}' >${GATAF}

${MTSA} normalize -l CTAGA -r AGATC -n ${EXPCTRL} ${CTRLF} ${BCTRLF} ${NORMCTRL}
${MTSA} normalize -l CTAGA -r AGATC -n ${EXPGATA} ${GATAF} ${BGATAF} ${NORMGATA}

paste ${NORMCTRL} ${NORMGATA} |cut -f 2-7,9- |awk 'BEGIN {print "K562_CTRL_minP_RNA1	K562_CTRL_minP_RNA2	K562_CTRL_minP_RNA3	K562_CTRL_minP_RNA4	K562_CTRL_minP_RNA5	K562_CTRL_minP_RNA6	K562_GATA1_minP_RNA1	K562_GATA1_minP_RNA2	K562_GATA1_minP_RNA3	K562_GATA1_minP_RNA4"}{print $0}' >${NORMCMBN}

gunzip -c ${RAWDATAF} |cut -f 1-13 |paste - ${NORMCMBN} >MPRA_minP_mtsanorm.txt

#remove intermediate files
rm -f $BCTRLF $BGATAF $CTRLF $GATAF $NORMCTRL $NORMGATA $NORMCMBN
