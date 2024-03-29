## MTSA: MPRA Tag Sequence Analysis

Version 1.0.0 Last edited: Sep 8, 2021, (c) Dongwon Lee

MTSA is a sequence-based analysis for estimating tag sequence effects on 
gene expression in massively parallele reporter assay (MPRA) experiment.
It trains a support vector regression (SVR) using gapped-kmer kernels (gkm-kernels)
(Ghandi et al., 2014; Lee, 2016), and learns sequence features that modulate
gene expressions. We use LIBSVM (Chang & Lin 2011) for implementing SVR.

* Ghandi M†, Lee D†, Mohammad-Noori M, & Beer MA. Enhanced Regulatory Sequence Prediction Using Gapped k-mer Features. PLoS Comput Biol 10, e1003711 (2014). doi:10.1371/journal.pcbi.1003711 *† Co-first authors*

* Lee D. LS-GKM: A new gkm-SVM for large-scale Datasets. Bioinformatics btw142 (2016). doi:10.1093/bioinformatics/btw142

* Chang C.-C and Lin C.-J. LIBSVM : a library for support vector machines. ACM Transactions on Intelligent Systems and Technology, 2:27:1--27:27, 2011.

Note: SVR with gkm-kernels is a generalizable method. We implemented a general purpose gkm-SVR in LS-GKM (https://github.com/Dongwon-Lee/lsgkm). 

### Citation

*Please cite the following paper if you use MTSA in your research:*

* [Lee D†, Kapoor A, Lee C, Mudgett M, Beer MA, Chakravarti A. Sequence-based correction of barcode bias in massively parallel reporter assays. Genome Res. 2021 Sep;31(9):1638–1645. PMID: 34285053 *† Corresponding author*](https://genome.cshlp.org/content/31/9/1638.abstract)

### Installation

After downloading the source codes, type:

    $ cd src
    $ make 

If successful, You should be able to find the following library file in the current (src) directory:

    libmtsa.so

`make install` will simply copy this library to the `../bin` directory

### Get Started

The main program, mtsa.py, is originally written in Python 2. (UPDATE 7/27/2020: It now supports Python 3 as well!) 
It offers four main functions (build/build2, train, predict, and normalize/normalize2) as follows:

    $ bin/mtsa.py  -h
    usage: mtsa.py [-h] {build,build2,train,predict,normalize,normalize2} ...

    perform MPRA tag sequence analysis using support vector regression (SVR) with
    gapped-kmer kernels (Ghandi et al. 2014; Lee 2016). LIBSVM (Chang & Lin 2011)
    was used for implementing SVR. -- by Dongwon Lee
    (dongwon.lee@childrens.harvard.edu)

    optional arguments:
      -h, --help            show this help message and exit

    commands:
      {build,build2,train,predict,normalize,normalize2}
        build               build training data for SVR
        build2              build training data for SVR using an input file in a
                            tsv format ([element] [tag] [DNA] [RNA])
        train               train SVR and calculate sequence factors for
                            normalization
        predict             score sequences using the trained SVR model
        normalize           normalize mRNA counts
        normalize2          normalize mRNA counts using an input file in a tsv
                            format ([element] [tag] [DNA] [RNA])

The basic workflow is :

  1. format the tag (barcode) count input data. Although there is no standard script for this step, you can find the Python scripts in the scripts directory used for the analysis of public data sets presented in the paper.
  2. run 'mtsa.py build/build2' to construct the appropriate training set from the input data, by filtering low quality tags and adding flanking sequences.
  3. run 'mtsa.py train' to learn the SVR model. This is the main step, and it can take a while depending on the number of tags for training.
  4. (optional) run 'mtsa.py predict' to score tags that were NOT used in the training. This can also be used to calculate the SVR weights.
  5. run 'mtsa.py normalize/normalize2' to correct the sequence-specific effect of the mRNA read counts.

Please refer to help messages for more detailed information for each command.

### Tutorial

We introduce the users to a basic tutorial of running `MTSA`: https://github.com/chlee-tabin/mtsa-tutorial


**Please email Dongwon Lee (dongwon.lee AT childrens DOT harvard DOT edu) if you have any questions.**

