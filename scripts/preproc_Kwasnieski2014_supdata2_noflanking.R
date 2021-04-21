library(tidyverse)

d<-read_tsv('SuppData2.txt')

d2 <-d %>%
    group_by(CRE) %>%
    summarise(ntags=n()) %>%
    filter(ntags>3) %>%
    inner_join(d)

d2 <- d2 %>% mutate(log2expr = log2(d2$Exp_Mean))

d3 <- d2 %>% group_by(CRE) %>% 
    summarise(mean_log2expr = mean(log2expr)) %>% 
    inner_join(d2) %>%
    mutate(rexpr = log2expr - mean_log2expr)

excluded.ind<-which(!(d$BC %in% d3$BC))

write.table(d3[,c("BC", "rexpr", "CRE")],
            'processed/mtsa_kwa14.t4.e0.tag_rexpr.txt', 
            col.names=F, row.names=F, sep="\t", quote=F)

write.table(d[excluded.ind,c("BC", "CRE")],
            'processed/mtsa_kwa14.t4.e0.excluded_tags.txt', 
            col.names=F, row.names=F, sep="\t", quote=F)
