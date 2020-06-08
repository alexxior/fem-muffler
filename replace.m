function replace(x1,x2,fstep)
	warning('off', 'all');
	xvec = [-x2-3*x1, -x2-2*x1, -x2-x1, -3*x1, -2*x1, 0, 0.1];
	xstr = [];
	for i = xvec
		xstr = [xstr, ' ', num2str(i)];
	end
	fid=fopen("xstr.txt",'w');
	fprintf(fid, xstr);
	fclose(fid);
	fvec = 100:fstep:500;
	fstr = [];
	for i = fvec
		fstr = [fstr, ' ', num2str(i)];
	end
	fid=fopen("fstr.txt",'w');
	fprintf(fid, fstr);
	fclose(fid);
end