#!/bin/bash

set -o errexit
set -o nounset

echo "## 1. MTSA normalization based on tag sequence.."
sh mtsa_normalize_ulirsch16.sh

echo "## 2. quantile normalization (original data).."
Rscript normalize_data_ulirsch16.R ../raw_data/GSE87711_RBC_MPRA_minP_raw.txt.gz MPRA_minP.norm.txt

echo "## 3. quantile normalization (MTSA normalized data).."
Rscript normalize_data_ulirsch16.R MPRA_minP_mtsanorm.txt MPRA_minP_mtsanorm.norm.txt

echo "## 4. perform 2-sided Mann-Whitney-U test and calculate p-values (this will take some time..)"
echo "## 4.1 original data, control"
Rscript cal_pval_mfv.R MPRA_minP.norm.txt CTRL 
echo "## 4.2 original data, GATA1"
Rscript cal_pval_mfv.R MPRA_minP.norm.txt GATA
echo "## 4.3 MTSA normalized data, control"
Rscript cal_pval_mfv.R MPRA_minP_mtsanorm.norm.txt CTRL 
echo "## 4.4 MTSA normalized data, GATA"
Rscript cal_pval_mfv.R MPRA_minP_mtsanorm.norm.txt GATA

echo "## 5. calculate FDR using R qvalue package"
Rscript cal_fdr_mfv.R MPRA_minP.norm 0.01
Rscript cal_fdr_mfv.R MPRA_minP_mtsanorm.norm 0.01

echo "## 6. extract mean fold-change and delta-SVM scores for the significant SNPs"
Rscript mfc_vs_dsvm.R MPRA_minP.norm 0.01
Rscript mfc_vs_dsvm.R MPRA_minP_mtsanorm.norm 0.01
