#!usr/bin/perl -w
# This script is used to transform the output of nature_genotype_call.pl from the format of genotype to snp variations of each locus, and different variations on the same nucleotide position is delete;
# Version 2.0
#
#
# Usage: perl genotype_to_snp.pl -i input_file -o output_file
#
# Options:
#
# --input	: The name of input file,default: genotype.out;
# --output	: The name of output file,default: snp.out;
#

use strict;
use Getopt::Long;

my $tmp1="";
my $allele_num=0;
my @allele="";
my $tmp2="";
my $tmp3="";
my @tmp1="";
my @tmp2="";
my @type="";
my $i=0;
my $j=0;
my @tmp3="";
my $input="genotype.out";
my $output="snp.out";

GetOptions(
 'input=s'=>\$input,
 'output=s'=>\$output
);

open PRF, "$input"||di("out");
open SNP, ">$output"||di("out");
while(<PRF>){
 @tmp1=split;
 @tmp2=split /%/,$tmp1[1];
 $allele_num=$#tmp2;
 $tmp1=$tmp1[1];
 $tmp1=~s/\%/ /g;
 $tmp1=~s/\|/ /g;
 $tmp1=~s/n//g;
 $tmp1=~s/p//g;
 $tmp1=~s/\@/ /g;
 $tmp1=~s/^\s+//g;
 @tmp3=split /\s+/,$tmp1;
 for($i=0;$i<$#tmp3;$i+=2){
   my $a=$tmp3[$i];$b=$tmp3[$i+1];
   for($j=$i;$j<$#tmp3;$j+=2){
    if($tmp3[$j]<$a){$a=$tmp3[$j];$b=$tmp3[$j+1];$tmp3[$j]=$tmp3[$i];$tmp3[$j+1]=$tmp3[$i+1];}
                             }
   $tmp3[$i]=$a;$tmp3[$i+1]=$b; 
                          }
  $type[0]=$tmp3[0];push @type,$tmp3[1];
  for($i=0,$j=0;$i<$#tmp3;$i+=2){
    if(($tmp3[$i] eq $type[$j]) && ($tmp3[$i+1] eq $type[$j+1])){next;}
    elsif($tmp3[$i] ne $type[$j]){push @type,$tmp3[$i];push @type,$tmp3[$i+1];$j+=2;}
    elsif(($tmp3[$i] eq $type[$j]) && ($tmp3[$i+1] ne $type[$j+1])){goto Start;}
                                }
  for($j=0;$j<=$#type;$j+=2){
   my $test=$type[$j]."@".$type[$j+1];
   for($i=0;$i<=$#tmp2;$i++){
    if($test =~ $tmp2[$i]){
      my $tmp5=$type[$j+1];$tmp5=~s/-//;$tmp5=~s/>//;my $tmp6=substr($tmp5,1,1);
      if($allele[$i]){$allele[$i].=$tmp6;}
      else{$allele[$i]=$tmp6;}
                         }
    else{
       if($j>=2 && $type[$j]==$type[$j-2]){next;}
       my $tmp5=$type[$j+1];$tmp5=~s/-//;$tmp5=~s/>//;my $tmp6=substr($tmp5,0,1);
       if($allele[$i]){$allele[$i].=$tmp6}
       else{$allele[$i]=$tmp6;}
       }
                           }
                           }
   my @tmp4=split /\%/,$tmp1[6];my @geno="";my $numb=0;
   for($i=0;$i<=$#tmp4;$i++){
     my @tmp5=split /_/,$tmp4[$i];
     for($j=0;$j<=$#tmp5;$j++){
       unless($geno[$j]){
         if($tmp5[$j] eq 1){$geno[$j]=$allele[$i];}
         else{$geno[$j]="-";}
                        }
       if($tmp5[$j] eq 1 && $geno[$j] eq "-"){$geno[$j]=$allele[$i];}
       elsif($tmp5[$j] eq 1 && $geno[$j] ne "-" && $geno[$j] ne $allele[$i]){$geno[$j]=$geno[$j]."/"."$allele[$i]"}
                              }
                            }
   my $tmp7="";
   for($i=0;$i<=$#type;$i+=2){
      if($type[$i]>=130){$type[$i]=$type[$i]-61;}
      if($tmp7){$tmp7=$tmp7.";".$type[$i].",".$type[$i+1];}
      else{$tmp7=$type[$i].",".$type[$i+1];}     
                             }
   for($i=0;$i<=$#geno;$i++){if($geno[$i] ne "-"){$numb++;}}
   $tmp7=~s/-//g;
   my $tmp8=($#type+1)/2;
   print SNP "$tmp1[0] $tmp8 $numb $tmp7 @geno\n";
Start:   @allele="";@type="";@geno="";$numb=0;}
