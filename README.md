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

### Get Started

The main program, mtsa.py, is written in Python 2.  It offers four main functions (build, train, predict, and normalize) as follows:

    $ python mtsa.py --help
    usage: mtsa.py [-h] {build,train,predict,normalize} ...

    perform MPRA tag sequence analysis using support vector regression (SVR) with
    gapped-kmer kernels (Ghandi et al. 2014; Lee 2016). LIBSVM (Chang & Lin 2011)
    was used for implementing SVR. -- by Dongwon Lee (dwlee@jhu.edu)

    optional arguments:
      -h, --help            show this help message and exit

    commands:
      {build,train,predict,normalize}
        build               build training data for SVR
        train               train SVR and calculate sequence factors for
                            normalization
        predict             score sequences using the trained SVR model
        normalize           normalize mRNA counts

The basic workflow is :

  1. format the tag (barcode) count input data. Although there is no standard script for this step, you can find the Python scripts in the scripts directory used for the analysis of the four public data sets presented in the paper.
  2. run 'mtsa.py build' to construct the appropriate training set from the input dat, by filtering low quality tags and adding flanking sequences.
  3. run 'mtsa.py train' to learn the SVR model. This is the main step, and it can takes a while depending on the number of tags for training. 
  4. (optional) run 'mtsa.py predict' to score tags/barcodes that wer NOT used in the training. This can also be used to calculate the SVR weights.
  5. run 'mtsa.py normalize' to correct the sequence-specific effect of the mRNA read counts.

Please refer to help messages for more detailed information for each command.

### Tutorial

We introduce the users to a basic tutorial of running `MTSA`: https://github.com/chlee-tabin/mtsa-tutorial


**Please email Dongwon Lee (dongwon.lee AT childrens DOT harvard DOT edu) if you have any questions.**

