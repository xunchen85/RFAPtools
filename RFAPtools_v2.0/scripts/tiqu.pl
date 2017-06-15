#!usr/bin/perl -w
#
#
#
# Author: Xun Chen
# Version: 1.0

use strict;
my $temp01="";
my @temp01="";
my $count=0;
my $coun_a=0;
open GEN01,"total.genotype3"||di("di");
open GEN02,">total.genotype4.same"||di("di");
open GEN03,">total.genotype4"||di("di");
while($temp01=<GEN01>){
  @temp01=split /\s+/, $temp01;
  $count=@temp01;
  $coun_a=7;
  if(($temp01[0] eq "0" && $temp01[2] eq "0")||(($temp01[7] =~ "np")&&($temp01[8] =~ "np"))||(($temp01[7] =~ "po")&&($temp01[8] =~ "po"))||(($temp01[7] =~ "nn")&&($temp01[8] =~ "nn"))){
      print GEN02 "@temp01\n";
     @temp01="";}
  else{print GEN03 "@temp01\n";
       @temp01="";}
                       }
