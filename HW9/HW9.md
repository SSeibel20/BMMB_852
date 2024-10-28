# Homework 8: Making a BAM file
*Samantha Seibel October 27th, 2024*

*Using code from HWs 8*

## Background

**Reference**

Salmonella Typhimurium (ST) LT2

NCBI RefSeq assembly: GCF_000006945.2

Submitted GenBank assembly: GCA_000006945.2

Taxon: Salmonella enterica subsp. enterica serovar Typhimurium str. LT2

Strain: LT2

Submitter: Washington University Genome Sequencing Center

Date: Jan 13, 2016

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

**simulate**: generates simulated fastq reads from the assembly

**download**: downloads subset of fastq files from select reads from NCBI SRA database

**quality**: runs fastqc on downloaded files

**trim**: trims fastq files with fastp based of output of fastqc then reruns fastqc

**index**: uses BWA to make an index from the ST LT2 reference

**align**: using samtools, create an alignment of both ST and simulated reads against reference, convert to a sorted, indexed BAM file, run stats

**evaluate**: using samtools to evaluate our generated BAM files

**filter**: filter BAM files to only contain properly paired primary alignments with a mapping quality of over 10

**all**: runs all of the above targets


## Question 1: How many reads did not align with the reference genome?

Command to use:
```samtools flagstat sorted_st.bam```

There were 17,828 total reads, 15,423 were mapped, therefore 2,405 did not align

## Question 2: How many primary, secondary, and supplementary alignments are in the BAM file?

*primary* 
```samtools view -c -F 0x100 your_file.bam```

There were 17,808 primary alignments

*secondary* 
```samtools view -c -f 0x100 your_file.bam```

There were no secondary alignments

*supplementary* 
```samtools view -c -f 0x800 your_file.bam```

There were 20 supplementary alignments

*all of the above pass QC*

## Question 3: How many properly-paired alignments on the reverse strand are formed by reads contained in the first pair?

```samtools view -c -f 0x1 -f 0x10 -f 0x40 your_file.bam```

There were 3,872 properly-paired alignments on the reverse strand are formed by reads contained in the first pair

## Question 4: Make a new BAM file that contains only the properly paired primary alignments with a mapping quality of over 10
```samtools view -h -f 0x2 -q 10 -F 0x100 -b your_file.bam > filtered.bam```

## Question 5: Compare the flagstats for your original and your filtered BAM file.
```samtools flagstat your_file.bam``
```samtools flagstat filtered.bam```








