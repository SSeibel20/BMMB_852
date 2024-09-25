# Homework 3: IGV Viz GFF files
*Samantha Seibel September 15th, 2024*

## Move to working directory

`cd /Users/sls6550/work/BMMB_852`

## Make directories for storing data

`mkdir -p ref #references`

## Download files for Xenopus tropicalis`

`wget https://ftp.ensembl.org/pub/current_gff3/xenopus_tropicalis/Xenopus_tropicalis.UCB_Xtro_10.0.112.gff3.gz`

## Unzip files

`gunzip Xenopus_tropicalis.UCB_Xtro_10.0.112.gff3`

## Separate features based on gene

`grep -w "gene" Xenopus_tropicalis.UCB_Xtro_10.0.112.gff3 > Xtropicalis_genes_only.gff3`

# Rest will be done in IGV editor