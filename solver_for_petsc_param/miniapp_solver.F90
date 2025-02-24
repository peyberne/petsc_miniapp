program miniapp_solver
#include <petsc/finclude/petscksp.h>
#include <petsc/finclude/petscmat.h>
    use petscksp
    use petscmat
    use iso_c_binding
    implicit none
    character*(128)  mat0_file, rhs0_file, sol0_file, which
    character(kind=c_char,len=128) solver_type
    PetscViewer      fd
    PetscBool flg
    PetscInt its, m, n, nnz
    PetscReal norm, solution_norm, petsc_norm, petsc_norm_ssprec
    integer ierr, nprocs, color, key, rank
    KSP :: ksp
    Mat :: A
    Vec :: rhs_petsc, rhs_amgx, lhs_petsc, sol_petsc
    integer(c_long_long) :: mataddr, rhs_addr, lhs_addr
    double precision :: t1, t2, mal
    double precision :: info(MAT_INFO_SIZE)
    PetscScalar      none
    PetscInt :: maxits
    PetscReal :: normResSolver, normResCheck, normRHS, normSol, normMat, rtol, atol, dtol
    PC :: solverPC
    KSPType :: ksp_type_string
    PCType :: pc_type_string
    logical :: verbosePETSC
    real*8 :: starttime,endtime
    real*8 :: starttime_ssprec,endtime_ssprec

    verbosePETSC=.true.
    none = -1.0
    call PetscInitialize('petscrc',ierr)
!    call PetscInitialize(PETSC_NULL_CHARACTER,ierr)
    if (ierr .ne. 0) then
        print*,'Unable to initialize PETSc'
        stop
    endif

    !Read in matrix and RHS
    call PetscOptionsGetString(PETSC_NULL_OPTIONS,&
        PETSC_NULL_CHARACTER,'-mat',mat0_file,flg,ierr);CHKERRA(ierr)
    call PetscOptionsGetString(PETSC_NULL_OPTIONS,&
        PETSC_NULL_CHARACTER,'-rhs',rhs0_file,flg,ierr);CHKERRA(ierr)
    call PetscOptionsGetString(PETSC_NULL_OPTIONS,&
        PETSC_NULL_CHARACTER,'-sol',sol0_file,flg,ierr);CHKERRA(ierr)

    call MPI_Comm_Size(MPI_COMM_WORLD, nprocs, ierr)
    call MPI_Comm_Rank(MPI_COMM_WORLD, rank, ierr)

!    if(rank.eq.0) write(*,*) 'Running with ', nprocs, 'MPI tasks'

    call PetscViewerBinaryOpen(MPI_COMM_WORLD,mat0_file,FILE_MODE_READ,fd,ierr);
    call MatCreate(MPI_COMM_WORLD,A,ierr)
    call MatSetFromOptions(A, ierr)
    call MatLoad(A,fd,ierr)
    call PetscViewerDestroy(fd,ierr)
    call MatNorm(A,NORM_INFINITY,normMat,ierr)
!    print *, 'Norm of matrix:', normMat
  
    call PetscViewerBinaryOpen(MPI_COMM_WORLD,rhs0_file,FILE_MODE_READ,fd,ierr);
    call VecCreate(MPI_COMM_WORLD,rhs_petsc,ierr)
    call VecSetFromOptions(rhs_petsc, ierr)
    call VecLoad(rhs_petsc,fd,ierr)
    call PetscViewerDestroy(fd,ierr)
    call VecNorm(rhs_petsc,NORM_INFINITY,normRHS,ierr)
!     print *, 'Norm of RHS:', normRHS

    call PetscViewerBinaryOpen(MPI_COMM_WORLD,sol0_file,FILE_MODE_READ,fd,ierr);
    call VecCreate(MPI_COMM_WORLD,sol_petsc,ierr)
    call VecSetFromOptions(sol_petsc, ierr)
    call VecLoad(sol_petsc,fd,ierr)
    call PetscViewerDestroy(fd,ierr)
    call VecNorm(sol_petsc,NORM_INFINITY,normSol,ierr)
!     print *, 'Norm of RHS:', normRHS

    call VecDuplicate(rhs_petsc,lhs_petsc,ierr)
    call VecSetFromOptions(rhs_petsc, ierr)

    ! solving with PETSC
    if(rank.eq.0) then
!       print *, 'Solving with Petsc .....'
    endif
    call KSPCreate(PETSC_COMM_WORLD,ksp,ierr)
    call KSPSetFromOptions(ksp,ierr)
    call KSPSetOperators(ksp,A,A,ierr)
    starttime=MPI_Wtime()
    call KSPSolve(ksp,rhs_petsc,lhs_petsc,ierr)
    endtime=MPI_Wtime()
!    if(rank.eq.0) then    print *, "TIME PETSC = ",endtime-starttime
    call VecNorm(lhs_petsc,NORM_2,petsc_norm,ierr)

! time re-using preconditionner
    call KSPSetReusePreconditioner(ksp,PETSC_TRUE,ierr)
    starttime_ssprec=MPI_Wtime()
    call KSPSolve(ksp,rhs_petsc,lhs_petsc,ierr)
    endtime_ssprec=MPI_Wtime()
    call VecNorm(lhs_petsc,NORM_2,petsc_norm_ssprec,ierr)
!

    if(verbosePETSC) then
     ! Print convergence information. PetscPrintf() produces a single print statement from all processes that share a communicator.  
       call VecNorm(lhs_petsc,NORM_INFINITY,normSol,ierr)
!!$     call VecDuplicate(rhsPETSC,vecPETSC,ierr)
!!$     call MatMult(matPETSC,solPETSC,vecPETSC,ierr)  
!!$     call VecAXPY(vecPETSC,-1._dp,rhsPETSC,ierr)
!!$     call VecNorm(vecPETSC,NORM_INFINITY,normResCheck,ierr)
       call KSPGetTolerances(ksp, rtol, atol, dtol, maxits, ierr)
       call KSPGetType(ksp, ksp_type_string, ierr)
       call KSPGetPC(ksp, solverPC, ierr)
       call PCGetType(solverPC, pc_type_string, ierr)
       call KSPGetIterationNumber(ksp,its,ierr)
       call KSPGetResidualNorm(ksp,normResSolver,ierr)
       if(rank.eq.0) then
          print *, normResSolver!, normResCheck
          print *, endtime-starttime
          print *, endtime_ssprec-starttime_ssprec
          print *, '----------------------------------------------'
          print *, '----------    PETSC     ----------------------'
          print *, 'Krylov solver: ', trim(ksp_type_string)
          print *, 'Preconditioner: ', trim(pc_type_string)
          print *, 'Norm of matrix:', normMat
          print *, 'Norm of RHS:', normRHS
          print *, 'Norm Linf solution:', normSol
          print *, 'norm L2   solution computing precond', petsc_norm
          print *, 'norm L2   solution re-using precond', petsc_norm_ssprec
          print *, 'Number of iterations:', its
          print *, 'Residual norm from solver and check:', normResSolver!, normResCheck
          print *, '----------------------------------------------'
          print *, 'PETSC relative tolerance:', rtol
          print *, 'PETSC absolute tolerance:', atol
          print *, 'PETSC divergence tolerance:', dtol
          print *, 'PETSC max iterations:', maxits
          print *, '----------------------------------------------'
          print *, '----------------------------------------------'
       end if
    end if
    !call KSPGetIterationNumber(ksp,its,ierr)
    !call MatMult(A0,lhs0,x0,ierr)
    !call VecAXPY(x0,none,rhs0,ierr)
    !call VecNorm(lhs0,NORM_2,solution_norm,ierr)
    !call VecNorm(x0,NORM_2,norm,ierr)
    !call VecNorm(x0,NORM_2,norm,ierr)

    !if(rank.eq.0) write(6,100) solution_norm, norm,its, t2-t1
    !100 format('Solution norm ',e14.8, ' Residual norm',e11.4,' iterations ',i5, ' time',f12.5)

    call PetscFinalize(ierr)
!    call MPI_Finalize(ierr)

end program miniapp_solver
