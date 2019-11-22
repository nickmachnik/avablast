#!/usr/bin/env python

import sys
import gzip


def main():
    assert len(sys.argv) == 5, """
    Usage:
        partition_fasta.py <path to fasta> <path to temp> <number of fasta entries in input> <number of partitions>
    """
    fasta_parser = parse_fasta(sys.argv[1])
    output_path = sys.argv[2]
    fasta_len, n_partitions = [int(e) for e in sys.argv[3:]]
    
    partition_size = int(fasta_len / n_partitions)
    
    partition = 0
    fout = None
    for parsed, (h, s) in enumerate(fasta_parser):
        if parsed % partition_size == 0:
            if partition != n_partitions:
                partition += 1
                if fout is not None:
                    fout.close()
                fout = open('{}/partition_{}.fasta'.format(output_path, partition), 'w')
        fout.write(h + '\n')
        fout.write(s + '\n')
    fout.close()


def parse_fasta(path):
    """
    Return (header, sequence) in fasta.
    """
    if path.endswith('.gz'):
        o, mode = gzip.open, 'rt'
    else:
        o, mode = open, 'r'
    with o(path, mode) as fin:
        first_header = False
        seq = ''
        for line in fin:
            if line.startswith('>'):
                header = line.strip()
                if first_header:
                    yield (header, seq)
                    seq = ''
                else:
                    first_header = True
            else:
                seq += line.strip()
        yield (header, seq)


if __name__ == '__main__':
    main()