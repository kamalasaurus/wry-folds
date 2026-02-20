#!/bin/bash
#SBATCH --job-name=nlr-inference
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --constraint=h200
#SBATCH --mem=60GB
#SBATCH --time=10:00:00
#SBATCH --account=torch_pr_121_general
#SBATCH --output=/scratch/kr3059/nlr-lrr-folds/gpu_logs/%A.out

set -euo pipefail

# Inputs list file; override with SBATCH arg: --export=LIST=/path/to/list.txt
LIST=${LIST:-/scratch/kr3059/nlr-lrr-folds/inference_list.txt}
OUT_ROOT=${OUT_ROOT:-/scratch/kr3059/nlr-lrr-folds/inference_output}
LOG_ROOT=${LOG_ROOT:-/scratch/kr3059/nlr-lrr-folds/gpu_logs}

echo "Processing list: $LIST"
mkdir -p "$OUT_ROOT" "$LOG_ROOT"

idx=0
while IFS= read -r JSON_PATH; do
    [[ -z "$JSON_PATH" ]] && continue
    idx=$((idx+1))
    echo "[$idx] Running inference for: $JSON_PATH"

    outdir="$OUT_ROOT/$idx"
    mkdir -p "$outdir"

    /share/apps/af3/3.0.1/run-af3-inference.bash \
            --json_path="$JSON_PATH" \
            --output_dir="$outdir" \
            --run_data_pipeline=false \
            --run_inference=true
done < "$LIST"

