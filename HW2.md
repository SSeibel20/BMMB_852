#Homework Assignment 2 BMMB 852

#Tell us a bit about the organism.
#Vulpes vulpes is a red fox. It is part of the order Carnivora. This species is present across the entire northern hemisphere.

#How many features does the file contain? 
#484791

#How many sequence regions (chromosomes) does the file contain? 
#82423

#How many genes are listed for this organism? 
#there were no genes in this file but based on using "exon" as the prompt there are 351973

#What are the top-ten most annotated feature types (column 3) across the genome? 
#exon, region, mRNA are the only ones listed for this

#Having analyzed this GFF file, does it seem like a complete and well-annotated organism? 
#No, there are a bunch of other features that could be annotated (ex: tRNA, rRNA, terminator, #polypeptide, etc). I think this is not a well-annotated organism

#Share any other insights you might note. 
#I thought it was weird that this gff3 file contained no gene annotations, I may have downloaded it wrong though.

#Create a text file that shows both how you downloaded the data and how you generated each of your results.

#find location of you desired directory 
cd /home/BMMB852

#to get number of features 
wget -O vulpes.gff3.gz https://ftp.ensembl.org/pub/current_gff3/vulpes_vulpes/Vulpes_vulpes.VulVul2.2.112.abinitio.gff3.gz .

#to unzip the file 
gunzip vulpes.gff3.gz

#to figure out how many sequence regions 
grep -v '^#' vulpes.gff3 | wc -l

#to determine how many genes 
grep -v '^#' vulpes.gff3 | awk '$3' == "exon" | wc -l

#to determine top 10 annotated features 
rep -v '^#' vulpes.gff3 | awk '{print $3}' | sort | uniq -c | sort -nr | head -10