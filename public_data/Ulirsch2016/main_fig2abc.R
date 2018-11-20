# scatterplot between predicted expression from sequence and observed expression

args<-commandArgs(trailingOnly=T)

cvfile<-"processed/mtsa_uli16.m100.t5.e5.adj.0.cv.txt"

d<-read.table(cvfile, stringsAsFactors=F)
svr<-d[[2]]
expr<-d[[3]]

#setup for figure
wd <- 2.4
ht <- 2.4
fig.nrows <- 1
fig.ncols <- 3
pt <- 8
cex.general <- 1
cex.lab <- 1
cex.axis <- 1
cex.main <- 1
cex.legend <- 1

outfn<-"main_fig2abc.pdf"
pdf(outfn, width=wd*fig.ncols, height=ht*fig.nrows)
par(mar=c(3.0,3.0,1.5,1.5)+0.1, mgp=c(1.3,0.3,0), tck=-0.02, mfrow = c(fig.nrows, fig.ncols))
par(cex=cex.general, ps=pt, cex.axis=cex.axis, cex.lab=cex.lab, cex.main=cex.main, font.main=1, bty="n")


df <- data.frame(svr, expr)
x <- densCols(df$svr, df$expr, colramp=colorRampPalette(c("black", "white")))

df$dens <- col2rgb(x)[1,] + 1L

## Map densities to colors
cols <-  colorRampPalette(c("#000099", "#00FEFF", "#45FE4F",
                            "#FCFF00", "#FF9400", "#FF3100"))(256)
df$col <- cols[df$dens]

plot(svr ~ expr, data=df[order(df$dens),], col=col,
     pch=20, cex=0.5,
     xlab="Observed relative expression",
     ylab="Predicted expression")

abline(a=0, b=1, lty=2, col=2)
pc<-cor(svr, expr)
legend("bottomright",
       legend=c(paste("r =", format(pc, nsmall=2, digits=2)),
                paste("n =", format(nrow(df), big.mark=","))),
        bty="n", inset=c(-0.05, 0), cex=cex.legend)

############################################
workingdir<-"tag_expr_cmp"
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

scatterplot_tag_expr<-function(r1, r2, range, title, xlabtxt, ylabtxt) {
    df <- data.frame(r1, r2)
    x <- densCols(df$r1,df$r2, colramp=colorRampPalette(c("black", "white")))

    df$dens <- col2rgb(x)[1,] + 1L

    ## Map densities to colors
    cols <-  colorRampPalette(c("#000099", "#00FEFF", "#45FE4F",
                                "#FCFF00", "#FF9400", "#FF3100"))(256)
    df$col <- cols[df$dens]

    plot(r2~r1, data=df[order(df$dens),], col=col,
         main=title, pch=20, cex=0.5,
         xlim=range, ylim=range,
         xlab=xlabtxt, ylab=ylabtxt)
    abline(a=0, b=1, lty=2, col=2)
    pc<-cor(r1, r2)
    legend("topleft", legend=paste("r =", format(pc, nsmall=2, digits=2)),
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

#scatterplot_tag_expr(r1, r2, range_lin, "Before MTSA Correction", "tag1 expression", "tag2 expression")
#scatterplot_tag_expr(nr1, nr2, range_lin, "After MTSA Correction", "tag1 expression", "tag2 expression")

scatterplot_tag_expr(lr1, lr2, range_log, "Before MTSA Correction", "log2(tag1 expression)", "log2(tag2 expression)")
scatterplot_tag_expr(lnr1, lnr2, range_log, "After MTSA Correction", "log2(tag1 expression)", "log2(tag2 expression)")

dev.off()
