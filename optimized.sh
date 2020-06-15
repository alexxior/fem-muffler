#!/bin/bash
echo "RUN FOR OPTIMIZED MUFFLER: x1=0.17 m, x2=0.35 m"
echo "Freq vec:  [100 : 1 : 500] Hz"
freq=()
for i in $(seq 100 1 500); do freq+=($i); done
fstr=$(IFS=$' '; echo "${freq[*]}")
rm -f tlumik/* plaski/*
sed "1s/@/$fstr/" data/case.txt > tlumik/case.sif
number=401
sed -i "15s/@/$number/" tlumik/case.sif
cp tlumik/case.sif plaski/case.sif
echo -e "case.sif\n1" > tlumik/ELMERSOLVER_STARTINFO
cp tlumik/ELMERSOLVER_STARTINFO plaski/ELMERSOLVER_STARTINFO
# obliczenia dla tłumika:
xline=$(octave --silent --eval "replace(0.17,0.35)")
sed "4s/@/$xline/" data/tlumik.txt > tlumik.grd
ElmerGrid 1 2 tlumik.grd > /dev/null
cd tlumik
ElmerSolver > /dev/null
cd ..
# obliczenia dla płaskiego falowodu:
length=$(echo "-15-0.35" | bc) # wpisać zależnie od długości tłumika!
sed "4s/@/$length/" data/plaski.txt > plaski.grd
ElmerGrid 1 2 plaski.grd > /dev/null
cd plaski
ElmerSolver > /dev/null
cd ..
sed -e 's/\s\+/,/g' tlumik/output.dat > output/tlumik-optimized.txt
sed -e 's/\s\+/,/g' plaski/output.dat > output/plaski-optimized.txt
octave optILchar.m