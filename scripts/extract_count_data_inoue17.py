#!/bin/env python

import sys
import gzip

def main():
    if len(sys.argv) < 2:
        print("Usage:", sys.argv[0], "tagfile file1 [file2 [file3 ...]]")
        sys.exit()

    tagfn = sys.argv[1]

    elem_list = []
    tags_list = []
    cnts_list = []
    elemid2num = dict()

    fp = open(tagfn, 'r')
    linecnt = 0 
    for line in fp:
        f = line.strip().split('\t')
        elem_list.append(f[0])
        tags_list.append(f[1:])
        cnts_list.append([0]*len(f[1:]))
        elemid2num[f[0]] = linecnt
        linecnt += 1
    fp.close()

    for fn in sys.argv[2:]:
        if fn[-2:] == "gz":
            fp = gzip.open(fn, 'rt')
        else:
            fp = open(fn, 'rt')

        for line in fp:
            f = line.strip().split('\t')
            tagseq = f[0]
            tagcnt = int(f[1])
            elem = f[2]

            elemid = ':'.join(elem.split(':')[:-1])
            tagnum = int(elem.split(':')[-1]) - 1

            elem_no = elemid2num[elemid] 
            if tags_list[elem_no][tagnum] != tagseq:
                sys.stderr.write("ERROR: tag sequences do not match at line %d (%s =/= %s)\n" % (linecnt, tags_list[elem_no][tagnum], tagseq))
                sys.exit()

            cnts_list[elem_no][tagnum] += tagcnt
            linecnt+=1
        fp.close()
    
    for i in range(len(elem_list)):
        print('\t'.join( [ elem_list[i] ] + list(map(str, cnts_list[i]) )))
        #print '\t'.join( map(str, cnts_list[i]) )

if __name__ == "__main__":
    main()
