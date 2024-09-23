#!/bin/bash
#Counting feature types from GFF3 files 
#Samantha Seibel
#September 22nd, 2024

#Set Paths for reproducibility
#Change the variables to suit your needs
HOME_DIR="/Users/sls6550/work/BMMB_852"
URL="https://ftp.ensembl.org/pub/current_gff3/vulpes_vulpes/Vulpes_vulpes.VulVul2.2.112.abinitio.gff3.gz"
ORGANISM="Vulpes_vulpes"

#Activate your bioinfo environment
#I activate my code via the following, not sure if this is how others do
source ~/.bashrc
eval "$(micromamba shell hook --shell bash)"
micromamba activate bioinfo

#others us "conda activate bioinfo" use whichever suits your package manager

# Move to the desired directory to download your files
cd $HOME_DIR

#Get number of features 
wget -O $ORGANISM.gff3.gz $URL .

#Unzip the file 
gunzip $ORGANISM.gff3.gz 

#Figure out how many sequence regions 
seq_reg=$(grep -v '^#' $ORGANISM.gff3 | wc -l)

#print results
echo "In the $ORGANISM GFF3 file, there are $seq_reg sequence regions"

#To determine how many genes 
genes=$(grep -v '^#' $ORGANISM.gff3 | awk '$3 == "gene"' | wc -l)
echo "In the $ORGANISM GFF3 file, there are $genes genes"

if [ "$genes" -eq 0 ]; then
    echo "No genes detected, find another feature to view!"
fi

#Determine top 10 annotated features 
top_ten=$(grep -v '^#' $ORGANISM.gff3 | awk '{print $3}' | sort | uniq -c | sort -nr | head -10)
echo "In the $ORGANISM GFF3 file, the top ten annotated features are as follows: $top_ten"

#use the above annotated features if no genes are detected
