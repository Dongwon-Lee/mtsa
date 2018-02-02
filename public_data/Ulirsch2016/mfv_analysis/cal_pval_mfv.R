# R script that calculates p-values for differential activity between alleles
#
# This script is based on "RBC_MPRA_CELLv1.Rmd" and optimized by Dongwon Lee

args<-commandArgs(trailingOnly=T)

inputfile<-args[1] # MPRA_minP.norm
exptype<-args[2] # CTRL or GATA
output_prefix<-gsub(".txt$", "", inputfile) 

MPRA_minP.melt<-read.table(inputfile, sep="\t", header=T)

MPRA_minP.final <- MPRA_minP.melt[grep(exptype, MPRA_minP.melt$variable), ]

construct_levels<- levels(factor(MPRA_minP.final$construct))
construct_inds<- lapply(construct_levels, function(j) which(MPRA_minP.final$construct == j))
construct_oligos<- sapply(construct_inds, function(j) MPRA_minP.final$oligo[j[1]])

# Determine alleles with differences in activity 
# using 2-sided Mann-Whitney-U test between alleles
construct_pvals<-
    sapply(construct_inds,
           function(ind) {
               if (nlevels(factor(MPRA_minP.final$type[ind])) == 2) { 
                   pval<-wilcox.test(value ~ factor(type),
                                     data = MPRA_minP.final[ind, ])$p.value
               } else {
                   NA
               }
           })

MPRA_minP.final.pvalues <- 
    data.frame(construct=construct_levels, 
               oligo=construct_oligos,
               Control_P=construct_pvals)

outfn<-paste(output_prefix, exptype, "diff.pvalues.txt", sep=".")
write.table(MPRA_minP.final.pvalues, outfn, sep="\t", col.names=T, row.names=F, quote=F)
