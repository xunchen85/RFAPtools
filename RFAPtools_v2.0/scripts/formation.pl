#!usr/bin/perl -w
use strict;
#
#
# Author: Xun Chen
# Version: 1.0
#
#

my $temp01="";
my @temp01="";
my $temp02="";
my $count=0;
my $coun_a=0;
my $coverage=0;
open GEN01,"total.genotype2"||di("di");
open GEN02,">total.genotype3"||di("di");
while($temp01=<GEN01>){
  @temp01=split /\s+/, $temp01;
  $count=@temp01;
  $coun_a=13;
  print GEN02 "$temp01[0] $temp01[1] $temp01[2] $temp01[3]%$temp01[4] $temp01[5] $temp01[6] ";
  while($coun_a<$count){
    if($temp01[$coun_a] eq "np" || $temp01[$coun_a] eq "po"){
     $coverage=$coverage+$temp01[$coun_a+1];
                                                            }
    $coun_a=$coun_a+3; }
  $coun_a=7;
  $temp02="$temp01[8]"."_"."$temp01[11]"."_"."$coverage";
  print GEN02 "$temp02 ";
  $temp02="";$coverage=0;
  while($coun_a<$count){
     if($temp01[$coun_a] eq "np"){
         if(($temp01[$coun_a+1]-$temp01[$coun_a+2])>=2){print GEN02 "np ";}
         elsif((($temp01[$coun_a+1]-$temp01[$coun_a+2])==1)&&($temp01[$coun_a+1]>1)){print GEN02 "np1 ";}
         elsif((($temp01[$coun_a+1]-$temp01[$coun_a+2])==1)&&($temp01[$coun_a+1]==1)){print GEN02 "np2 ";}
         else{print GEN02 "np3 ";}}
     elsif($temp01[$coun_a] eq "nn"){
         if(($temp01[$coun_a+1]-$temp01[$coun_a+2])>=3){print GEN02 "nn ";}
         elsif((($temp01[$coun_a+1]-$temp01[$coun_a+2])==1)&&($temp01[$coun_a+1]>1)){print GEN02 "nn1 ";}
         elsif((($temp01[$coun_a+1]-$temp01[$coun_a+2])==1)&&($temp01[$coun_a+1]==1)){print GEN02 "nn2 ";}
         else{print GEN02 "nn3 ";}}
     elsif($temp01[$coun_a] eq "po"){
         if(($temp01[$coun_a+1]>=2)&&($temp01[$coun_a+2]>=20)){print GEN02 "po ";}
         elsif(($temp01[$coun_a+1]==1)&&($temp01[$coun_a+2]>=20)){print GEN02 "po2 "}
         elsif(($temp01[$coun_a+1]>=2)&&($temp01[$coun_a+2]<20)){print GEN02 "po1 ";}
         else{print GEN02 "po3 ";}}
     else{print GEN02 "0 ";}
     $coun_a=$coun_a+3;}
  print GEN02 "\n";
  $count=0;@temp01="";}
