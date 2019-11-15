#!/usr/bin/env python

import gzip
import sys

def main():
    """
    Return the next fasta entry given a bytes index.
    """
    assert len(sys.argv) == 3, """
        Usage: all_vs_all_blastp.py <path to fasta file> <last index>
    """
    header, seq, position = get_next_fasta_entry(sys.argv[1], int(sys.argv[2]))
    print(position)
    with open('./temp/neg_seqids', 'a') as fout:
        fout.write('>' + header + '\n')
    with open('./temp/curr.fasta', 'w') as fout:
        fout.write('>' + header + '\n')
        fout.write(seq + '\n')

    


def get_next_fasta_entry(path, start=0):
    if path.endswith('gz'):
        o = gzip.open
        mode = 'rt'
    else:
        o = open
        mode = 'r'
    with o(path, mode) as fin:
        seq = ""
        header = None
        fin.seek(start)
        line = fin.readline()
        last_index = 0
        while True:
            if line == '':
                return (header, seq, 0)
            elif header != None and line.startswith('>'):
                return (header, seq, last_index)
            elif line.startswith('>'):
                header = line.strip()[1:]
            else:
                seq += line.strip()
            last_index = fin.tell()
            line = fin.readline()


if __name__ == '__main__':
    main()