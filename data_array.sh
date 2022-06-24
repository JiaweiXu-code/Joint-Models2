#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 2:00:00
#SBATCH --mem 7000
#SBATCH --output=./cluster-out/jm-%a.out
#SBATCH --error=./cluster-err/jm-%a.err
#SBATCH --array=1-10

## run R command
R CMD BATCH "--no-save --args $SLURM_ARRAY_TASK_ID" ./programs/data_gen.R ./cluster-logs/data-$SLURM_ARRAY_TASK_ID.Rout
R CMD BATCH "--no-save --args $SLURM_ARRAY_TASK_ID" ./programs/RE_php.R ./cluster-logs/php-$SLURM_ARRAY_TASK_ID.Rout
