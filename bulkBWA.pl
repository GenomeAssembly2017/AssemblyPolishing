#!/usr/bin/env perl

# Shashwat Deepali Nagar, 2017
# Jordan Lab, Georgia Tech

# Script for running the Burrows-Wheeler Aligner, in bulk.
# The Input directory should hav all the reads files, named
# in a logical order.

use strict;

my $usage = "Usage:\n$0 <Input Directory> <Output Directory> <Reference Genome>";
die $usage if @ARGV < 3;

my $outDir = $ARGV[0];
my $inDir = $ARGV[1];
my $refGenome = $ARGV[2];

my ($read1, $read2);
chomp(my @fileList = `ls $inDir | awk '{if(\$0 !~ /README/ && \$0 !~ /kmer/ && \$0 !~ /trim_galore/){print;}}'`);

`bwa index $refGenome`;

for (my $i = 0; $i < scalar @fileList; $i++) {
  $read1 = $fileList[$i];
  $read1 =~ /(OB\d\d\d\d)/;
  $i += 1;
  $read2 = $fileList[$i];
  system("bwa mem -R '\@RG\\tID:foo\\tSM:bar\\tLB:library1' $refGenome $read1 $read2 > $1.sam");
  system("samtools view -Sb $1.sam > $1.bam");
  `rm $1.sam`;
}
