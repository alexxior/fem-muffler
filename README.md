# fem-muffler
## FEM model and optimization for acoustic muffler
###### Project for MiNPwA MES
##### Requirements: Elmer FEM, Octave
## Syntax & steps:
1. Run Bash & go to master directory
2. Run main script with parameters as a step for x1, x2, freq
    `./main.sh x1_step x2_step freq_step CCI/SWEEP_flag`
3. Script will run all simulations to calculate Insertion Loss in desired total frequency band (ILtot),
    \the pressure values in 4 points near outlet for each frequency are located in:
    - `./data/cci-tlumik.txt ./data/sweep-tlumik.txt` - for muffler
    - `./data/cci-plaski.txt ./data/sweep-plaski.txt` - for flat waveguide
4. `main.sh` will run next Octave script  `./optimize.m` to obtain muffler optimization in CCI experiment and interpolate sweeped data
5. Optimized muffler parameters will be printed & saved in `./Optimum.txt`