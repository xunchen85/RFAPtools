#!usr/bin/perl -w

#
# Author: Xun Chen
# Version: 1.0
#

use strict;
my $temp01="";
my @temp01="";
my $temp02="";
my @temp02="";
my $genetype="";
open OUT06,"total.out05.sort"||di("di");
open OUT07,">total.out05.filter"||di("di");
open OUT08,">total.out05.change"||di("di");
while(<OUT06>){
  @temp01=split;
  $temp01=$_;
  $genetype="";
#  print "$temp01[4]\n";
  if($temp01[2]==0){print OUT07 "$temp01";}
  elsif($temp01[2]==1){
     if($temp01[4]<20){
         print OUT08 "$temp01[0] $temp01[1] 0 np\n";}
     else{print OUT07 "$temp01";}
                       }
  elsif($temp01[2]==2){
     if(($temp01[4]>=20)&&($temp01[6]>=20)){
         print OUT07 "$temp01";}
     else{
         if(($temp01[4]<20)&&($temp01[6]<20)){
              print OUT08 "$temp01[0] $temp01[1] 0 np\n";}
         elsif(($temp01[4]<20)&&($temp01[6]>=20)){
              print OUT08"$temp01[0] $temp01[1] 1 $temp01[5] $temp01[6]\n";}
         elsif(($temp01[4]>=20)&&($temp01[6]<20)){
              print OUT08 "$temp01[0] $temp01[1] 1 $temp01[3] $temp01[4]\n";}
          }           
                       }
   elsif($temp01[2]==3){
      if(($temp01[4]>=20)&&($temp01[6]>=20)&&($temp01[8]>=20)){
          print OUT07 "$temp01";}
      elsif(($temp01[4]<20)&&($temp01[6]<20)&&($temp01[8]<20)){
          print OUT08 "$temp01[0] $temp01[1] 0 np\n";}
      else{
          if($temp01[4]>=20){
             $temp01[2]=1;
             $genetype="$temp01[3]"." "."$temp01[4]"." ";
                            }
          else{
             $temp01[2]=0;
             $genetype="";
              }
          if($temp01[6]>=20){
              $temp01[2]=$temp01[2]+1;
              $genetype="$genetype"."$temp01[5]"." "."$temp01[6]"." ";}
          if($temp01[8]>=20){$temp01[2]=$temp01[2]+1;$genetype="$genetype"."$temp01[7]"." "."$temp01[8]"." ";}
          print OUT08 "$temp01[0] $temp01[1] $temp01[2] $genetype\n";
           }
                        }
    elsif($temp01[2]==4){
      if(($temp01[4]>=20)&&($temp01[6]>=20)&&($temp01[8]>=20)&&($temp01[10]>=20)){
          print OUT07 "$temp01";}
      elsif(($temp01[4]<20)&&($temp01[6]<20)&&($temp01[8]<20)&&($temp01[10]<20)){
          print OUT08 "$temp01[0] $temp01[1] 0 np\n";}
      else{
          if($temp01[4]>=20){$temp01[2]=1;$genetype="$temp01[3]"." "."$temp01[4]"." ";}
          else{
               $temp01[2]=0;
               $genetype="";
              }
          if($temp01[6]>=20){
               $temp01[2]=$temp01[2]+1;$genetype="$genetype"."$temp01[5]"." "."$temp01[6]"." ";}
          if($temp01[8]>=20){$temp01[2]=$temp01[2]+1;$genetype="$genetype"."$temp01[7]"." "."$temp01[8]"." ";}
          if($temp01[10]>=20){$temp01[2]=$temp01[2]+1;$genetype="$genetype"."$temp01[9]"." "."$temp01[10]"." ";}
          print OUT08 "$temp01[0] $temp01[1] $temp01[2] $genetype\n";
          }
                        }
                } 
