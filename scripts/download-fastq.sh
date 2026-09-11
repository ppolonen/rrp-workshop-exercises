#!/bin/bash
set -euo pipefail

# This script downloads FASTQ files from a list of URLs provided in a text file.
#ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR115/089/SRR11518889/SRR11518889_1.fastq.gz
#ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR115/089/SRR11518889/SRR11518889_2.fastq.gz

dirname="~/git_home/rrp-workshop-exercises"
study_id="SRR11518889"
fastq_url='ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR115/089/SRR11518889/'
fastq_r1="SRR11518889_1.fastq.gz"
fastq_r2="SRR11518889_2.fastq.gz"

fastq_dir="${dirname}/data/raw/fastq/${study_id}"

cd "$(dirname "${BASH_SOURCE[0]}")"

# create output directory if it doesn't exist
mkdir -p "${fastq_dir}"

echo "Obtaining $fastq_r1"
curl -O "${fastq_url}${fastq_r1}" --output-dir "${fastq_dir}"
gunzip "${fastq_dir}/${fastq_r1}"

echo "Obtaining $fastq_r2"
curl -O "${fastq_url}${fastq_r2}" --output-dir "${fastq_dir}"
gunzip "${fastq_dir}/${fastq_r2}"

