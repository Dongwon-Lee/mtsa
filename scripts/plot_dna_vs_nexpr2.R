# inspect MPRA data

suppressMessages(library('tidyverse'))

args<-commandArgs(trailingOnly=T)

dna_rna_cnt_fn<-args[1]
out_fn<-args[2]

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

plot_plasmid_expr<-function(dna_rna_cnt_fn, titletxt, expr_threshold=1) {

    dat<-read_tsv(dna_rna_cnt_fn, col_names=c("elemid", "barcode", "dna", "rna"))

    np0<-sum(dat$dna==0)
    nr0<-sum(dat$rna==0)
    npra0<-sum(dat$dna==0 & dat$rna==0)
    npro0<-sum(dat$dna==0 | dat$rna==0)

    # 1. remove tags with zero counts 
    # 2. calculate log2 ratio
    dat <- dat %>% 
        filter(dna>0 & rna>0) %>%
        mutate(l2r=log2(dna/rna))

    # 3. calculate mean expr
    # 4. calculate relative expression (rexpr)
    dat <- dat %>%
        group_by(elemid) %>%
        summarise(mean(l2r)) %>%
        rename(l2r.mean=`mean(l2r)`) %>%
        inner_join(dat) %>% 
        mutate(rexpr=l2r-l2r.mean)

    n<-nrow(dat)

    print(titletxt)
    print(paste(n, np0, nr0, npra0, npro0))
    print(paste(sum(dat$dna), sum(dat$rna)))
    print("----")

    # just to reuse the previous code..
    res<-data.frame(plasmid=dat$dna, expr=dat$rexpr)

    cutoff_res<-c()
    cutoffs<-c(50,60,70,80,90,100,200)
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
plot_plasmid_expr(dna_rna_cnt_fn, "")
dev.off()
