#Homework 3
#IGV Viz GFF files
#Samantha Seibel
#September 15th, 2024

#move to working directory
cd /Users/sls6550/work/BMMB_852

#make files for storing data
mkdir -p ref #references

#download files
wget https://ftp.ensembl.org/pub/current_gff3/xenopus_tropicalis/Xenopus_tropicalis.UCB_Xtro_10.0.112.gff3.gz

#unzip files
gunzip Xenopus_tropicalis.UCB_Xtro_10.0.112.gff3

#separate features based on gene
grep -w "gene" Xenopus_tropicalis.UCB_Xtro_10.0.112.gff3 > Xtropicalis_genes_only.gff3

#rest will be done in IGV editor


