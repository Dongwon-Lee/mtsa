library(GGally)
library(ggplot2)

#setup for figure
wd <- 5
ht <- 5
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
d2k<-read.table("Kheradpour2013/processed/mtsa_khe13_k562.m500.t5.e5.8mers.txt", stringsAsFactors=F)
d3<-read.table("Ulirsch2016/processed/mtsa_uli16.m100.t5.e5.8mers.txt", stringsAsFactors=F)
d4<-read.table("Ulirsch2016/processed/mtsa_uli16_gata.m100.t5.e5.8mers.txt", stringsAsFactors=F)
d5<-read.table("Inoue2017/processed/mtsa_ino17.m50.t10.e5.8mers.txt", stringsAsFactors=F)
d6<-read.table("Inoue2017/processed/mtsa_ino17_wt.m50.t10.e5.8mers.txt",stringsAsFactors=F)
d7<-read.table("Mogno2013/processed/mtsa_mog13.t4.e0.8mers.txt",stringsAsFactors=F)
d8<-read.table("Ernst2016/processed/mtsa_ern16.m2000.t5.e5.8mers.txt", stringsAsFactors=F)
d9<-read.table("Ernst2016/processed/mtsa_ern16_k562.m2000.t5.e5.8mers.txt", stringsAsFactors=F)
d10<-read.table("Tewhey2016/processed/mtsa_tew16.m60.t10.8mers.txt", stringsAsFactors=F)
d11<-read.table("Tewhey2016/processed/mtsa_tew16_NA19239.m60.t10.8mers.txt", stringsAsFactors=F)
d12<-read.table("Kwasnieski2014/processed/mtsa_kwa14.t4.e5.8mers.txt", stringsAsFactors=F)

colnames(d1)<-c("kmer", "Mel12")
colnames(d2)<-c("kmer", "Khe13")
colnames(d2k)<-c("kmer", "Khe13K")
colnames(d3)<-c("kmer", "Uli16")
colnames(d4)<-c("kmer", "Uli16G")
colnames(d5)<-c("kmer", "Ino17")
colnames(d6)<-c("kmer", "Ino17WT")
colnames(d7)<-c("kmer", "Mog13")
colnames(d8)<-c("kmer", "Ern16")
colnames(d9)<-c("kmer", "Ern16K")
colnames(d10)<-c("kmer", "Tew16")
colnames(d11)<-c("kmer", "Tew16N")
colnames(d12)<-c("kmer", "Kwa14")

d<-merge(d1, d2)
d<-merge(d, d2k)
d<-merge(d, d3)
d<-merge(d, d4)
d<-merge(d, d5)
d<-merge(d, d6)
d<-merge(d, d7)
d<-merge(d, d8)
d<-merge(d, d9)
d<-merge(d, d10)
d<-merge(d, d11)
d<-merge(d, d12)

# reorder
dat<-d[,c("Mel12",
          "Khe13", "Khe13K",  
          "Ern16", "Ern16K",
          "Uli16", "Uli16G",
          "Tew16", "Tew16N",
          "Ino17", "Ino17WT",
          "Mog13", "Kwa14")]

colnames(dat)<-c("Mel12_HEK293",
                 "Khe13_HepG2", "Khe13_K562",
                 "Ern16_HepG2", "Ern16_K562",
                 "Uli16_K562", "Uli16_K562_G",
                 "Tew16_LCL1", "Tew16_LCL2",
                 "Ino17_HepG2_M", "Ino17_HepG2_W",
                 "Mog13_Y", "Kwa14_K562")

outfn<-"pairwise_scatterplot_kmerweights.pdf"
pdf(outfn, width=wd*fig.ncols, height=ht*fig.nrows)

p<-ggcorr(dat, label=TRUE, label_round=2, angle=-30, size=2, hjust=1, label_size=2, legend.size=6)
p<-p + theme(plot.margin = margin(2, 2, 2, 2, "pt"))
p<-p + guides(fill = guide_colorbar(barwidth = 0.4))
print(p)
dev.off()
