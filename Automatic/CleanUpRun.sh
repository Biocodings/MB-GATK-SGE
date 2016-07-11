B#!/bin/bash -e

# Matthew Bashton 2012-2016

# A script to clean up the output following successful completion of the
# automated pipeline.

tput bold

echo -e "\nThis script will delete all intermediate files, .sam, .bam, and will leave all"
echo -e "g.vcf/.vcf and log files intact.  The de-duplicated, realigned and recalibrated"
echo -e "HaplotypeCaller emitted .bam files for each sample will also be left intact.\n\n"

read -p "Are you sure you want to delete intermediate output? " -n 1 -r
echo  ""

tput sgr0

if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    echo " - Deleting sam files"
    cd BWA_MEM
    rm *.sam
    cd ..
    echo " - Deleting inital bam files"
    cd SamToSortedBam
    rm *.ba*
    cd ..
    echo " - Deleting duplicate marked bam"
    cd MarkDuplicates
    rm *.ba*
    cd ..
    echo " - Deleting realigned bam"
    cd 1stRealn
    rm *.ba*
    cd ..
    echo " - Deleting BQSR bam"
    cd BQSR_sample_lvl
    rm *.ba*
    cd ..
    echo "All intermediate files deleted, de-duplicated, realigned and recalibrated"
    echo "HC emited .bam is left in /HC_sample_lvl left intact along with .vcf/g.vcf"
    echo "and log files."
fi
