/* libmtsa.c
 *
 * Copyright (C) 2017 Dongwon Lee
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>
#include <unistd.h>

#include "libsvm_gkm.h"
#include "libmtsa.h"

#define CLOG_MAIN
#include "clog.h"

static struct svm_parameter param;
static struct svm_problem prob;        // set by read_problem
static struct svm_model *model;

static char *line = NULL;
static int max_line_len;

static void handle_signal(int signal);

// this function was copied from libsvm & slightly modified 
static char* readline(FILE *input)
{
    if(fgets(line,max_line_len,input) == NULL)
        return NULL;

    while(strrchr(line,'\n') == NULL)
    {
        max_line_len *= 2;
        line = (char *) realloc(line, (size_t) max_line_len);
        int len = (int) strlen(line);
        if(fgets(line+len,max_line_len-len,input) == NULL)
            break;
    }
    
    //remove CR ('\r') or LF ('\n'), whichever comes first
    line[strcspn(line, "\r\n")] = '\0';

    return line;
}

static double calculate_score(char *seq)
{
    union svm_data x;
    double score;

    x.d = gkmkernel_new_object(seq, NULL, 0);

    svm_predict_values(model, x, &score);

    gkmkernel_delete_object(x.d);

    return score;
}

static void predict(FILE *input, FILE *output)
{
    int iseq = -1;
    char seq[MAX_SEQ_LENGTH];

    while (readline(input)) {
        char *ptr = strtok(line," \t\r\n");

        if (ptr != NULL) {
            if (strlen(ptr) >= MAX_SEQ_LENGTH) {
                clog_warn(CLOG(LOGGER_ID), "maximum sequence length allowed is %d. The first %d nucleotides of '%s' will only be used (Note: You can increase the MAX_SEQ_LENGTH parameter in libsvm_gkm.h and recompile).", MAX_SEQ_LENGTH-1, MAX_SEQ_LENGTH-1, line);
                line[MAX_SEQ_LENGTH-1] = '\0';
            }
            strcpy(seq, ptr);
        } else {
            clog_error(CLOG(LOGGER_ID), "illigal format of test file.\n");
            exit(1);
        }

        ++iseq;
        double score = calculate_score(seq);
        fprintf(output, "%s\t%g\n",seq, score);
        if ((iseq + 1) % 1000 == 0) {
            clog_info(CLOG(LOGGER_ID), "scoring %d tags...", iseq+1);
        }

    }

    clog_info(CLOG(LOGGER_ID), "%d tags scored", iseq+1);
}

static void read_training_data_file(const char *filename)
{
    FILE *fp = fopen(filename,"r");

    if(fp == NULL) {
        clog_error(CLOG(LOGGER_ID), "can't open input file %s", filename);
        exit(1);
    }

    int iseq = -1;
    char seq[MAX_SEQ_LENGTH];
    double expr = 0;
    while (readline(fp)) {
        if (iseq >= prob.l) {
            clog_error(CLOG(LOGGER_ID), "error occured while reading training data file (%d > %d).\n", iseq, prob.l);
            exit(1);
        }

        iseq++;

        char *ptr = strtok(line," \t\r\n");

        // get tag sequence
        if (ptr != NULL) {
            if (strlen(ptr) >= MAX_SEQ_LENGTH) {
                clog_error(CLOG(LOGGER_ID), "maximum sequence length is %d.\n", MAX_SEQ_LENGTH-1);
                exit(1);
            }
            strcpy(seq, ptr);
        } else {
            clog_error(CLOG(LOGGER_ID), "illigal format of training data file.\n");
            exit(1);
        }

        // get relative normalized expression 
        ptr = strtok (NULL, " \t\r\n");
        if (ptr != NULL) {
            char *end;
            expr = strtod(ptr, &end);
        } else {
            clog_error(CLOG(LOGGER_ID), "illigal format of training data file.\n");
            exit(1);
        }
        prob.y[iseq] = expr;
        prob.x[iseq].d = gkmkernel_new_object(seq, seq, iseq);
    }

    fclose(fp);
}

static int count_lines(const char *filename)
{
    FILE *fp = fopen(filename,"r");
    int nseqs = 0;

    if(fp == NULL) {
        clog_error(CLOG(LOGGER_ID), "can't open input file %s", filename);
        exit(1);
    }

    //count the number of lines for memory allocation
    while(readline(fp)!=NULL) {
        ++nseqs;
    }
    fclose(fp);
    
    return nseqs;
}

static void read_problem(const char *tdfile)
{
    int n = count_lines(tdfile);

    prob.l = n;

    prob.y = (double *) malloc (sizeof(double) * ((size_t) n));
    prob.x = (union svm_data *) malloc(sizeof(union svm_data) * ((size_t) n));

    clog_info(CLOG(LOGGER_ID), "reading %d tags from %s", n, tdfile);
    read_training_data_file(tdfile);
}

static void do_cross_validation(const char *filename, int ncv, int icv)
{
    double *target = (double *) malloc(sizeof(double) * ((size_t) prob.l));

    svm_cross_validation(&prob,&param,ncv,icv,target,filename);

    free(target);
}

int mtsa_init(int verbosity, int nthreads)
{
    struct sigaction sa;

	// proper handling of stop signals 
	memset(&sa, '\0', sizeof(sa));
    sa.sa_handler = &handle_signal;
    sa.sa_flags = SA_RESTART; // Restart the system call, if at all possible
    sigfillset(&sa.sa_mask); // Block every signal during the handler

    // Intercept SIGHUP/SIGTERM/SIGINT
    if (sigaction(SIGHUP, &sa, NULL) == -1) { perror("SIGHUP"); }
    if (sigaction(SIGTERM, &sa, NULL) == -1) { perror("SIGTERM"); }
    if (sigaction(SIGINT, &sa, NULL) == -1) { perror("SIGINT"); }

    // Initialize the logger
    if (clog_init_fd(LOGGER_ID, 1) != 0) {
        fprintf(stderr, "Logger initialization failed.\n");
        return 1;
    }

    clog_set_fmt(LOGGER_ID, LOGGER_FORMAT);
    switch(verbosity) 
    {
        case 0:
            clog_set_level(LOGGER_ID, CLOG_ERROR);
            break;
        case 1:
            clog_set_level(LOGGER_ID, CLOG_WARN);
            break;
        case 2:
            clog_set_level(LOGGER_ID, CLOG_INFO);
            break;
        case 3:
            clog_set_level(LOGGER_ID, CLOG_DEBUG);
            break;
        case 4:
            clog_set_level(LOGGER_ID, CLOG_TRACE);
            break;
        default:
            fprintf(stderr, "Unknown verbosity: %d\n", verbosity);
            exit(0);
    }

    gkmkernel_set_num_threads(nthreads);

    return 0;
}

int mtsa_train_main(char *tdfile, char *outprefix,
        int rseed, int L, int k, int d,
        int norc, double Cp, double p, double eps,
        int ncv, int icv, double cache_size)
{
    char model_file_name[1024];
    char cv_file_name[1024];
    const char *error_msg;

    // default values
    param.svm_type = EPSILON_SVR;
    param.kernel_type = EST_TRUNC;
    param.L = L;
    param.k = k;
    param.d = d;
    param.norc = norc;
    param.C = Cp;
    param.p = p;
    param.eps = eps;
    param.cache_size = cache_size;

    param.shrinking = 0; //not used
    param.nr_weight = 0; //not used
    param.weight_label = NULL; //not used
    param.weight = NULL; //not used
    param.gamma = 1.0; //not used
    param.M = 50; //not used
    param.H = 50; //not used
    param.probability = 0; //not used
    param.nu = 0.5; //not used

    /*
    clog_info(CLOG(LOGGER_ID), "Arguments:");
    clog_info(CLOG(LOGGER_ID), "  trainig_data_file = %s", tdfile);
    clog_info(CLOG(LOGGER_ID), "  output_prefix = %s", outprefix);

    clog_info(CLOG(LOGGER_ID), "Parameters:");
    clog_info(CLOG(LOGGER_ID), "  L = %d", param.L);
    clog_info(CLOG(LOGGER_ID), "  k = %d", param.k);
    clog_info(CLOG(LOGGER_ID), "  d = %d", param.d);
    clog_info(CLOG(LOGGER_ID), "  C = %g", param.C);
    clog_info(CLOG(LOGGER_ID), "  p = %g", param.p);
    clog_info(CLOG(LOGGER_ID), "  eps = %g", param.eps);
    clog_info(CLOG(LOGGER_ID), "  ncv= %d", ncv);
    clog_info(CLOG(LOGGER_ID), "  icv= %d", icv);
    clog_info(CLOG(LOGGER_ID), "  cache_size = %g", param.cache_size);
    */

    sprintf(model_file_name,"%s.model.txt", outprefix);

    if (ncv>1) {
        srand((unsigned int) rseed);
        //clog_info(CLOG(LOGGER_ID), "random seed is set to %d", rseed);

        if (icv>0) {
            /* save CV results to this file if -i option is set */
            sprintf(cv_file_name,"%s.cv.%d.txt", outprefix, icv); 
        } else {
            sprintf(cv_file_name,"%s.cv.txt", outprefix); 
        }
    } 

    gkmkernel_init(&param);

    max_line_len = 1024;
    line = (char *) malloc(sizeof(char) * ((size_t) max_line_len));
    read_problem(tdfile);

    error_msg = svm_check_parameter(&prob,&param);
    if(error_msg) {
        clog_error(CLOG(LOGGER_ID), error_msg);
        exit(1);
    }

    if(ncv>1) {
        do_cross_validation(cv_file_name, ncv, icv);
    } else {
        model = svm_train(&prob,&param);

        clog_info(CLOG(LOGGER_ID), "save SVM model to %s", model_file_name);

        if(svm_save_model(model_file_name,model)) {
            clog_error(CLOG(LOGGER_ID), "can't save model to file %s", model_file_name);
            exit(1);
        }
        svm_free_and_destroy_model(&model);
    }

    int i;
    for (i=0; i<prob.l; i++) {
        gkmkernel_delete_object(prob.x[i].d);
    }

    svm_destroy_param(&param);
    free(prob.y);
    free(prob.x);
    free(line);

	return 0;
}

int mtsa_predict_main(char *testfile, char *modelfile, char *outfile)
{
    FILE *input, *output;

    input = fopen(testfile,"r");
    if(input == NULL) {
        clog_error(CLOG(LOGGER_ID),"can't open input file %s", testfile);
        exit(1);
    }

    output = fopen(outfile,"w");
    if(output == NULL) {
        clog_error(CLOG(LOGGER_ID),"can't open output file %s", outfile);
        exit(1);
    }

    clog_info(CLOG(LOGGER_ID), "load model %s", modelfile);
    if((model=svm_load_model(modelfile))==0) {
        clog_error(CLOG(LOGGER_ID),"can't open model file %s", modelfile);
        exit(1);
    }

    max_line_len = 1024;
    line = (char *)malloc(((size_t) max_line_len) * sizeof(char));

    clog_info(CLOG(LOGGER_ID), "write prediction result to %s", outfile);
    predict(input, output);
    svm_free_and_destroy_model(&model);
    free(line);
    fclose(input);
    fclose(output);
    return 0;
}

void handle_signal(int signal) {
    switch (signal) {
        case SIGHUP:
            fprintf(stderr, "Caught SIGHUP, exiting now\n");
            exit(0);
        case SIGTERM:
            fprintf(stderr, "Caught SIGINT, exiting now\n");
            exit(0);
        case SIGINT:
            fprintf(stderr, "Caught SIGINT, exiting now\n");
            exit(0);
        default:
            fprintf(stderr, "Caught wrong signal: %d\n", signal);
            return;
    }
}
