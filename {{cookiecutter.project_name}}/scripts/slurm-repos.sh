#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=repos
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=4:00:00
#SBATCH --mem=10G
#SBATCH --array=0-0
#SBATCH --output=log-%x-%A_%a.out

set -euo pipefail

# Repositories
REPOS=("{{cookiecutter.package_name}}")
REPO="${REPOS[$SLURM_ARRAY_TASK_ID]}"

# Directories
WORK_DIR=$SLURM_SUBMIT_DIR

echo "=== Job Info ==="
echo "TASK_ID        = $SLURM_ARRAY_TASK_ID"
echo "REPO           = $REPO"
echo "WORK_DIR       = $WORK_DIR"
echo "PIXI_CACHE_DIR = $PIXI_CACHE_DIR"
echo "==============================="

# Check that the required repository directories exist
for repo in "${REPOS[@]}"; do
    if [[ ! -d "$WORK_DIR/$repo" ]]; then
        echo "ERROR: Required repository directory missing!" >&2
        echo "Path not found: $WORK_DIR/$repo" >&2
        exit 1
    fi
done

cd "$WORK_DIR/$REPO"

echo "=== Step 1/4 ($REPO): pixi install started ==="
time pixi install

echo "=== Step 2/4 ($REPO): pixi install -e dev ==="
time pixi install -e dev

echo "=== Step 3/4 ($REPO): prepare local environment ==="
time (
    pixi run local start
    pixi run python -c "import automol; print(automol.__file__)"
    pixi run -e dev python -c "import automol; print(automol.__file__)"
)

echo "=== Step 4/4 ($REPO): restore original environment ==="
time (
    pixi run local stop
    pixi run python -c "import automol; print(automol.__file__)"
    pixi run -e dev python -c "import automol; print(automol.__file__)"
)
