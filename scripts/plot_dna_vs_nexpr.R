# inspect MPRA data

args<-commandArgs(trailingOnly=T)

plasmid_cnt_fn<-args[1]
mrna_cnt_fn<-args[2]
out_fn<-args[3]

wd <- 2
ht <- 1.5
fig.nrows <- 1
fig.ncols <- 3
pt <- 8
cex.general <- 1
cex.lab <- 1
cex.axis <- 1
cex.main <- 1
cex.legend <- 1
lwd<-0.5

plot_plasmid_expr<-function(plasmid_fn, mrna_fn, titletxt, expr_threshold=1) {

    counts.plasmid<-read.table(plasmid_fn, header=F, stringsAsFactors=F)
    counts.mrna<-read.table(mrna_fn, header=F, stringsAsFactors=F) 
    # remove ID column
    counts.plasmid<-counts.plasmid[,-1]
    counts.mrna<-counts.mrna[,-1]

    np0<-length(which(counts.plasmid==0))
    nr0<-length(which(counts.mrna==0))
    npra0<-length(which(counts.plasmid==0 & counts.mrna==0))
    npro0<-length(which(counts.plasmid==0 | counts.mrna==0))

    log2.cntratio<-log2(counts.mrna/counts.plasmid)

    #remove tags with zero counts
    for(i in c(1:length(log2.cntratio))) {
        log2.cntratio[is.infinite(log2.cntratio[,i]),i]<-NA
        log2.cntratio[is.nan(log2.cntratio[,i]),i]<-NA
    }

    rel.norm.expr<-log2.cntratio - rowMeans(log2.cntratio, na.rm=T)
    res<-data.frame(plasmid=unlist(counts.plasmid), expr=unlist(rel.norm.expr))
    n<-nrow(res)

    print(titletxt)
    print(paste(n, np0, nr0, npra0, npro0))
    print(paste(sum(counts.plasmid), sum(counts.mrna)))
    print("----")

    res<-subset(res, !is.na(res$expr))

    cutoff_res<-c()
    cutoffs<-c(1,50,100,200,500,1000,2000,5000,10000,20000,50000,100000,200000,500000)
    ranges.txt<-c()
    for(i in 1:(length(cutoffs)-1)) {
        res.subset<-subset(res, res$plasmid>=cutoffs[i] & res$plasmid<cutoffs[i+1])
        n<-nrow(res.subset)
        m<-length(which(abs(res.subset$expr)>expr_threshold))
        r<-m/n

        print(paste(cutoffs[i], cutoffs[i+1], n, m, r))
        if (i==1) {
            cutoff_res<-data.frame(i=i, n=n, m=m, r=r)
            ranges.txt<-c(ranges.txt, paste(cutoffs[i], cutoffs[i+1], sep="~"))

        } else {
            if (n>0) {
                cutoff_res<-rbind(cutoff_res, c(i, n, m, r))
                ranges.txt<-c(ranges.txt, paste(cutoffs[i], cutoffs[i+1], sep="~"))
            }
        }
    }

    par(cex=cex.general, ps=pt, cex.axis=cex.axis, cex.lab=cex.lab, cex.main=cex.main, lwd=lwd, font.main=1, bty="n")
    par(mar=c(2.5,2.5,0.5,0.5)+0.1, mgp=c(1.3,0.3,0), tck=-0.04, mfrow = c(fig.nrows, fig.ncols))

    smoothScatter(log10(res$plasmid), res$expr,
         xlab="log10(DNA tag counts)", ylab="Relative expression", main=titletxt)

    abline(h=c(-expr_threshold, expr_threshold), lty=2, col="gray")
    abline(v=log10(cutoffs), lty=3, col="gray")

    mp<-barplot(cutoff_res$n, main="", border=NA,
            xlab="DNA tag counts", 
            ylab="Number of tags")
    text(mp, par("usr")[3]-max(cutoff_res$n)*0.03, labels=ranges.txt, srt=30, pos=2, offset=0, xpd=TRUE, cex=5/6)

    mp<-barplot(cutoff_res$r, main="", border=NA,
            xlab="DNA tag counts", 
            ylab=paste("Frac. of tags with |expr|>", expr_threshold, sep=""))
    text(mp, par("usr")[3]-max(cutoff_res$r)*0.03, labels=ranges.txt, srt=30, pos=2, offset=0, xpd=TRUE, cex=5/6)

}

pdf(out_fn, width=5.4, height=1.5)
plot_plasmid_expr(plasmid_cnt_fn, mrna_cnt_fn, "")
dev.off()
