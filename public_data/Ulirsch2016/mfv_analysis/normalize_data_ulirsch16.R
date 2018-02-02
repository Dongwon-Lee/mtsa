# R script that QC & normalize the raw data (Ulirsch et al. 2016)
# This script is mostly based on "RBC_MPRA_CELLv1.Rmd",
# and further modified by Dongwon Lee.

args<-commandArgs(trailingOnly=T)

inputfile<-args[1] #../raw_data/GSE87711_RBC_MPRA_minP_raw.txt.gz
outputfile<-args[2] #"MPRA_minP.norm.txt"

library(readr)
library(reshape2)

# the following library is available from bioconductor
library(preprocessCore)

MPRA <- data.frame(read_delim(file = inputfile,
                              delim = "\t",
                              col_names = T,
                              col_types = cols(chr = "c")))

MPRA <- subset(MPRA, clean == "var")
MPRA <- as.data.frame(append(MPRA,
                             list(K562_minP_DNA = MPRA$K562_minP_DNA1 + MPRA$K562_minP_DNA2),
                             after = 13))

mpra_sum<-c()

# Normalize counts to counts per million (CPM):
# NOTE: bug corrected version
for (i in 12:length(MPRA)) {
    s<-sum(MPRA[, i])
    mpra_sum<-c(mpra_sum, s)
    MPRA[, i] <- (MPRA[, i] + 1) * 1000000 / s
}

# Remove multi-allelic variants:
MPRA <- MPRA[!(MPRA$pos %in% c(2519416, 43842618, 46046134)), ]

# Exclude Duffy variant as well
MPRA <- MPRA[!(MPRA$pos %in% c(159174683)),]

# log2(x+1) normalize
MPRA[(length(MPRA) + 1):(length(MPRA) + length(MPRA[, 12:length(MPRA)]))] <-
    log(MPRA[, 12:(length(MPRA))], 2)

# Keep only barcodes with minimum raw counts...(modified by Dongwon Lee)
# The minimum raw counts matched to the original threshold is 8
dna_cutoff<-8
converted_cutoff<-((dna_cutoff + 1)*1000000/mpra_sum[3])
MPRA_minP <- MPRA[MPRA$K562_minP_DNA >= converted_cutoff,]
print(c("Percent of barcodes remaining: ", (dim(MPRA_minP) / dim(MPRA))[1]))

#Define activity [log2(mRNA/DNA) = log2(mRNA) - log2(DNA)]:
attach(MPRA_minP)
MPRA_minP$K562_CTRL_RATIO_R1 <- K562_CTRL_minP_RNA1.1 - K562_minP_DNA.1
MPRA_minP$K562_CTRL_RATIO_R2 <- K562_CTRL_minP_RNA2.1 - K562_minP_DNA.1
MPRA_minP$K562_CTRL_RATIO_R3 <- K562_CTRL_minP_RNA3.1 - K562_minP_DNA.1
MPRA_minP$K562_CTRL_RATIO_R4 <- K562_CTRL_minP_RNA4.1 - K562_minP_DNA.1
MPRA_minP$K562_CTRL_RATIO_R5 <- K562_CTRL_minP_RNA5.1 - K562_minP_DNA.1
MPRA_minP$K562_CTRL_RATIO_R6 <- K562_CTRL_minP_RNA6.1 - K562_minP_DNA.1
MPRA_minP$K562_GATA1_RATIO_R1 <- K562_GATA1_minP_RNA1.1 - K562_minP_DNA.1
MPRA_minP$K562_GATA1_RATIO_R2 <- K562_GATA1_minP_RNA2.1 - K562_minP_DNA.1
MPRA_minP$K562_GATA1_RATIO_R3 <- K562_GATA1_minP_RNA3.1 - K562_minP_DNA.1
MPRA_minP$K562_GATA1_RATIO_R4 <- K562_GATA1_minP_RNA4.1 - K562_minP_DNA.1
detach(MPRA_minP)

#Quantile normalize activities, set median to 0, check, and combine replicates in separate DF:
MPRA_minP.melt <- 
    melt(MPRA_minP[c("chr",
                     "pos",
                     "ref",
                     "alt",
                     "type",
                     "bot",
                     "top",
                     "clean",
                     "oligo",
                     "construct",
                     "byallele",
                     "K562_CTRL_RATIO_R1",
                     "K562_CTRL_RATIO_R2",
                     "K562_CTRL_RATIO_R3",
                     "K562_CTRL_RATIO_R4",
                     "K562_CTRL_RATIO_R5",
                     "K562_CTRL_RATIO_R6",
                     "K562_GATA1_RATIO_R1",
                     "K562_GATA1_RATIO_R2",
                     "K562_GATA1_RATIO_R3",
                     "K562_GATA1_RATIO_R4")],
         id = c("chr",
                "pos",
                "ref",
                "alt",
                "type",
                "bot",
                "top",
                "clean",
                "oligo",
                "construct",
                "byallele"))

temp <- normalize.quantiles(as.matrix(MPRA_minP[, 38:47]))
temp <- temp - median(temp)
MPRA_minP.melt$value <- melt(temp[, 1:10])$value

write.table(MPRA_minP.melt, outputfile, sep="\t", col.names=T, row.names=F, quote=F)
