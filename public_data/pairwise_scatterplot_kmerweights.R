library(GGally)
library(ggplot2)

#setup for figure
wd <- 3
ht <- 3
fig.nrows <- 1
fig.ncols <- 1
pt <- 8
cex.general <- 1
cex.lab <- 1
cex.axis <- 1
cex.main <- 1
cex.legend <- 1

d1<-read.table("Melnikov2012/processed/mtsa_mel12.m1000.t5.e5.8mers.txt", stringsAsFactors=F)
d2<-read.table("Kheradpour2013/processed/mtsa_khe13.m500.t5.e5.8mers.txt", stringsAsFactors=F)
d3<-read.table("Ulirsch2016/processed/mtsa_uli16.m100.t5.e5.8mers.txt", stringsAsFactors=F)
d4<-read.table("Ulirsch2016/processed/mtsa_uli16_gata.m100.t5.e5.8mers.txt", stringsAsFactors=F)
d5<-read.table("Inoue2017/processed/mtsa_ino17.m50.t10.e5.8mers.txt", stringsAsFactors=F)

colnames(d1)<-c("kmer", "Mel12")
colnames(d2)<-c("kmer", "Khe13")
colnames(d3)<-c("kmer", "Uli16")
colnames(d4)<-c("kmer", "Uli16G")
colnames(d5)<-c("kmer", "Ino17")

dat<-data.frame(cbind(d3$Uli16, d4$Uli16G, d1$Mel12, d2$Khe13, d5$Ino17))
colnames(dat)<-c("L1_K562_U", "L1_K562_GATA1_U", "L1_HEK293_M", "L1_HepG2_K", "L2_HepG2_I")

outfn<-"pairwise_scatterplot_kmerweights.pdf"
pdf(outfn, width=wd*fig.ncols, height=ht*fig.nrows)

p<-ggcorr(dat, label=TRUE, label_round=2, angle=-45, size=2, hjust=0.65, label_size=2, legend.size=6)
p<-p + theme(plot.margin = margin(1, 1, 1, 1, "pt"))
p<-p + guides(fill = guide_colorbar(barwidth = 0.4))
print(p)
dev.off()

