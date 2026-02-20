#!/bin/bash
#SBATCH --job-name=wrkys_msa
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=120GB
#SBATCH --time=36:00:00
#SBATCH --array=0-36
#SBATCH --account=torch_pr_121_general
#SBATCH --output=/scratch/kr3059/wrky-folds/logs/%A_%a.out

BATCH_FILE=$(printf "/scratch/kr3059/wrky-folds/input/batch_%03d.json" $SLURM_ARRAY_TASK_ID)

outdir=/scratch/kr3059/wrky-folds/output/msa_${SLURM_ARRAY_TASK_ID}
mkdir -p $outdir

echo "Running batch: $BATCH_FILE"

/share/apps/af3/3.0.1/run-af3-pipeline.bash \
  --json_path="$BATCH_FILE" \
  --output_dir=$outdir \
  --run_data_pipeline=true \
  --run_inference=false
