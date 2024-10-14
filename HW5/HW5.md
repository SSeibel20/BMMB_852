# Homework 5: Simulating FASTQ Files
*Samantha Seibel September 22nd, 2024*

**Select a genome, then download the corresponding FASTA file**
Selected: Escherichia coli O157:H7 str. Sakai
NCBI Taxonomy ID: 386585

## Size of file
5.4Mb zipped

## The total size of the genome
5664540 bases

## The number of chromosomes in the genome
3

## The name (id) and length of each chromosome in the genome
NC_002695.2 5498578
NC_002127.1 3306
NC_002128.1 92721

**Generate a simulated FASTQ output for a sequencing instrument of your choice.  Set the parameters so that your target coverage is 10x**

Number of reads needed for 10x: (coverage x genome size)/read length

For E. coli O157 H7: (10 * 5,500,000)/150 = 366,667

## How many reads have you generated?
366,667 * 2 = 733,334

## What is the average read length?
150bp

## How big are the FASTQ files?
112Mb each

## Compress the files and report how much space that saves.
Compressed from 112Mb to 21Mb

## Discuss whether you could get the same coverage with different parameter settings (read length vs. read number).
I could get the same coverage (10x) with less reads if the read length is longer

**How much data would be generated when covering the Yeast, the Drosophila or the Human genome at 30x?**
Based on the above calculation used for calculating number of reads: 

Yeast: 
(12,000,000 bp * 30X coverage)/150bp = 2,400,000 reads for 30x coverage

FASTQ Size= Number of Reads * Read Length * 4 (for the 4 lines in FASTQ format)
for Yeast: 2,400,000 * 150 * 4 = 1.44 GB

Fastq gz compresses at a ratio of around 4:1
0.36 GB OR 360 MB

Drosophila:
(175,000,000 bp * 30X coverage)/150bp = 35,000,000 reads for 30x coverage 	
for Drosophila: 35,000,000 * 150 * 4 = 21.0 GB

Fastq gz compresses at a ratio of around 4:1
5.25 GB

Human:
(3,000,000,000 bp * 30X coverage)/150bp = 600,000,000 reads for 30x coverage
for Human: 600,000,000 * 150 * 4 = 360.0 GB

Fastq gz compresses at a ratio of around 4:1
90.0 GB

