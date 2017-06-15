#!/bin/perl -w
# This script is used to extract and format the snp information from the output file;
# The input_file is the output_file of soapconvert01.pl;
#
# Author: Xun Chen
# Version: 2.0
# Date: 04/16/17
#
#
# Usage: perl soapconvert02.pl -i input_file -o output_file -l 70 -t pair
#
#options:
#--input        : The name of input file;
#--output       : The name of output file;
#--length	: The length of read sequence;
#--type         : Mean that the type of reads like "single" or "pair", default: pair;


use strict;
use Getopt::Long;

my $temp01="";
my @temp01="";
my $count=0;
my $weizhi=0;
my $genetype="";
my $genetype_total="";
my $temp02="";

#variants
my $input="p1_out04";
my $output="p1_out05";
my $length=70;
my $type="pair";

GetOptions(
 'input=s' =>\$input,
 'output=s'=>\$output,
 'length=i'=>\$length,
 'type=s'=>\$type
);

open OUT04,"$input"||di("di");
open OUT05,">$output"||di("di");

if($type eq "pair"){
while(<OUT04>){
 @temp01=split;
 $temp01=$_;
 $temp02=@temp01;
 $count=3;
 $weizhi=0;
 while($count<$temp02){
    if($temp01[3] eq "np"){
        print OUT05 "$temp01";last;}
    if($temp01[$count] eq "->"){
       if($temp01[$count-2] eq "r"){
          $weizhi=$temp01[$count+1]+$length+61;
#          print "$weizhi";
          $genetype="$weizhi"."@"."$temp01[$count-1]"."$temp01[$count]"."$temp01[$count+2]"." "."$temp01[$count+3] ";
          $genetype_total="$genetype_total"."$genetype";}
        else{
          $temp01[$count+1]=$temp01[$count+1]+1;
          $genetype="$temp01[$count+1]"."@"."$temp01[$count-1]"."$temp01[$count]"."$temp01[$count+2]"." "."$temp01[$count+3] ";
          $genetype_total="$genetype_total"."$genetype";}                              
                                 }
    $count++;}
 if($temp01[3] ne "np"){
      print OUT05 "$temp01[0] $temp01[1] $temp01[2] $genetype_total\n";}
 @temp01="";$genetype="";$temp02=0;$genetype_total="";$genetype="";
               }     }
elsif($type eq "single"){
  while(<OUT04>){
 @temp01=split;
 $temp01=$_;
 $temp02=@temp01;
 $count=3;
 while($count<$temp02){
    if($temp01[3] eq "np"){
        print OUT05 "$temp01";last;}
    if($temp01[$count] eq "->"){
          $temp01[$count+1]=$temp01[$count+1]+1;
          $genetype="$temp01[$count+1]"."@"."$temp01[$count-1]"."$temp01[$count]"."$temp01[$count+2]"." "."$temp01[$count+3] ";
          $genetype_total="$genetype_total"."$genetype";}                              
    $count++;}
 if($temp01[3] ne "np"){
      print OUT05 "$temp01[0] $temp01[1] $temp01[2] $genetype_total\n";}
 @temp01="";$genetype="";$genetype_total="";$genetype="";
                 }
                            }

close OUT05;
close OUT04;
