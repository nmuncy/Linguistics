#!/bin/bash


# Written by Nathan Muncy on 11/20/17


workDir=~/compute/Ben_template
slurmDir=${workDir}/Slurm_out
tempDir=~/bin/Templates/old_templates/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c

time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/template_${time}

cd $slurmDir
if [ ! -d $outDir ]; then
    mkdir $outDir
fi


cd $workDir

for i in S* ; do

    subjDir=${workDir}/${i}

    sbatch \
    -o ${outDir}/output_step2_${i}.txt \
    -e ${outDir}/error_step2_${i}.txt \
    sbatch_step2.sh $subjDir $tempDir

    sleep 1

done
