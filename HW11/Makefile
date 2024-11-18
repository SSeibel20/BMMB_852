#Homework 11 Makefile
#Part 1: Simulate reads
#Part 2: Download reads from NCBI SRA Database and analyze
#Part 3: Align simulated and trimmed reads to a reference
#Part 4: Filter the BAM file
#Part 5: Variant Calling
#Part 6: Variant Effect Prediction

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


#Set Paths for reproducibility
HOME_DIR = HW11
ACC = GCA_000006945.2
N = 10000
SRR = SRR1963625
QUALITY = $(HOME_DIR)/Quality
FASTQ_INDIR = $(HOME_DIR)/Data
R1 = $(FASTQ_INDIR)/${SRR}_1.fastq.gz
R2 = $(FASTQ_INDIR)/${SRR}_2.fastq.gz
FASTP_OUTDIR = $(HOME_DIR)/fastp_filt
T1 = $(FASTP_OUTDIR)/${SRR}_1_trimmed.fastq.gz
T2 = $(FASTP_OUTDIR)/${SRR}_2_trimmed.fastq.gz
FASTA = $(HOME_DIR)/ST_LT2_assembly.fasta
SAM = $(HOME_DIR)/SAM_BAM
S1 = sim_1.fastq.gz
S2 = sim_2.fastq.gz
BAM = $(SAM)/filtered.bam
VCF = $(HOME_DIR)/ST.vcf.gz
VEP= $(HOME_DIR)/ST.vef

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
	
	#Salmonella Typhimurium LT2 assembly from NCBI
	datasets download genome accession $(ACC) --filename $(HOME_DIR)/ST_LT2_assembly.zip

	#Unzip the assembly file
	unzip -n $(HOME_DIR)/ST_LT2_assembly.zip -d $(HOME_DIR)/ST_LT2_assembly

	#Extract the FASTA file
	mv $(HOME_DIR)/ST_LT2_assembly/ncbi_dataset/data/$(ACC)/*.fna $(HOME_DIR)/ST_LT2_assembly.fasta

	#Remove all extraneous information, leaving just the .fasta files
	rm -rf $(HOME_DIR)/ST_LT2_assembly/data/$(ACC)
	rm -f md5sum.txt $(HOME_DIR)/ST_LT2_assembly.zip


simulate:
	# Generate a simulated FASTQ output for a sequencing instrument of your choice. Set the parameters so that your target coverage is 10x
	wgsim -N 333333 -1 150 -2 150 $(FASTA) $(HOME_DIR)/sim_1.fastq $(HOME_DIR)/sim_2.fastq

	#Size of the FASTQ files
	@echo "Size of FASTQ files"
	@echo "Size of sim_1.fastq"
	@ls -lh $(HOME_DIR)/sim_1.fastq
	@echo "Size of sim_2.fastq"
	@ls -lh $(HOME_DIR)/sim_2.fastq

	#Number of reads generated
	@echo "Number of reads generated for simulate reads"
	@echo "Number of reads for sim_1.fastq"
	@cat $(HOME_DIR)/sim_1.fastq | wc -l
	@echo "Number of reads for sim_2.fastq"
	@cat $(HOME_DIR)/sim_2.fastq | wc -l

	#Average read length
	@echo "Average read length"
	@grep -A 2 '^@' $(HOME_DIR)/*.fastq | grep -v '^@' | awk '{count += length($0); total++} END {print count / total}'

	#Compress the files
	gzip $(HOME_DIR)/sim_1.fastq $(HOME_DIR)/sim_2.fastq

	#report size of zipped files
	@echo "Size of zipped files (1 and 2, respectively)"
	@ls -lh $(HOME_DIR)/sim_1.fastq.gz $(HOME_DIR)/sim_2.fastq.gz

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
	# Make SAM_BAM directory 
	mkdir -p $(SAM)

	# Index with the reference 
	bwa index $(FASTA)
	
	# Move the output files to the SAM_BAM directory
	mv $(HOME_DIR)/ST_LT2_assembly.fasta.* $(SAM)

	
align:
	# Make SAM_BAM directory 
	mkdir -p $(SAM)

	# Align simulated reads
	bwa mem -t 4 $(SAM)/$(notdir $(FASTA)) $(HOME_DIR)/$(notdir $(S1)) $(HOME_DIR)/$(notdir $(S2)) > $(SAM)/aligned_sim.sam

	# Convert SAM file to BAM file
	samtools view -bS $(SAM)/aligned_sim.sam > $(SAM)/aligned_sim.bam

	# Sort BAM file
	samtools sort $(SAM)/aligned_sim.bam -o $(SAM)/sorted_sim.bam

	# Index BAM file
	samtools index $(SAM)/sorted_sim.bam

	# Create stats on BAM file
	samtools stats $(SAM)/aligned_sim.bam > $(SAM)/alignment_stats_sim.txt
	@echo "Simulated reads aligned, indexed, and sorted"

	# Repeat with trimmed reads
	bwa mem -t 4 $(SAM)/$(notdir $(FASTA)) $(FASTP_OUTDIR)/$(notdir $(T1)) $(FASTP_OUTDIR)/$(notdir $(T2)) > $(SAM)/aligned_st.sam
	samtools view -bS $(SAM)/aligned_st.sam > $(SAM)/aligned_st.bam
	samtools sort $(SAM)/aligned_st.bam -o $(SAM)/sorted_st.bam
	samtools index $(SAM)/sorted_st.bam
	samtools stats $(SAM)/aligned_st.bam > $(SAM)/alignment_stats_st.txt
	@echo "Trimmed reads aligned, indexed, and sorted"

##--------------------------------------------##
evaluate:
	# Determine how many reads did not align with the reference genome
	samtools flagstat $(SAM)/sorted_st.bam

	# Determine how many primary, secondary, and supplementary alignments are in the BAM file

	# primary
	samtools view -c -F 0x100 $(SAM)/sorted_st.bam

	#secondary
	samtools view -c -f 0x100 $(SAM)/sorted_st.bam

	#supplemental
	samtools view -c -f 0x800 $(SAM)/sorted_st.bam

	# Determine How many properly-paired alignments on the reverse strand are formed by reads contained in the first pair
	samtools view -c -f 0x1 -f 0x10 -f 0x40 $(SAM)/sorted_st.bam

filter:
	# Make a new BAM file that contains only the properly paired primary alignments with a mapping quality of over 10
	samtools view -h -f 0x2 -q 10 -F 0x100 -b $(SAM)/sorted_st.bam > $(SAM)/filtered.bam

	# Compare the flagstats for your original and your filtered BAM file.
	samtools flagstat $(SAM)/sorted_st.bam
	samtools flagstat $(SAM)/filtered.bam

##--------------------------------------------##
# Call the SNPs in the resulting BAM file.
vcf:
	# make home directory if necessary
	mkdir -p $(HOME_DIR)
	
	make -f src/run/bcftools.mk REF=${FASTA} BAM=${BAM} VCF=${VCF} run
##--------------------------------------------##
# Establish the effects of the variants
vep:
	cd . #current dir
	git clone https://github.com/Ensembl/ensembl-vep.git #cloning of ensembl vep
	cd ensembl-vep #move into dir
	perl INSTALL.pl #install perl script
	./vep ${VCF} --cache --force_overwrite #run

##--------------------------------------------##
all: usage genome simulate download quality trim index align evaluate filter vcf vep
clean:
	rm -rf $(QUALITY) $(FASTQ_INDIR) $(FASTP_OUTDIR) $(FASTA) $(SAM) $(S1) $(S2)
	@echo "All extraneous files have been removed"

#Mark the targets that do not create files.
.PHONY: usage genome simulate download quality trim index align evaluate filter vcf
