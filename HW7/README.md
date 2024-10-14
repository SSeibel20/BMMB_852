# Homework 7: Writing a Makefile
*Samantha Seibel October 13th, 2024*
*Using code from HWs 5 and 6*

**Bacteria of Interest**

Salmonella Typhimurium LT2
NCBI RefSeq assembly: GCF_000006945.2
Submitted GenBank assembly: GCA_000006945.2
Taxon: Salmonella enterica subsp. enterica serovar Typhimurium str. LT2
Strain: LT2
Submitter: Washington University Genome Sequencing Center
Date: Jan 13, 2016

**Code before initiating Makefile**
#activate bioinfo environment
micromamba activate environment

**Constructing a Makefile using the following**

*Targets*
usage: defines each target for user
genome: downloads assembly of selected organism
simulate: generates simulated fastq reads from the assembly
download: downloads subset of fastq files from select reads from NCBI SRA database
quality: runs fastqc on downloaded files
trim: trims fastq files with fastp based of output of fastqc then reruns fastqc

**Running the Makefile**
*usage*
![Screenshot](HW7_Screenshot1.png)



*genome*
#I had issues with the efetch command I couldn't resolve. I manually downloaded the fasta file and will proceed with this
#may be due to outage in the NCBI? Also not sure if -db assembly or genome is correct
![Screenshot](HW7_Screenshot2.png)

*simulate*
![Screenshot](HW7_Screenshot3.png)
![Screenshot](HW7_Screenshot4.png)

*download*
![Screenshot](HW7_Screenshot5.png)

*quality*
![Screenshot](HW7_Screenshot6.png)
![Screenshot](HW7_Screenshot7.png)
![Screenshot](HW7_Screenshot8.png)
![Screenshot](HW7_Screenshot9.png)

*trim*
![Screenshot](HW7_Screenshot6.png)


