#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=cache
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=4:00:00
#SBATCH --mem=10G
#SBATCH --output=log-%x-%A.out

set -euo pipefail

# Repositories
REPOS=("{{cookiecutter.package_name}}")

if [[ -z "${PIXI_CACHE_DIR:-}" ]]; then
    echo "ERROR: PIXI_CACHE_DIR is not set."
    echo
    echo "Please add the following to your ~/.bashrc:"
    echo
    echo "export PIXI_CACHE_DIR=/scratch/\$USER/pixi-cache" >&2
    echo "mkdir -p \$PIXI_CACHE_DIR" >&2
    echo
    exit 1
fi

# Directories
ORIG_DIR=$SLURM_SUBMIT_DIR
WORK_DIR=/lscratch/$USER/pixi-work-$SLURM_JOB_ID
ORIG_CACHE_DIR=$PIXI_CACHE_DIR
WORK_CACHE_DIR=/lscratch/$USER/pixi-cache-tmp-$SLURM_JOB_ID

echo "=== Directories ==="
echo "ORIG_DIR        = $ORIG_DIR"
echo "WORK_DIR        = $WORK_DIR"
echo "ORIG_CACHE_DIR  = $ORIG_CACHE_DIR"
echo "WORK_CACHE_DIR  = $WORK_CACHE_DIR"
echo "================================"

# Check that the required repository directories exist
for repo in "${REPOS[@]}"; do
    if [[ ! -d "$ORIG_DIR/$repo" ]]; then
        echo "ERROR: Required repository directory missing!" >&2
        echo "Path not found: $ORIG_DIR/$repo" >&2
        exit 1
    fi
done

mkdir -p "$ORIG_CACHE_DIR"
mkdir -p "$WORK_CACHE_DIR"
mkdir -p "$WORK_DIR"

echo "=== Step 1/5: Sync cache to lscratch ==="
time rsync -a "$ORIG_CACHE_DIR/" "$WORK_CACHE_DIR/"
export PIXI_CACHE_DIR="$WORK_CACHE_DIR"

echo "=== Step 2/5: Sync each repository to lscratch (excluding .git) ==="
for repo in "${REPOS[@]}"; do
    echo "--- Syncing $repo ---"
    time rsync -a --exclude='.git/' "$ORIG_DIR/$repo/" "$WORK_DIR/$repo/"
done

echo "=== Step 3/5: pixi install ==="
for repo in "${REPOS[@]}"; do
    echo "--- Installing $repo ---"
    (
        cd "$WORK_DIR/$repo"
        time pixi install -v
    )
done

echo "=== Step 4/5: pixi install (dev) ==="
for repo in "${REPOS[@]}"; do
    echo "--- Installing (dev) $repo ---"
    (
        cd "$WORK_DIR/$repo"
        time pixi install -e dev -v
    )
done

echo "=== Step 5/5: Sync cache back ==="
time rsync -a "$WORK_CACHE_DIR/" "$ORIG_CACHE_DIR/"

echo "=== Cleanup ==="
time rm -rf "$WORK_CACHE_DIR"
