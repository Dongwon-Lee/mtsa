# scatterplot between predicted expression from sequence and observed expression

args<-commandArgs(trailingOnly=T)

cal_cor<-function(cvfile) {
    d<-read.table(cvfile, stringsAsFactors=F)
    svr<-d[[2]]
    expr<-d[[3]]
    cor(svr, expr)
}

expids<-c("Melnikov2012/processed/mtsa_mel12.m1000.t5.e5",
          "Kheradpour2013/processed/mtsa_khe13.m500.t5.e5",
          "Ulirsch2016/processed/mtsa_uli16.m100.t5.e5",
          "Inoue2017/processed/mtsa_ino17.m50.t10.e5")

cv1<-paste(expids, "adj.0.cv.txt", sep=".")
cv2<-paste(expids, "rc.adj.0.cv.txt", sep=".")

for(fn in cv1) {
    pc<-cal_cor(fn)
    print(paste(fn, pc))
}

for(fn in cv2) {
    pc<-cal_cor(fn)
    print(paste(fn, pc))
}
