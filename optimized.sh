#!/bin/bash
line=$(sed -n '13p' ../output/Optimum.txt)
xopt=(${line})
echo "RUN FOR OPTIMIZED MUFFLER: x1=" ${xopt[0]} "m, x2=" ${xopt[0]} "m"
echo "Freq vec:  [100 : 1 : 500] Hz"
freq=()
for i in $(seq 100 1 500); do freq+=($i); done
fstr=$(IFS=$' '; echo "${freq[*]}")
cd output
rm -f tlumik/* plaski/*
sed "1s/@/$fstr/" ../data/case.txt > tlumik/case.sif
number=401
sed -i "15s/@/$number/" tlumik/case.sif
cp tlumik/case.sif plaski/case.sif
echo -e "case.sif\n1" > tlumik/ELMERSOLVER_STARTINFO
cp tlumik/ELMERSOLVER_STARTINFO plaski/ELMERSOLVER_STARTINFO
# obliczenia dla tłumika:
xline=$(octave --silent --eval "replace(${xopt[0]},${xopt[0]})")
sed "4s/@/$xline/" data/tlumik.txt > tlumik.grd
ElmerGrid 1 2 tlumik.grd > /dev/null
cd tlumik
ElmerSolver > /dev/null
cd ..
# obliczenia dla płaskiego falowodu:
length=$(echo "-15-${xopt[1]}" | bc) # wpisać zależnie od długości tłumika!
sed "4s/@/$length/" data/plaski.txt > plaski.grd
ElmerGrid 1 2 plaski.grd > /dev/null
cd plaski
ElmerSolver > /dev/null
cd ..
sed -e 's/\s\+/,/g' tlumik/output.dat > tlumik-optimized.txt
sed -e 's/\s\+/,/g' plaski/output.dat > plaski-optimized.txt
octave ../scripts/optILchar.m
cd ..