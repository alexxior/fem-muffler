function optimize(x1min,x1step,x1max,x2min,x2step,x2max,fmin,fmax)
    % posortuj wyniki CCI i wyznacz calk strate wtracenia plaskiego falowodu
    [CCI_intp2bez, k] = sortcalc("cci-plaski",fmin,fmax);
    % posortuj wyniki CCI i wyznacz calk strate wtracenia tlumika
    CCI_intp2tlum = sortcalc("cci-tlumik",fmin,fmax);
    % wyznaczenie calkowitej straty wtracenia
    CCI_ILtot = zeros(1,k);
    for i = 1:k
        CCI_ILtot(i) = 10*log10(CCI_intp2bez(i)/CCI_intp2tlum(i));
    end
    [CCI_t1,CCI_t2] = textread('cci-t1t2.txt','%f %f');
    % wykonanie siatki dla punktow z planu CCI
    x1_0 = (x1max + x1min)/2;
    dx1 = (x1max - x1min)/2;
    x2_0 = (x2max + x2min)/2;
    dx2 = (x2max - x2min)/2;
    CCI_x1vec = x1min:0.001:x1max; % gesta siatka dla interpolacji
    CCI_t1vec = (CCI_x1vec-x1_0)/dx1;
    CCI_x2vec = x2min:0.001:x2max;
    CCI_t2vec = (CCI_x2vec-x2_0)/dx2;
    % wyznaczanie wspolczynnikow wielomianu dla planu CCI
    W = zeros(6);
    for i = 1:6
        W(i,:) = [1,CCI_t1(i),CCI_t2(i),CCI_t1(i)*CCI_t2(i),CCI_t1(i)^2,CCI_t2(i)^2];
    end
    [CCI_T1,CCI_T2] = meshgrid(CCI_t1vec,CCI_t2vec);
    % wyznaczanie i plotowanie plaszczyzny odpowiedzi
    a=W\(CCI_ILtot'); % rownanie macierzowe: x=A^(-1)*b'
    ILsurf = a(1)+a(2)*CCI_T1+a(3)*CCI_T2+a(4)*CCI_T1.*CCI_T2+a(5)*CCI_T1.^2+a(6)*CCI_T2.^2;
    px = [-1, (0.1-x1_0)/dx1, 1, 1, -1];
    py = [-1, -1, (0.8-x2_0)/dx2, 1, 1];
    inpts = inpolygon(CCI_T1,CCI_T2,px,py);
    ILsurf(~inpts) = nan; % wytnij niefizyczny fragment płaszczyzny
    figure('Position', [1000 300 750 600]);
    surf(CCI_T1,CCI_T2,ILsurf); shading interp;
    hold on;
    scatter3(CCI_t1,CCI_t2,CCI_ILtot,80,'r','filled');
    set(gca,'FontSize',17);
    xlabel('t_1');
    ylabel('t_2');
    zlabel('IL_{tot} [dB]')
    view(170,20);
    line = "ILtot values for CCI points:\nt1\tt2\tILtot\n";
    for i=1:length(CCI_t1)
        text(CCI_t1(i)+0.3,CCI_t2(i),CCI_ILtot(i)+1,['(',num2str(CCI_t1(i),2),',',num2str(CCI_t2(i),2),')'],'FontSize',17);
        line = strcat(line,num2str(CCI_t1(i),2),"\t",num2str(CCI_t2(i),2),"\t",num2str(CCI_ILtot(i),2),"\n");
    end
    clb = colorbar(gca,'FontSize',17);
    set(clb,'YTick',[round(min(min(ILsurf))*10)/10,-4:1,round(max(max(ILsurf))*10)/10]);
    [CCI_ILtotmax,Idx] = max(ILsurf(:));
    [CCI_ILtotmaxRow,CCI_ILtotmaxCol] = ind2sub(size(ILsurf), Idx);
    Popt = [CCI_T1(1,CCI_ILtotmaxCol),CCI_T2(CCI_ILtotmaxRow,1),CCI_ILtotmax];
    scatter3(Popt(1),Popt(2),Popt(3),'b','filled');
    text(Popt(1)+0.3,Popt(2),Popt(3)+1,['(',num2str(Popt(1),2),',',num2str(Popt(2),2),')'],'FontSize',17);
    contour3(CCI_T1,CCI_T2,ILsurf,15,'b');
    % posortuj wyniki sweepa i wyznacz calk strate wtracenia plaskiego falowodu
    [SW_intp2bez, k] = sortcalc("5sweep-plaski",fmin,fmax);
    % posortuj wyniki sweepa i wyznacz calk strate wtracenia tlumika
    SW_intp2tlum = sortcalc("5sweep-tlumik",fmin,fmax);
    SW_ILtot = zeros(1,k);
    for i = 1:k
        SW_ILtot(i) = 10*log10(SW_intp2bez(i)/SW_intp2tlum(i));
    end
    % wykonanie siatki dla punktow dyskretnych ze sweepowania
    SW_x1vec = x1min:x1step:x1max;
    SW_t1vec = (SW_x1vec-x1_0)/dx1;
    SW_x2vec = x2min:x2step:x2max;
    SW_t2vec = (SW_x2vec-x2_0)/dx2;
    [SW_T1,SW_T2] = meshgrid(SW_t1vec,SW_t2vec);
    [SW_x1,SW_x2] = textread('sw-x1x2.txt','%f %f');
    SW_t1 = (SW_x1-x1_0)/dx1;
    SW_t2 = (SW_x2-x2_0)/dx2;
    figure();
    scatter3(SW_t1,SW_t2,SW_ILtot,'b','filled');
    x1opt = num2str(Popt(1)*dx1 + x1_0);
    x2opt = num2str(Popt(2)*dx2 + x2_0);
    disp("Optimized surface inpterpolant coeffs:");
    disp(num2str(a'));
    input([line,"Optimum for CCI: x1 = ",x1opt," m, x2 = ",x2opt," m with ILtot = ",num2str(CCI_ILtotmax,2)," dB\n"]);