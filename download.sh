#!/bin/bash

# PATH WORK DIR
p_sra="/mnt/rdisk/duydao/SCRNA/PANCREAS_DATA/DATA/SRA"
p_raw="/mnt/rdisk/duydao/SCRNA/PANCREAS_DATA/DATA/RAW"

# Query SRA list by PRJNA
## INPUT A SERIES
series="GSE114454"

## Make a directory for SRA in series
mkdir -p ${p_sra}/${series}/

## Query 3 SRRs in SRA to create list
esearch -db bioproject -query ${series} | efetch -format xml | \
awk '{match($0, /<ArchiveID accession="(.*)" archive/, a); if (a[1]) print a[1]}' | \
xargs -I {} bash -c 'esearch -db sra -query {} | efetch -format runinfo | awk '\''BEGIN {RS=","; ORS="\t"} {print}'\'' | awk '\''BEGIN {FS=OFS="\t"} NR > 1 {if ($1 != "") print $1}'\''' | \
head -n3 > ${p_sra}/${series}/${series}_List.txt

# Download fastq files
## This will download SRA files and split the fastq files.
for sra_acc in $(cat $p_sra/$series/${series}_List.txt); do

    # Get the SRA
    echo "--- Processing SRA file for $sra_acc ---"
    echo "Loading..."
    prefetch -v $sra_acc --output-directory $p_sra/$series/
    echo " "
    echo "--- $sra_acc SRA file downloaded ---"

    # Download fastq file
    echo "--- Processing FASTQ files for $sra_acc ---"
    echo "Loading..."
    fastq-dump \
    --outdir ${p_raw}/${series}/ \
    --split-files ${p_sra}/${series}/${sra_acc}/${sra_acc}.sra \
    && gzip -f ${p_raw}/${series}/*.fastq
    echo " "
    echo "--- FASTQ files for $sra_acc completed ---"

done