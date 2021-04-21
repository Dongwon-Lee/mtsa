import sys

def main(args = sys.argv):
    dat_fn = sys.argv[1]
    out_tr_fn = sys.argv[2]
    out_tag1_fn = sys.argv[3]
    out_tag2_fn = sys.argv[4]
    
    cre1 = dict()
    cre2 = dict()
    fp = open(dat_fn, 'rt')
    out_fp1 = open(out_tr_fn, 'wt')
    out_fp2 = open(out_tag1_fn, 'wt')
    out_fp3 = open(out_tag2_fn, 'wt')
    for line in fp:
        f = line.strip().split('\t')
        elemid = f[0]
        if elemid not in cre1:
            tags_printed = False
            cre1[elemid] = line
            continue
        elif elemid not in cre2:
            tags_printed = False
            cre2[elemid] = line 
            continue
        else:
            out_fp1.write(line)
            if not tags_printed:
                out_fp2.write(cre1[elemid])
                out_fp3.write(cre2[elemid])
                tags_printed = True

    out_fp1.close()
    out_fp2.close()
    out_fp3.close()
    fp.close()


if __name__ == "__main__":
    main()
