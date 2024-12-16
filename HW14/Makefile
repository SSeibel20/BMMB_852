#Homework 14 Makefile
#RNAseq analysis

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


#Set Paths for reproducibility
HOME_DIR=HW14
REF=$(HOME_DIR)/refs
GFF=$(REF)/chr22.gtf
GENOME=$(REF)/chr22.genome.fa
RNA=$(HOME_DIR)/chr22.transcripts.fa
READS=$(HOME_DIR)/reads

usage:
	@echo "Define variables"
	@echo "make download       #Download Example Data"
	@echo "make index     #Index the reference genome"
	@echo "make design     #Download reads from SRA database and run quality control"

##--------------------------------------------##
download:
	mkdir -p $(HOME_DIR)
	
	# Check if the file exists and only download if not present
	if [ ! -f $(HOME_DIR)/uhr-hbr.tar.gz ]; then \
		wget -O $(HOME_DIR)/uhr-hbr.tar.gz http://data.biostarhandbook.com/data/uhr-hbr.tar.gz; \
	fi
	
	# Unpack the data
	tar xzvf $(HOME_DIR)/uhr-hbr.tar.gz -C $(HOME_DIR)


##--------------------------------------------##
design:
	# Create a design file with sample IDs and groups
	echo -e "SampleID\tGroup" > $(HOME_DIR)/design.csv
	
	# Add the sample information (adjust the paths if necessary)
	echo -e "HBR_1\tHBR" >> $(HOME_DIR)/design.csv
	echo -e "HBR_2\tHBR" >> $(HOME_DIR)/design.csv
	echo -e "HBR_3\tHBR" >> $(HOME_DIR)/design.csv
	echo -e "UHR_1\tUHR" >> $(HOME_DIR)/design.csv
	echo -e "UHR_2\tUHR" >> $(HOME_DIR)/design.csv
	echo -e "UHR_3\tUHR" >> $(HOME_DIR)/design.csv

##--------------------------------------------##
index:
	make -f $(HOME_DIR)/hisat2.mk index REF=$(GENOME)

	cd HW14/reads
	ls HBR_1_R1.fq

##--------------------------------------------##
rna_seq:

	make -f $(HOME_DIR)/hisat2.mk \
        REF=refs/chr22.genome.fa \
        R1=reads/HBR_1_R1.fq \
        BAM=bam/HBR_1.bam \
        run


all: download design index rna_seq 
clean:
	rm -rf $(QUALITY) $(FASTQ_INDIR) $(FASTP_OUTDIR) $(FASTA) $(SAM) $(VCF) $(GFF) $(RES)
	@echo "All extraneous files have been removed"

#Mark the targets that do not create files.
.PHONY: usage