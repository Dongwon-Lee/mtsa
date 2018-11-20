#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_uli16.m100.t5.e5.rc

cd ${INDIR}
if [ -e mtsa_uli16.m100.t5.e5.rc.tag_rexpr.txt ]; then
    echo "skip making symlink files";
else
ln -s mtsa_uli16.m100.t5.e5.tag_rexpr.txt mtsa_uli16.m100.t5.e5.rc.tag_rexpr.txt
ln -s mtsa_uli16.m100.t5.e5.excluded_tags.txt mtsa_uli16.m100.t5.e5.rc.excluded_tags.txt
fi

cd -

${MTSA} train -M 4096 -R -T 4 -n ${EXPNAME}
