#!/bin/bash

# stwórz wektor częstotliwości i przygotuj pliki:
fmin=100
fmax=500
fstep=$3
echo "Freq vec:  ["$fmin":" $fstep ":"$fmax"] Hz"
freq=()
for i in $(seq $fmin $fstep $fmax);do freq+=($i);done
fstr=$(IFS=$' '; echo "${freq[*]}")
sed "1s/@/$fstr/" data/case.txt > tlumik/case.sif
number=$(echo "($fmax-$fmin)/$fstep + 1" | bc)
sed -i "15s/@/$number/" tlumik/case.sif
rm -f tlumik/*.dat plaski/*.dat xvec.txt
cp tlumik/case.sif plaski/case.sif
echo -e "case.sif\n1" > tlumik/ELMERSOLVER_STARTINFO
cp tlumik/ELMERSOLVER_STARTINFO plaski/ELMERSOLVER_STARTINFO
# wykonaj plan eksperymentu:
echo "--------------EXPERIMENT CCI---------------"
echo "Calc for:   x1  |  x2  |  x-coords (meters)"
octave --silent --eval "cci(0.05,0.4,0.2,1)"
while read -r x1 x2; do
	# obliczenia dla tlumika:
	xline=$(octave --silent --eval "replace($x1,$x2)")
	echo "          " $x1 "|" $x2 "| " $xline
	sed "4s/@/$xline/" data/tlumik.txt > tlumik.grd
	ElmerGrid 1 2 tlumik.grd > /dev/null
	cd tlumik
	ElmerSolver > /dev/null
	cd ..
	# obliczenia dla płaskiego falowodu:
	length=$(echo "-$x2-3*$x1" | bc) #zależnie czy bedzie jeszcze +5m
	sed "4s/@/$length/" data/plaski.txt > plaski.grd
	ElmerGrid 1 2 plaski.grd > /dev/null
	cd plaski
	ElmerSolver > /dev/null
	cd ..
done < x12.txt
sed -e 's/\s\+/,/g' tlumik/WyjscieTlumik.dat > tlumik/cci.txt
sed -e 's/\s\+/,/g' plaski/WyjscieTlumik.dat > plaski/cci.txt
rm -f tlumik/*.dat plaski/*.dat
# wykonaj omiatanie z dyskretnym krokiem parametrów:
echo "--------------DISCRETE SWEEP---------------"
echo "Calc for:   x1  |  x2  |  x-coords (meters)"
for x1 in $(seq 0.05 $1 0.4);do
	for x2 in $(seq 0.2 $2 1);do
		if [ $(echo "$x2 > 2*$x1" | bc) -eq 1 ];then
			# obliczenia dla tlumika:
			xline=$(octave --silent --eval "replace($x1,$x2)")
			# echo $x1 $x2 >> xvec.txt
			echo "          " $x1 "|" $x2 "| " $xline
			sed "4s/@/$xline/" data/tlumik.txt > tlumik.grd
			ElmerGrid 1 2 tlumik.grd > /dev/null
			cd tlumik
			ElmerSolver > /dev/null
			cd ..
			# obliczenia dla płaskiego falowodu:
			length=$(echo "-$x2-3*$x1" | bc) #zależnie czy bedzie jeszcze +5m
			sed "4s/@/$length/" data/plaski.txt > plaski.grd
			ElmerGrid 1 2 plaski.grd > /dev/null
			cd plaski
			ElmerSolver > /dev/null
			cd ..
		fi
	done
done # sformatuj wyniki do analizy zamieniając spacje na przecinki:
sed -e 's/\s\+/,/g' tlumik/WyjscieTlumik.dat > tlumik/sweep.txt
sed -e 's/\s\+/,/g' plaski/WyjscieTlumik.dat > plaski/sweep.txt
# wyznacz IL, optymalizuj i zwróć wynik w konsoli
octave --silent --eval "FunkcjaCelu($1,$2)"
