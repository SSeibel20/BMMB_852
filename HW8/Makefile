#Homework 8 Makefile
#Part 1: Simulate reads
#Part 2: Download reads from NCBI SRA Database and analyze
#Part 3: Align simulated and trimmed reads to a reference

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


#Set Paths for reproducibility
HOME_DIR = HW8
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

##--------------------------------------------##

usage:
	@echo "Define variables"
	@echo "make genome       #Download Salmonella Typhimurium LT2 genome assembly"
	@echo "make simulate     #Simulate FASTQ reads based on downloaded assembly"
	@echo "make download     #Download reads from SRA database and run quality control"
	@echo "make trim         #Trim reads and run quality control post-trimming"

##--------------------------------------------##

genome:
	#make home directory if necessary
	mkdir -p $(HOME_DIR)

	#move to home directory
	cd $(HOME_DIR)
	
	#Salmonella Typhimurium LT2 assembly from NCBI
	datasets download genome accession $(ACC) --filename ST_LT2_assembly.zip

	#Unzip the assembly file
	unzip -n ST_LT2_assembly.zip -d ST_LT2_assembly

	#Extract the FASTA file
	mv ST_LT2_assembly/ncbi_dataset/data/$(ACC)/*.fna ST_LT2_assembly.fasta

	#Remove all extraneous information, leaving just the .fasta files
	rm -rf ST_LT2_assembly/data/$(ACC)
	rm -f md5sum.txt ST_LT2_assembly.zip


simulate:
	#move to home directory
	cd $(HOME_DIR)
	
	#Generate a simulated FASTQ output for a sequencing instrument of your choice.  Set the parameters so that your target coverage is 10x**
	wgsim -N 333333 -1 150 -2 150 $(FASTA) sim_1.fastq sim_2.fastq

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

##--------------------------------------------##

download:
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

##--------------------------------------------##

index:
	#go to home directory
	cd $(HOME_DIR)

	#index with a reference 
	bwa index ST_LT2_assembly.fasta
	
align:
	#go to home directory
	cd $(HOME_DIR)

	#Index
	bwa mem -t 4 ST_LT2_assembly.fasta sim_1.fastq.gz sim_2.fastq.gz > aligned_sim.sam

	#Convert SAM file to BAM file
	samtools view -bS aligned_sim.sam > aligned_sim.bam

	#Sort BAM file
	samtools sort aligned_sim.bam -o sorted_sim.bam

	#Index BAM file
	samtools index sorted_sim.bam

	#Create stats on BAM file
	samtools stats aligned_sim.bam > alignment_stats_sim.txt
	@echo "Simulated reads aligned, indexed, and sorted"

	#repeat with trimmed reads
	bwa mem -t 4 ST_LT2_assembly.fasta fastp_filt/${SRR}_1_trimmed.fastq.gz fastp_filt/${SRR}_2_trimmed.fastq.gz > aligned_st.sam
	samtools view -bS aligned_st.sam > aligned_st.bam
	samtools sort aligned_st.bam -o sorted_st.bam
	samtools index sorted_st.bam
	samtools stats aligned_st.bam > alignment_stats_st.txt
	@echo "Simulated reads aligned, indexed, and sorted"

##--------------------------------------------##

all: usage genome simulate download quality trim index align
clean:
	rm -rf QUALITY FASTQ_INDIR FASTP_OUTDIR FASTA
	@echo "All extraneous files have been removed"

#Mark the targets that do not create files.
.PHONY: usage genome simulate download quality trim index align
