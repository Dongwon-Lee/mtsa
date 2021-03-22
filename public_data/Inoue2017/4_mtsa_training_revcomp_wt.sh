#!/bin/bash

set -o errexit
set -o nounset

MTSA=../../bin/mtsa.py
INDIR=processed
EXPNAME=${INDIR}/mtsa_ino17_wt.m50.t10.e5.rc

cd ${INDIR}
if [ -e mtsa_ino17_wt.m50.t10.e5.rc.tag_rexpr.txt ]; then
    echo "skip making symlink files";
else
ln -s mtsa_ino17_wt.m50.t10.e5.tag_rexpr.txt mtsa_ino17_wt.m50.t10.e5.rc.tag_rexpr.txt
ln -s mtsa_ino17_wt.m50.t10.e5.excluded_tags.txt mtsa_ino17_wt.m50.t10.e5.rc.excluded_tags.txt
fi
cd -

${MTSA} train -M 8192 -R -T 4 -n ${EXPNAME}
