#!/bin/sh
# After you sequence the two parents and segregation population like RILs or DHs or each individual in a natural population using modified ddRAD protocol, this program is used to detect allelic SNP locus from homoeologous loci using pseudo reference for segregation population or natural population;
# You need to pre-install soap2 software;
# 
# You also need to change the name of the sequencing data of the samples:
# For segregation population: You need to name them as p1-F.fastq, p1-R.fastq (if pared-end), p2-F.fastq and p2-R.fastq (if pared-end); For each segregation individual, you need to name them as 1-F.fastq, 1-R.fastq (if pared-end), 2-F.fastq, 2-R.fastq (if pared-end) and et al...
# For natural population: You just need to name them as 1-F.fastq, 1-R.fastq (if pared-end), 2-F.fastq, 2-R.fastq (if pared-end) and et al...
#
# Author: Xun Chen
# Version: 2.0
# 
#
#
# Several parameters need to be list below;
#
# population	: segregation or natural population, default: segregation;
# first_strand   : The first strand of sample used to construct pseudo-reference, default: p1-F.fastq;
# second_strand  : The second strand of sample used to construct pseudo-reference, default: p1-R.fastq;
# output_file    : The name of the output file for pseudo-reference, default: p1_tag;
# sequence_type  : Mean that the type of reads like "single" or "pair", default: pair;
# read_count     : The tags contained more than that are selected to build pseudo-reference sequence, and the selection of this value depend on the volume of sequence data which you select to build prf like p1, default :2;
# sample_number: please specify the total number of samples of segregation population (not include parents), or natural population, default: 50;
# output        : The name of output file, default: SNP_final;
# else          : The file contained dump genotypes, default: else;
# minor_genotype: The minor genotype number of the locus should be higher than this value, or this locus would be dumped, default: 20;
# loss_genotype : The loss genotype number of the locus should be less than this value, or this locus would be dumped, default: 10;
# hr_relative   : Relative heterozygous ratio which express as (heterozygous genotype/minor genotype), the value of each allelic SNP locus should be lower than it, or this locus would be dumped, default: 0.2;
# allele_number	: The number of candidate alleles belong to one candidate locus that more than that would be filtered, This parameter is only for natural population;
# read_length	: The length of read sequence;
# Options:
#
population="natural"
first_strand="1-F.fastq"
second_strand="1-R.fastq"
output_file="p1_tag"
sequence_type="pair"
read_count=2
sample_number=6
output="SNP.out"
dump="dump"
minor_genotype=1
loss_genotype=1
hr_relative=0.2
allele_number=20
read_length=70

######################################################################################prf_building.sh

perl scripts/link.pl -read1 $first_strand -read2 $second_strand -t $sequence_type -c $read_count -o $output_file
perl scripts/rf_without_N.pl
cd pseudo_reference
2bwt-builder prf.fasta
cd ../

######################################################################################prf_snpcalling.sh

if [ "$sequence_type" = "pair" ]
then
 id=1

 while [ $id -le $sample_number ]
 do
  soap -a "samples/"$id"-F.fastq" -b "samples/"$id"-R.fastq" -D pseudo_reference/prf.fasta.index -o $id"_out" -2 $id"_se" -u $id"_dump" -m 60 -x 300
  sort -k 9 -n $id"_out" >$id"_out02"
  perl scripts/soapconvert-01.pl -i $id"_out02" -o $id"_out04" -l 70 -t $sequence_type
  perl scripts/soapconvert-02.pl -i $id"_out04" -o $id"_out05" -l 70 -t $sequence_type
  sort -n -k 1 -k 4 -k 6 -k 8 -k 10 $id"_out05" >$id"_out05.sort"
  rm $id"_out" $id"_out04" $id"_out05"
  id=`expr $id + 1`
 done

 if [ "$population" = "segregation" ]
 then
  soap -a samples/p1-F.fastq -b samples/p1-R.fastq -D pseudo_reference/prf.fasta.index -o p1_out -2 p1_se -u p1_dump -m 60 -x 300
  soap -a samples/p2-F.fastq -b samples/p2-R.fastq -D pseudo_reference/prf.fasta.index -o p2_out -2 p2_se -u p2_dump -m 60 -x 300
  sort -k 9 -n p1_out >p1_out02
  perl scripts/soapconvert-01.pl -i p1_out02 -o p1_out04 -l 70 -t $sequence_type
  perl scripts/soapconvert-02.pl -i p1_out04 -o p1_out05 -l 70 -t $sequence_type
  sort -n -k 1 -k 4 -k 6 -k 8 -k 10 p1_out05 >p1_out05.sort
  rm p1_out p1_out04 p1_out05
  sort -k 9 -n p2_out >p2_out02
  perl scripts/soapconvert-01.pl -i p2_out02 -o p2_out04 -l 70 -t $sequence_type
  perl scripts/soapconvert-02.pl -i p2_out04 -o p2_out05 -l 70 -t $sequence_type
  sort -n -k 1 -k 4 -k 6 -k 8 -k 10 p2_out05 >p2_out05.sort
  rm p2_out p2_out04 p2_out05
 fi

elif [ "$sequence_type" = "single" ]
then
  id=1

  while [ $id -le $sample_number ]
  do
   soap -a "samples/"$id"-F.fastq" -D pseudo_reference/prf.fasta.index -o $id"_out"
   sort -k 9 -n $id"_out" >$id"_out02"
   perl scripts/soapconvert-01.pl -i $id"_out02" -o $id"_out04" -l 70 -t $sequence_type
   perl scripts/soapconvert-02.pl -i $id"_out04" -o $id"_out05" -l 70 -t $sequence_type
   sort -n -k 1 -k 4 -k 6 -k 8 -k 10 $id"_out05" >$id"_out05.sort"
   rm $id"_out" $id"_out04" $id"_out05"
   id=`expr $id + 1`
  done

  if [ "$population" = "segregation" ]
  then
   soap -a samples/p1-F.fastq -D pseudo_reference/prf.fasta.index -o p1_out
   soap -a samples/p2-F.fastq -D pseudo_reference/prf.fasta.index -o p2_out
   sort -k 9 -n p1_out >p1_out02
   perl scripts/soapconvert-01.pl -i p1_out02 -o p1_out04 -l 70 -t $sequence_type
   perl scripts/soapconvert-02.pl -i p1_out04 -o p1_out05 -l 70 -t $sequence_type
   sort -n -k 1 -k 4 -k 6 -k 8 -k 10 p1_out05 >p1_out05.sort
   rm p1_out p1_out04 p1_out05
   sort -k 9 -n p2_out >p2_out02
   perl scripts/soapconvert-01.pl -i p2_out02 -o p2_out04 -l 70 -t $sequence_type
   perl scripts/soapconvert-02.pl -i p2_out04 -o p2_out05 -l 70 -t $sequence_type
   sort -n -k 1 -k 4 -k 6 -k 8 -k 10 p2_out05 >p2_out05.sort
   rm p2_out p2_out04 p2_out05
  fi

else
    echo "wrong sequence_type, you need to fill in pair or single type;";
fi

################################################################

mkdir total
cat *.sort >total/total.out05.sort
cd total/
perl ../scripts/filter_out05.pl
cat total.out05.change total.out05.filter >total.out06
awk '{print$2,$3,$1,$4,$6,$8,$10}' total.out06 |sed 's/@/ /g' >total.out07
sort -k 3 -k 4 -k 6 -k 8 -k 10 -k 5 -k 7 -k 9 -k 11 total.out07 >total.out07.sort
uniq -f 1 -c total.out07.sort >total.out07.sort.uniq
sort -n -k 4 -k 5 -k 7 -k 9 -k 11 -k 6 -k 8 -k 10 -k 12 total.out07.sort.uniq >total.out07.sort.uniq.sort
awk '{print$4,$1,$2,$3,$5"@"$6,$7"@"$8,$9"@"$10,$11"@"$12}' total.out07.sort.uniq.sort |sed 's/ @//g'|sed 's/@$//g' >total.out08
awk '{if($2>=2)print$1,$2,$4,$5,$6,$7,$8}' total.out08 >../total_uniq_locus
cd ../

awk '{print$2,$3,$1"|"$4"|"$5"|"$6"|"$7}' total_uniq_locus >locus
awk '{print$1"|"$4"|"$6"|"$8"|"$10,$2}' total/total.out05.filter>map1
sort -k 1 -k 2 map1|awk '{print$2,$1}' |uniq -f 1 >map2
awk '{print$2,$1}' map2>map3
perl scripts/map_number.pl
awk '{print$2}' uniq2 >uniq3
sed 's/|$//' locus|sed 's/|$//'|sed 's/|$//' |awk '{print$3,$2}' |sed 's/|/ /' >information
rm locus map1 map2 map3 uniq2

if [ "$population" = "segregation" ]
then
 perl scripts/genotype.pl -i p1_out05.sort -o p1_genotype
 perl scripts/genotype.pl -i p2_out05.sort -o p2_genotype
fi

id=1
while [ $id -le $sample_number ]
do
 perl scripts/genotype.pl -i $id"_out05.sort" -o $id"_genotype"
 id=`expr $id + 1`
done

################################################################################################prf_allele.sh or prf_allele_nature.sh

if [ "$population" = "segregation" ]
then
 id=1
 paste information uniq3 p1_genotype p2_genotype >total.genotype
 while [ $id -le $sample_number ]
 do
   paste total.genotype $id"_genotype" >temp1
   mv temp1 total.genotype
   id=`expr $id + 1`
 done
 perl scripts/stat.pl
 perl scripts/formation.pl
 perl scripts/tiqu.pl
 sed 's/%/ /' total.genotype4 >total.genotype5
 rm total.genotype2 total.genotype3 total.genotype4 total.genotype4.same
 perl scripts/allele_call.pl -s $sample_number -o $output -d $dump -m $minor_genotype -l $loss_genotype -h $hr_relative
elif [ "$population" = "natural" ]
then
 id=1
 paste information uniq3 >total.genotype
 while [ $id -le $sample_number ]
 do
   paste total.genotype $id"_genotype" >temp1
   mv temp1 total.genotype
   id=`expr $id + 1`
 done
 perl scripts/nature_genotype_call.pl -i total.genotype -o genotype.out -e all.else -s $sample_number -l $loss_genotype -h $hr_relative -a $allele_number
 perl scripts/genotype_to_snp.pl -i genotype.out -o $output
fi
 
