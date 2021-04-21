mkdir -p processed

# 1. generate input
Rscript ../../scripts/preproc_Kwasnieski2014_supdata2.R

# 2. run MTSA training
python ../../bin/mtsa.py train -T 1 -n processed/mtsa_kwa14.t4.e5

# 3. making plots
Rscript ~/mtsa/scripts/plot_svr_vs_rexpr.R processed/mtsa_kwa14.t4.e5.adj.0.cv.txt

# 4. calculate 8mer weights
python ../../bin/mtsa.py predict -n processed/mtsa_kwa14.t4.e5 ../8mers.txt \
    processed/mtsa_kwa14.t4.e5.8mers.txt
