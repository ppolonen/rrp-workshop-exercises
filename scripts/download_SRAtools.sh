#!/bin/bash
set -euo pipefail

# 0) If needed, install via conda
# conda create -n sra-tools -y -c bioconda sra-tools && conda activate sra-tools
# conda activate sra-tools

# Set the working directory to the directory of this file
cd "$(dirname "${BASH_SOURCE[0]}")"

# Define study ID
study_id="SRP255885"

# Define and create destination directory for FASTQ files to live in
fastq_dest="../data/raw/fastq/$study_id/"
mkdir -p $fastq_dest

# 1) Workspace and cache
mkdir -p ~/sra_cache ./fastq && export NCBI_SETTINGS=./ncbi_user.settings
vdb-config --prefetch-to-cwd yes 2>/dev/null || true

# 2) Prefetch the .sra (uses HTTPS mirrors; resume-safe)
prefetch SRR11518889 --max-size 200G --output-directory ./sra_cache

# 4) Convert to FASTQ
# --split-files splits paired-end, --skip-technical drops technical reads, -e threads, -p progress
fasterq-dump ./sra_cache/${study_id}SRR11518889.sra \
  --split-files --skip-technical -e 8 -p -O ./fastq

# 5) Move files to output folder:
mv ./fastq/SRR11518889*.fastq.gz $fastq_dest
