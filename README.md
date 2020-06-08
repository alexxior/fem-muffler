# fem-muffler
## FEM model and optimization for acoustic muffler
###### Project for MiNPwA MES
##### Requirements: Elmer FEM, Octave
## Syntax & steps:
1. Go to master directory and run Bash
2. Run main script with parameters with respect to step for x1, x2, freq:
    `./main.sh x1_step x2_step freq_step`
3. Script will run all simulations to calculate Insertion Loss (IL), results are in:
    - `./tlumik/WyjscieTlumik.dat` - for muffler
    - `./plaski/WyjscieTlumik.dat` - for flat waveguide
4. Next run Octave script  `./FunkcjaCelu.m` to run calculations for muffler optimization
5. Optimized muffler parameters will be saved in `./WynikOptimum.txt`