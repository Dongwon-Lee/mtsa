#ifndef LIBSVM_GKM_H_INCLUDED
#define LIBSVM_GKM_H_INCLUDED

#include "libsvm.h"

#define MAX_ALPHABET_SIZE 4 /* base ACGT, DON'T CHANGE THIS PARAMETER! */
#define MAX_ALPHABET_SIZE_SQ 16 // MAX_ALPHABET_SIZE*MAX_ALPHABET_SIZE
#define MAX_SEQ_LENGTH 256
#define MMCNT_LOOKUPTAB_WIDTH 8

#ifdef __cplusplus 
extern "C" {
#endif

typedef struct _KmerTree KmerTree;
typedef struct _KmerTreeLeaf KmerTreeLeaf;
typedef struct _NodeMismatchCount NodeMismatchCount;
typedef struct _KmerTreeCoef KmerTreeCoef;
typedef struct _KmerTreeLeafData KmerTreeLeafData;

struct _KmerTreeLeafData {
    int seqid;
    int wt;
};

/* simple stack */
struct _KmerTreeLeaf {
    int count;
    int capacity;
    KmerTreeLeafData *data;
};

struct _KmerTree {
    int depth; //the same as kmer-length
    int node_count; //internal node only
    int leaf_count; //leaf node only
    int *node;
    KmerTreeLeaf *leaf;
};

struct _KmerTreeCoef {
    int depth; //the same as kmer-length
    int node_count; //internal node only
    int leaf_count; //leaf node only
    double *coef_sum;
};

void gkmkernel_init(struct svm_parameter *param);
void gkmkernel_destroy();
void gkmkernel_set_num_threads(int n);

gkm_data* gkmkernel_new_object(char *seq, char *sid, int seqid);
void gkmkernel_delete_object(gkm_data* d);
void gkmkernel_free_object(gkm_data* d);

double gkmkernel_kernelfunc(const gkm_data *da, const gkm_data *db);
double* gkmkernel_kernelfunc_batch(const gkm_data *da, const union svm_data *db_array, const int n, double *res);

void gkmkernel_init_problems(union svm_data *x, int n);
void gkmkernel_destroy_problems();
void gkmkernel_swap_index(int i, int j);
void gkmkernel_update_index();
double* gkmkernel_kernelfunc_batch_all(const int a, const int start, const int end, double *res);

void gkmkernel_init_sv(union svm_data *sv, double *coef, int nclass, int n);
void gkmkernel_destroy_sv();
double* gkmkernel_kernelfunc_batch_sv(const gkm_data *d, double *res);

void gkmkernel_init_predict(union svm_data *sv, double *alpha, int nclass, int n);
double gkmkernel_predict(const gkm_data *d);

int svm_save_model(const char *model_file_name, const struct svm_model *model);
svm_model *svm_load_model(const char *model_file_name);


#ifdef __cplusplus
}
#endif

#endif
