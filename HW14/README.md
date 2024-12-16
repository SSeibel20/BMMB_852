# Homework 14: RNA Stats Analysis
*Samantha Seibel December 15th, 2024*

*Using code from HW 13*

## Background

**Reference**

Salmonella Typhimurium (ST) LT2

NCBI RefSeq assembly: GCF_000006945.2

Submitted GenBank assembly: GCA_000006945.2

Taxon: Salmonella enterica subsp. enterica serovar Typhimurium str. LT2

Strain: LT2

Submitter: Washington University Genome Sequencing Center

Date: Jan 13, 2016


**Downloaded RNA Seq Data**

*TTranscriptome Cappable-Seq Sequencing Data Set of Gene Expression in Salmonella enterica serovar Typhimurium 14028S inside Acanthamoeba castellanii, and under Oxidative and Starvation Stress Conditions*

"Here we present high-resolution Cappable-Seq transcriptomic data on Salmonella gene expression under optimal, starvation and hydrogen peroxide conditions, and after 8 and 15 hours of co-culture with A. Castellanii. Overall design: To assess changes in global Salmonella gene expression during long-term infection of amoebae, we performed Cappable-Seq sequencing of total Salmonella RNA within A. castellanii at late stages of infection (8 h and 15 h) and also compared three free-living cultures grown under different conditions, including rich medium (LB), poor medium (PAS), and exposure to hydrogen peroxide."

BioProject: PRJNA1130907
Registration date: 02-Jul-2024
Laboratory og Biomedical technologies, Institute for Cellular and Intracellular Symbiosis

List of SRRs:
- SRR29681622
- SRR29681623
- SRR29681624
- SRR29681625
- SRR29681626


## Prior to Makefile

**Code before initiating Makefile**

```bash
# activate bioinfo environment

micromamba activate environment

# Get the bioinformatics toolbox
bio code

# copy hisat2.mk file to your working directory
# write in your own HOME_DIR (mine is ~/work/BMMB_852/HW13)
cp ~/src/run/hisat2.mk ${HOME_DIR}/hisat2.mk
```
**Make sure to run genome, design, and dry run before running parallel**

**Had issues with downloading the rna file via the datasets command, so manual download will have to do**

1. Manually download "GCF_000006945.2_ASM694v2_rna_from_genomic.fna.gz" from NCBI Genomes website

2. Unzip the file and rename it

```bash
#unzip the fna file
gunzip GCF_000006945.2_ASM694v2_rna_from_genomic.fna.gz

#rename
mv GCF_000006945.2_ASM694v2_rna_from_genomic.fna ST_LT2_rna.fasta
```

**Merge target needs to be run after parallel has finished!**

## Constructing a Makefile using the following

*Targets*

**usage**: defines each target for user

**genome**: downloads assembly of selected organism

**download**: downloads subset of fastq files from select reads from NCBI SRA database

**quality**: runs fastqc on downloaded files

**trim**: trims fastq files with fastp based of output of fastqc then reruns fastqc

**index**: uses BWA to make an index from the ST LT2 reference

**align**: using samtools, create an alignment of ST reads against reference, convert to a sorted, indexed BAM file, run stats

**filter**: filter BAM files to only contain properly paired primary alignments with a mapping quality of over 10

**vcf** create the variant call file

**all**: runs all of the above targets

**design**: creates a csv with all the important metadata for each SRR from a chosen BioProject ID

**dry-run**: runs a dry run on the parallel command

**parallel**: runs each SRR through the full pipeline in unison


## Creating an RNA Seq Count Matrix did not work last time
### I have written a Makefile for both human and my Salmonella to try and see if I was causing any issues, but I couldnt resolve the following issue

```bash

make[1]: Entering directory '/Users/sls6550/work/BMMB_852'
# file not found: R1=reads/HBR_1_R1.fq
make[1]: *** [HW14/hisat2.mk:70: reads/HBR_1_R1.fq] Error 255
make[1]: Leaving directory '/Users/sls6550/work/BMMB_852'
make: *** [Makefile:62: rna_seq] Error 2

make[1]: Entering directory '/Users/sls6550/work/BMMB_852'
# file not found: R1=HW13/rnaseq/reads/SRR29681626_1_trimmed.fastq.gz
make[1]: Leaving directory '/Users/sls6550/work/BMMB_852'

```
The error is due to the structure of the hisat2.mk script, it calls things locally, and my makefile to run the hisat2.mk file doesnt run properly

Used workflow with simulated data, had to tweak src R files due to installation of tools my R did not have (Deseq2, gplots, etc)

## RESULTS FROM SIMULATED DATA

![Screenshot](rnaseq/pca.pdf)

![Screenshot](rnaseq/heatmap.pdf)






