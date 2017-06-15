#!usr/bin/perl -w
#
# This script is used to tandemly linked unique tags remained in the "select" file to form pseudo-reference sequence (default like p1) by stuffing 100 guanines (G) to separate adjacent unique tags
# It will result several files:
#	prf.fasta contain the pseudo-reference sequence which will be used to build reference sequence by 2bwt-builder software;
#	prf.information contain all the sequence reads informations that be used to construct pseudo-reference sequence, Row 1: the order; Row 2: the position of this tag; Row 3: the total number of reads that formed this unique tag; Row 4 the name of one of representative read; Row 5: the sequence of this artificial tag;
#	prf.reads_with_N: the tags containing "N" are filtered out into this file;
#
#
# Author: Xun Chen
# Version: 2.0
# Date: 04/16/17
#
#
#usage: perl rf_without_N.pl
#
#
use strict;
my @x="";
my $n1=1;
my $n2=0;
my $n3=0;
my $rf01="";
my $m=0;
my $n=0;
my $temp01="";
my $temp02="";
my $number="";
open RF03, "select"||di("cannot open rf3");
open FILE, ">prf.fasta"||di("cannot open it");
open INFORMATION, ">prf.information"||di("cannot open it");
open DUMP01, ">prf.reads_with_N"||di("cannot open it");
print FILE ">pseudo_reference\n";
while(<RF03>){
    @x=split;
    my $temp01=index($x[2],"N");
    if($temp01!=-1){print DUMP01 "$_";}
    else{
      $temp02=$x[2];
      $temp02 .="GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG";
      $rf01 .=$temp02;
      $temp02="";
      $n2=length($x[2]);
      $n=$n1;
      $n1=$n1+$n2+100;
      $m++;
      $number=$x[0];
      print INFORMATION "$m\t$n\t$number\t$x[1]\t$x[2]\n";}}
      print FILE "$rf01\n";
close RF03;
close FILE;
close INFORMATION;
system "mkdir pseudo_reference";
system "mv prf.fasta prf.information prf.reads_with_N pseudo_reference/";

