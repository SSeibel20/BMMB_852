#Homework 12 Makefile
#Using GNU Parallel to process multiple SRR entries at once

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


#Set Paths for reproducibility
HOME_DIR = HW12
ACC = GCA_000006945.2
N = 1000
SRR = $(HOME_DIR)/ST_SRR.txt
QUALITY = $(HOME_DIR)/Quality
FASTQ_INDIR = $(HOME_DIR)/Data
R1 = $(FASTQ_INDIR)/${SRR}_1.fastq.gz
R2 = $(FASTQ_INDIR)/${SRR}_2.fastq.gz
FASTP_OUTDIR = $(HOME_DIR)/fastp_filt
T1 = $(FASTP_OUTDIR)/${SRR}_1_trimmed.fastq.gz
T2 = $(FASTP_OUTDIR)/${SRR}_2_trimmed.fastq.gz
FASTA = $(HOME_DIR)/ST_LT2_assembly.fasta
SAM = $(HOME_DIR)/SAM_BAM
BAM = $(SAM)/filtered.bam
ALIGNED_BAM = $(SAM)/$(SRR).aligned.bam
SORTED_BAM = $(SAM)/$(SRR).sorted.bam
FILTERED_BAM = $(SAM)/$(SRR).filtered.bam
VCF_FILE = $(RES)/$(SRR).vcf.gz
GFF = $(HOME_DIR)/ST_LT2.gff3
RES = $(HOME_DIR)/results 

##--------------------------------------------##

usage:
	@echo "Define variables"
	@echo "make genome       #Download Salmonella Typhimurium LT2 genome assembly"
	@echo "make simulate     #Simulate FASTQ reads based on downloaded assembly"
	@echo "make download     #Download reads from SRA database and run quality control"
	@echo "make trim         #Trim reads and run quality control post-trimming"

##--------------------------------------------##
design:
	# Ensure design.csv is generated first
	bio search PRJNA1119266 -H --csv > design.csv

	# Filter design.csv to keep only the SRRs listed in ST_SRR.txt
	awk -F, 'NR==FNR {s[$1]; next} $1 in s' $(SRR) design.csv > filtered_design.csv

##--------------------------------------------##
dry-run:
	cat filtered_design.csv | \
	parallel --dry-run --bar --eta --lb -j 4 --colsep , --header : \
		make all SRR={run_accession}

##--------------------------------------------##
# Parallel execution to process SRR entries
parallel:
	cat $(SRR) | \
	parallel --bar --eta --lb -j 4 \
		make all SRR={}

##--------------------------------------------##
genome:
	#make home directory if necessary
	mkdir -p $(HOME_DIR)
	
	#Salmonella Typhimurium LT2 assembly from NCBI
	datasets download genome accession $(ACC) --include gff3,genome --filename $(HOME_DIR)/ST_LT2_assembly.zip

	#Unzip the assembly file
	unzip -n $(HOME_DIR)/ST_LT2_assembly.zip -d $(HOME_DIR)/ST_LT2_assembly

	#Extract the FASTA file
	mv $(HOME_DIR)/ST_LT2_assembly/ncbi_dataset/data/$(ACC)/*.fna $(HOME_DIR)/ST_LT2_assembly.fasta
	mv $(HOME_DIR)/ST_LT2_assembly/ncbi_dataset/data/$(ACC)/*.gff $(HOME_DIR)/ST_LT2.gff3

	#Remove all extraneous information, leaving just the .fasta files
	rm -rf $(HOME_DIR)/ST_LT2_assembly/data/$(ACC)
	rm -f md5sum.txt $(HOME_DIR)/ST_LT2_assembly.zip

##--------------------------------------------##

download:
	#Make directory for data to download
	mkdir -p $(FASTQ_INDIR)

	#Need to use prefetch to download SRR files
	prefetch --option-file $(SRR) --output-directory $(FASTQ_INDIR)

	#Run fastq-dump for each SRR in the list
	cat $(SRR) | xargs -I {} fastq-dump -X $(N) --split-files -O $(FASTQ_INDIR) {}

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
	# Create fastp output directory
	mkdir -p $(FASTP_OUTDIR)

	# Run fastp for filtering and trimming
	fastp -r -q 20 -i $(FASTQ_INDIR)/$(SRR)_1.fastq.gz -I $(FASTQ_INDIR)/$(SRR)_2.fastq.gz \
	      -o $(TRIMMED_R1) -O $(TRIMMED_R2)

	# Run FastQC on trimmed files
	mkdir -p $(QUALITY)/trim_$(SRR)
	fastqc $(TRIMMED_R1) $(TRIMMED_R2) -o $(QUALITY)/trim_$(SRR)

##--------------------------------------------##

index:
	# Make SAM_BAM directory 
	mkdir -p $(SAM)

	# Index with the reference 
	bwa index $(FASTA)
	
	# Move the output files to the SAM_BAM directory
	mv $(HOME_DIR)/ST_LT2_assembly.fasta.* $(SAM)

	
align:
	# Make SAM_BAM directory 
	mkdir -p $(SAM)

	# Align reads using BWA MEM
	bwa mem -t 4 $(FASTA) $(TRIMMED_R1) $(TRIMMED_R2) > $(ALIGNED_BAM)

	# Convert to BAM, sort, and index
	samtools view -bS $(ALIGNED_BAM) > $(SORTED_BAM)
	samtools sort $(SORTED_BAM) -o $(SORTED_BAM)
	samtools index $(SORTED_BAM)

	# Generate alignment stats
	samtools stats $(SORTED_BAM) > $(SAM)/$(SRR).alignment_stats.txt

	@echo "Trimmed reads aligned, indexed, and sorted"

##--------------------------------------------##
filter:
	# Filter BAM file for properly paired alignments with MAPQ > 10
	samtools view -h -f 0x2 -q 10 -F 0x100 -b $(SORTED_BAM) > $(FILTERED_BAM)

	# Compare flagstats
	samtools flagstat $(SORTED_BAM)
	samtools flagstat $(FILTERED_BAM)

##--------------------------------------------##
# Call the SNPs in the resulting BAM file.
vcf:
	# Call SNPs and generate VCF file
	bcftools mpileup -Ou -f $(FASTA) $(FILTERED_BAM) | \
	bcftools call -mv -Oz -o $(VCF_FILE)

	# Index the VCF file
	bcftools index $(VCF_FILE)

##--------------------------------------------##
merge:
	# Merge VCF files into a single one.
	bcftools merge -0 vcf/*.vcf.gz -O z > merged.vcf.gz

	# Index the merged VCF file
	bcftools index merged.vcf.gz

##--------------------------------------------##
all: usage genome  download quality trim index align evaluate filter vcf 
clean:
	rm -rf $(QUALITY) $(FASTQ_INDIR) $(FASTP_OUTDIR) $(FASTA) $(SAM) $(VCF) $(GFF) $(RES)
	@echo "All extraneous files have been removed"

#Mark the targets that do not create files.
.PHONY: usage clean dry-run
