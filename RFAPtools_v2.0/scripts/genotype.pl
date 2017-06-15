#!usr/bin/perl -w
# This script is used to call the SNPs on each locus together with the information of coverage, position and base quality;
#
# Author: Xun Chen
# Version: 1.0
#
#
# Usage: perl genotype.pl -i input_file -o output_file
#
# Options:
# --input        : The name of input file;
# --output       : The name of output file;
#

use strict;
use Getopt::Long;

my $temp01="";
my $temp02="";
my @temp01="";
my @temp02="";
my $temp03="";
my $count="";
my @f01="";
my $exit=0;
my $locus_a="";
my $locus_b="";
my @a="";                        #locus_a' number;
my @b="";                        #locus_b' number;
my $r01="";
my $coun_a=0;
my $coun_b=0;
my $test=0;
my @r_qua01="";
my @r_locus="";
my @r_number="";
my $r_qua01="";
my $r_number="";
my $np="";
my $npcount=0;
my $npqua01=0;
#variables
my $input="p1_out05.sort";
my $output="p1_genotype";

GetOptions(
 'input=s' =>\$input,
 'output=s'=>\$output
);

open REF,"total_uniq_locus"||di("di");
open LINE,"$input"||di("di");
open GENETYPE,">$output"||di("di");
$temp01=<REF>;                                        #read total_uniq_locus in front of the cycle
@temp01=split /\s+/, $temp01;                         #split this line
$locus_a=$temp01[0];                                  #read locus_a->$temp01[0]
if($temp01[2]==0){$f01[0]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]\n";}   #this four lines were format convertion
elsif($temp01[2]==1){$f01[0]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]\n";}
elsif($temp01[2]==2){$f01[0]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]\n";}
elsif($temp01[2]==3){$f01[0]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]"." "."$temp01[5]\n";}
elsif($temp01[2]==4){$f01[0]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]"." "."$temp01[5]"." "."$temp01[6]\n";}
$temp02=<LINE>;                                   #read line file in front of the cycle
@temp02=split /\s+/, $temp02;                     #split this line
$locus_b=$temp02[0];                               #read locus_b->$temp02[0]
if($temp02[2]==0){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]\n";$r_qua01=0;}      #this four lines were format convertion
elsif($temp02[2]==1){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]\n";$r_qua01=$temp02[4];}
elsif($temp02[2]==2){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]"." "."$temp02[5]\n";$r_qua01=$temp02[4]+$temp02[6];}
elsif($temp02[2]==3){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]"." "."$temp02[5]"." "."$temp02[7]\n";$r_qua01=$temp02[4]+$temp02[6]+$temp02[8];}
elsif($temp02[2]==4){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]"." "."$temp02[5]"." "."$temp02[7]"." "."$temp02[9]\n";$r_qua01=$temp02[4]+$temp02[6]+$temp02[8]+$temp02[10];}
$count=1;                                                             #$count value were 1
while(<REF>){                                                         #read total_uniq_locus
   @temp01=split;
#   print "@temp01\n";                                                     #split
   if($temp01[0] eq $locus_a){                                           #the first line compare
     if($temp01[2]==0){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]\n";}  #format convertion in total_uniq_locus
     elsif($temp01[2]==1){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]\n";}
     elsif($temp01[2]==2){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]\n";}
     elsif($temp01[2]==3){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]"." "."$temp01[5]\n";}
     elsif($temp01[2]==4){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]"." "."$temp01[5]"." "."$temp01[6]\n";}
     $count++;
#     if(eof){goto xun;}        
                             }                                               #count++ if the locus were the same
    else{                              #if the locus were not the same, then complit reading this locus,and transform to next cycle
#          print "@f01";
          @a=split /_/, $locus_a;
          @b=split /_/, $locus_b;
xun:      if($locus_a eq $locus_b){
              $coun_a=0;
              $test=2;
              while($coun_a<$count){
                 if($r01 eq $f01[$coun_a]){
                     if($temp02[3] eq "np"){$r_locus[$coun_a]="np";$np="np";$npcount++;
                          if($r_number[$coun_a]){$r_number[$coun_a]++;}
                          else{$r_number[$coun_a]=1;}
                          if($r_qua01[$coun_a]){$r_qua01[$coun_a]+=$r_qua01;}
                          else{$r_qua01[$coun_a]=$r_qua01;}
                          if($r_qua01==1){$npqua01++;}}
                     else{$r_locus[$coun_a]="po";
                         if($r_number[$coun_a]){$r_number[$coun_a]++;}
                         else{$r_number[$coun_a]=1;}
                         if($r_qua01[$coun_a]){$r_qua01[$coun_a]+=$r_qua01;}
                         else{$r_qua01[$coun_a]=$r_qua01;}}
#                     print GENETYPE "$r01";
#                     print "$r_qua01 $r01";
#                     print "$r_locus[$coun_a] $r_number[$coun_a] $r_qua01[$coun_a]\n";
                     $test=1;
                     last;
                                          }
                  $coun_a++;
                                   }
              if($exit==3){$exit=0;$test=1;}
              if($test==2){
                     $r_qua01=0;
                     if(($temp02[2]==1)&&($temp02[4]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                     elsif($temp02[2]==2){
                                if(($temp02[4]<20)&&($temp02[6]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                                elsif(($temp02[4]<20)&&($temp02[6]>=20)){$r01="$temp02[0]"." 1 "."$temp02[5]\n";$r_qua01=$temp02[6];}
                                elsif(($temp02[4]>=20)&&($temp02[6]<20)){$r01="$temp02[0]"." 1 "."$temp02[3]\n";$r_qua01=$temp02[4];}
                                         }
                     elsif($temp02[2]==3){
                                if(($temp02[4]<20)&&($temp02[6]<20)&&($temp02[8]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                                else{
                                    if($temp02[4]>=20){$temp02[2]=1;$r01="$temp02[3]"." ";$r_qua01=$temp02[4];}
                                    else{$temp02[2]=0;$r01="";}
                                    if($temp02[6]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[5]"." ";$r_qua01=$r_qua01+$temp02[6];}
                                    if($temp02[8]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[7]"." ";$r_qua01=$r_qua01+$temp02[8];}
                                    $r01=~s/\s+$//;$r01="$temp02[0]"." "."$temp02[2]"." "."$r01\n";}
                                         }
                     elsif($temp02[2]==4){
                                if(($temp02[4]<20)&&($temp02[6]<20)&&($temp02[8]<20)&&($temp02[10]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                                else{
                                    if($temp02[4]>=20){$temp02[2]=1;$r01="$temp02[3]"." ";$r_qua01=$temp02[4];}
                                    else{$temp02[2]=0;$r01="";}
                                    if($temp02[6]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[5]"." ";$r_qua01=$r_qua01+$temp02[6];}
                                    if($temp02[8]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[7]"." ";$r_qua01=$r_qua01+$temp02[8];}
                                    if($temp02[10]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[9]"." ";$r_qua01=$r_qua01+$temp02[10];}
                                    $r01=~s/\s+$//;$r01="$temp02[0]"." "."$temp02[2]"." "."$r01\n";}
                                  }
#                     print "$r01";
                     $exit=3;
                     goto xun;}}
         elsif($a[0]<$b[0]){goto xun2;}
         while(<LINE>){
             @temp02=split;
             $locus_b=$temp02[0];
             @b=split /_/, $locus_b;
#             print "@temp02\n";
             if($temp02[2]==0){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]\n";$r_qua01=0;}
             elsif($temp02[2]==1){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]\n";$r_qua01=$temp02[4];}
             elsif($temp02[2]==2){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]"." "."$temp02[5]\n";$r_qua01=$temp02[4]+$temp02[6];}
             elsif($temp02[2]==3){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]"." "."$temp02[5]"." "."$temp02[7]\n";$r_qua01=$temp02[4]+$temp02[6]+$temp02[8];}
             elsif($temp02[2]==4){$r01="$temp02[0]"." "."$temp02[2]"." "."$temp02[3]"." "."$temp02[5]"." "."$temp02[7]"." "."$temp02[9]\n";$r_qua01=$temp02[4]+$temp02[6]+$temp02[8]+$temp02[10];}
#             print "$r01";
huan:             if($locus_a eq $locus_b){
               $coun_a=0;
               $test=2;
               while($coun_a<$count){
                 if($r01 eq $f01[$coun_a]){
                     if($temp02[3] eq "np"){$r_locus[$coun_a]="np";
                                            $np="np";$npcount++;
                                            if($r_number[$coun_a]){$r_number[$coun_a]++;}
                                            else{$r_number[$coun_a]=1;}
                                            if($r_qua01[$coun_a]){$r_qua01[$coun_a]+=$r_qua01;}
                                            else{$r_qua01[$coun_a]=$r_qua01;}
                                            if($r_qua01==1){$npqua01++;}}
                     else{$r_locus[$coun_a]="po";
                          if($r_number[$coun_a]){$r_number[$coun_a]++;}
                          else{$r_number[$coun_a]=1;}
                          if($r_qua01[$coun_a]){$r_qua01[$coun_a]+=$r_qua01;}
                          else{$r_qua01[$coun_a]=$r_qua01;}}
#                   print GENETYPE "$r01";
#                   print "$r_qua01 $r01";
#                    print "$r_locus[$coun_a] $r_number[$coun_a] $r_qua01[$coun_a]\n";
                    $test=1;
                    last;}
                 $coun_a++;
                                    }
              if($exit==3){$test=1;$exit=0;}
              if($test==2){
                     $r_qua01=0;
                     if(($temp02[2]==1)&&($temp02[4]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                     elsif($temp02[2]==2){
                                if(($temp02[4]<20)&&($temp02[6]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                                elsif(($temp02[4]<20)&&($temp02[6]>=20)){$r01="$temp02[0]"." 1 "."$temp02[5]\n";$r_qua01=$temp02[6];}
                                elsif(($temp02[4]>=20)&&($temp02[6]<20)){$r01="$temp02[0]"." 1 "."$temp02[3]\n";$r_qua01=$temp02[4];}
                                         }
                     elsif($temp02[2]==3){
                                if(($temp02[4]<20)&&($temp02[6]<20)&&($temp02[8]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                                else{
                                    if($temp02[4]>=20){$temp02[2]=1;$r01="$temp02[3]"." ";$r_qua01=$temp02[4];}
                                    else{$temp02[2]=0;$r01="";}
                                    if($temp02[6]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[5]"." ";$r_qua01=$r_qua01+$temp02[6];}
                                    if($temp02[8]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[7]"." ";$r_qua01=$r_qua01+$temp02[8];}
                                    $r01=~s/\s+$//;$r01="$temp02[0]"." "."$temp02[2]"." "."$r01\n";}
                                         }
                     elsif($temp02[2]==4){
                                if(($temp02[4]<20)&&($temp02[6]<20)&&($temp02[8]<20)&&($temp02[10]<20)){$r01="$temp02[0]"." 0 np\n";$temp02[3]="np";$r_qua01=1;}
                                else{
                                    if($temp02[4]>=20){$temp02[2]=1;$r01="$temp02[3]"." ";$r_qua01=$temp02[4];}
                                    else{$temp02[2]=0;$r01="";}
                                    if($temp02[6]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[5]"." ";$r_qua01=$r_qua01+$temp02[6];}
                                    if($temp02[8]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[7]"." ";$r_qua01=$r_qua01+$temp02[8];}
                                    if($temp02[10]>=20){$temp02[2]=$temp02[2]+1;$r01="$r01"."$temp02[9]"." ";$r_qua01=$r_qua01+$temp02[10];}
                                    $r01=~s/\s+$//;$r01="$temp02[0]"." "."$temp02[2]"." "."$r01\n";}
                                  }
#                     print "$r01";
                      $exit=3;
                      goto huan;}

                                    }
             elsif($a[0]>$b[0]){next;}
             else{last;}                      
                        }
xun2:         @f01="";
         $coun_a=0;
         while($coun_a<$count){
           if($r_locus[$coun_a]){print GENETYPE "$r_locus[$coun_a] $r_number[$coun_a] $r_qua01[$coun_a]\n";}
           else{
              if($np eq "np"){print GENETYPE "no 0 0\n";}
              else{print GENETYPE "no 0 0\n";}}
           $coun_a++;}
         $np="";$npcount=0;$npqua01=0;
         @r_locus="";@r_number="";@r_qua01="";
         $locus_a=$temp01[0];
         $count=0;
#         print "@temp01\n";
         if($temp01[2]==0){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]\n";}
         elsif($temp01[2]==1){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]\n";}
         elsif($temp01[2]==2){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]\n";}
         elsif($temp01[2]==3){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]"." "."$temp01[5]\n";}
         elsif($temp01[2]==4){$f01[$count]="$temp01[0]"." "."$temp01[2]"." "."$temp01[3]"." "."$temp01[4]"." "."$temp01[5]"." "."$temp01[6]\n";}
         $count++;
         }         
             }
