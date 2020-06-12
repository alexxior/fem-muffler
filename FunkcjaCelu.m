function [x1opt,x2opt] = FunkcjaCelu(x1min,x1step,x1max,x2min,x2step,x2max,fmin,fmax)
    % wyznacz srednia amplitude plaskiego falowodu
    filename = './plaski/cci.txt';
    M = dlmread(filename,',');
    [w,k] = size(M);
    pbez = zeros(w,1);
    for i = [2,7,12,17]
        pbez = pbez + sqrt( M(:,i).^2 + M(:,i+1).^2 );
    end
    p2bez = (pbez/4).^2;
    % wyznacz srednia amplitude tlumika
    filename = './tlumik/cci.txt';
    M = dlmread(filename,',');
    [w,k] = size(M);
    ptlum = zeros(w,1);
    for i = [2,7,12,17]
        ptlum = ptlum + sqrt( M(:,i).^2 + M(:,i+1).^2 );
    end
    p2tlum = (ptlum/4).^2;

    fstep = M(2,22) - M(1,22);
    number = (500-100)/fstep + 1;
    p2bezsort = zeros(number,w/number);
    p2tlumsort = p2bezsort;
    for i = 1:w/number
        p2bezsort(1:number,i) = p2bez(1+(i-1)*number : i*number);
        p2tlumsort(1:number,i) = p2tlum(1+(i-1)*number : i*number);
    end
    % wyznacz całkowitą stratę wtracenia

    f = 100:fstep:500;
    [w,k] = size(p2bezsort);
    ILtot = zeros(1,k);
    for i = 1:k
        intp2bez = trapz(f,p2bezsort(:,i)');
        intp2tlum = trapz(f,p2tlumsort(:,i)');
        ILtot(i) = 10*log10(intp2bez/intp2tlum);
    end
    format bank;
    disp(['Wyniki ILtot dla punktów CCI: ',num2str(ILtot)]);
    [t1,t2] = textread('t1t2.txt','%f %f');
    % wykonanie siatki dla punktów dyskretnych ze sweepowania
    x1_0 = (x1max + x1min)/2;
    deltax1 = (x1max - x1min)/2;
    x2_0 = (x2max + x2min)/2;
    deltax2 = (x2max - x2min)/2;
    x1vec = x1min:x1step:x1max;
    t1vec = zeros(1,length(x1vec));
    for i = 1:length(x1vec)
        t1vec(i) = (x1vec(i)-x1_0)/deltax1;
    end
    x2vec = x2min:x2step:x2max;
    t2vec = zeros(1,length(x2vec));
    for i = 1:length(x2vec)
        t2vec(i) = (x2vec(i)-x2_0)/deltax2;
    end
    % wyznaczanie współczynników wielomianu dla planu CCI
    W = zeros(6);
    for i = 1:6
        W(i,:) = [1,t1(i),t2(i),t1(i)*t2(i),t1(i)^2,t2(i)^2];
    end
    a=W\(ILtot') % równanie macierzowe x=A^(-1)*b'
    [T1,T2] = meshgrid(t1vec,t2vec);
    ILsurf=a(1)+a(2)*T1+a(3)*T2+a(4)*T1.*T2+a(5)*T1.^2+a(6)*T2.^2;
    px = [-1, (0.1-x1_0)/deltax1, 1, 1, -1];
    py = [-1, -1, (0.8-x20)/deltax2, 1, 1];
    inpts = inpolygon(T1,T2,px,py);
    ILsurf(~inpts) = nan; % wytnij niefizyczny fragment płaszczyzny
    figure('Position', [10 10 750 600]);
    surf(T1,T2,ILsurf);
    shading interp;
    hold on;
    scatter3(t1,t2,ILtot,80,'r','filled');
    set(gca,'FontSize',17);
    zlim([0,30])
    xlabel('t_1');
    ylabel('t_2');
    zlabel('IL_{tot} [dB]')
    view(-45,35);
    for i=1:length(t1)
        text(t1(i)-0.2,t2(i),ILtot(i)+2,['(',num2str(t1(i),2),',',num2str(t2(i),2),')'],'FontSize',17);
    end
    colorbar(gca);
    [min(min(ILsurf)) max(max(ILsurf))]
    [ILtot_opt,Idx] = max(ILsurf(:));

    %[ind1, ind2, ind3] = ind2sub(size(A),I)
    
    
    input('Enter:');
    
    
    %size(T1)
    %size(T2)
    %ILtot_interp = griddata(t12(:,1),t12(:,2)',ILtot,t1vec,t2vec','linear');
    %ILtot_interp = interp2(t12(:,1),t12(:,2),ILtot,T1,T2,"pchip")
    %figure();
    %mesh(T1,T2,ILtot_interp);
    %hold on
    %scatter3(t12(:,1),t12(:,2)',ILtot);
    %figure();
    %plot3(T1,T2,ones(size(T1)));
    %input("Enter:");