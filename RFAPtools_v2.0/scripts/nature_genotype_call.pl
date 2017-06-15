#!/usr/bin/perl -w
#
# Author: Xun Chen
# Version: 2.0
# Data: 04/16/17
# Usage: perl nature_genotype_call.pl -i sample -o snp.out -e else.out -n 6 -l 0.2 -h 0.2 -a 20
#
# Options:
# --input        : Then name of input file;
# --output       : The name of output file;
# --else         : The name of file including the result of multiple mappale tags;
# --allele_number	: The number of candidate alleles belong to one candidate locus that more than that would be filtered,default:20;
# --sample_number       : The total number of the individuals you analyzed,default=6;
# --loss_genotype	: The percentage of loss genotypes,default=1;
# --hr_relative		: The percentage of relative-heterozygous genotypes,default=0.2;
# --depth		: The minimum depth of coverage of each individual,default=2;

use strict;
use Getopt::Long;
my $loci=undef;
my @buf01=""; 
my @tmp=""; 
my $individual_number=0;
my @reads_less_than_two=();
my $reads_less_than_two=0;
my @multiple=();
my $geno_single_map=0;
my $geno_multiple_map=0;
my $i=0;
my $j=0;
my $input="total.genotype";
my $output="genotype.out";
my $sample_number=6;
my $loss_genotype=1;
my $hr_relative=0.2;
my $allele_number=20;
my $else="snp.else";
my @AoA=();
my @dupli=();
my @hybrid_result=();
my $want=0;
my $compare=1;
my @duplicate="";
my $duplicate=0;
my $ge_call=0;
my $candidate=0;
my $depth=2
GetOptions(
 'input=s'=>\$input,
 'output=s'=>\$output,
 'sample_number=i'=>\$sample_number,
 'else=s'=>\$else,
 'allele_number=i'=>\$allele_number,
 'loss_genotype=i'=>\$loss_genotype,
 'hr_relative=f'=>\$hr_relative,
 'depth=i'=>\$depth
);

open INPUT,"$input"||di("di");
open OUTPUT,">$output"||di("di");
open ELSE,">$else"||di("di");

#####read each line in the while struct;
while(<INPUT>){
 @buf01=split;

#####if all the genotypes on this locus were read out then perform geno_call, or continue read out;
 data_in:if(defined($loci)){
    if($loci ne $buf01[0]){
       $ge_call++;
       goto geno_call;}
                    } 

#####read out the genotypes line by line;
 @tmp="";$tmp[0]=$buf01[0];$tmp[1]=$buf01[1];
 $tmp[2]=$buf01[2];
 $tmp[2]=0;
 $tmp[3]=$buf01[3];
 $individual_number=0;@duplicate="";
 for($i=1;$i<=$sample_number;$i++){
   if($buf01[1] eq "np"){ ## if this line is "np" genotype;
     $tmp[4]+=$buf01[($i-1)*3+5]-$buf01[($i-1)*3+6];  ##$tmp[4]: the total number of high quality copies;
     if(($buf01[($i-1)*3+5]-$buf01[($i-1)*3+6])>=$depth){$individual_number++;}
                        } ##$individual_number: the total number of available individual with more than 2 high quality copies ;
   else{
     $tmp[4]+=$buf01[($i-1)*3+5];
     if($buf01[($i-1)*3+5]>=$detph){
       if($buf01[($i-1)*3+6]/$buf01[($i-1)*3+5]>=20){$individual_number++;}}
       } ## if this line is not "np" genotype;
                           }
 $tmp[5]=$individual_number; ##tmp[5]: the number of available individual;

 for($i=1;$i<=$sample_number;$i++){ ##the formating and store of @tmp for each line;
   if(($buf01[($i-1)*3+4] eq "np")&&(($buf01[($i-1)*3+5]-$buf01[($i-1)*3+6])<1)){$tmp[($i-1)*3+7]="nn";}
   elsif(($buf01[($i-1)*3+4] eq "po")&&(($buf01[($i-1)*3+6]/$buf01[($i-1)*3+5])<20)){$tmp[($i-1)*3+7]="pp";}
   else{$tmp[($i-1)*3+7]=$buf01[($i-1)*3+4];}
   $tmp[($i-1)*3+8]=$buf01[($i-1)*3+5];
   $tmp[($i-1)*3+9]=$buf01[($i-1)*3+6];
   if($tmp[($i-1)*3+7] eq "np" || $tmp[($i-1)*3+7] eq "po"){$tmp[2]++;if(defined($tmp[6])){$tmp[6]="$tmp[6]"."_1";}else{$tmp[6]="1";}}
   else{if(defined($tmp[6])){$tmp[6]="$tmp[6]"."_0";}else{$tmp[6]="0";}}
                           }

 unless(defined($loci)){$loci=$buf01[0];} ## the define of the name of the first $locus;
 if($tmp[5]<1){push(@reads_less_than_two,[@tmp]);$reads_less_than_two++;
   print ELSE "less_than_two: @tmp\n";
              }
 elsif($tmp[3]>=2 || $tmp[3]==0){push(@multiple,[@tmp]);$geno_multiple_map++;
   print ELSE "multiple: @tmp\n";
                                }
 else{
   my $not_input=0;my $less_number=0;
   unless(defined($AoA[0])){  ##if it is empty, fill it;
     if($not_input==0){push(@AoA,[@tmp]);$not_input++;$geno_single_map++;
                          }}
   for($i=0;$i<$geno_single_map;$i++){    ## replace the record before
      if($tmp[6] eq $AoA[$i][6] && $tmp[1] ne $AoA[$i][1]){
         $not_input++;
         if($tmp[4]>$AoA[$i][4]){
            for($j=0;$j<=$#tmp;$j++){$duplicate[$j]=$AoA[$i][$j];$AoA[$i][$j]=$tmp[$j];}
                                }
         else{@duplicate=@tmp;$less_number++;}
                                                          }
                                     }
    if(defined($duplicate[4])){push(@dupli,[@duplicate]);$duplicate++;print ELSE "duplicate:@duplicate\n";}
    elsif($not_input==0){push(@AoA,[@tmp]);$geno_single_map++;
                        }
     }##input end;

  geno_call: if($ge_call>0){
    $loci=$buf01[0];
    my $pailie_count=0;my @pailie1="";my @pailie2="";my @pailie3="";my $pailie1="";
    my @zuhe=();
## detail all possible assembles;
   if($geno_single_map<=$allele_number){
    @pailie1= '1' .. $geno_single_map;
    $pailie1= '%0' . @pailie1 . 'b';
    for (1 .. 2**@pailie1 - 1){
      @pailie2=split '', sprintf $pailie1, $_;
      @pailie3=@pailie1[grep $pailie2[$_], 0 .. $#pailie2];
      if($#pailie3<$sample_number){
      push(@zuhe,[@pailie3]);
                            }
                              }}
    my @hybrid_number="";
    @hybrid_number[($sample_number*2+7)..($sample_number*3+6)]=(0) x $sample_number;
    for($i=0;$i<=$#zuhe;$i++){  ## each composition: first cycle
      for($j=0;defined($zuhe[$i][$j]);$j++){  ##test each line: second cycle
        my $k=0;my $kk=0;my $bianhao=$zuhe[$i][$j]-1;
        $hybrid_number[0]=$AoA[$bianhao][0];
        for($k=1;$k<7;$k++){
          if($k==2){if(defined($hybrid_number[$k])){if($hybrid_number[$k]>$AoA[$bianhao][$k]){$hybrid_number[$k]=$AoA[$bianhao][$k];}}
                    else{$hybrid_number[$k]=$AoA[$bianhao][$k];}
                   }
          else{if(defined($hybrid_number[$k])){$hybrid_number[$k]="$hybrid_number[$k]"."%"."$AoA[$bianhao][$k]";}
               else{$hybrid_number[$k]=$AoA[$bianhao][$k];}
              }
                           }
        my $tt=7;
        for($k=7,$kk=($sample_number*2+7),$tt=7;$k<($sample_number*3+6);$k+=3,$kk++,$tt+=2){ ## test if the individual is hybrid;
          if(defined($hybrid_number[$tt])){$hybrid_number[$tt]="$hybrid_number[$tt]"."%"."$AoA[$bianhao][$k]";}
          else{$hybrid_number[$tt]=$AoA[$bianhao][$k];}
          if(defined($hybrid_number[$tt+1])){$hybrid_number[$tt+1]="$hybrid_number[$tt+1]"."%"."$AoA[$bianhao][$k+1]";}
          else{$hybrid_number[$tt+1]=$AoA[$bianhao][$k+1];}
          if($AoA[$bianhao][$k] eq "np" || $AoA[$bianhao][$k] eq "po"){$hybrid_number[$kk]++;}
                                                                }
                                           }
        my $one=0;my $two=0;my $zero=0;
        for(my $k=$sample_number*2+7;$k<=$sample_number*3+6;$k++){
          if($hybrid_number[$k]==0){$zero++;}
          if($hybrid_number[$k]==1){$one++;}
          if($hybrid_number[$k]>=2){$two++;}
                                                   }
        $hybrid_number[$sample_number*3+7]=$zero/$sample_number;
        $hybrid_number[$sample_number*3+8]=$one/$sample_number;
        $hybrid_number[$sample_number*3+9]=$two/$hybrid_number[2];
        $hybrid_number[$sample_number*3+10]=$hybrid_number[$sample_number*3+7]+$hybrid_number[$sample_number*3+9];
        if($zero<=$loss_genotype && $hybrid_number[$sample_number*3+9]<=$hr_relative && $j>1){
          push(@hybrid_result,[@hybrid_number]);
          $candidate++;
                                                                                         }
        @hybrid_number="";
        @hybrid_number[($sample_number*2+7)..($sample_number*3+6)]=(0) x $sample_number;
                             }
                           } ##geno_call end;

  judge:if($ge_call>0){##judge start;
   if($candidate>0){
    $want=0;$compare=1;
    for($i=0;$i<$candidate;$i++){
      if($candidate==1){$want=$candidate-1;}
      else{
        if($hybrid_result[$i][$sample_number*3+8]==1){$want=$i;}
        elsif($hybrid_result[$i][$sample_number*3+10]<$compare){
         $compare=$hybrid_result[$i][$sample_number*3+10];$want=$i;}
        elsif($hybrid_result[$i][$sample_number*3+10]==$compare){
         if($hybrid_result[$i][$sample_number*3+7]<$hybrid_result[$want][$sample_number*3+7]){$want=$i;}
                                                        }
          }
                                  }
     for($i=0;$i<=$sample_number*3+10;$i++){print OUTPUT "$hybrid_result[$want][$i] ";}
     print OUTPUT "\n";
     @hybrid_result=();
     $candidate=0;
     $ge_call=0;
     @AoA=();
     @dupli=();
     @multiple=();
     @reads_less_than_two=();
     $geno_single_map=0;
     $geno_multiple_map=0;
     $reads_less_than_two=0;
     $duplicate=0;
     $want=0;$compare=1;
     goto data_in;  }
    else{
     $ge_call=0;
     $candidate=0;
     @hybrid_result=();@AoA=();@multiple=();@reads_less_than_two=();
     @dupli=();
     $duplicate=0;
     $geno_single_map=0;
     $geno_multiple_map=0;
     $reads_less_than_two=0;
     $want=0;$compare=1;
     goto data_in;
        }
                       }##judge end;


}##program end

