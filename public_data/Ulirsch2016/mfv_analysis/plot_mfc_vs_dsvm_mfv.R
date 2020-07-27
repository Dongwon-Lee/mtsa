# R script that compares between mean fold-changes and deltaSVM scores for the MFVs
library('RColorBrewer')
orig<-read.table("MPRA_minP.norm.diff.pvalues.combined.sig.0.01.mfc_vs_dsvm.txt", header=T, sep="\t")
mtsa<-read.table("MPRA_minP_mtsanorm.norm.diff.pvalues.combined.sig.0.01.mfc_vs_dsvm.txt", header=T, sep="\t")

orig$common<-orig$oligo %in% mtsa$oligo
mtsa$common<-mtsa$oligo %in% orig$oligo

#setup for figure
wd <- 2.7
ht <- 2.4
fig.nrows <- 1
fig.ncols <- 2
pt <- 8
cex.general <- 1
cex.lab <- 1
cex.axis <- 1
cex.main <- 1
cex.legend <- 1

xrange<-c(min(orig$dsvm, mtsa$dsvm), max(orig$dsvm, mtsa$dsvm))
yrange<-c(min(orig$mean.fc, mtsa$mean.fc), max(orig$mean.fc, mtsa$mean.fc))

pval_format<-function(p) {
	pstr<-format(p, nsmall=2, digits=2, scientific=T)
	pstr_split<-sapply(unlist(strsplit(pstr, 'e')), as.numeric)
	p1<-format(pstr_split[1], nsmall=1, digits=2)
	p2<-pstr_split[2]
	as.expression(bquote(italic(P) == .(p1) %*% 10^.(p2)))
}

plot_mfc_vs_dsvm<-function(x, title, col1, col2) {
    plot(x$dsvm, x$mean.fc, pch=20, cex=0.75, col=ifelse(x$common, col1, col2),
         xlim=xrange, ylim=yrange,
         main=title, xlab="deltaSVM score", ylab="log2(mean fold-change)")
    pc<-cor(x$mean.fc, x$dsvm)
    pval<-cor.test(x$mean.fc, x$dsvm)$p.value
    abline(v=0, h=0, lty=2, col="gray")
    legend("topleft",
           legend=c(paste("Agree =", sum(x$dsvm*x$mean.fc>0)),
                    paste("Disagree =", sum(x$dsvm*x$mean.fc<0)),
                    paste("r =", format(pc, nsmall=2, digits=2)),
                    pval_format(pval)),
            bty="n", inset=c(-0.08,-0.05), cex=cex.legend, y.intersp=0.8)
}

colset1<-brewer.pal(9, 'Set1')
cols<-c(colset1[3], colset1[2], colset1[1]) # before, after, both

outfn<-"plot_mfc_vs_dsvm_mfv_scatterplot.pdf"
pdf(outfn, width=wd*fig.ncols, height=ht*fig.nrows)
par(mar=c(2.2,2.2,1.2,0.2)+0.1, mgp=c(1.3,0.3,0), tck=-0.02, mfrow = c(fig.nrows, fig.ncols))
par(cex=cex.general, ps=pt, cex.axis=cex.axis, cex.lab=cex.lab, cex.main=cex.main, font.main=1, bty="n")

plot_mfc_vs_dsvm(orig, "Before MTSA Correction", cols[3], cols[1])
plot_mfc_vs_dsvm(mtsa, "After MTSA Correction", cols[3], cols[2])

absdsvm.common<-abs(orig$dsvm[orig$common])
absdsvm.orig<-abs(orig$dsvm[!orig$common])
absdsvm.mtsa<-abs(mtsa$dsvm[!mtsa$common])

absdsvm<-list(orig_only=absdsvm.orig,
              mtsa_only=absdsvm.mtsa,
              common=absdsvm.common)
dev.off()

d <- data.frame(absdsvm = unlist(absdsvm),
                group = rep(c("0.Before", "1.After", "2.Both"), ,times = sapply(absdsvm,length)))

library(ggplot2)
library(ggsignif)
p3<-ggplot(d,aes(x = group, y = absdsvm)) +
    labs(title="", x="Significant SNP groups", y="abs(deltaSVM)") +
    theme_classic() + 
    theme(panel.border = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), 
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(colour="black",size=8,angle=45,hjust=.5,vjust=.5,face="plain"),
          axis.text.y = element_text(colour="black",size=8,angle=90,hjust=.5,vjust=0,face="plain"),
          axis.title.x = element_text(colour="black",size=8,angle=0,hjust=.5,vjust=0,face="plain"),
          axis.title.y = element_text(colour="black",size=8,angle=90,hjust=.5,vjust=.5,face="plain")) +
    geom_boxplot(outlier.shape=NA) +
    scale_x_discrete(labels=c("Uncorrected\nOnly","Corrected\nOnly","Both")) +
    geom_jitter(width=0.2, col=cols[as.numeric(as.factor(d$group))], cex=0.75) +
    geom_signif(comparisons = list(c("2.Both", "0.Before"),
                                   c("1.After", "0.Before"),
                                   c("2.Both", "1.After")),
                test = "wilcox.test", test.args=list(alternative="g"),
                map_signif_level=c("**"=0.005, "*"=0.05), y_position=c(26, 23, 20), textsize=3) +
    ylim(0, 28)

outfn<-"plot_mfc_vs_dsvm_mfv_barplot.pdf"
wd <- 1.8
ht <- 2.4
fig.nrows <- 1
fig.ncols <- 1
pdf(outfn, width=wd*fig.ncols, height=ht*fig.nrows)
par(mar=c(2.2,2.2,1.2,1.2)+0.1, mgp=c(1.3,0.3,0), tck=-0.02, mfrow = c(fig.nrows, fig.ncols))
par(cex=cex.general, ps=pt, cex.axis=cex.axis, cex.lab=cex.lab, cex.main=cex.main, font.main=1, bty="n")

print(p3)

dev.off()
