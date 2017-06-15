#!/bin/perl -w
# This script is used to extract and format the snp information from the output file;
# Author: Xun Chen
# Version: 1.0
# Date: 04/16/17
#
#usage: perl soapconvert01.pl -i input_file -o output_file -l 70 -t pair
#
#options:
#--input	: The name of input file;
#--output	: The name of output file;
#--length	: Then length of read sequence;
#--type		: Mean that the type of reads like "single" or "pair", default: pair;

use strict;
use Getopt::Long;

my $temp01="";
my $temp02=0;
my @left="";
my @right="";
my @temp01="";
my $count=0;
my $couna=0;
my $counb=0;
my $name="";
my $best_hits="";
my $snp_number=0;
my $poli="";
my @tempa="";
my @tempb="";

#variables
my $input="p1_out02";
my $output="p1_out03";
my $length=70;
my $type="pair";

GetOptions(
 'input=s' =>\$input,
 'output=s'=>\$output,
 'length=i'=>\$length,
 'type=s'=>\$type
);
open INT,"$input"||di("di");
open OUT,">temp_out03"||di("di");
if($type eq "pair"){
while(<INT>){
  @temp01=split;
  $temp01=$_;
  if($temp01[6] eq "+"){
     $left[$couna]=$temp01;
     $couna++;}
  elsif($temp01[6] eq "-"){
     $right[$counb]=$temp01;
     $counb++;
     if($couna==$counb){
        while($count<$couna){
           @tempa=split /\s+/,$left[$count];
           @tempb=split /\s+/,$right[$count];
           $count++;
           $temp02=$tempb[8]-$length-60;
           if($temp02==$tempa[8]){
                $name="$tempa[8]";
                $best_hits=$tempa[3];
                $snp_number=$tempa[9]+$tempb[9];
                if(($tempa[9]==0)&&($tempb[9]==0)){$poli="np";}
                elsif(($tempa[9]==0)&&($tempb[9]==1)){$poli="r"."$tempb[10]";}
                elsif(($tempa[9]==0)&&($tempb[9]==2)){$poli="r"."$tempb[11]"." "."r"."$tempb[10]";}
                elsif(($tempa[9]==1)&&($tempb[9]==0)){$poli="$tempa[10]";}
                elsif(($tempa[9]==1)&&($tempb[9]==1)){$poli="$tempa[10]"." "."r"."$tempb[10]";}
                elsif(($tempa[9]==1)&&($tempb[9]==2)){$poli="$tempa[10]"." "."r"."$tempb[11]"." "."r"."$tempb[10]";}
                elsif(($tempa[9]==2)&&($tempb[9]==0)){$poli="$tempa[10]"." "."$tempa[11]";}
                elsif(($tempa[9]==2)&&($tempb[9]==1)){$poli="$tempa[10]"." "."$tempa[11]"." "."r"."$tempb[10]";}
                elsif(($tempa[9]==2)&&($tempb[9]==2)){$poli="$tempa[10]"." "."$tempa[11]"." "."r"."$tempb[11]"." "."r"."$tempb[10]";}
                print OUT "$name $best_hits $snp_number $poli\n";
                $name="";$best_hits="";$snp_number=0;$poli="";$temp02=0;
                                 }
                               }
          @tempa="";@tempb="";$count=0;$couna=0;$counb=0;@left="";@right="";                  
                           }                             
                             }
                }
                 }
elsif($type eq "single"){
while(<INT>){
  @temp01=split;
  $temp01=$_;
  $name=$temp01[8];
  $best_hits=$temp01[3];
  $snp_number=$temp01[9];
  if($temp01[9]==0){$poli="np";}
  elsif($temp01[9]==1){$poli="$temp01[10]";}
  elsif($temp01[9]==2){$poli="$temp01[10]"." "."$temp01[11]"}
  print OUT "$name $best_hits $snp_number $poli\n";
            }
                        }
close INT;
close OUT;
system "sed 's/A/ A /g' temp_out03>a;";
system "sed 's/T/ T /g' a>b";
system "sed 's/C/ C /g' b>c";
system "sed 's/G/ G /g' c>d";
system "sed 's/>/> /g' d>e";
system "mv e $output";
system "rm a b c d temp_out03";

