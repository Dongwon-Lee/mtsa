#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_mog13.t4.e0.rc

cd ${INDIR}
if [ -e mtsa_mog13.t4.e0.rc.tag_rexpr.txt ]; then
    echo "skip making symlink files";
else
ln -s mtsa_mog13.t4.e0.tag_rexpr.txt mtsa_mog13.t4.e0.rc.tag_rexpr.txt
ln -s mtsa_mog13.t4.e0.excluded_tags.txt mtsa_mog13.t4.e0.rc.excluded_tags.txt
fi
cd -

${MTSA} train -M 8192 -R -T 4 -n ${EXPNAME}
