#!usr/bin/perl -w
#this script is used to link the first strand and the reverse complementary sequence of the second strand of each PE read together to form one artificial sequence tag by filling the unsequenced middle part with 60 cytosines (C). 
#
# Author: Xun Chen
# Version: 1.0
#
#
#usage: perl link.pl -read1 p1-F.fastq -read2 p1-R.fastq -t pair -c 2 -o p1_tags
#
#options:
#--read1	: The first strand of p1 parent, default: p1-F.fastq;
#--read2	: The second strand of p1 parent, default: p1-R.fastq;
#--o		: The output file name you need to specify, default=p1_tag;
#--t		: Mean that the type of reads like "single" or "pair", default: pair;
#--count	: the tags contained more than that are selected to build pseudo reference sequence, and the selection of this value depend on the volume of sequencing data of parent which you select to build prf like p1, default :2;
#


use strict;
use Getopt::Long;

my @rf1="";
my @f1="";
my $c_60="CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC";
my @r1="";
my $wf="";
my $wr="";

#variables
my $read1="p1-F.fastq";
my $read2="p1-R.fastq";
my $output="p1_tags";
my $type="pair";
my $count=2;

GetOptions(
  'read1=s' =>\$read1,
  'read2=s' =>\$read2,
  'output=s' =>\$output,
  'type=s' =>\$type,
  'count=i' =>\$count
);
###########################paire-end sequences;
if($type eq "pair"){
open WF, "samples/$read1" ||di("cannot open F");
open WR, "samples/$read2" ||di("cannot open R");
open FILE, ">$output"||di("cannot open it");
while(my $f1=<WF>){
    $f1[0]=$f1;
    chomp($f1[1]=<WF>);
    $f1[2]=<WF>;
    chomp($f1[3]=<WF>);
    $r1[0]=<WR>;
    chomp(my $temp1=<WR>);
    $r1[1]=reverse($temp1);
    $r1[1]=~s/A/a/g;
    $r1[1]=~s/T/t/g;
    $r1[1]=~s/C/c/g;
    $r1[1]=~s/G/g/g;
    $r1[1]=~s/a/T/g;
    $r1[1]=~s/t/A/g;
    $r1[1]=~s/c/G/g;
    $r1[1]=~s/g/C/g;
    $r1[2]=<WR>;
    chomp(my $temp2=<WR>);
    $r1[3]=reverse($temp2);
    my $rf1=$f1[1].$c_60.$r1[1];
    chomp($f1[0]);
    print FILE "$f1[0] $rf1\n";
    }
close WF;
close WR;
close FILE;
                  }
##########################single-end sequences;
elsif($type eq "single"){
 open WF, "samples/$read1" ||di("cannot open F");
 open FILE, ">$output"||di("cannot open it");
 while(my $f1=<WF>){
    $f1[0]=$f1;
    chomp($f1[1]=<WF>);
    $f1[2]=<WF>;
    chomp($f1[3]=<WF>);
    my $rf1=$f1[1].$c_60; 
    chomp($f1[0]);
    print FILE "$f1[0] $rf1\n";
                   }
close WF;
close FILE;
}
############################select the tags contained the minimum number of reads;
system "sort -k 2 $output >temp01";
system "uniq -c -f 1 temp01 |sort -n -r >temp02";
my @each_line="";
open TEMP02, "temp02"||di("cannot open temp02 file");
open SELECT, ">select"||di("cannot open select file");
open NOT_SELECT, ">not_select"||di("cannot open not_select file");
while(<TEMP02>){
  @each_line=split;
#  print "$each_line[0]   $count\n";
  if($each_line[0] >= $count){print SELECT "$_";}
  else{print NOT_SELECT "$_";}
             }
close TEMP02;
close SELECT;
close NOT_SELECT;
system "rm temp01 temp02";
