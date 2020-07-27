## MTSA: MPRA Tag Sequence Analysis

MTSA is a sequence-based analysis for estimating tag sequence effects on 
gene expression in massively parallele reporter assay (MPRA) experiment.
It trains a support vector regression (SVR) using gapped-kmer kernels
(Ghandi et al., 2014; Lee, 2016), and learns sequence features that modulate
gene expressions. We use LIBSVM (Chang & Lin 2011) for implementing SVR.

* Ghandi M†, Lee D†, Mohammad-Noori M, & Beer MA. Enhanced Regulatory Sequence Prediction Using Gapped k-mer Features. PLoS Comput Biol 10, e1003711 (2014). doi:10.1371/journal.pcbi.1003711 *† Co-first authors*

* Lee D. LS-GKM: A new gkm-SVM for large-scale Datasets. Bioinformatics btw142 (2016). doi:10.1093/bioinformatics/btw142

* Chang C.-C and Lin C.-J. LIBSVM : a library for support vector machines. ACM Transactions on Intelligent Systems and Technology, 2:27:1--27:27, 2011.

### Citation

*Please cite the following paper if you use MTSA in your research:*

* Lee D†, Kapoor A, Lee C, Mudgett M, Beer MA, Chakravarti A†. Improved identification of functional regulatory variants from massively parallel
reporter assays by sequence correction of DNA tag bias - *submitted* *† Co-corresponding authors*

### Installation

After downloading the source codes, type:

    $ cd src
    $ make 

If successful, You should be able to find the following library file in the current (src) directory:

    libmtsa.so

`make install` will simply copy this library to the `../bin` direcory

### Tutorial

https://github.com/chlee-tabin/mtsa-tutorial

We introduce the users to the basic workflow of `MTSA`.  Please refer to help messages 
for more detailed information of mtsa.py.  You can access to it by running the program 
without any argument/parameter.
  
**Please email Dongwon Lee (dongwon.lee AT childrens DOT harvard DOT edu) if you have any questions.**

