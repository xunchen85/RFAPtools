#!usr/bin/perl -w
#
# This script is used to discriminate allelic SNPs from homoeologous loci;
#
# Usage: perl allele_call.pl -o SNP_final -d dump -m 8 -l 8 -h 0.2
#
# Options:
#--output        : The name of output file, default: SNP_final;
#--sample_number : The total number of samples of segregation population, default: 40;
#--dump       	 : The file contained dump genotypes, default: dump;
#--minor_genotype: The minor genotype number of the locus should be higher than this value, or this locus would be dumped;
#--loss_genotype : The loss genotype number of the locus should be less than this value, or this locus would be dumped; 
#--hr_relative   : Relative heterozygous ratio which express as (heterozygous genotype/minor genotype), the value of each allelic SNP locus should be lower than it, or this locus would be dumped; 
#
# Author: Xun Chen
# Version: 1.0
# Date: 02/16/2014
#
#
#
use strict;
use Getopt::Long;



my $temp01="";
my $temp02="";
my $locus="";
my @locus01="";
my @locus02="";
my $locus02_count=0;
my @a_count="";
my @b_count="";
my $a_num=0;
my $b_num=0;
my @left01="";
my @left02="";
my @right01="";
my @right02="";
my $coun_a=0;
my $coun_b02=0;
my $coun_a02=0;
my $coun_b=0;
my $a_number=0;
my $b_number=0;
my $h_number=0;
my $o_number=0;
my @genetype="";
my $count=10;

#variables
my $output="SNP_final";
my $dump="dump";
my $minor_genotype=8;
my $loss_genotype=8;
my $hr_relative=0.2;
my $sample_number=40;

GetOptions(
 'dump=s'	   =>\$dump,
 'output=s'	   =>\$output,
 'minor_genotype=i'=>\$minor_genotype,
 'loss_genotype=i' =>\$loss_genotype,
 'hr_relative=f'   =>\$hr_relative,
 'sample_number=i' =>\$sample_number
);

open GEN04,"total.genotype5"||("di");
open GEN05,">$output"||("di");
open GEN06,">$dump"||("di");
$temp01=<GEN04>;
$locus02[0]=$temp01;
@locus01=split /\s+/, $temp01;
$locus=$locus01[03];
if($locus01[8]=~"np"){$left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;}
elsif(($locus01[8]=~"po")&&($locus01[9]=~"po")){
   $left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;
   $right01[$coun_b]=$temp01;$b_count[$coun_b]=$locus02_count;$coun_b++;}
elsif(($locus01[8]=~"po")&&(($locus01[9]=~"nn")||($locus01[9] eq "0"))){
    $left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;}
elsif(($locus01[9]=~"po")&&(($locus01[8]=~"nn")||($locus01[8] eq "0"))){
    $right01[$coun_b]=$temp01;$b_count[$coun_b]=$locus02_count;$coun_b++;}
while(<GEN04>){
  @locus01=split;
  $temp01=$_;
  if($locus01[3] eq $locus){
      $locus02_count++;$locus02[$locus02_count]=$temp01;
      if($locus01[8]=~"np"){
          $left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;}
      elsif(($locus01[8]=~"po")&&($locus01[9]=~"po")){
          $left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;
          $right01[$coun_b]=$temp01;$b_count[$coun_b]=$locus02_count;$coun_b++;}
      elsif(($locus01[8]=~"po")&&(($locus01[9]=~"nn")||($locus01[9] eq "0"))){
          $left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;}
      elsif(($locus01[9]=~"po")&&(($locus01[8]=~"nn")||($locus01[8] eq "0"))){
          $right01[$coun_b]=$temp01;$b_count[$coun_b]=$locus02_count;$coun_b++;}}
  else{
      if(($coun_a>=1)&&($coun_b>=1)){
        $coun_a02=0;$coun_b02=0;
        while($coun_b02<$coun_b){
          @right02=split /\s+/, $right01[$coun_b02];
          $coun_a02=0;
#           print "@right02\n";
           while($coun_a02<$coun_a){
              @left02=split /\s+/, $left01[$coun_a02];
              $count=10;
#              print "@left02\n";
              $genetype[0]=$locus;$genetype[1]="$left02[4]"."/"."$right02[4]";
              $genetype[2]=$left02[5];$genetype[3]=$left02[6];$genetype[4]=$left02[7];$genetype[5]=$right02[5];$genetype[6]=$right02[6];$genetype[7]=$right02[7];
              while($count<(10+$sample_number)){
#                print "$count\t$left02[$count]aaaaa\n";
                if(($left02[$count]=~"np")&&(($right02[$count] eq "0")||($right02[$count]=~"nn"))){
                    if($left02[$count] eq "np"){$genetype[$count+5]="A";$a_number++;}
                    elsif($left02[$count] eq "np1"){$genetype[$count+5]="A1";$a_number++;}
                    elsif($left02[$count] eq "np2"){$genetype[$count+5]="A2";$a_number++;}
                    elsif($left02[$count] eq "np3"){$genetype[$count+5]="A3";$a_number++;}}
                elsif(($left02[$count]=~"po")&&(($right02[$count] eq "0")||($right02[$count]=~"nn"))){
                    if($left02[$count] eq "po"){$genetype[$count+5]="A";$a_number++;}
                    elsif($left02[$count] eq "po1"){$genetype[$count+5]="A1";$a_number++;}
                    elsif($left02[$count] eq "po2"){$genetype[$count+5]="A2";$a_number++;}
                    elsif($left02[$count] eq "po3"){$genetype[$count+5]="A3";$a_number++;}}
                elsif((($left02[$count] eq "0")||($left02[$count]=~"nn"))&&($right02[$count]=~"po")){
                    if($right02[$count] eq "po"){$genetype[$count+5]="B";$b_number++;}
                    elsif($right02[$count] eq "po1"){$genetype[$count+5]="B1";$b_number++;}
                    elsif($right02[$count] eq "po2"){$genetype[$count+5]="B2";$b_number++;}
                    elsif($right02[$count] eq "po3"){$genetype[$count+5]="B3";$b_number++;}}
                elsif(($left02[$count] eq "0")&&($right02[$count] eq "0")){
                    $genetype[$count+5]="0";$o_number++;}
                elsif(($left02[$count]=~"nn")&&($right02[$count]=~"nn")){
                    $genetype[$count+5]="0";$o_number++;}
                elsif((($left02[$count]=~"np")&&($right02[$count]=~"po"))||(($left02[$count]=~"po")&&($right02[$count]=~"po"))){
                    if(($left02[$count]=~"np")&&($right02[$count] eq "po3")&&($left02[$count] ne "np3")){$genetype[$count+5]="A4";$a_number++;}
                    elsif(($left02[$count] eq "np3")&&($right02[$count]=~"po")&&($right02[$count] ne "po3")){$genetype[$count+5]="B4";$b_number++;}
                    else{$genetype[$count+5]="H";
                    $h_number++;}}
                    $count++;  }
              $genetype[8]=$a_number;$genetype[9]=$b_number;$genetype[10]=$h_number;$genetype[11]=$o_number;$genetype[13]="$left02[8]"."/"."$right02[8]";$genetype[14]="$left02[9]"."/"."$right02[9]";
              if(($a_number<=$b_number)&&($a_number!=0)){$genetype[12]=$h_number/$a_number;}
              elsif(($b_number!=0)&&($a_number>$b_number)){$genetype[12]=$h_number/$b_number;}
              else{$genetype[12]=$sample_number;}
              if(($genetype[12]<=$hr_relative)&&($genetype[8]>=$minor_genotype)&&($genetype[9]>=$minor_genotype)&&($genetype[11]<=$loss_genotype)){
                   print GEN05 "@genetype\n";
                   $a_num=$a_count[$coun_a02];$b_num=$b_count[$coun_b02];
                   $locus02[$a_num]="";
                   $locus02[$b_num]="";}
#             else{print GEN06 "@right02\n";}
              $a_number=0;$b_number=0;$h_number=0;$o_number=0;@genetype="";
              $coun_a02++;                     }   
              $coun_b02++;                 }}
#      print "@right01";
      print GEN06 "@locus02";
      $locus=$locus01[3];
      $coun_a=0;$coun_b=0;@locus02="";$locus02_count=0;@a_count="";@b_count="";$locus02[$locus02_count]=$temp01;
      if($locus01[8]=~"np"){$left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;}
      elsif(($locus01[8] eq "po3")&&($locus01[9] eq "po3")){
           $left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;
           $right01[$coun_b]=$temp01;$b_count[$coun_b]=$locus02_count;$coun_b++;}
      elsif(($locus01[8]=~"po")&&(($locus01[9]=~"nn")||($locus01[9] eq "0"))){
           $left01[$coun_a]=$temp01;$a_count[$coun_a]=$locus02_count;$coun_a++;}
      elsif(($locus01[9]=~"po")&&(($locus01[8]=~"nn")||($locus01[8] eq "0"))){
           $right01[$coun_b]=$temp01;$b_count[$coun_b]=$locus02_count;$coun_b++;}
      if(eof){print GEN06 "@locus02";}
       }
}
