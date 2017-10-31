#!/bin/env python

import sys
import gzip

def main():
    if len(sys.argv) != 2:
        print "Usage:", sys.argv[0], "barcode_design_file"
        sys.exit()

    elem_list = []
    tags_list = []
    fn=sys.argv[1]
    if fn[-2:] == "gz":
        fp = gzip.open(fn, 'r')
    else:
        fp = open(fn, 'r')

    for line in fp:
        f = line.strip().split('\t')
        elem = f[0]
        tags = f[1].split(',')
        elem_list.append(elem)
        tags_list.append(tags)
    fp.close()
    
    for i in xrange(len(elem_list)):
        #print '\t'.join( map(str, tags_list[i]) )
        print '\t'.join( [ elem_list[i] ] + map(str, tags_list[i]) )

if __name__ == "__main__":
    main()
