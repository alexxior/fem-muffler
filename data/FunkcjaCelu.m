% wyznacz srednia amplitude plaskiego falowodu
filename = './plaski/modified.txt';
M = dlmread(filename,',');
w = size(M);
pbez = zeros(w,1);
for i = [2,7,12,17]
    pbez = pbez + sqrt( M(:,i).^2 + M(:,i+1).^2 );
end
pbez = pbez/4;
% wyznacz srednia amplitude tlumika
filename = './tlumik/modified.txt';
M = dlmread(filename,',');
w = size(M);
ptlum = zeros(w,1);
for i = [2,7,12,17]
    ptlum = ptlum + sqrt( M(:,i).^2 + M(:,i+1).^2 );
end
ptlum = ptlum/4;
% wyznacz strate wtracenia
pstrat2 = pbez.^2 - ptlum.^2;
%IL_mocy = 
IL = 20*log10(pbez./ptlum);
fstep = M(2,22) - M(1,22);
number = (500-100)/fstep + 1;
IL_sort = zeros(number,w/number);
for i = 1:w/number
    IL_sort(1:number,i) = IL(1+(i-1)*number : i*number);
end
format bank
disp([(100:fstep:500)', IL_sort]);
