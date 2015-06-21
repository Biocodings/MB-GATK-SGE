#!/bin/bash -e

# Matthew Bashton 2015
# Runs VEP with a whole dir of vcf input from $1 given as ../dir/*.vcf $2 is output dir which is created
[ $# -eq 0 ] && { echo -e "\nMatt Bashton 2015\n\n*** This script runs VEP on *.vcf in given dir ***\n\nError nothing to do!\n\nUsage: <input dir>  <output dir>\n\nThe output dir will be created, also don't use / on output dir names\n\n" ; exit 1; }

set -o pipefail
hostname
date

echo "Creating output dir $2"
mkdir -p $2

# Get sample names
list=(`ls -1 $1/*.vcf`)
for i in ${list[@]}
do
    echo "*** Working on $i  ***"
    echo " - Converting $i to ensembl chr ids using sed"
    sed -i.bak s/chr//g $i
    SAMP_NAME=`basename $i .vcf`
    echo " - Basename is $SAMP_NAME"
    echo " - Running VEP on $i"
    /usr/bin/time --verbose variant_effect_predictor.pl -i $i --cache --port 3337 --everything --force_overwrite --pubmed --fields Uploaded_variation,Location,Allele,Gene,Feature,Feature_type,Consequence,cDNA_position,CDS_position,Protein_position,Amino_acids,Codons,Existing_variation,IMPACT,DISTANCE,STRAND,SYMBOL,SYMBOL_SOURCE,HGNC_ID,BIOTYPE,CANONICAL,TSL,CCDS,ENSP,SWISSPROT,TREMBL,UNIPARC,SIFT,PolyPhen,EXON,INTRON,DOMAINS,HGVSc,HGVSp,GMAF,AFR_MAF,AMR_MAF,ASN_MAF,EAS_MAF,EUR_MAF,SAS_MAF,AA_MAF,EA_MAF,CLIN_SIG,SOMATIC,PUBMED,MOTIF_NAME,MOTIF_POS,HIGH_INF_POS,MOTIF_SCORE_CHANGE --html -o $2/$SAMP_NAME.VEP.txt --buffer_size 50000 --fork 12 --pick
done
echo "END"
