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

if [ ! -d ${OUT_DIR} ]; then
    mkdir ${OUT_DIR}
fi

if [ ! -d ${OUT_DIR}/results ]; then
    mkdir ${OUT_DIR}/results
fi
rm ${OUT_DIR}/results/*

if [ ! -d ${OUT_DIR}/temp ]; then
    mkdir ${OUT_DIR}/temp
fi
rm ${OUT_DIR}/temp/*

if [ ! -d ${OUT_DIR}/log ]; then
    mkdir ${OUT_DIR}/log
fi
rm ${OUT_DIR}/log/*

./partition_fasta.py ${FASTA} ${OUT_DIR}/temp `grep -c "^>" ${FASTA}` ${N_JOBS}

for i in $(seq ${N_JOBS});
do
    # submit blastp job
    cmd="blastp -outfmt 6 -query ${OUT_DIR}/temp/partition_${i}.fasta -db ${DB} -out ${OUT_DIR}/results/${i} -num_threads=24"
    sed -i "s@verbose.*@verbose ${cmd}@" ./submit_blast.sh
    sed -i "s@job-name=.*@job-name=${i}_blast@" ./submit_blast.sh
    sed -i "s@#SBATCH --output=.*@#SBATCH --output=${OUT_DIR}/log/${i}@" ./submit_blast.sh
    # sbatch submit_blast.sh
done
