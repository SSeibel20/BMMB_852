#Homework 14 Makefile

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


#Set Paths for reproducibility
HOME_DIR = HW14
ACC = GCA_000006945.2
N = 1000
SRR_LIST = $(HOME_DIR)/design.csv
SRR = $(HOME_DIR)/ST_SRR.csv
QUALITY = $(HOME_DIR)/Quality
FASTQ_INDIR = $(HOME_DIR)/Data
R1 = $(FASTQ_INDIR)/$(SRR)_1.fastq.gz
R2 = $(FASTQ_INDIR)/$(SRR)_2.fastq.gz
FASTP_OUTDIR = $(HOME_DIR)/fastp_filt
T1 = $(FASTP_OUTDIR)/$(SRR)_1_trimmed.fastq.gz
T2 = $(FASTP_OUTDIR)/$(SRR)_2_trimmed.fastq.gz
FASTA = $(HOME_DIR)/ST_LT2_assembly.fasta
SAM = $(HOME_DIR)/SAM_BAM
BAM = $(SAM)/filtered.bam
ALIGNED_BAM = $(SAM)/$(SRR).aligned.bam
SORTED_BAM = $(SAM)/$(SRR).sorted.bam
FILTERED_BAM = $(SAM)/$(SRR).filtered.bam
VCF_FILE = $(RES)/*.vcf.gz
GFF = $(HOME_DIR)/ST_LT2.gff3
RES = $(HOME_DIR)/results
RNA=$(HOME_DIR)/ST_LT2_rna.fasta
RNA_SEQ=$(HOME_DIR)/rnaseq
MERGE = $(RES)/merged.vcf.gz

##--------------------------------------------##

usage:
	@echo "Define variables"
	@echo "make genome       #Download Salmonella Typhimurium LT2 genome assembly"
	@echo "make simulate     #Simulate FASTQ reads based on downloaded assembly"
	@echo "make download     #Download reads from SRA database and run quality control"
	@echo "make trim         #Trim reads and run quality control post-trimming"
	@echo "make index        #Index the reference genome"
	@echo "make align        #Align reads to the reference genome"
	@echo "make filter       #Filter the aligned reads"
	@echo "make vcf          #Call SNPs from the filtered reads"
	@echo "make merge        #Merge the VCF files"
	@echo "make parallel     #Run all steps in parallel"
	@echo "make dry-run      #Print the commands that would be run"
	@echo "make clean        #Remove all extraneous files"

##--------------------------------------------##
genome:
	#make home directory if necessary
	mkdir -p $(HOME_DIR)
	
	#Salmonella Typhimurium LT2 assembly from NCBI
	datasets download genome accession $(ACC) --include gff3,gtf,genome,rna --filename $(HOME_DIR)/ST_LT2_NCBI.zip

	#Unzip the assembly file
	unzip -n $(HOME_DIR)/ST_LT2_NCBI.zip -d $(HOME_DIR)/ST_LT2_NCBI

	#Extract the FASTA file
	mv $(HOME_DIR)/ST_LT2_NCBI/ncbi_dataset/data/$(ACC)/*.fna $(HOME_DIR)/ST_LT2_assembly.fasta
	mv $(HOME_DIR)/ST_LT2_NCBI/ncbi_dataset/data/$(ACC)/*.gff $(HOME_DIR)/ST_LT2.gff3
	mv $(HOME_DIR)/ST_LT2_NCBI/ncbi_dataset/data/$(ACC)/*.gtf $(HOME_DIR)/ST_LT2.gtf3

	#Remove all extraneous information, leaving just the .fasta files
	rm -rf $(HOME_DIR)/ST_LT2_NCBI/data/$(ACC)
	rm -f md5sum.txt $(HOME_DIR)/ST_LT2_NCBI.zip

##--------------------------------------------##
design:
	bio search PRJNA1130907 -H --csv > $(HOME_DIR)/design.csv
	awk -F, 'NR>1 {print $$1}' $(SRR_LIST) > $(HOME_DIR)/ST_SRR.csv

##--------------------------------------------##
dry-run:
	cat $(HOME_DIR)/design.csv | head -10 $(SRR) | \
	parallel --dry-run --lb -j 4 --colsep , --header : \
	make run SRR={1}

##--------------------------------------------##
parallel: genome design
	cat $(HOME_DIR)/design.csv | head -10 $(SRR) | \
	parallel --lb -j 4 --colsep , --header : \
	make run SRR={1}

##--------------------------------------------##

download:
	#Make directory for data to download
	mkdir -p $(FASTQ_INDIR)

	#Need to use prefetch to download SRR files
	prefetch $(SRR) --output-directory $(FASTQ_INDIR)

	#Run fastq-dump for each SRR in the list
	fastq-dump -X $(N) --split-files -O $(FASTQ_INDIR) $(SRR)

	# GZip incoming files to preserve space, only if not already gzipped
	gzip $(FASTQ_INDIR)/*.fastq

quality:
	#Create directory for quality checking
	mkdir -p $(QUALITY)

	#Run fastqc on all .fastq.gz files
	fastqc $(FASTQ_INDIR)/*.fastq.gz -o $(QUALITY)

	#Compare fastqc results before trimming
	@echo "Compare fastqc results to define trimming parameters"

trim:
	#Make directory for data to be stored
	mkdir -p $(FASTP_OUTDIR)

	#Run fastp to trim reads
	fastp -r -q 20 \
		-i $(FASTQ_INDIR)/$(SRR)_1.fastq.gz \
		-o $(FASTP_OUTDIR)/$(SRR)_1_trimmed.fastq.gz
	
	#Run fastqc on trimmed files and store in individual directories
	mkdir -p $(QUALITY)/$(SRR)
	fastqc $(FASTP_OUTDIR)/$(SRR)_*.fastq.gz -o $(QUALITY)/$(SRR)

##--------------------------------------------##

index:
	# Make SAM_BAM directory 
	mkdir -p $(SAM)

	# Index with the reference 
	bwa index $(FASTA)
	
	# Move the output files to the SAM_BAM directory
	mv $(HOME_DIR)/ST_LT2_assembly.fasta.* $(SAM)

	# Copy the original FASTA
	cp $(FASTA) $(SAM)
	
align:
	# Make SAM_BAM directory 
	mkdir -p $(SAM)

	# Align reads using BWA MEM
	bwa mem -t 4 $(SAM)/ST_LT2_assembly.fasta $(T1) > $(ALIGNED_BAM)

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
rna_seq:
	# Make folders if needed
	mkdir -p $(RNA_SEQ)/refs
	mkdir -p $(RNA_SEQ)/reads
	mkdir -p $(RNA_SEQ)/bam

	# copy design file to this dir
	# cp $(HOME_DIR)/design.csv $(RNA_SEQ)/
	cp $(HOME_DIR)/ST_LT2.gtf3 $(RNA_SEQ)/refs/

	# Run the alignment for multiple samples
	cat $(RNA_SEQ)/design.csv | parallel --lb --header : --colsep , \
		make -f $(RNA_SEQ)/hisat2.mk \
        REF=$(RNA_SEQ)/refs/ST_LT2_rna.fasta \
        R1=$(RNA_SEQ)/reads/{run_accession}_1_trimmed.fastq.gz  \
        BAM=$(RNA_SEQ)/bam/{run_accession}.bam \
    	run

	# Feature counts
	featureCounts -a refs/ST_LT2.gtf -o counts.txt bam/*.bam

##--------------------------------------------##
stats:
	# If this worked, id start with the command below
	#Rscript src/r/format_featurecounts.r -c counts.txt -o counts.csv

	# Since rna_seq make didnt work use this
	cd $(RNA_SEQ)
	bio code
	Rscript src/r/simulate_counts.r

	# Evaluate the tables
	Rscript src/r/edger.r
	Rscript  src/r/evaluate_results.r  -a counts.csv -b edger.csv

	# Create pca using simulated data
	src/r/plot_pca.r -c edger.csv

	# Create a heatmap using simulated data
	src/r/plot_heatmap.r -c edger.csv

	# Get significantly differentially expressed genes in a list
	cat edger.csv | cut -f 1 -d ,  | head -10


##--------------------------------------------##
run: download quality trim index align filter rna_seq 
all: usage genome download quality trim index align filter rna_seq stats clean
clean:
	rm -rf $(QUALITY) $(FASTQ_INDIR) $(FASTP_OUTDIR) $(FASTA) $(SAM) $(VCF) $(GFF) $(RES)
	@echo "All extraneous files have been removed"

#Mark the targets that do not create files.
.PHONY: usage clean dry-run
