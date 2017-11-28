#!/bin/bash

set -o errexit
set -o nounset

../scripts/gen_kmers.py 8 8mers.txt

../bin/mtsa.py predict -n Melnikov2012_processed/mtsa_mel12.m1000.t5.e5 8mers.txt Melnikov2012_processed/mtsa_mel12.m1000.t5.e5.8mers.txt
../bin/mtsa.py predict -n Kheradpour2013_processed/mtsa_khe13.m500.t5.e5 8mers.txt Kheradpour2013_processed/mtsa_khe13.m500.t5.e5.8mers.txt
../bin/mtsa.py predict -n Ulirsch2016_processed/mtsa_uli16.m100.t5.e5 8mers.txt Ulirsch2016_processed/mtsa_uli16.m100.t5.e5.8mers.txt
../bin/mtsa.py predict -n Inoue2017_processed/mtsa_ino17.m100.t10.e5 8mers.txt Inoue2017_processed/mtsa_ino17.m100.t10.e5.8mers.txt
