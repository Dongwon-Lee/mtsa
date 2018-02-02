args<-commandArgs(trailingOnly=T)

input_prefix<-args[1] # "MPRA_minP.norm"
threshold<-as.numeric(args[2]) # q-value threshold: 0.01

controls <- c("1 155271258",
              "X 55054634",
              "X 55054635",
              "X 55054636",
              "10 127505272")

library(qvalue)

fn1<-paste(input_prefix, "CTRL.diff.pvalues.txt", sep=".")
fn2<-paste(input_prefix, "GATA.diff.pvalues.txt", sep=".")
MPRA_minP.CTRL.diff.pvalues <- read.table(fn1, sep="\t", header=T)
MPRA_minP.GATA.diff.pvalues <- read.table(fn2, sep="\t", header=T)

colnames(MPRA_minP.CTRL.diff.pvalues)[3]<-"CTRL.diff.pval"
colnames(MPRA_minP.GATA.diff.pvalues)[3]<-"GATA.diff.pval"
MPRA_minP<-merge(MPRA_minP.CTRL.diff.pvalues, MPRA_minP.GATA.diff.pvalues)
MPRA_minP$CTRL.diff.qval<-qvalue(MPRA_minP$CTRL.diff.pval)[3]$qvalues
MPRA_minP$GATA.diff.qval<-qvalue(MPRA_minP$GATA.diff.pval)[3]$qvalues
MPRA_minP$controls<-ifelse(MPRA_minP$oligo %in% controls, 1, 0)

outfn1<-paste(input_prefix, "diff.pvalues.combined.txt", sep=".")
write.table(MPRA_minP, outfn1, sep="\t", col.names=T, row.names=F, quote=F)

#identify MPRA Functional Variants
MPRA_minP.sig.ind <- (MPRA_minP$controls == 0) & 
    ((MPRA_minP$CTRL.diff.qval < threshold) |
     (MPRA_minP$GATA.diff.qval < threshold))

MPRA_minP.sig <- MPRA_minP[MPRA_minP.sig.ind,]

#remove NA rows
inds.to_remove<-is.na(MPRA_minP.sig$CTRL.diff.pval)
MPRA_minP.sig <- MPRA_minP.sig[!(inds.to_remove), ]

outfn2<-paste(input_prefix, "diff.pvalues.combined.sig", threshold, "txt", sep=".")
write.table(MPRA_minP.sig, outfn2, sep="\t", col.names=T, row.names=F, quote=F)
