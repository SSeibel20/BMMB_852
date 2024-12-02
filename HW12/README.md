# Homework 12: Automate a VCF calling pipeline
*Samantha Seibel December 1st, 2024*

*Using code from HW 11*

## Background

**Reference**

Salmonella Typhimurium (ST) LT2

NCBI RefSeq assembly: GCF_000006945.2

Submitted GenBank assembly: GCA_000006945.2

Taxon: Salmonella enterica subsp. enterica serovar Typhimurium str. LT2

Strain: LT2

Submitter: Washington University Genome Sequencing Center

Date: Jan 13, 2016


**Downloaded Data**

*Genomic diversity of Salmonella enterica serovar Typhimurium isolated from chicken processing facilities in New South Wales, Australia*

Date: 3-Jun-2024

University of New South Wales

**Needed to download individual SRRs from this project because some of the data was from Nanopore sequencing and I didn't want that to affect the alignment**

List of SRRs:
SRR29260553
SRR29260554
SRR29260555
SRR29260556
SRR29260557
SRR29260558
SRR29260559
SRR29260560
SRR29260561
SRR29260562

## Prior to Makefile

**Code before initiating Makefile**

```bash
#activate bioinfo environment

micromamba activate environment
```

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

**snpEff** interpret variant effect

**all**: runs all of the above targets


## Using GNU Parallel to create multiple VCFs










