#R script for extracting mean fold-changes and deltaSVM scores

args<-commandArgs(trailingOnly=T)

input_prefix<-args[1] # "MPRA_minP.norm"
threshold<-as.numeric(args[2]) # q-value threshold: 0.01

inputfile1<-paste(input_prefix, "txt", sep=".")
inputfile2<-paste(input_prefix, "diff.pvalues.combined.sig", threshold, "txt", sep=".")

MPRA_minP.melt<-read.table(inputfile1, sep="\t", header=T, stringsAsFactors=F)

# Derive activity estimates by collapsing barcodes and taking the median:
CTRL.temp <- MPRA_minP.melt[grep("CTRL", MPRA_minP.melt$variable),]
CTRL.value <- tapply(CTRL.temp$value, factor(CTRL.temp$byallele), median)
GATA1.temp <- MPRA_minP.melt[grep("GATA1", MPRA_minP.melt$variable),]
GATA1.value <- tapply(GATA1.temp$value, factor(GATA1.temp$byallele), median)
RATIO.temp <- MPRA_minP.melt[!duplicated(MPRA_minP.melt$byallele),!(names(MPRA_minP.melt) %in% c("value", "variable"))]

RATIO.temp <- merge(RATIO.temp,
                    data.frame(byallele = names(CTRL.value), CTRL.median = CTRL.value),
                    by = "byallele")

RATIO.temp <- merge(RATIO.temp,
                    data.frame(byallele = names(GATA1.value), GATA1.median = GATA1.value),
                    by = "byallele")

REF<-RATIO.temp[RATIO.temp$type == "Ref", c("construct", "oligo", "CTRL.median", "GATA1.median")]
MUT<-RATIO.temp[RATIO.temp$type == "Mut", c("construct", "oligo", "CTRL.median", "GATA1.median")]

temp<-merge(MUT, REF, by = c("construct", "oligo"))
temp$CTRL.fc<-temp$CTRL.median.x - temp$CTRL.median.y
temp$GATA1.fc<-temp$GATA1.median.x - temp$GATA1.median.y
ratio<-temp[, c("construct", "oligo", "CTRL.fc", "GATA1.fc")]
ratio.mean_fc.ctrl<-aggregate(CTRL.fc ~ oligo, ratio, mean)
ratio.mean_fc.gata<-aggregate(GATA1.fc ~ oligo, ratio, mean)
ratio.oligo<-merge(ratio.mean_fc.ctrl, ratio.mean_fc.gata)
ratio.oligo$mean.fc<-(ratio.oligo$CTRL.fc + ratio.oligo$GATA1.fc)/2
ratio.oligo$CTRL.fc<-NULL
ratio.oligo$GATA1.fc<-NULL
ratio.oligo$chr<-unlist(lapply(strsplit(ratio.oligo$oligo, " "), function(x) x[1]))
ratio.oligo$pos<-unlist(lapply(strsplit(ratio.oligo$oligo, " "), function(x) x[2]))

dsvm<-read.table("deltasvm_MPRA_K562.txt", stringsAsFactors=F)
colnames(dsvm)<-c("snpid", "dsvm")
dsvm$chr<-unlist(lapply(strsplit(dsvm$snpid, ":"), function(x) x[1]))
dsvm$pos<-unlist(lapply(strsplit(dsvm$snpid, ":"), function(x) x[2]))
dsvm<-merge(ratio.oligo, dsvm)

data<-read.table(inputfile2, header=T, sep="\t", stringsAsFactors=F)
data$chr<-unlist(lapply(strsplit(data$oligo, " "), function(x) x[1]))
data$pos<-unlist(lapply(strsplit(data$oligo, " "), function(x) x[2]))
res<-subset(dsvm, oligo %in% data$oligo)
res<-res[, c("oligo", "mean.fc", "dsvm")]

output<-gsub("txt", "mfc_vs_dsvm.txt", inputfile2)
write.table(res, output, sep="\t", col.names=T, row.names=F, quote=F)
