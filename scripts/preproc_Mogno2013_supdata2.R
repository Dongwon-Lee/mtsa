# R script to make MTSA input from Supplemental Data 2
# Dongwon Lee

d<-read.table('Supplemental_Data_2.txt', header=T)
thresh<-10^(-4)
d4<-d[d$gDNA_expr>thresh,]
tag_thresh<-4
goodprom<-names(which(table(d4$PROM)>=tag_thresh))
d4p<-d4[d4$PROM %in% goodprom,]
d4p<-d4p[order(d4p$PROM),]
d4p$log2expr<-log2(d4p$EXPR)
d4p.m<-aggregate(log2expr ~ PROM, data=d4p, mean)
colnames(d4p.m)[2]<-"mean_log2expr"
d4pa<-merge(d4p, d4p.m)
d4pa$rexpr<-d4pa$log2expr - d4pa$mean_log2expr
write.table(d4pa[,c("BC", "rexpr", "PROM")],
            'processed/mtsa_mog13.t4.e0.tag_rexpr.txt', 
            col.names=F, row.names=F, sep="\t", quote=F)

excluded<-d[!(d$BC %in% d4pa$BC),]
excluded<-excluded[order(excluded$PROM),]
write.table(excluded[,c("BC", "PROM")],
            'processed/mtsa_mog13.t4.e0.excluded_tags.txt', 
            col.names=F, row.names=F, sep="\t", quote=F)
