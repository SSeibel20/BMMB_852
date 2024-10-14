#Homework 7 Makefile
#Part 1: Simulate reads
#Part 2: Download reads from NCBI SRA Database and analyze

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


#Set Paths for reproducibility
HOME_DIR = HW7
ACC = GCF_000006945.2
N = 10000
SRR = SRR1963625
QUALITY = $(HOME_DIR)/Quality
FASTQ_INDIR = $(HOME_DIR)/Data
R1 = $(FASTQ_INDIR)/${SRR}_1.fastq.gz
R2 = $(FASTQ_INDIR)/${SRR}_2.fastq.gz
FASTP_OUTDIR = $(HOME_DIR)/fastp_filt
T1 = $(FASTP_OUTDIR)/${SRR}_1_trimmed.fastq.gz
T2 = $(FASTP_OUTDIR)/${SRR}_2_trimmed.fastq.gz
FASTA = ST_LT2_assembly.fasta

usage:
	@echo "Define variables"
	@echo "make genome       #Download Salmonella Typhimurium LT2 genome assembly"
	@echo "make simulate     #Simulate FASTQ reads based on downloaded assembly"
	@echo "make download     #Download reads from SRA database and run quality control"
	@echo "make trim         #Trim reads and run quality control post-trimming"

genome:
	#change to home directory
	cd $(HOME_DIR)

	#make home directory if necessary
	mkdir -p $(HOME_DIR)

	#get Salmonella Typhimurium LT2 assembly from NCBI 
	efetch -db genome -format fasta -email sls6550@psu.edu -id $(ACC) > ST_LT2_assembly.fasta

simulate:
	#change to home directory
	cd $(HOME_DIR)

	#Generate a simulated FASTQ output for a sequencing instrument of your choice.  Set the parameters so that your target coverage is 10x**
	wgsim -N 366667 -1 150 -2 150 $(FASTA) sim_1.fastq sim_2.fastq

	#Size of the FASTQ files
	@echo "Size of FASTQ files"
	@echo "Size of sim_1.fastq"
	@ls -lh sim_1.fastq
	@echo "Size of sim_2.fastq"
	@ls -lh sim_2.fastq

	#Number of reads generated
	@echo "Number of reads generated for simulate reads"
	@echo "Number of reads for sim_1.fastq"
	@cat sim_1.fastq | wc -l
	@echo "Number of reads for sim_2.fastq"
	@cat sim_2.fastq | wc -l

	#Average read length
	@echo "Average read length"
	@grep -A 2 '^@' *.fastq | grep -v '^@' | awk '{count += length($$0); total++} END {print count / total}'

	#Compress the files
	gzip sim_1.fastq sim_2.fastq

	#report size of zipped files
	@echo "Size of zipped files (1 and 2, respectively)"
	@ls -lh sim_1.fastq.gz sim_2.fastq.gz

download:
	#change to home directory
	cd $(HOME_DIR)

	#Make directory for data to download
	mkdir -p $(FASTQ_INDIR)

	#Get subset of FASTQ files from NCBI via SRR number base on N
	fastq-dump -X $(N) $(SRR) --outdir $(FASTQ_INDIR) --split-files

	#GZip incoming files to preserve space
	gzip $(FASTQ_INDIR)/*.fastq

quality:
	#Create directory for quality checking
	mkdir -p $(QUALITY)

	#Run fastqc on all .fastq.gz files
	fastqc $(FASTQ_INDIR)/*.fastq.gz -o $(QUALITY)

	#Compare fastqc results before trimming
	@echo "Compare fastqc results to define trimming parameters"

trim:
	#change to home directory
	cd $(HOME_DIR)
	
	#Define fastp output directory
	mkdir -p $(FASTP_OUTDIR)

	#Run fastp for fitering and trimming
	fastp -r -q 20 -i $(R1) -I $(R2) -o $(T1) -O $(T2)

	#Create Quality directory for trimming reports
	mkdir -p $(QUALITY)/trim_${SRR}

	#Run fastqc on newly trimmed files
	fastqc $(FASTP_OUTDIR)/*.fastq.gz -o $(QUALITY)/trim_${SRR}

	#Compare fastqc.html files before and after trimming
	@echo "Compare fastqc results to ensure correct trimming"

#Mark the targets that do not create files.
.PHONY: usage genome simulate download quality trim
