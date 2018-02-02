# R script that compares between mean fold-changes and deltaSVM scores for the MFVs

orig<-read.table("MPRA_minP.norm.diff.pvalues.combined.sig.0.01.mfc_vs_dsvm.txt", header=T, sep="\t")
mtsa<-read.table("MPRA_minP_mtsanorm.norm.diff.pvalues.combined.sig.0.01.mfc_vs_dsvm.txt", header=T, sep="\t")

orig$common<-orig$oligo %in% mtsa$oligo
mtsa$common<-mtsa$oligo %in% orig$oligo

#setup for figure
wd <- 3
ht <- 2.5
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

plot_mfc_vs_dsvm<-function(x, title) {
    plot(x$dsvm, x$mean.fc, pch=20, cex=0.75, col=x$common+1,
         xlim=xrange, ylim=yrange,
         main=title, xlab="deltaSVM score", ylab="Mean fold-change")
    pc<-cor(x$mean.fc, x$dsvm)
    abline(v=0, h=0, lty=2, col="gray")
    legend("topleft", legend=paste("C =", format(pc, nsmall=2, digits=2)),
            bty="n", inset=c(-0.1, 0), cex=cex.legend)
}

outfn<-"plot_mfc_vs_dsvm_mfv.pdf"

pdf(outfn, width=wd*fig.ncols, height=ht*fig.nrows)
par(cex=cex.general, ps=pt, cex.axis=cex.axis, cex.lab=cex.lab, cex.main=cex.main, font.main=1, bty="n")
par(mar=c(3.0,3.0,1.5,1.5)+0.1, mgp=c(1.3,0.3,0), tck=-0.02, mfrow = c(fig.nrows, fig.ncols))

plot_mfc_vs_dsvm(orig, "Before MTSA Normalization")
plot_mfc_vs_dsvm(mtsa, "After MTSA Normalization")

dev.off()
