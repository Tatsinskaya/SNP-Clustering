#!/usr/local/bin/perl

use strict;
use warnings;
use Getopt::Long qw(:config auto_help);
use File::Copy;
use Pod::Usage;

=head1 NAME

SNP Clustering

=head1 SYNOPSIS

perl ./SNPC.pl [options]

	Options:
		--file		=>	Input data file.
		--outputdir	=>	Output directory.	[./]
		--percent	=> 	Similarity percentage cut	[97]
		--nind	=>	Number of individuals	[100

=head1 DESCRIPTION

Perl software to cluster SNPs based on its genotype. 
Genotypes should be written in (a,h,b), (a,c), (b,d) format, "-" for No Call or genotype calls as 0,1,2 and -1 for No Call.
Number of individuals is set on 117, for different N, change $nind value.

=head1 AUTHOR

Jose M. Hidalgo-Lopez - chema.hl@gmail.com

=cut
my $nind = "100";
my $percent = "97";
my $file = "";
my $output = "";
my $outputdir = "";
my $i;
my $a;
my $count;
my $gaps;
my $invers;
my $perc;
my $percinv;
my $mism;
my @outarray;
my @cluster;

#------------Argument passing------------#
GetOptions (			"file=s"   => \$file,      # string
				"outputdir=s"   => \$outputdir,      # string
				"nind=i" => \$nind,    # numeric
				"percent=i" => \$percent,    # numeric
				)
				or die("Error in command line arguments\n");
				
#------------Creating Output Folder------------#
open FILEIN, $file or die "Input file not found\n";
print "Creating Output folder: \n";

mkdir $outputdir or print STDERR "Couldn't create output folder $! \n";
chdir $outputdir or print STDERR "Couldn't set output folder $! \n";
open FILEOUT, ">", "out.txt" or die "Could not create output file";
open CLUSTEREDOUT, ">", "clusterout.txt" or die "Could not create output file";

#------------Script------------#
my @array = <FILEIN>;
close (FILEIN);
printf FILEOUT $array[0];
splice(@array, 0, 1);
for ($i = 0; $i < scalar @array; $i++) {
chomp $array[$i] ;
$array[$i] =~ tr/\r//d; 
}
for ($i = 0; $i < scalar @array;) {
	my $line = $array[0]; 
	my @frase1 = split('\t', $line);
	my $id1 = $frase1[0];
	push (@outarray, $array[0]);
	splice(@array, 0, 1);
	for ($b = 0; $b < scalar @array; $b++) {
		my @frase2 = split('\t', $array[$b]);
		my $id2 = $frase2[0];
		$count = 0;
		$gaps = 0;
		$perc = 0;
		$invers = 0;
		$mism = 0;
		for ($a = 1; $a < scalar @frase1; $a++) 
		{
			if (( $frase1[$a] eq "-1" ) || ( $frase2[$a] eq "-1" ) || ( $frase1[$a] eq "-" ) || ( $frase2[$a] eq "-" ))
			{
				$gaps++;
			}
				elsif (( $frase1[$a] eq $frase2[$a] ) || ( $frase1[$a] eq "a" ) && ( $frase2[$a] eq "d" ) || ( $frase1[$a] eq "d" ) && ( $frase2[$a] eq "a" ) || ( $frase1[$a] eq "b" ) && ( $frase2[$a] eq "c" ) || ( $frase1[$a] eq "c" ) && ( $frase2[$a] eq "b" ))
				{
					$count++;
					if ((  $frase1[$a] eq "h" ) && ( $frase2[$a] eq "h" ) || ( $frase1[$a] eq "1" ) && ( $frase2[$a] eq "1" ))
						{
						$invers++;
						}
				}
					elsif (( $frase1[$a] eq "0" ) && ( $frase2[$a] eq "2" ) || ( $frase1[$a] eq "2" ) && ( $frase2[$a] eq "0" ) || ( $frase1[$a] eq "a" ) && ( $frase2[$a] eq "b" ) || ( $frase1[$a] eq "b" ) && ( $frase2[$a] eq "a" ) || ( $frase1[$a] eq "d" ) && ( $frase2[$a] eq "c" ) || ( $frase1[$a] eq "c" ) && ( $frase2[$a] eq "d" ))
						{
							$invers++;
							$mism++;

						}
					else
					{
										$mism++;
					}
		}
		$perc=(($count+$gaps)/$nind)*100;
		$percinv=(($invers+$gaps)/$nind)*100;
		if (( $perc > "$percent" ) || ( $perc eq "100" ))  {
			$array[$b]= join("\t",$id1,"NORMAL",$array[$b]);
			push(@cluster, $array[$b]); # A la variable Cluster es guarden els SNPs a descartar.
			splice(@array, $b, 1);		# S'elimina l'SNP idéntic
			$b--;
		}
		elsif (( $percinv > "$percent" ) || ( $percinv eq "100" ))  
		{
			$array[$b]= join("\t",$id1,"INVERS",$array[$b]);
			push(@cluster, $array[$b]);	# SNPs to be discarded are saved in @cluster.
			splice(@array, $b, 1);		# SNPs matching are removed.
			$b--;
		}
	}
}

foreach (@outarray) {
	 print FILEOUT "$_\n";
	 };

foreach (@cluster) {
	 print CLUSTEREDOUT "$_\n";
	 };

close FILEOUT;
close CLUSTEREDOUT;
