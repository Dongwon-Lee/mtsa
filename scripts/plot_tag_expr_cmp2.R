# compare expression between two randomly selected tags 
# from each of the CRE elements before and after normalization

args<-commandArgs(trailingOnly=T)

suppressMessages(library('ggpubr'))
suppressMessages(library('ggplot2'))
suppressMessages(library('gridExtra'))

workingdir<-args[1]
tag_cnt_cutoff<-as.numeric(args[2]) # 100

t1<-read.table(file.path(workingdir, "tags1.txt"))
t2<-read.table(file.path(workingdir, "tags2.txt"))
c1<-read.table(file.path(workingdir, "tags_col1_score.txt"))
c2<-read.table(file.path(workingdir, "tags_col2_score.txt"))

d<-data.frame(tag1=t1[[3]], tag2=t2[[3]])
m<-data.frame(tag1=t1[[4]], tag2=t2[[4]])
r<-(m/d) # Ratio using original counts

mc1<-m[[1]]/(2**c1[[2]]) # Normalized counts of the first tag set
mc2<-m[[2]]/(2**c2[[2]]) # Normalized counts of the second tag set
rc1<-(mc1/d[[1]]) # Ratio using normalized counts
rc2<-(mc2/d[[2]]) # Ratio using normalized counts

# use tags with at least "tag_cnt_cutoff" plasmid counts and non-zero RNA counts
ind<-((d[[1]]>=tag_cnt_cutoff) & (d[[2]]>=tag_cnt_cutoff) & 
      (m[[1]]>0) & (m[[2]]>=0) &
      (m[[1]]>=(d[[1]]*0.01)) & (m[[2]]>=(d[[2]]*0.01))) 

scatterplot_tag_expr<- function(r1, r2, range, title) {
    df <- data.frame(r1, r2)
    print(cor(df$r1, df$r2))
    print(nrow(df))

    p1 <- ggplot(df, aes(r1, r2)) +
    geom_point(alpha = 0.25) + 
    geom_abline(intercept=0, slope=1, col="red") +
    ggtitle(title) + 
    xlab('tag1 expr.') +
    ylab('tag2 expr.') +
    xlim(range) +
    ylim(range) + 
    stat_cor(aes(label = ..r.label..), digits=3, na.rm=T) +
    theme_classic()
    
    return(p1)
}

# log scale comparison
r1<-r[ind, 1]
r2<-r[ind, 2]
lr1<-log2(r1)
lr2<-log2(r2)
lnr1<-log2(rc1[ind])
lnr2<-log2(rc2[ind])
range_log<-c(min(lr1, lr2, lnr1, lnr2)-0.1, max(lr1, lr2, lnr1, lnr2)+0.1)

p1<-scatterplot_tag_expr(lr1, lr2, range_log, "original")
p2<-scatterplot_tag_expr(lnr1, lnr2, range_log, "after MTSA")

outpdf<-file.path(workingdir, "plot_tag_expr_cmp.pdf")
ggsave(outpdf, width=5, height=2.5,
              arrangeGrob(grobs = list(p1, p2), ncol=2))
