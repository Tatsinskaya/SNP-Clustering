# SNP-Clustering
Perl software to cluster SNPs based on its genotype.

## Usage
perl ./SNPC.pl [options]

	Options:
		--file		=>	Input data file.
		--outputdir	=>	Output directory.	[./]
		--percent	=> 	Similarity percentage cut	[97]
		--nind	=>	Number of individuals	[100]

## Description

Perl software to cluster SNPs based on its genotype. 
Genotypes should be written in (a,h,b), (a,c), (b,d) format, "-" for No Call or genotype calls as 0,1,2 and -1 for No Call.

## Author

Jose M. Hidalgo-Lopez - chema.hl@gmail.com
