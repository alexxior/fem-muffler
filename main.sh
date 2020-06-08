#!/bin/bash

# przygotuj wektor czestotliwosci:
fstep=$3
echo "Freq vec:  [100 :" $fstep ": 500] Hz"
freq=()
for i in $(seq 100 $fstep 500);do freq+=($i);done
fstr=$(IFS=$' '; echo "${freq[*]}")
sed "1s/@/$fstr/" tlumik/case.txt > tlumik/case.sif
number=$(echo "400/$fstep + 1" | bc)
sed -i "15s/@/$number/" tlumik/case.sif
rm -f tlumik/*.dat plaski/*.dat
cp tlumik/case.sif plaski/case.sif
# wykonaj plan eksperymentu:
echo "Calc for:   x1  |  x2  |  x-coords (meters)"
for x1 in $(seq 0.05 $1 0.4);do
	for x2 in $(seq 0.2 $2 1);do
		if [ $(echo "$x2 > 2*$x1" | bc) -eq 1 ];then
			# obliczenia dla tlumika:
			octave --silent --eval "replace($x1,$x2)"
			xline=$(cat xstr.txt)
			echo "          " $x1 "|" $x2 " | " $xline
			sed "4s/@/$xline/" tlumik.txt > tlumik.grd
			ElmerGrid 1 2 tlumik.grd > /dev/null
			cd tlumik
			ElmerSolver > /dev/null
			cd ..
			# obliczenia dla plaskiego falowodu:
			length=$(echo "-$x2-3*$x1" | bc) #zaleznie czy bedzie jeszcze +5m
			sed "4s/@/$length/" plaski.txt > plaski.grd
			ElmerGrid 1 2 plaski.grd > /dev/null
			cd plaski
			ElmerSolver > /dev/null
			cd ..
		fi
	done
done
