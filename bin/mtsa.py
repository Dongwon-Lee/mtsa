#!/usr/bin/env python

"""
    mtsa.py: MPRA Tag Sequence Analysis

    Copyright (C) 2020 Dongwon Lee

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import sys
import argparse
import os.path
import math
import logging
from ctypes import *

try:
    from itertools import imap
except ImportError:
    imap=map # Python 3...

__version__ = '1.0.0'

HEADER  = "\n# ======================================="
HEADER += "\n#   MPRA Tag Sequence Analysis (MTSA)"
HEADER += "\n#   Version {0}".format(__version__)
HEADER += "\n#   (C) 2020 Dongwon Lee"
HEADER += "\n#   GNU General Public License v3"
HEADER += "\n# ======================================="

def read_tsv_data(filename, trans_func=None):
    try:
        fp = open(filename, 'r')
    except IOError as e:
        logging.error("cannot open '%s' (errno=%d)", filename, e.errno)
        sys.exit(0)
    except:
        raise

    elemids = []
    data = []
    ncols = None
    for i, line in enumerate(fp):
        f = line.strip().split('\t')
        d = f[1:]

        if ncols == None:
            ncols = len(d)
        elif ncols != len(d):
            logging.error("number of columns are different at %d in %s",
                    i+1, filename)
            sys.exit(0)

        if trans_func != None:
            d = list(map(trans_func, d))

        elemids.append(f[0])
        data.append(d)

    fp.close()

    return elemids, data


def build_training_data(args, ttagfile, rtagfile):
    dna_ids, dna_cnts = read_tsv_data(args.dna_cnt_fn, trans_func=int)
    mrna_ids, mrna_cnts = read_tsv_data(args.mrna_cnt_fn, trans_func=int)
    tag_ids, tags = read_tsv_data(args.tag_seq_fn)

    # ID check
    if len(dna_ids) != len(mrna_ids) or len(dna_ids) != len(tag_ids):
        logging.error("Number of Elements do not match between input files.")
        sys.exit(0)

    if any((d != m or d != t) for (d, m, t) in zip(dna_ids, mrna_ids, tag_ids)):
        logging.error("Element IDs do not match between input files.")
        sys.exit(0)

    len_dna_cnts = len(list(dna_cnts))
    len_tag_cnts = len(list(dna_cnts[0]))
    logging.info("%d elements loaded", len(dna_ids))
    logging.info("%d tags per element", len_tag_cnts)
    logging.info("%d tags total", len(dna_ids)*len_tag_cnts)

    bad_tags = []
    num_good_tags_per_elem = []
    for i in range(len_dna_cnts):
        bad_tags_one_row = [True
                if (d < args.min_dna_read_cnts) or (m == 0) else False
                for (d, m) in zip(dna_cnts[i], mrna_cnts[i])]
        num_good_tags_per_elem.append(bad_tags_one_row.count(False))
        bad_tags.append(bad_tags_one_row)

    n_bad_tags = sum([x.count(True) for x in bad_tags])
    logging.info("%d tags with <%d DNA reads or 0 mRNA reads (excluded)",
            n_bad_tags, args.min_dna_read_cnts)

    good_elems = [True if n >= args.min_num_tags else False
            for n in num_good_tags_per_elem]

    n_good_tags_in_bad_elems = sum([t.count(False)
            for (g, t) in zip(good_elems, bad_tags) if not g])

    logging.info("%d elements have <%d tags after filtering",
            good_elems.count(False), args.min_num_tags)
    logging.info("%d tags are additionally excluded",
            n_good_tags_in_bad_elems)

    training_tags = []
    excluded_tags = []
    for i in range(len_dna_cnts):
        tags_i = tags[i]
        elemid = dna_ids[i]

        if not good_elems[i]:
            excluded_tags.extend([(t, elemid) for t in tags_i])
            continue

        mrna_i = mrna_cnts[i]
        dna_i = dna_cnts[i]
        bad_i = bad_tags[i]

        #log2ratio_i = [ (t, math.log(m/float(d), 2) )
        #        for j, (t, m, d) in enumerate(zip(tags_i, mrna_i, dna_i))
        #        if not bad_i[j] ]

        #mean = sum([v for (t, v) in log2ratio_i])/float(len(log2ratio_i))
        #log2ratio_i_norm = [(t, v - mean, elemid) for (t, v) in log2ratio_i]

        log2ratio_i = [ (t, math.log(m/float(d), 2), m, d)
                for j, (t, m, d) in enumerate(zip(tags_i, mrna_i, dna_i))
                if not bad_i[j] ]
        mean = sum([v for (t, v, m, d) in log2ratio_i])/float(len(log2ratio_i))
        log2ratio_i_norm = [(t, v - mean, m, d, elemid) for (t, v, m, d) in log2ratio_i]
        training_tags.extend(log2ratio_i_norm)

        excluded_tags.extend([(t, elemid) for j, t in enumerate(tags_i) if bad_i[j]])

    fp = open(ttagfile, 'w')
    for i in range(len(training_tags)):
        tag = training_tags[i][0]
        if args.left_flanking_seq != None:
            tag = args.left_flanking_seq + tag
        if args.right_flanking_seq != None:
            tag = tag + args.right_flanking_seq
        #fp.write("{0}\t{1}\t{2}\n".format(tag, training_tags[i][1], training_tags[i][2]))
        #fp.write("{0}\t{1}\t{2}\t{3}\t{4}\n".format(tag, training_tags[i][1], training_tags[i][2], training_tags[i][3], training_tags[i][4]))
        fp.write("{0}\t{1}\t{2}\n".format(tag, training_tags[i][1], training_tags[i][4]))
    fp.close()

    logging.info("%d tags written to %s for SVR training", len(training_tags), ttagfile)

    fp = open(rtagfile, 'w')
    for i in range(len(excluded_tags)):
        tag = excluded_tags[i][0]
        if args.left_flanking_seq != None:
            tag = args.left_flanking_seq + tag
        if args.right_flanking_seq != None:
            tag = tag + args.right_flanking_seq
        fp.write("{0}\t{1}\n".format(tag, excluded_tags[i][1]))
    fp.close()

def read_elem_tag_cnt_data(filename):
    try:
        fp = open(filename, 'r')
    except IOError as e:
        logging.error("cannot open '%s' (errno=%d)", filename, e.errno)
        sys.exit(0)
    except:
        raise

    dat = {}
    for line in fp:
        f = line.strip().split('\t')
        elemid = f[0]
        if elemid not in dat:
            dat[elemid] = {'tag':[], 'dna':[], 'rna':[]}
            
        dat[elemid]['tag'].append(f[1])
        dat[elemid]['dna'].append(int(f[2]))
        dat[elemid]['rna'].append(int(f[3]))

    fp.close()

    return dat

def build2_training_data(args, ttagfile, rtagfile):
    dat = read_elem_tag_cnt_data(args.input_fn)
    
    ntags = 0
    nelem = 0
    for elemid in dat.keys():
        nelem += 1
        ntags += len(dat[elemid]['tag'])


    logging.info("%d elements loaded", nelem)
    logging.info("%d tags per element (on average)", ntags/nelem)
    logging.info("%d tags total", ntags)

    n_bad_tags = 0
    n_good_elem = 0
    n_good_tags_in_bad_elems = 0
    for elemid in dat.keys():
        dat[elemid]['is_bad_tag'] = [ True
                if (d < args.min_dna_read_cnts) or (m == 0) else False
                for (d, m) in zip(dat[elemid]['dna'], dat[elemid]['rna'])]
        n_bad_tags += dat[elemid]['is_bad_tag'].count(True)

        if dat[elemid]['is_bad_tag'].count(False) >= args.min_num_tags:
            dat[elemid]['is_good_elem'] = True
            n_good_elem += 1
        else:
            dat[elemid]['is_good_elem'] = False
            n_good_tags_in_bad_elems += dat[elemid]['is_bad_tag'].count(False)

    logging.info("%d tags with <%d DNA reads or 0 mRNA reads (excluded)",
            n_bad_tags, args.min_dna_read_cnts)

    logging.info("%d elements have <%d tags after filtering",
            len(dat)-n_good_elem, args.min_num_tags)

    logging.info("%d tags are additionally excluded",
            n_good_tags_in_bad_elems)

    training_tags = []
    excluded_tags = []
    for elemid in dat.keys():
        if not dat[elemid]['is_good_elem']:
            excluded_tags.extend([(t, elemid) for t in dat[elemid]['tag']])
            continue

        tags_i = dat[elemid]['tag']
        mrna_i = dat[elemid]['rna']
        dna_i = dat[elemid]['dna']
        bad_i = dat[elemid]['is_bad_tag']

        log2ratio_i = [ (t, math.log(m/float(d), 2), m, d)
                for j, (t, m, d) in enumerate(zip(tags_i, mrna_i, dna_i))
                if not bad_i[j] ]
        mean = sum([v for (t, v, m, d) in log2ratio_i])/float(len(log2ratio_i))
        log2ratio_i_norm = [(t, v - mean, m, d, elemid) for (t, v, m, d) in log2ratio_i]
        training_tags.extend(log2ratio_i_norm)

        excluded_tags.extend([(t, elemid) for j, t in enumerate(tags_i) if bad_i[j]])

    fp = open(ttagfile, 'w')
    for i in range(len(training_tags)):
        tag = training_tags[i][0]
        if args.left_flanking_seq != None:
            tag = args.left_flanking_seq + tag
        if args.right_flanking_seq != None:
            tag = tag + args.right_flanking_seq
        fp.write("{0}\t{1}\t{2}\n".format(tag, training_tags[i][1], training_tags[i][4]))
    fp.close()

    logging.info("%d tags written to %s for SVR training", len(training_tags), ttagfile)

    fp = open(rtagfile, 'w')
    for i in range(len(excluded_tags)):
        tag = excluded_tags[i][0]
        if args.left_flanking_seq != None:
            tag = args.left_flanking_seq + tag
        if args.right_flanking_seq != None:
            tag = tag + args.right_flanking_seq
        fp.write("{0}\t{1}\n".format(tag, excluded_tags[i][1]))
    fp.close()

def pearsonr(x, y):
    n = float(len(x))
    sum_x = float(sum(x))
    sum_y = float(sum(y))
    sum_x_sq = sum(map(lambda x: pow(x, 2), x))
    sum_y_sq = sum(map(lambda x: pow(x, 2), y))
    prod_sum = sum(imap(lambda x, y: x * y, x, y))
    den = pow((sum_x_sq - pow(sum_x, 2) / n) * (sum_y_sq - pow(sum_y, 2) / n), 0.5)
    if den == 0: return 0
    return (prod_sum - (sum_x * sum_y/n))/den

def cal_tag_sequence_factor(args):
    rtagfile = args.name + ".excluded_tags.score.txt"

    tag2svr = dict()
    tag2logr = dict()
    nrepeats = float(args.repeats)
    for i in range(args.repeats):
        cvfile = args.name + ".adj." + str(i) + ".cv.txt"
        # calculate Pearson's correlation using CV result
        try:
            fp = open(cvfile, 'r')
        except IOError as e:
            logging.error("cannot open '%s' (errno=%d)", cvfile, e.errno)
            sys.exit(0)
        except:
            raise

        for line in fp:
            f = line.strip().split('\t')
            tag = f[0]
            svr = float(f[1])/nrepeats
            logr = float(f[2])
            if i == 0:
                tag2svr[tag] = svr
                tag2logr[tag] = logr
            else:
                tag2svr[tag] += svr
        fp.close()

    # calculate Pearson's correlation
    r = pearsonr([tag2svr[t] for t in tag2svr.keys()],
            [tag2logr[t] for t in tag2svr.keys()])
    logging.info("Pearson's r = %g", r)

    # load tag SVR scores that were NOT in the training set
    try:
        fp = open(rtagfile, 'r')
    except IOError as e:
        logging.error("cannot open '%s' (errno=%d)", rtagfile, e.errno)
        sys.exit(0)
    except:
        raise
    for line in fp:
        f = line.strip().split('\t')
        tag2svr[f[0]] = float(f[1])
    fp.close()

    # calculate tag sequence effect
    seqfactfile = args.name + ".sequence_factor.txt"
    fp = open(seqfactfile, 'w')
    for t in sorted(tag2svr.keys()):
        fp.write("{0}\t{1}\n".format(t, tag2svr[t]))
    fp.close()


def adjust_tag_group_effect(ttagfile, cvfile, ttag_adj_file, ncv):
    try:
        fp = open(ttagfile, 'r')
    except IOError as e:
        logging.error("cannot open '%s' (errno=%d)", ttagfile, e.errno)
        sys.exit(0)
    except:
        raise

    elemid2tags = dict()
    tag2elemid = dict()
    for line in fp:
        f = line.strip().split('\t')
        tag = f[0]
        elemid = f[2]
        if elemid not in elemid2tags:
            elemid2tags[elemid] = []
        elemid2tags[elemid].append(tag)
        tag2elemid[tag] = elemid
    fp.close()

    elemids = elemid2tags.keys()

    try:
        if not os.path.isfile(cvfile):
            # concatenate the splitted CV result files into one
            icvfiles = [ cvfile[:-3] + str(i+1) + ".txt" for i in range(ncv) ]
            
            # make sure that the CV files exist
            if not all(map(os.path.isfile, icvfiles)):
                logging.error("CV files do not exist. quit.")
                sys.exit(0)

            with open(cvfile, 'w') as outfile:
                for fname in filenames:
                    with open(fname) as icvfiles:
                        for line in infile:
                            outfile.write(line)

        fp = open(cvfile, 'r')
    except IOError as e:
        logging.error("cannot open '%s' (errno=%d)", cvfile, e.errno)
        sys.exit(0)
    except:
        raise

    t2s = dict()
    training_tags = []
    for line in fp:
        f = line.strip().split('\t')
        tag = f[0]
        t2s[tag] = float(f[1])
        training_tags.append((tag, float(f[2])))
    fp.close()

    avg = lambda x: sum(x)/float(len(x))
    global_effects = [ avg(list(map(lambda x: t2s[x], elemid2tags[e])))
            for e in elemids ]

    tag2ge = dict()
    for i, eid in enumerate(elemids):
        ge = global_effects[i]
        for t in elemid2tags[eid]:
            tag2ge[t] = ge

    fp = open(ttag_adj_file, 'w')
    for tag, rexpr in training_tags:
        fp.write("{0}\t{1}\t{2}\n".format(tag, rexpr + tag2ge[tag],tag2elemid[tag]))
    fp.close()

def normalize_mrna_counts(args):
    seqfactfile = args.name + ".sequence_factor.txt"
    tag2norm = dict()

    fp = open(seqfactfile, 'r')
    for line in fp:
        f = line.strip().split('\t')
        tag = f[0]
        norm = pow(2, float(f[1]))
        tag2norm[tag] = norm
    fp.close()

    mrna_ids, mrna_cnts = read_tsv_data(args.mrna_cnt_fn, trans_func=int)
    tag_ids, tags = read_tsv_data(args.tag_seq_fn)

    # ID check
    if len(mrna_ids) != len(tag_ids):
        logging.error("Number of Elements do not match between input files.")
        sys.exit(0)

    if any((m != t) for (m, t) in zip(mrna_ids, tag_ids)):
        logging.error("Element IDs do not match between input files.")
        sys.exit(0)

    logging.info("%d elements loaded", len(mrna_ids))
    logging.info("%d tags per element", len(mrna_cnts[0]))
    logging.info("%d tags total", len(mrna_ids)*len(mrna_cnts[0]))

    fp = open(args.output_fn, 'w')
    for elemid, mrna_cnts_row, tags_row in zip(mrna_ids, mrna_cnts, tags):
        fp.write("{0}".format(elemid))
        for cnt, tag in zip(mrna_cnts_row, tags_row):
            if args.left_flanking_seq != None:
                tag = args.left_flanking_seq + tag
            if args.right_flanking_seq != None:
                tag = tag + args.right_flanking_seq
            fp.write("\t{0}".format(cnt/tag2norm[tag]))
        fp.write("\n")
    fp.close()

def normalize2_mrna_counts(args):
    seqfactfile = args.name + ".sequence_factor.txt"
    tag2norm = dict()

    fp = open(seqfactfile, 'r')
    for line in fp:
        f = line.strip().split('\t')
        tag = f[0]
        norm = pow(2, float(f[1]))
        tag2norm[tag] = norm
    fp.close()

    try:
        fp_in = open(args.input_fn, 'r')
    except IOError as e:
        logging.error("cannot open '%s' (errno=%d)", args.input_fn, e.errno)
        sys.exit(0)
    except:
        raise

    fp_out = open(args.output_fn, 'w')

    for line in fp_in:
        f = line.strip().split('\t')
        elemid = f[0]
        tag = f[1]
        dna = int(f[2])
        rna = int(f[3])

        tag_flank = tag
        if args.left_flanking_seq != None:
            tag_flank = args.left_flanking_seq + tag_flank
        if args.right_flanking_seq != None:
            tag_flank = tag_flank + args.right_flanking_seq
        fp_out.write("{0}\t{1}\t{2}\t{3}\n".format(elemid, tag, dna, rna/tag2norm[tag_flank]))

    fp_out.close()
    fp_in.close()

def main():
    global HEADER

    desc_txt="perform MPRA tag sequence analysis using support vector regression\
    (SVR) with gapped-kmer kernels (Ghandi et al. 2014; Lee 2016). \
    LIBSVM (Chang & Lin 2011) was used for implementing SVR. \
    -- by Dongwon Lee (dongwon.lee@childrens.harvard.edu)"

    desc_build_txt = "build training data for SVR "
    desc_build2_txt = "build training data for SVR using an input file in a tsv format ([element] [tag] [DNA] [RNA])"
    desc_train_txt = "train SVR and calculate sequence factors for normalization"
    desc_predict_txt = "score sequences using the trained SVR model"
    desc_normalize_txt = "normalize mRNA counts"
    desc_normalize2_txt = "normalize mRNA counts using an input file in a tsv format ([element] [tag] [DNA] [RNA])"

    parser = argparse.ArgumentParser(description=desc_txt,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    subparsers = parser.add_subparsers(title='commands', dest='commands', required=True)

    subparser_build = subparsers.add_parser('build',
            help=desc_build_txt,
            description=desc_build_txt,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    subparser_build2 = subparsers.add_parser('build2',
            help=desc_build2_txt,
            description=desc_build2_txt,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    subparser_train = subparsers.add_parser('train',
            help=desc_train_txt,
            description=desc_train_txt,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    subparser_predict = subparsers.add_parser('predict',
            help=desc_predict_txt,
            description=desc_predict_txt,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    subparser_normalize = subparsers.add_parser('normalize',
            help=desc_normalize_txt,
            description=desc_normalize_txt,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    
    subparser_normalize2 = subparsers.add_parser('normalize2',
            help=desc_normalize2_txt,
            description=desc_normalize2_txt,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    # parser for the "build" command
    subparser_build.add_argument("dna_cnt_fn", type=str,
            help="DNA read counts file")
    subparser_build.add_argument("mrna_cnt_fn", type=str,
            help="mRNA read counts file")
    subparser_build.add_argument("tag_seq_fn", type=str,
            help="tag sequences file")
    subparser_build.add_argument("-n", "--name", type=str, required=True,
            help="name of output prefix. REQUIRED")
    subparser_build.add_argument("-m", "--min-dna-read-cnts", type=int, default=200,
            help="minimum DNA tag read counts for SVR training")
    subparser_build.add_argument("-t", "--min-num-tags", type=int, default=5,
            help="minimum number of tags per element for SVR training")
    subparser_build.add_argument("-l", "--left-flanking-seq", type=str, default=None,
            help="left flanking sequence (5') of tags for SVR training")
    subparser_build.add_argument("-r", "--right-flanking-seq", type=str, default=None,
            help="right flanking sequence (3') of tags for SVR training")

    # parser for the "build2" command
    subparser_build2.add_argument("input_fn", type=str,
            help="barcode counts file in a element-tag-count format")
    subparser_build2.add_argument("-n", "--name", type=str, required=True,
            help="name of output prefix. REQUIRED")
    subparser_build2.add_argument("-m", "--min-dna-read-cnts", type=int, default=200,
            help="minimum DNA tag read counts for SVR training")
    subparser_build2.add_argument("-t", "--min-num-tags", type=int, default=5,
            help="minimum number of tags per element for SVR training")
    subparser_build2.add_argument("-l", "--left-flanking-seq", type=str, default=None,
            help="left flanking sequence (5') of tags for SVR training")
    subparser_build2.add_argument("-r", "--right-flanking-seq", type=str, default=None,
            help="right flanking sequence (3') of tags for SVR training")

    # parser for the "train" command
    subparser_train.add_argument("-n", "--name", type=str, required=True,
            help="prefix used in 'build' command for training data set. this will also be used for output prefix. REQUIRED")
    subparser_train.add_argument("-L", "--full-word-length", type=int, default=8,
            help="full word length including gaps, 3<=L<=12")
    subparser_train.add_argument("-k", "--non-gap-length", type=int, default=4,
            help="number of non-gap positions, k<=L")
    subparser_train.add_argument("-d", "--max-num-gaps", type=int, default=4,
            help="maximum number of gaps allowed, d<=min(4, L-k)")
    subparser_train.add_argument("-R", "--use-revcomp", action='store_true',
            help="if set, reverse-complement tag sequences are also used")
    subparser_train.add_argument("-C", "--regularization", type=float, default=0.1,
            help="regularization parameter C")
    subparser_train.add_argument("-p", "--epsilon", type=float, default=0.1,
            help="epsilon in loss function of SVR")
    subparser_train.add_argument("-e", "--precision", type=float, default=0.001,
            help="precision parameter")
    subparser_train.add_argument("-M", "--cache-size", type=float, default=512,
            help="cache memory size in MB")
    subparser_train.add_argument("-x", "--cv", type=int, default=5,
            help="x-fold cross validation for estimating effects of tags in training set")
    subparser_train.add_argument("-i", "--icv", type=int, default=0,
            help="run i'th x-fold cross validation only (1~x) for parallization. This only works with -S option 1 and 2.")
    subparser_train.add_argument("-S", "--step", type=int, default=0,
            help="run specific step only. (0:run-all(default), 1:1st CV, 2:adjust expression, 3:2nd CV, 4:build-full model, 5:score excluded tags, 6:calc. norm factors)")
    subparser_train.add_argument("-s", "--random-seeds", type=int, default=1,
            help="random seed number for reproducibility of cross-validation")
    subparser_train.add_argument("-r", "--repeats", type=int, default=1,
            help="number of repeats of CV training to reduce random variation")
    subparser_train.add_argument("-T", "--threads", type=int, default=1,
            help="number of threads for SVR training; 1, 4, or 16")

    # parser for the "predict" command
    subparser_predict.add_argument("input_fn", type=str,
            help="input sequence file for scoring")
    subparser_predict.add_argument("output_fn", type=str,
            help="output file name")

    subparser_predict.add_argument("-n", "--name", type=str, required=True,
            help="prefix used in 'build/train' command for training data set. REQUIRED")
    subparser_predict.add_argument("-T", "--threads", type=int, default=1,
            help="number of threads for scoring; 1, 4, or 16")

    # parser for the "normalize" command
    subparser_normalize.add_argument("mrna_cnt_fn", type=str,
            help="mRNA read counts file for normalization")
    subparser_normalize.add_argument("tag_seq_fn", type=str,
            help="tag sequences file")
    subparser_normalize.add_argument("output_fn", type=str,
            help="output file name for normalized mRNA read counts")

    subparser_normalize.add_argument("-n", "--name", type=str, required=True,
            help="prefix used in 'build/train' command for training data set. REQUIRED")
    subparser_normalize.add_argument("-l", "--left-flanking-seq", type=str, default=None,
            help="left flanking sequence (5') of tags used for SVR training")
    subparser_normalize.add_argument("-r", "--right-flanking-seq", type=str, default=None,
            help="right flanking sequence (3') of tags used for SVR training")

    # parser for the "normalize2" command
    subparser_normalize2.add_argument("input_fn", type=str,
            help="barcode counts file in a element-tag-count format")
    subparser_normalize2.add_argument("output_fn", type=str,
            help="output file name for normalized mRNA read counts")

    subparser_normalize2.add_argument("-n", "--name", type=str, required=True,
            help="name of output prefix. REQUIRED")
    subparser_normalize2.add_argument("-l", "--left-flanking-seq", type=str, default=None,
            help="left flanking sequence (5') of tags for SVR training")
    subparser_normalize2.add_argument("-r", "--right-flanking-seq", type=str, default=None,
            help="right flanking sequence (3') of tags for SVR training")

    args = parser.parse_args()

    # compatible with clog format..
    logfmt_str = '%(levelname)s %(asctime)s: %(message)s'
    datefmt_str = '%Y-%m-%d %H:%M:%S'

    logging.basicConfig(stream=sys.stdout,
            format=logfmt_str, datefmt=datefmt_str,
            level=logging.INFO)

    HEADER += "\n# Command line:" + ' '.join(sys.argv)
    HEADER += "\n# Optional parameters:"
    if args.commands == "build":
        HEADER += "\n#   EXP_NAME={0}".format(args.name)
        HEADER += "\n#   MIN_DNA_READ_CNTS={0}".format(args.min_dna_read_cnts)
        HEADER += "\n#   MIN_NUM_TAGS={0}".format(args.min_num_tags)
        HEADER += "\n#   LEFT_FLANKING_SEQ={0}".format(args.left_flanking_seq)
        HEADER += "\n#   RIGHT_FLANKING_SEQ={0}".format(args.right_flanking_seq)

    if args.commands == "build2":
        HEADER += "\n#   EXP_NAME={0}".format(args.name)
        HEADER += "\n#   MIN_DNA_READ_CNTS={0}".format(args.min_dna_read_cnts)
        HEADER += "\n#   MIN_NUM_TAGS={0}".format(args.min_num_tags)
        HEADER += "\n#   LEFT_FLANKING_SEQ={0}".format(args.left_flanking_seq)
        HEADER += "\n#   RIGHT_FLANKING_SEQ={0}".format(args.right_flanking_seq)

    if args.commands == "train":
        HEADER += "\n#   EXP_NAME={0}".format(args.name)
        HEADER += "\n#   FULL_WORD_LENGTH={0}".format(args.full_word_length)
        HEADER += "\n#   NON_GAP_LENGTH={0}".format(args.non_gap_length)
        HEADER += "\n#   MAX_NUM_GAPS={0}".format(args.max_num_gaps)
        HEADER += "\n#   USE_REVCOMP={0}".format(True if args.use_revcomp else False)
        HEADER += "\n#   REGULARIZATION={0}".format(args.regularization)
        HEADER += "\n#   EPSILON={0}".format(args.epsilon)
        HEADER += "\n#   PRECISION={0}".format(args.precision)
        HEADER += "\n#   CACHE_SIZE={0}".format(args.cache_size)
        HEADER += "\n#   CV={0}".format(args.cv)
        HEADER += "\n#   RANDOM_SEEDS={0}".format(args.random_seeds)
        HEADER += "\n#   NUM_THREADS={0}".format(args.threads)
        HEADER += "\n#   CV_REPEATS={0}".format(args.repeats)

    if args.commands == "predict":
        HEADER += "\n#   EXP_NAME={0}".format(args.name)
        HEADER += "\n#   NUM_THREADS={0}".format(args.threads)
        
    if args.commands == "normalize":
        HEADER += "\n#   EXP_NAME={0}".format(args.name)
        HEADER += "\n#   LEFT_FLANKING_SEQ={0}".format(args.left_flanking_seq)
        HEADER += "\n#   RIGHT_FLANKING_SEQ={0}".format(args.right_flanking_seq)

    logging.info(HEADER)

    # input/output files
    TTAGFILE = args.name + ".tag_rexpr.txt"
    TTAG_ADJ_FILE = args.name + ".tag_rexpr_adj.txt"
    RTAGFILE = args.name + ".excluded_tags.txt"
    MODELFILE = args.name + ".adj.model.txt" # model trained on adjusted data`
    RTAGSCOREFILE = args.name + ".excluded_tags.score.txt"
    CVFILE = args.name + ".cv.txt"

    if args.commands == "build":
        logging.info("### build training data")
        build_training_data(args, TTAGFILE, RTAGFILE)

    if args.commands == "build2":
        logging.info("### build training data")
        build2_training_data(args, TTAGFILE, RTAGFILE)

    if args.commands == "train":
        # assuming that libmtsa.so is in the same directory as mtsa.py
        dll_name = os.path.join(os.path.dirname(__file__), "libmtsa.so")
        libmtsa=CDLL(dll_name)

        tdfile=c_char_p(TTAGFILE.encode('utf-8'))
        outprefix=c_char_p(args.name.encode('utf-8'))
        nthreads = c_int(args.threads)
        rseed = c_int(args.random_seeds)
        L = c_int(args.full_word_length)
        k = c_int(args.non_gap_length)
        d = c_int(args.max_num_gaps)
        norc = c_int(0) if args.use_revcomp else c_int(1)
        Cp = c_double(args.regularization)
        p = c_double(args.epsilon)
        eps = c_double(args.precision)
        ncv = c_int(args.cv)
        icv = c_int(args.icv)
        cache_size = c_double(args.cache_size)
        adj_tdfile=c_char_p(TTAG_ADJ_FILE.encode('utf-8'))
        outprefix_adj = c_char_p((args.name + ".adj").encode('utf-8'))

        libmtsa.mtsa_init(2, nthreads)

        if args.step == 0 or args.step == 1:
            logging.info("### 1. perform initial cross-validation")
            libmtsa.mtsa_train_main(tdfile, outprefix, rseed,
                    L, k, d, norc, Cp, p, eps, ncv, icv, cache_size)

        if args.step == 0 or args.step == 2:
            logging.info("### 2. adjusting expression based on the CV")
            adjust_tag_group_effect(TTAGFILE, CVFILE, TTAG_ADJ_FILE, ncv)

        if args.step == 0 or args.step == 3:
            logging.info("### 3. perform second cross-validation(s) with adjusted exprs")
            if not os.path.isfile(TTAG_ADJ_FILE):
                logging.error("%s does not exist. quit.", TTAG_ADJ_FILE)
                sys.exit(0)

            logging.info("repeat cross-valiations %d time(s)", args.repeats)
            #repeat cross validation with different random seeds
            for i in range(args.repeats):
                logging.info("repeated cross-valiation #%d", i+1)
                outprefix_adj_i = c_char_p((args.name + ".adj." + str(i)).encode('utf-8'))
                rseed = c_int(args.random_seeds+i)
                libmtsa.mtsa_train_main(adj_tdfile, outprefix_adj_i, rseed,
                        L, k, d, norc, Cp, p, eps, ncv, icv, cache_size)

        if args.step == 0 or args.step == 4:
            logging.info("### 4. build a model using all data")
            if not os.path.isfile(TTAG_ADJ_FILE):
                logging.error("%s does not exist. quit.", TTAG_ADJ_FILE)
                sys.exit(0)

            libmtsa.mtsa_train_main(adj_tdfile, outprefix_adj, rseed,
                    L, k, d, norc, Cp, p, eps, 0, 0, cache_size)

        if args.step == 0 or args.step == 5:
            logging.info("### 5. score excluded tags")
            if not os.path.isfile(MODELFILE):
                logging.error("%s does not exist. quit.", MODELFILE)
                sys.exit(0)

            testfile=c_char_p(RTAGFILE.encode('utf-8'))
            modelfile=c_char_p(MODELFILE.encode('utf-8'))
            outfile=c_char_p(RTAGSCOREFILE.encode('utf-8'))
            libmtsa.mtsa_predict_main(testfile, modelfile, outfile)

        if args.step == 0 or args.step == 6:
            logging.info("### 6. calculate the sequence factor for normalization")
            cal_tag_sequence_factor(args)

    if args.commands == "predict":
        dll_name = os.path.join(os.path.dirname(__file__), "libmtsa.so")
        libmtsa=CDLL(dll_name)

        nthreads = c_int(args.threads)
        libmtsa.mtsa_init(2, nthreads)

        logging.info("### score sequences using the trained model")

        testfile=c_char_p(args.input_fn.encode('utf-8'))
        modelfile=c_char_p(MODELFILE.encode('utf-8'))
        outfile=c_char_p(args.output_fn.encode('utf-8'))
        libmtsa.mtsa_predict_main(testfile, modelfile, outfile)

    if args.commands == "normalize":
        logging.info("### normalize mRNA count data")
        normalize_mrna_counts(args)

    if args.commands == "normalize2":
        logging.info("### normalize mRNA count data")
        normalize2_mrna_counts(args)

if __name__=='__main__':
    main()
