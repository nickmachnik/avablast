#!/usr/bin/env bash

DB=$1
FASTA=$2
N_JOBS=$3
OUT_DIR=$4

if [ $# -eq 0 ]
  then
    echo "No arguments supplied.
    Usage:
        all_vs_all_blast.sh <blast db name> <fasta path> <number of single jobs to run> <output directory>

    Where:
        fasta path: file from which db was created
    "
    exit 1
fi

if [ ! -d ./temp ]; then
    mkdir temp
fi
rm temp/*

if [ ! -d ./log ]; then
    mkdir log
fi

if [ ! -d ${OUT_DIR} ]; then
    mkdir ${OUT_DIR}
fi

./partition_fasta.py ${FASTA} `grep -c "^>" ${FASTA}` ${N_JOBS}

for i in $(seq ${N_JOBS});
do
    # submit blastp job
    cmd="blastp -outfmt 6 -query ./temp/partition_${i}.fasta -db ${DB} -out ${OUT_DIR}/${i} -num_threads=24"
    sed -i "s@verbose.*@verbose ${cmd}@" ./submit_blast.sh
    sed -i "s@job-name=.*@job-name=${i}_blast@" ./submit_blast.sh
    sed -i "s@log/.*@log/${i}@" ./submit_blast.sh
    sbatch submit_blast.sh
done
