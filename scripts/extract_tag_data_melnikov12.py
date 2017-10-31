#!/bin/env python

import sys
import gzip

def main():
    if len(sys.argv) < 2:
        print "Usage:", sys.argv[0], "file1 [file2 [file3 ...]]"
        sys.exit()

    elem_list = []
    tags_list = []
    first_file = True
    for fn in sys.argv[1:]:
        if fn[-2:] == "gz":
            fp = gzip.open(fn, 'r')
        else:
            fp = open(fn, 'r')

        fp.readline() # throw out header...

        linecnt = 0 
        for line in fp:
            f = line.strip().split('\t')
            elem = f[0]
            tags = f[2].split(',')
            cnts = map(int, f[3].split(','))
            if first_file:
                elem_list.append(elem)
                tags_list.append(tags)
            else:
                if elem != elem_list[linecnt]:
                    sys.stderr.write("ERROR: Element IDs do not match at line %d (%s =/= %s)\n" % (linecnt, elem, elem_list[linecnt]))
                    sys.exit()
                for i in xrange(len(tags_list[linecnt])):
                    if tags_list[linecnt][i] != tags[i]:
                        sys.stderr.write("ERROR: tags do not match at (%d,%d) (%s =/= %s)\n" % (linecnt, i, tags[i], tags_list[linecnt][i]))
                        sys.exit()
            linecnt+=1
        fp.close()
        first_file = False
    
    for i in xrange(len(elem_list)):
        #print '\t'.join( map(str, tags_list[i]) )
        print '\t'.join( [ elem_list[i] ] + map(str, tags_list[i]) )

if __name__ == "__main__":
    main()
