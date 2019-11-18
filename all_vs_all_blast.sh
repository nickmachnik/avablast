#!/usr/bin/env bash

DB=$1
FASTA=$2
N_JOBS=$3

if [ $# -eq 0 ]
  then
    echo "No arguments supplied.
    Usage:
        all_vs_all_blast.sh <blast db name> <fasta path> <number of single jobs to run>

    Where:
        fasta path: file from which db was created
    "
    exit 1
fi

if [ ! -d ./temp ]; then
    mkdir temp
fi
rm temp/*

if [ ! -d ./out ]; then
    mkdir out
fi

if [ ! -d ./log ]; then
    mkdir log
fi

./partition_fasta.py ${FASTA} `grep -c "^>" ${FASTA}` ${N_JOBS}

for i in $(seq ${N_JOBS});
do
    # submit blastp job
    cmd="blastp -outfmt 6 -query ./temp/partition_${i}.fasta -db ${DB} -out ./out/${i} -num_threads=24"
    sed -i "s@verbose.*@verbose ${cmd}@" ./submit_blast.sh
    sed -i "s@job-name=.*@job-name=${i}_blast@" ./submit_blast.sh
    sed -i "s@log/.*@log/${i}@" ./submit_blast.sh
    sbatch submit_blast.sh
done

# while true; do
    

#     if [ "$pos" -eq 0 ]; then
#         break
#     fi
#     cmd="blastp -outfmt 6 -query ./temp/curr.fasta -db ${DB} -negative_seqidlist ./temp/neg_seqids -out ./out/${currid} -num_threads=24"
#     sed -i "s@verbose.*@verbose ${cmd}@" ./submit_blast.sh
#     sed -i "s@job-name=.*@job-name=${currid}_blast@" ./submit_blast.sh
#     sed -i "s@log/.*@log/${currid}@" ./submit_blast.sh
#     while [ `squeue -u nmachnik | wc -l` -ge 100 ]; do
#         sleep 10
#     done
#     sbatch submit_blast.sh
#     # time blastp -outfmt 6 -query ./temp/curr.fasta -db ${DB} -negative_seqidlist ./temp/neg_seqids
# done