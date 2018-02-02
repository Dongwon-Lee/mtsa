# scatterplot between predicted expression from sequence and observed expression

args<-commandArgs(trailingOnly=T)

cvfile<-args[1]

d<-read.table(cvfile, stringsAsFactors=F)
svr<-d[[2]]
expr<-d[[3]]

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

outfn<-gsub(".txt$", ".svr_vs_rexpr.pdf", cvfile)
pdf(outfn, width=wd*fig.ncols, height=ht*fig.nrows)
par(cex=cex.general, ps=pt, cex.axis=cex.axis, cex.lab=cex.lab, cex.main=cex.main, font.main=1, bty="n")
par(mar=c(3.0,3.0,1.5,1.5)+0.1, mgp=c(1.3,0.3,0), tck=-0.02, mfrow = c(fig.nrows, fig.ncols))


df <- data.frame(svr, expr)
x <- densCols(df$svr, df$expr, colramp=colorRampPalette(c("black", "white")))

df$dens <- col2rgb(x)[1,] + 1L

## Map densities to colors
cols <-  colorRampPalette(c("#000099", "#00FEFF", "#45FE4F",
                            "#FCFF00", "#FF9400", "#FF3100"))(256)
df$col <- cols[df$dens]

plot(expr ~ svr, data=df[order(df$dens),], col=col,
     pch=20, cex=0.5,
     xlab="Predicted expression from tag sequence", ylab="Relative expression")
abline(a=0, b=1, lty=2, col=2)
pc<-cor(svr, expr)
legend("topleft", legend=paste("C =", format(pc, nsmall=2, digits=2)),
        bty="n", inset=c(-0.1, 0), cex=cex.legend)

dev.off()
