#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --sockets-per-node=1
#SBATCH --time=1:00:00
#SBATCH --mem=0
###SBATCH -p debug
#SBATCH -q scitas

module load   gcc/8.4.0-cuda  mvapich2/2.3.4   cmake/3.16.5  petsc/3.13.1-cuda-mpi fftw mumps superlu-dist

module list
#======START=====

export OMP_NUM_THREAD=1

ulimit -s unlimited

srun  --cpu-bind=rank --gpu-bind=closest   /home/peyberne/Codes/gbs_miniapp/gbs/miniapp/solver_for_petsc_param/build_izar_gcc/miniapp_solver -mat mat_Vfine_3 -rhs rhs_Vfine_3
