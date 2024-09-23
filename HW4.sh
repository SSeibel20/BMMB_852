#!/bin/bash
#Counting feature types from GFF3 files 
#Samantha Seibel
#September 22nd, 2024

#Set Paths for reproducibility
#Change the variables to suit your needs
HOME_DIR="/Users/sls6550/work/BMMB_852"
URL="https://ftp.ensembl.org/pub/current_gff3/vulpes_vulpes/Vulpes_vulpes.VulVul2.2.112.abinitio.gff3.gz"
ORGANISM="Vulpes_vulpes"

# Move to the desired directory to download your files
cd $HOME_DIR

#Get number of features 
wget -O $ORGANISM.gff3.gz $URL

#Unzip the file 
gunzip $ORGANISM.gff3.gz 

#Figure out how many sequence regions 
grep -v '^#' $ORGANISM.gff3 | wc -l

#To determine how many genes 
grep -v '^#' $ORGANISM.gff3 | awk '$3 == "exon"' | wc -l

#Determine top 10 annotated features 
grep -v '^#' $ORGANISM.gff3 | awk '{print $3}' | sort | uniq -c | sort -nr | head -10
