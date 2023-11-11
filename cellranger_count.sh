
# 
P_REF="/mnt/d4t/SCRNA/PANCREAS_DATA/REF"
P_RAW="/mnt/d4t/SCRNA/PANCREAS_DATA/TEST"
P_OUT="/mnt/d4t/SCRNA/PANCREAS_DATA/OUTPUT"

cellranger count --id=GSE_test \
                --transcriptome=$P_REF/refdata-gex-GRCh38-2020-A \
                --fastqs=$P_RAW \
                --sample=SRR17717448,SRR17717460 \
                --localcores=12 \
                --expect-cells=10000 \
                --localmem=50 \
                --output-dir $P_OUT

# RUN 2 samples of GSE156405 (HPC02)
## PATH
P_REF="/mnt/rdisk/duydao/SCRNA/PANCREAS_DATA/REF"
P_RAW="/mnt/rdisk/duydao/SCRNA/PANCREAS_DATA/DATA/RAW"
P_OUT="/mnt/rdisk/duydao/SCRNA/PANCREAS_DATA/OUTPUT"

series="GSE156405"
samples=$(ls $P_RAW/$series/ | cut -d '_' -f1 | uniq | head -n2 | tr '\n' ',' | awk 'BEGIN{FS=OFS=","} {print $1,$2}')

## RENAME FASTQ files following the right format
## SampleName_S1_L001_R1_001.fastq.gz
i=0
for sample in $(ls $P_RAW/$series/ | cut -d '_' -f1 | uniq);do
    ((i++))
    echo $sample
    mv ${sample}_1.fastq.gz ${sample}_S${i}_L001_R1_001.fastq.gz
    mv ${sample}_2.fastq.gz ${sample}_S${i}_L001_R2_001.fastq.gz
done

## CELLRANGER COUNT
cellranger count --id=GSE156405 \
                --transcriptome=$P_REF/refdata-gex-GRCh38-2020-A \
                --fastqs=$P_RAW \
                --sample=$samples \
                --localcores=64 \
                --expect-cells=10000 \
                --localmem=216 \
                --output-dir $P_OUT

