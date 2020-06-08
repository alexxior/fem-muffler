#!/bin/bash

fstep=$3
echo "Freq vec:  [100 :" $fstep ": 500] Hz"
rm -f tlumik/*.vtu tlumik/*.dat
echo "Calc for:   x1  |  x2  |  x-coords"
for x1 in $(seq 0.05 $1 0.4);do
	for x2 in $(seq 0.2 $2 1);do
		if [ $(echo "$x2 > 2*$x1" | bc) -eq 1 ];then
			octave --silent --eval "replace($x1,$x2,$fstep)"
			xline=$( cat xstr.txt )
			echo "          " $x1 " " $x2 "   " $xline
			sed "4s/@/$xline/" tlumik.txt > tlumik.grd
			ElmerGrid 1 2 tlumik.grd > /dev/null
			fline=$( cat fstr.txt )
			cd tlumik
			sed "1s/@/$fline/" case.txt > case.sif
			number=$( echo "400/$fstep + 1" | bc)
			sed -i "15s/@/$number/" case.sif
			ElmerSolver > /dev/null
			cd ..
		fi
	done
done
