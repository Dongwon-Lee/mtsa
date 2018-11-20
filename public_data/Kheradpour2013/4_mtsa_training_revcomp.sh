#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_khe13.m500.t5.e5.rc

cd ${INDIR}
if [ -e mtsa_khe13.m500.t5.e5.rc.tag_rexpr.txt ]; then
    echo "skip making symlink files";
else
ln -s mtsa_khe13.m500.t5.e5.tag_rexpr.txt mtsa_khe13.m500.t5.e5.rc.tag_rexpr.txt
ln -s mtsa_khe13.m500.t5.e5.excluded_tags.txt mtsa_khe13.m500.t5.e5.rc.excluded_tags.txt
fi
cd -

${MTSA} train -M 2048 -T 4 -R -n ${EXPNAME}
