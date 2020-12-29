#!/bin/env python

import sys
import gzip

def main():
    if len(sys.argv) != 4:
        print("Usage:", sys.argv[0], "tag_file count_file column_name(s)")
        sys.exit()

    tagfn = sys.argv[1]

    elem_list = []
    tag_num_per_elem = 0
    fp = open(tagfn, 'r')
    for line in fp:
        f = line.strip().split('\t')
        tag_num_per_elem = len(f) - 1
        elem_list.append(f[0])
    fp.close()

    countfn = sys.argv[2]
    if countfn[-2:] == "gz":
        fp = gzip.open(countfn, 'rt')
    else:
        fp = open(countfn, 'rt')

    header = fp.readline().strip().split('\t')
    column_names = sys.argv[3].strip().split(',')
    column_inds = []
    for cn in column_names:
        for hind in range(len(header)):
            if header[hind] == cn:
                column_inds.append(hind)
                break

    elemnum = 0
    tagnum =  0
    tagcnts = []
    cnts_list = []
    for line in fp:
        f = line.strip().split('\t')
        chr_str=f[0]
        pos=f[1]
        ref=f[2]
        alt=f[3]
        type_str=f[4]
        bot=f[5]
        top=f[6]
        clean=f[7]

        if clean == "var":
            elemid = '_'.join([':'.join([chr_str, pos, ref, alt]), type_str, "Bot", bot, "Top", top])
        else:
            elemid = '_'.join([':'.join([chr_str, pos, ref, alt]), type_str, "Bot", bot, "Top", top, clean])

        if elem_list[elemnum] != elemid:
            sys.stderr.write("ERROR: element ids do not match at line %d (%s =/= %s)\n" % (elemnum, elem_list[elemnum], elemid))
            sys.exit()

        cnt = 0
        for ind in column_inds:
            cnt += int(f[ind])

        tagcnts.append(cnt)

        tagnum += 1
        if tagnum == tag_num_per_elem:
            cnts_list.append(tagcnts)
            tagcnts = []
            tagnum = 0
            elemnum += 1
        
    fp.close()
    
    for i in range(len(elem_list)):
        print('\t'.join( [ elem_list[i] ] + list(map(str, cnts_list[i])) ))
        #print '\t'.join( map(str, cnts_list[i]) )

if __name__ == "__main__":
    main()
