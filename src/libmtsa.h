#ifndef _LIBMTSA_H
#define _LIBMTSA_H

extern "C" int mtsa_init(int verbosity, int nthreads);

extern "C" int mtsa_train_main(char *tdfile, char *outprefix,
        int rseed, int L, int k, int d, 
        int norc, double Cp, double p, double eps,
        int ncv, int icv, double cache_size);

extern "C" int mtsa_predict_main(char *testfile, char *modelfile, char *outfile);

#endif /* _LIBMTSA_H */
