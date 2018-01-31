# compare expression between two randomly selected tags 
# from each of the CRE elements before and after normalization

args<-commandArgs(trailingOnly=T)

workingdir<-args[1]

tag_cnt_cutoff<-100

d<-read.table(file.path(workingdir, "dna_te.txt"))
m<-read.table(file.path(workingdir, "mrna_te.txt"))
c1<-read.table(file.path(workingdir, "tags_col1_score.txt"))
c2<-read.table(file.path(workingdir, "tags_col2_score.txt"))

r<-(m/d) # Ratio using original counts

mc1<-m[[1]]/(2**c1[[2]]) # Normalized counts of the first tag set
mc2<-m[[2]]/(2**c2[[2]]) # Normalized counts of the second tag set
rc1<-(mc1/d[[1]]) # Ratio using normalized counts
rc2<-(mc2/d[[2]]) # Ratio using normalized counts

# use tags with at least "tag_cnt_cutoff" plasmid counts and non-zero RNA counts
ind<-((d[[1]]>=tag_cnt_cutoff) & (d[[2]]>=tag_cnt_cutoff) & (m[[1]]>0) & (m[[2]]>0)) 

#setup for figure
wd <- 2.5
ht <- 2.5
fig.nrows <- 2
fig.ncols <- 2
pt <- 10
cex.general <- 0.7
cex.lab <- 1
cex.axis <- 1
cex.main <- 1
cex.legend <- 1

scatterplot_tag_expr<-function(r1, r2, range, title) {
    plot(r1, r2, 
         col=densCols(r1, r2),
         main=title, pch=20, cex=0.5,
         xlim=range, ylim=range,
         xlab="tag1 expr", ylab="tag2 expr")
    abline(a=0, b=1, lty=2, col=2)
    pc<-cor(r1, r2)
    legend("topleft", legend=paste("C =", format(pc, nsmall=2, digits=2)),
            bty="n", inset=c(-0.1, 0), cex=cex.legend)
}

# linear scale comparison
r1<-r[ind, 1]
r2<-r[ind, 2]
nr1<-rc1[ind]
nr2<-rc2[ind]
range_lin<-c(0, max(r1, r2, nr1, nr2)+1)

# log scale comparison
lr1<-log2(r1)
lr2<-log2(r2)
lnr1<-log2(rc1[ind])
lnr2<-log2(rc2[ind])
range_log<-c(min(lr1, lr2, lnr1, lnr2)-0.1, max(lr1, lr2, lnr1, lnr2)+0.1)

pdf(file.path(workingdir, "plot_tag_expr_cmp.pdf"), width=wd*fig.ncols, height=ht*fig.nrows)
par(cex=cex.general, ps=pt, cex.axis=cex.axis, cex.lab=cex.lab, cex.main=cex.main, font.main=1, bty="n")
par(xaxs="i", yaxs="i", mar=c(3.0,3.0,1.5,1.5)+0.1, mgp=c(1.3,0.3,0), tck=-0.02, mfrow = c(fig.nrows, fig.ncols))

scatterplot_tag_expr(r1, r2, range_lin, "original")
scatterplot_tag_expr(nr1, nr2, range_lin, "after normalization")

scatterplot_tag_expr(lr1, lr2, range_log, "original (log2 scale)")
scatterplot_tag_expr(lnr1, lnr2, range_log, "after normalization (log2 scale)")

dev.off()
