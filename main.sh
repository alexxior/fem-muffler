#!/bin/bash
if [[ $1 =~ "-h" ]]; then
  echo "FEM-MUFFLER Syntax: ./`basename $0` [x1step] [x2step] [fstep] [CCI|SWEEP](2x bool)"
  exit 0
fi
echo FEM started: "`date +%H:%M`" # mierzenie czasu dla przewidzenia złożoności
# stwórz wektor częstotliwości i przygotuj pliki:
read -r x1min x1max x2min x2max fmin fmax <<<$(echo 0.05 0.4 0.2 1 100 500);
echo "Freq vec:  [$fmin : $3 : $fmax] Hz"
freq=() #             (fstep=$3)
flag=${4:-11}
for i in $(seq $fmin $3 $fmax); do freq+=($i); done
fstr=$(IFS=$' '; echo "${freq[*]}")
mkdir -p tlumik plaski output
rm -f tlumik/* plaski/* sweep-x1x2.txt
sed "1s/@/$fstr/" data/case.txt > tlumik/case.sif
number=$(echo "($fmax-$fmin)/$3 + 1" | bc)
sed -i "15s/@/$number/" tlumik/case.sif
cp tlumik/case.sif plaski/case.sif
echo -e "case.sif\n1" > tlumik/ELMERSOLVER_STARTINFO
cp tlumik/ELMERSOLVER_STARTINFO plaski/ELMERSOLVER_STARTINFO
if [ $flag == 10 ] || [ $flag == 11 ]; then
	# wykonaj plan eksperymentu:
	echo "--------------EXPERIMENT CCI---------------"
	echo "Calc for:   x1  |  x2  |  x-coords (meters)"
	octave --silent --eval "cci($x1min,$x1max,$x2min,$x2max)"
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
		length=$(echo "-15-$x2" | bc) # wpisać zależnie od długości tłumika!
		sed "4s/@/$length/" data/plaski.txt > plaski.grd
		ElmerGrid 1 2 plaski.grd > /dev/null
		cd plaski
		ElmerSolver > /dev/null
		cd ..
	done < ./output/cci-x1x2.txt
	# sformatuj wyniki do analizy zamieniając spacje na przecinki:
	sed -e 's/\s\+/,/g' tlumik/output.dat > output/cci-tlumik.txt
	sed -e 's/\s\+/,/g' plaski/output.dat > output/cci-plaski.txt
	rm -f tlumik/*.dat plaski/*.dat
fi
if [ $flag == 01 ] || [ $flag == 11 ]; then
	# wykonaj omiatanie z dyskretnym krokiem parametrów:
	echo "--------------DISCRETE SWEEP---------------"
	echo "Calc for:   x1  |  x2  |  x-coords (meters)"
	for x1 in $(seq $x1min $1 $x1max);do # (x1step=$1; x2step=$2)
		for x2 in $(seq $x2min $2 $x2max);do
			if [ $(echo "$x2 > 2*$x1" | bc) -eq 1 ];then
				# obliczenia dla tlumika:
				echo $x1 $x2 >> sweep-x1x2.txt
				xline=$(octave --silent --eval "replace($x1,$x2)")
				echo "          " $x1 "|" $x2 "| " $xline
				sed "4s/@/$xline/" data/tlumik.txt > tlumik.grd
				ElmerGrid 1 2 tlumik.grd > /dev/null
				cd tlumik
				ElmerSolver > /dev/null
				cd ..
				# obliczenia dla płaskiego falowodu:
				length=$(echo "-15-$x2"  | bc) # wpisać zależnie od długości tłumika!
				sed "4s/@/$length/" data/plaski.txt > plaski.grd
				ElmerGrid 1 2 plaski.grd > /dev/null
				cd plaski
				ElmerSolver > /dev/null
				cd ..
			fi
		done
	done # sformatuj wyniki do analizy zamieniając spacje na przecinki:
	sed -e 's/\s\+/,/g' tlumik/output.dat > output/sweep-tlumik.txt
	sed -e 's/\s\+/,/g' plaski/output.dat > output/sweep-plaski.txt
fi # wyznacz IL, optymalizuj i zwróć wynik w konsoli
echo -e "FEM finished: `date +%H:%M`\nPress Enter to print results in Optimum.txt"
octave --silent --eval "optimize($x1min,$1,$x1max,$x2min,$2,$x2max,$fmin,$fmax)" > ./output/Optimum.txt
cat ./output/Optimum.txt
