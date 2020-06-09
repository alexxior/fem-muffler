function replace(x1,x2)
	warning('off', 'all');
	xvec = [-x2-3*x1, -x2-2*x1, -x2-x1, -3*x1, -2*x1, 0, 0.1];
	xstr = [];
	for i = xvec
		xstr = [xstr, ' ', num2str(i)];
	end
	disp(xstr);
end