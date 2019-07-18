# SNP-Clustering
Perl script to cluster SNPs based on their genotype.

## Usage
perl ./SNPC.pl [options]

	Options:
		--file		=>	Input data file.
		--outputdir	=>	Output directory.		[./]
		--percent	=> 	Similarity percentage cut	[97]
		--nind		=>	Number of individuals		[100]

## Description

Perl software to cluster SNPs based on its genotype. 
Genotypes should be written in (a,h,b), (a,c) and (b,d) format, "-" for No Call or as 0,1,2 genotype calls and -1 for No Call.

## Author

Jose M. Hidalgo-Lopez - chema.hl@gmail.com
