# To compile the miniapp
```
cd solver_for_petsc_param
mkdir build
cd build
cmake ..
make
```
# To run the miniapp
```
mkdir tests
cd tests
```
copy matrix and vectors of the linear problem: `mat`, `rhs`, `sol` 
modify the `params.json` file to set the petsc options investigated
```
python3 ../python_test_solver/generate_parameters_single.py -p ../python_test_solver/params_light.json
sbatch submission_script.sh
```
# To postprocess the results
`python3 ../python_test_solver/postprocess_data.py`
