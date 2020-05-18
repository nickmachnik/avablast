#!/bin/bash
#
#-------------------------------------------------------------
#example script for running a single-CPU serial job via SLURM
#-------------------------------------------------------------
#
#SBATCH --job-name=PROT_blast
#SBATCH --output=log/PROT
#
#Number of cores
#SBATCH -c 24
#
#Define the number of hours the job should run. 
#Maximum runtime is limited to 10 days, ie. 240 hours
#SBATCH --time=72:00:00
#
#Define the amount of RAM used by your job in GigaBytes
#SBATCH --mem 32Gb
#
####SBATCH --partition=bigtb
#SBATCH --partition=bigmem
#
#Send emails when a job starts, it is finished or it exits
#SBATCH --mail-user=NOPE
#SBATCH --mail-type=ALL
#
#Pick whether you prefer requeue or not. If you use the --requeue
#option, the requeued job script will start from the beginning, 
#potentially overwriting your previous progress, so be careful.
#For some people the --requeue option might be desired if their
#application will continue from the last state.
#Do not requeue the job in the case it fails.
#SBATCH --no-requeue
#
#Do not export the local environment to the compute nodes
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV
#
#
#load the respective software module you intend to use
module load python/3.8.2
module load ncbi-blast/2.10.0+
#
#
#run the respective binary through SLURM's srun
srun --cpu_bind=verbose C
