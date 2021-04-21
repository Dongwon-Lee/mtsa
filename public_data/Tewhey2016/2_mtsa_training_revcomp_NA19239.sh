#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_tew16_NA19239.m60.t10.rc

cd ${INDIR}
if [ -e mtsa_tew16_NA19239.m60.t10.rc.tag_rexpr.txt ]; then
    echo "skip making symlink files";
else
ln -s mtsa_tew16_NA19239.m60.t10.tag_rexpr.txt mtsa_tew16_NA19239.m60.t10.rc.tag_rexpr.txt
ln -s mtsa_tew16_NA19239.m60.t10.excluded_tags.txt mtsa_tew16_NA19239.m60.t10.rc.excluded_tags.txt
fi
cd -

${MTSA} train -M 8192 -R -T 4 -n ${EXPNAME}
