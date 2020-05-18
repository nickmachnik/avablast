#!/usr/bin/env bash

DB=$1
FASTA=$2
N_JOBS=$3
NUM_THREADS=$4
OUT_DIR=$5

if [ $# -ne 5 ]
  then
    echo "No arguments supplied.
    Usage:
        all_vs_all_blast.sh <blast db name> <fasta path> <number of single jobs to run> <number of threads per job> <output directory> 

    Where:
        fasta path: file from which db was created
    "
    exit 1
fi

# get the scripts location
BASELOC="$(dirname "$(readlink -f "$0")")"

if [ ! -d "${OUT_DIR}" ]; then
    mkdir "${OUT_DIR}"
fi

# make or empty subdirectories for the output directory
for SUBDIR in results temp log jobs;
do
    if [ ! -d "${OUT_DIR}"/"$SUBDIR" ]; then
        mkdir "${OUT_DIR}"/"$SUBDIR"
    fi
    rm "${OUT_DIR}"/"$SUBDIR"/*
done

# partition the input fasta in equally sized chunks
"$BASELOC"/partition_fasta.py "${FASTA}" "${OUT_DIR}"/temp "$(grep -c "^>" "${FASTA}")" "${N_JOBS}"

for i in $(seq "${N_JOBS}");
do
    JOB_SCRIPT="$OUT_DIR"/jobs/submit_"$i".sh
    # make sbatch script copy for this job
    cp "$BASELOC"/submit_blast.sh "$JOB_SCRIPT"
    
    # submit blastp job
    cmd="blastp -outfmt 6 -query ${OUT_DIR}/temp/partition_${i}.fasta -db ${DB} -out ${OUT_DIR}/results/${i} -num_threads=${NUM_THREADS}"
    sed -i "s@verbose.*@verbose ${cmd}@" "$JOB_SCRIPT"
    sed -i "s@job-name=.*@job-name=${i}_blast@" "$JOB_SCRIPT"
    sed -i "s@#SBATCH --output=.*@#SBATCH --output=${OUT_DIR}/log/${i}@" "$JOB_SCRIPT"
    sed -i "s@#SBATCH -c 24.*@#SBATCH -c ${NUM_THREADS}@" "$JOB_SCRIPT"
    sbatch "$JOB_SCRIPT"
done
