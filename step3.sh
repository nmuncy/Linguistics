#!/bin/bash


# Written by Nathan Muncy on 11/20/17


workDir=/Volumes/Yorick/Nate_work/Ben_template
refDir=/Volumes/Yorick/Templates/old_templates/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c
conDir=${workDir}/construct


cd $workDir

if [ ! -d $conDir ]; then
    mkdir $conDir
fi


# pull data
for i in S{1..9}*; do
    if [ ! -f ${conDir}/${i}_struct_mni.nii.gz ]; then

        dataDir=${workDir}/$i
        cp ${dataDir}/struct_mni.nii.gz ${conDir}/${i}_struct_mni.nii.gz

    fi
done


# build template
cd $conDir

DIM=3
ITER=30x90x30
TRANS=GR
SIM=CC
CON=2
PROC=6
REF=${refDir}/mni_icbm152_t1_tal_nlin_sym_09c.nii

buildtemplateparallel.sh \
-d $DIM \
-m $ITER \
-t $TRANS \
-s $SIM \
-c $CON \
-j $PROC \
-o cthulhu_mni_ \
-z $REF \
*mni.nii.gz
