#!/bin/bash


# Written by Nathan Muncy on 11/20/17


#SBATCH --time=10:00:00   # walltime
#SBATCH --ntasks=2   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32gb   # memory per CPU core
#SBATCH -J "BenTemp"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE



workDir=~/compute/Ben_template
rawDir=${workDir}/DICOMs


cd $rawDir

for i in t*; do

    dataDir=${rawDir}/$i
    subjDir=${workDir}/"${i/t1_Luke_Reading_}"

    if [ ! -d $subjDir ]; then
        mkdir $subjDir
    fi


    # construct
    if [ ! -f ${subjDir}/struct_orig.nii.gz ]; then

        cd $dataDir
        dcm2nii -a y -g n -x y *.dcm
        mv co*.nii ${subjDir}/struct_orig.nii
        rm *.nii

    fi


    cd $subjDir

    # acpc align
    if [ ! -f struct_acpc.nii.gz ]; then
        acpcdetect -M -o struct_acpc.nii.gz -i struct_orig.nii
    fi


    # n4bc
    dim=3
    input=struct_acpc.nii.gz
    n4=struct_n4bc.nii.gz

    con=[50x50x50x50,0.0000001]
    shrink=4
    bspline=[200]

    if [ ! -f $n4 ]; then

        N4BiasFieldCorrection \
        -d $dim \
        -i $input \
        -s $shrink \
        -c $con \
        -b $bspline \
        -o $n4

    fi

cd $rawDir
done
