function replace(x1,x2)
	% wektor o srodku wspolrzędnych (0,0) na osi symetrii konca wylotu
	xvec = [-15-x2, -10-x2, -10-x2+x1, -10-x1, -10, 0, 0.1];
	xstr = "";
	for i = xvec
		xstr = [xstr, ' ', num2str(i)];
	end
	disp(xstr);