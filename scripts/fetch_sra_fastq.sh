#!/usr/bin/env bash
set -euo pipefail

# usage: ./fetch_sra_fastq.sh SRR11518889 SRP255885
ACC="${1:?give SRR accession like SRR11518889}"
STUDY_ID="${2:-SRP_UNKNOWN}"

# conda activate in noninteractive shell
# if command -v conda >/dev/null 2>&1; then
#   eval "$(conda shell.bash hook)"
#   conda activate sra-tools
# elif command -v micromamba >/dev/null 2>&1; then
#   eval "$(micromamba shell hook -s bash)"
#   micromamba activate sra-tools
# else
#   echo "No conda or micromamba detected" >&2
#   exit 1
# fi

# destinations
FASTQ_DEST="../data/raw/fastq/${STUDY_ID}"
CACHE_DIR="${PWD}/sra_cache"
OUT_DIR="${FASTQ_DEST}"

mkdir -p "${CACHE_DIR}" "${OUT_DIR}"

# fast local scratch
export TMPDIR="${TMPDIR:-/scratch/${USER}}"
mkdir -p "${TMPDIR}"

# cache .sra
prefetch "${ACC}" --max-size 200G -O "${CACHE_DIR}" -p

# optional integrity check
SRA_PATH=$(find "${CACHE_DIR}" -type f -name "${ACC}*.sra" -print -quit || true)
if [[ -n "${SRA_PATH}" ]]; then
  vdb-validate "${SRA_PATH}"
fi

# dump to FASTQ in destination
# pass accession directly which will use the cached object
fasterq-dump "${ACC}" \
  --split-files --skip-technical -e 8 -p \
  --temp "${TMPDIR}" -O "${OUT_DIR}"

echo "FASTQ ready in ${OUT_DIR}"
ls -lh "${OUT_DIR}"/"${ACC}"_*.fastq.gz || true