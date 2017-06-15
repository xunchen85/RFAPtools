#!usr/bin/perl -w
#
# Author: Xun Chen
# Version: 1.0
#
use strict;
my $temp01="";
my @temp01="";
my $count=0;
my $coun_a=0;
my $nn=0;
my $np=0;
my $no=0;
my $po=0;
open GEN01,"total.genotype"||di("di");
open GEN02,">total.genotype2"||di("di");
while($temp01=<GEN01>){
  @temp01=split /\s+/, $temp01;
  $count=@temp01;
  $coun_a=10;
  while($coun_a<$count){
     if(($temp01[$coun_a] eq "np")||($temp01[$coun_a] eq "nn")){$np++;}
     elsif($temp01[$coun_a] eq "no"){$no++;}
     elsif($temp01[$coun_a] eq "po"){$po++;}
     if(($temp01[$coun_a+1]!=0)&&($temp01[3]!=0)){$temp01[$coun_a+2]=int($temp01[$coun_a+2]/($temp01[3]*$temp01[$coun_a+1]));}
     $coun_a=$coun_a+3;}
  if(($np+$no+$po)==0){next;}
  print GEN02 "$np $no $po @temp01\n";
  $np=0;$no=0;$nn=0;$po=0;$count=0;@temp01="";}
