# fem-muffler
## FEM model and optimization for acoustic muffler
###### Project for MiNPwA MES
##### Requirements: Elmer FEM, Octave
## Syntax & steps:
1. Run Bash & go to master directory
2. Run main script with parameters as a step for x1, x2, freq
    `./main.sh x1_step x2_step freq_step`
3. Script will run all simulations to calculate Insertion Loss (IL), results are in:
    - `./tlumik/WyjscieTlumik.dat` - for muffler
    - `./plaski/WyjscieTlumik.dat` - for flat waveguide
4. Run Octave script  `./FunkcjaCelu.m` to obtain muffler optimization in CCI experiment
5. Optimized muffler parameters will be saved in `./WynikOptimum.txt`