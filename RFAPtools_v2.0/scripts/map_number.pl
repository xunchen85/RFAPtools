#!usr/bin/perl -w
#
#
# Author: Xun Chen
# Version: 2.0
# Date: 02/16/2014
#

use strict;
my %file=();
my $a1="";
my @a1="";
my @a2="";
my $name="";
open A1, "locus"||di("aa");
open A2, "map3"||di("di");
open A3, ">uniq2"||di("di");
while(<A2>){
   @a2=split;
   $file{$a2[0]}=$a2[1];}
while(<A1>){
   @a1=split;
   $name=$a1[2];
   if($file{$name}){
      print A3 "$name $file{$name}\n";}
   else{print A3 "$name 0\n";}
   }
close A1;
close A2;
close A3;


