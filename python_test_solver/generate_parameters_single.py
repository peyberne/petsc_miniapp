#!/usr/bin/env python
import os
import json
import itertools
from datetime import datetime
#import pandas as pd
import shutil
import argparse

#import convert_to_petsc


parser = argparse.ArgumentParser(description='Description of your program')
parser.add_argument('-p','--pname', help='parameter file for scanning PETSc ksp/pc', required=True)
args = vars(parser.parse_args())

def read_json(paramfile):
    '''Read the hyperparameters file'''
    with open(paramfile) as json_file:
        json_data = json.load(json_file)
    return json_data

def mkdir_p(dir):
    '''make a directory (dir) if it doesn't exist'''
    if not os.path.exists(dir):
        os.mkdir(dir)


json_data = read_json(args['pname'])
#parse_grillix_nc4(args['fname'])

key_list = []
for k,v in json_data.items():
   key_list.append(k)

hyperparam_values = list(itertools.product(*[json_data[d]
                                    for d in key_list]))
hyperparam = []
for h in hyperparam_values:
   hyperparam.append(dict(zip(key_list, h)))

calculations = {}
for k,v in hyperparam[0].items():
   calculations[k] = []

with open('submission_script.sh','w') as fh:
    fh.writelines("#!/bin/bash\n")
    fh.writelines("#SBATCH --nodes=1\n")
    fh.writelines("#SBATCH --ntasks-per-node=1\n")
    fh.writelines("#SBATCH --cpus-per-task=1\n")
#    fh.writelines("#SBATCH --gres=gpu:1\n")
    fh.writelines("#SBATCH --time=1:00:00\n")
    fh.writelines("module load gcc openmpi petsc\n")
#    fh.writelines("export LD_LIBRARY_PATH=/home/peyberne/tools/petscbis/lib:${LD_LIBRARY_PATH}\n")

    fh.writelines("generate_benchmark(){\n")
    fh.writelines("cat <<EOF> $1/petscrc\n")
    fh.writelines("-ksp_rtol 1e-5\n")
    fh.writelines("-ksp_type $2\n")
    fh.writelines("-pc_type $3\n")
    fh.writelines("-ksp_inital_guess_nonzero no\n")

    fh.writelines("EOF\n")
    fh.writelines("   cp mat rhs sol $1\n")
    fh.writelines("   cd $1\n")
    fh.writelines("   srun /scratch/peyberne/petsc_miniapp/solver_for_petsc_param/build/miniapp_solver -mat mat -rhs rhs -sol sol > log\n")
    fh.writelines("   rm mat rhs sol $1\n")
    fh.writelines("   cd ..\n")
    fh.writelines("}\n")


    for h in hyperparam:
       string = '' 
       output_string = '' 
       current_calculation = {}
       for k,v in h.items():
           string += k+' '+v+"\n"
           calculations[k].append(v)
           current_calculation[k] = v

       output_string += h['-ksp_type']+'_'+h['-pc_type']
       shutil.rmtree(output_string, ignore_errors=True)
       mkdir_p(output_string)
       fh.writelines("generate_benchmark %s %s %s\n"% (output_string, h['-ksp_type'], \
               h['-pc_type']))





#my_df = pd.DataFrame(calculations)
#my_df.to_csv('calculations.csv')
