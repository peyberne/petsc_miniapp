#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
module load gcc openmpi petsc
generate_benchmark(){
cat <<EOF> $1/petscrc
-ksp_rtol 1e-5
-ksp_type $2
-pc_type $3
-ksp_inital_guess_nonzero no
EOF
   cp mat rhs sol $1
   cd $1
   srun /scratch/peyberne/petsc_miniapp/solver_for_petsc_param/build/miniapp_solver -mat mat -rhs rhs -sol sol > log
   rm mat rhs sol $1
   cd ..
}
generate_benchmark gmres_hypre gmres hypre
generate_benchmark bcgs_hypre bcgs hypre
generate_benchmark fgmres_hypre fgmres hypre
generate_benchmark lgmres_hypre lgmres hypre
generate_benchmark dgmres_hypre dgmres hypre
generate_benchmark pgmres_hypre pgmres hypre
generate_benchmark fbcgs_hypre fbcgs hypre
generate_benchmark cg_hypre cg hypre
generate_benchmark bcgsl_hypre bcgsl hypre
generate_benchmark cgs_hypre cgs hypre
generate_benchmark fbcgsr_hypre fbcgsr hypre
generate_benchmark gmres_gamg gmres gamg
generate_benchmark bcgs_gamg bcgs gamg
generate_benchmark fgmres_gamg fgmres gamg
generate_benchmark lgmres_gamg lgmres gamg
generate_benchmark dgmres_gamg dgmres gamg
generate_benchmark pgmres_gamg pgmres gamg
generate_benchmark fbcgs_gamg fbcgs gamg
generate_benchmark cg_gamg cg gamg
generate_benchmark bcgsl_gamg bcgsl gamg
generate_benchmark cgs_gamg cgs gamg
generate_benchmark fbcgsr_gamg fbcgsr gamg
generate_benchmark gmres_sor gmres sor
generate_benchmark bcgs_sor bcgs sor
generate_benchmark fgmres_sor fgmres sor
generate_benchmark lgmres_sor lgmres sor
generate_benchmark dgmres_sor dgmres sor
generate_benchmark pgmres_sor pgmres sor
generate_benchmark fbcgs_sor fbcgs sor
generate_benchmark cg_sor cg sor
generate_benchmark bcgsl_sor bcgsl sor
generate_benchmark cgs_sor cgs sor
generate_benchmark fbcgsr_sor fbcgsr sor
generate_benchmark gmres_gasm gmres gasm
generate_benchmark bcgs_gasm bcgs gasm
generate_benchmark fgmres_gasm fgmres gasm
generate_benchmark lgmres_gasm lgmres gasm
generate_benchmark dgmres_gasm dgmres gasm
generate_benchmark pgmres_gasm pgmres gasm
generate_benchmark fbcgs_gasm fbcgs gasm
generate_benchmark cg_gasm cg gasm
generate_benchmark bcgsl_gasm bcgsl gasm
generate_benchmark cgs_gasm cgs gasm
generate_benchmark fbcgsr_gasm fbcgsr gasm
generate_benchmark gmres_asm gmres asm
generate_benchmark bcgs_asm bcgs asm
generate_benchmark fgmres_asm fgmres asm
generate_benchmark lgmres_asm lgmres asm
generate_benchmark dgmres_asm dgmres asm
generate_benchmark pgmres_asm pgmres asm
generate_benchmark fbcgs_asm fbcgs asm
generate_benchmark cg_asm cg asm
generate_benchmark bcgsl_asm bcgsl asm
generate_benchmark cgs_asm cgs asm
generate_benchmark fbcgsr_asm fbcgsr asm
generate_benchmark gmres_bjacobi gmres bjacobi
generate_benchmark bcgs_bjacobi bcgs bjacobi
generate_benchmark fgmres_bjacobi fgmres bjacobi
generate_benchmark lgmres_bjacobi lgmres bjacobi
generate_benchmark dgmres_bjacobi dgmres bjacobi
generate_benchmark pgmres_bjacobi pgmres bjacobi
generate_benchmark fbcgs_bjacobi fbcgs bjacobi
generate_benchmark cg_bjacobi cg bjacobi
generate_benchmark bcgsl_bjacobi bcgsl bjacobi
generate_benchmark cgs_bjacobi cgs bjacobi
generate_benchmark fbcgsr_bjacobi fbcgsr bjacobi
generate_benchmark gmres_jacobi gmres jacobi
generate_benchmark bcgs_jacobi bcgs jacobi
generate_benchmark fgmres_jacobi fgmres jacobi
generate_benchmark lgmres_jacobi lgmres jacobi
generate_benchmark dgmres_jacobi dgmres jacobi
generate_benchmark pgmres_jacobi pgmres jacobi
generate_benchmark fbcgs_jacobi fbcgs jacobi
generate_benchmark cg_jacobi cg jacobi
generate_benchmark bcgsl_jacobi bcgsl jacobi
generate_benchmark cgs_jacobi cgs jacobi
generate_benchmark fbcgsr_jacobi fbcgsr jacobi
generate_benchmark gmres_pbjacobi gmres pbjacobi
generate_benchmark bcgs_pbjacobi bcgs pbjacobi
generate_benchmark fgmres_pbjacobi fgmres pbjacobi
generate_benchmark lgmres_pbjacobi lgmres pbjacobi
generate_benchmark dgmres_pbjacobi dgmres pbjacobi
generate_benchmark pgmres_pbjacobi pgmres pbjacobi
generate_benchmark fbcgs_pbjacobi fbcgs pbjacobi
generate_benchmark cg_pbjacobi cg pbjacobi
generate_benchmark bcgsl_pbjacobi bcgsl pbjacobi
generate_benchmark cgs_pbjacobi cgs pbjacobi
generate_benchmark fbcgsr_pbjacobi fbcgsr pbjacobi
generate_benchmark gmres_vpbjacobi gmres vpbjacobi
generate_benchmark bcgs_vpbjacobi bcgs vpbjacobi
generate_benchmark fgmres_vpbjacobi fgmres vpbjacobi
generate_benchmark lgmres_vpbjacobi lgmres vpbjacobi
generate_benchmark dgmres_vpbjacobi dgmres vpbjacobi
generate_benchmark pgmres_vpbjacobi pgmres vpbjacobi
generate_benchmark fbcgs_vpbjacobi fbcgs vpbjacobi
generate_benchmark cg_vpbjacobi cg vpbjacobi
generate_benchmark bcgsl_vpbjacobi bcgsl vpbjacobi
generate_benchmark cgs_vpbjacobi cgs vpbjacobi
generate_benchmark fbcgsr_vpbjacobi fbcgsr vpbjacobi
