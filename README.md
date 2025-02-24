# petsc_miniapp
cd solver_for_petsc_param
mkdir build
cd build
cmake ..
make
mkdir tests
cd tests
# copy matrix mat, rhs and sol in tests
python3 ../python_test_solver/generate_parameters_single.py -p ../python_test_solver/params_light.json
sbatch submission_script.sh