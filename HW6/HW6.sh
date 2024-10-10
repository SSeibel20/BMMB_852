# Samantha Seibel
# Homework 6: FASTQ Quality Control

#error tracing
set -uex

# Set Paths for reproducibility
HOME_DIR="/Users/sls6550/work/BMMB_852/HW6"
NUM=10000
SRR="SRR30756726"
QUALITY="$HOME_DIR/Quality"
FASTQ_INDIR="$HOME_DIR/Data"
R1="$FASTQ_INDIR/${SRR}_1.fastq.gz"
R2="$FASTQ_INDIR/${SRR}_2.fastq.gz"
FASTP_OUTDIR="$HOME_DIR/fastp_filt"
T1="$FASTP_OUTDIR/${SRR}_1_trimmed.fastq.gz"
T2="$FASTP_OUTDIR/${SRR}_2_trimmed.fastq.gz"

# Move to the desired directory to download your files
cd $HOME_DIR

# Make directory for data to download
mkdir -p $FASTQ_INDIR

# Get subset of FASTQ files from NCBI via SRR number base on NUM
fastq-dump -X $NUM $SRR --outdir $FASTQ_INDIR --split-files --threads 4

# Zip incoming files to preserve space
gzip $FASTQ_INDIR/*.fastq

# Create directory for quality checking
mkdir -p $QUALITY

# Run fastqc on all .fastq.gz files
fastqc $FASTQ_INDIR/*.fastq.gz -o $QUALITY

# Define fastp output directory
mkdir -p $FASTP_OUTDIR

# Run fastp for fitering and trimming
fastp -r -i $R1 -I $R2 -o $T1 -O $T2

# Run fastqc on newly trimmed files
fastqc $FASTP_OUTDIR/*.fastq.gz -o $QUALITY/trim_${SRR}

# Compare fastqc.html files before and after trimming



