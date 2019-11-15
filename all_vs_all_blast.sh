#!/usr/bin/env bash

DB=$1
FASTA=$2

if [ $# -eq 0 ]
  then
    echo "No arguments supplied.
    Usage:
        all_vs_all_blast.sh <blast db name> <fasta path>

    Where:
        fasta path: file from which db was created
    "
    exit 1
fi

mkdir temp
mkdir out
echo -n > ./temp/neg_seqids

pos=0

while true; do
    pos=`./single_fasta_acc.py ${FASTA} ${pos}`
    currid=`grep '^>' ./temp/curr.fasta`
    currid="${currid//>}"
    # submit blastp job
    if [ "$pos" -eq 0 ]; then
        break
    fi
    # blastp -outfmt 6 -query ./temp/curr.fasta -db ${DB} -negative_seqidlist ./temp/neg_seqids -out ./out/${currid}
    time blastp -outfmt 6 -query ./temp/curr.fasta -db ${DB} -negative_seqidlist ./temp/neg_seqids
done


