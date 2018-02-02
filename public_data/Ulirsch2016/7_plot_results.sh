#!/bin/bash

set -o errexit
set -o nounset

SCRIPT1=../../scripts/plot_svr_vs_rexpr.R
SCRIPT2=../../scripts/plot_tag_expr_cmp.R

Rscript ${SCRIPT1} processed/mtsa_uli16.m100.t5.e5.adj.0.cv.txt
Rscript ${SCRIPT1} processed/mtsa_uli16_gata.m100.t5.e5.adj.0.cv.txt

Rscript ${SCRIPT2} tag_expr_cmp
