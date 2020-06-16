# fem-muffler
## Universal FEM model and optimization for acoustic muffler
###### Project for MiNPwA MES
##### Requirements: Elmer CSC, Octave
## Syntax & steps:
0. Clone repo to desired directory: `git clone https://github.com/alexxior/fem-muffler.git .`
1. Run Bash & go to master directory
2. Run main script with parameters as **steps for x1(m), x2(m), f(Hz)** and **choice flag between CCI & sweeped data** method:
    `./runmuffler.sh [x1_step] [x2_step] [freq_step] [CCI|SWEEP](2xbool flag)`
3. Script will run all simulations to calculate *Total Insertion Loss* in desired frequency band - **ILtot (dB)**,\
    the pressure values in 4 points near outlet for each frequency are located in `./output/`:
    - `/cci-tlumik.txt /sweep-tlumik.txt` - for muffler
    - `/cci-plaski.txt /sweep-plaski.txt` - for flat waveguide
4. `runmuffler.sh` will run next Octave script  `./scripts/optimize.m` to obtain muffler *optimization in CCI experiment plan* and interpolate sweeped data
5. FEM process and optimized muffler parameters will be printed & saved in `./output/Optimum.txt`
6. - To only show precalculated data do not append flags in parameters.
    - To only show precalculated optimized muffler charateristics run `octave ./scripts/optILchar.m`
    - To calculate & show precise *Insertion Loss characteristics -* **IL(f)** for new optimized muffler run `./optimized.sh`