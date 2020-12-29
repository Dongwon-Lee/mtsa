#!/bin/env python

import sys
import gzip

def main():
    if len(sys.argv) < 2:
        print("Usage:", sys.argv[0], "design_file")
        sys.exit()

    fn = sys.argv[1]
    elem_list = []

    if fn[-2:] == "gz":
        fp = gzip.open(fn, 'rt')
    else:
        fp = open(fn, 'rt')

    linecnt = 0 
    elem_list = []
    elem_tags = dict()
    for line in fp:
        f = line.strip().split('\t')
        elem = f[0]
        seq = f[1]

        elemid = ':'.join(elem.split(':')[:-1])
        tagnum = int(elem.split(':')[-1]) - 1
        tagseq = seq[200:(200+15)]

        if elemid not in elem_tags:
            elem_list.append(elemid)
            elem_tags[elemid] = ['']*100
        
        elem_tags[elemid][tagnum] = tagseq
    fp.close()
    
    for i in range(len(elem_list)):
        tags = elem_tags[elem_list[i]]
        print('\t'.join( [ elem_list[i] ] + tags ))
        #print '\t'.join( tags )

if __name__ == "__main__":
    main()
