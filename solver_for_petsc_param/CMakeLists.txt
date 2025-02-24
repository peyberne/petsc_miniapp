cmake_minimum_required(VERSION 3.10)

# Project name and language
project(MiniAppSolver Fortran)

# Enable Fortran
enable_language(Fortran)

# Find MPI
find_package(MPI REQUIRED)

# Find PETSc
set(PETSC_DIR $ENV{PETSC_DIR})

if(NOT PETSC_DIR)
    message(FATAL_ERROR "PETSC_DIR environment variables must be set.")
endif()

set(PETSC_INCLUDE_DIRS ${PETSC_DIR}/include)
set(PETSC_LIBRARIES ${PETSC_DIR}/lib/libpetsc.so)

# Include directories
include_directories(${MPI_Fortran_INCLUDE_DIRS} ${PETSC_INCLUDE_DIRS})

# Add the Fortran source file
set(SOURCE_FILE "miniapp_solver.F90")
if(NOT EXISTS ${CMAKE_SOURCE_DIR}/${SOURCE_FILE})
    message(FATAL_ERROR "Source file ${SOURCE_FILE} not found in ${CMAKE_SOURCE_DIR}")
endif()

add_executable(miniapp_solver ${SOURCE_FILE})

# Link libraries
target_link_libraries(miniapp_solver ${MPI_Fortran_LIBRARIES} ${PETSC_LIBRARIES})

# Set Fortran compiler flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O3  -ffree-line-length-none ")

# Set PETSc-specific flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -I${PETSC_INCLUDE_DIRS}")

# Set MPI-specific flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${MPI_Fortran_COMPILE_FLAGS}")

# Set linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${PETSC_DIR}/lib -Wl,-rpath,${PETSC_DIR}/lib ${MPI_Fortran_LINK_FLAGS}")
