#!/bin/bash
#Samantha Seibel
#Homework 5: Simulating FASTQ files

#Activate your bioinfo environment
#I activate my code via the following, not sure if this is how others do
source ~/.bashrc
eval "$(micromamba shell hook --shell bash)"
micromamba activate bioinfo

#others use "conda activate bioinfo" use whichever suits your package manager

#Set Paths for reproducibility
#Change the variables to suit your needs
HOME_DIR="~/work/BMMB_852/HW5"
FASTA="Salmonella_Typhimurium.fasta"

# Move to the desired directory to download your files
cd $HOME_DIR

## Size of file
ls -lh $FASTA

## The total size of the genome
grep -v ">" $FASTA | wc -c

## The number of chromosomes in the genome
grep -c ">" $FASTA

## The name (id) and length of each chromosome in the genome.
seqtk comp $FASTA

#Generate a simulated FASTQ output for a sequencing instrument of your choice.  Set the parameters so that your target coverage is 10x**
wgsim -N 366667 -1 150 -2 150 $FASTA sim_1.fastq sim_2.fastq

#Number of reads generated
cat sim_1.fastq | wc -l
cat sim_2.fastq | wc -l

#Average read length
grep -A 2 '^@' *.fastq | grep -v '^@' | awk '{count += length($0); total++} END {print count / total}'

#Size of the FASTQ files
ls -lh sim_1.fastq
ls -lh sim_2.fastq

#Compress the files and report size
gzip sim_1.fastq sim_2.fastq
ls -lh sim_1.fastq.gz sim_2.fastq.gz
