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

# flanking sequences from Supp. Fig. 6 Kwasnieski. 2014
d <- d %>% mutate(BC.e5 = paste('ATGCC', BC, 'TGAGC', sep=''))
d3 <- d3 %>% mutate(BC.e5 = paste('ATGCC', BC, 'TGAGC', sep=''))

write.table(d3[,c("BC.e5", "rexpr", "CRE")],
            'processed/mtsa_kwa14.t4.e5.tag_rexpr.txt', 
            col.names=F, row.names=F, sep="\t", quote=F)

write.table(d[excluded.ind,c("BC.e5", "CRE")],
            'processed/mtsa_kwa14.t4.e5.excluded_tags.txt', 
            col.names=F, row.names=F, sep="\t", quote=F)
