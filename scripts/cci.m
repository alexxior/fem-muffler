function cci(x1min,x1max,x2min,x2max)
    % numeracja od punktu planu CCI (1,0) przeciwnie do wskazówek zegara
    t1 = [1,1/sqrt(2),0,-1/sqrt(2),-1,-1/sqrt(2),0,1/sqrt(2),0];
    t2 = [0,1/sqrt(2),1,1/sqrt(2),0,-1/sqrt(2),-1,-1/sqrt(2),0];
    x1_0 = (x1max + x1min)/2;
    dx1 = (x1max - x1min)/2;
    x2_0 = (x2max + x2min)/2;
    dx2 = (x2max - x2min)/2;
    x1x2(1,:) = [x1max,                                 x2_0];
    x1x2(2,:) = [1/sqrt(2)*dx1 + x1_0,  1/sqrt(2)*dx2 + x2_0];
    x1x2(3,:) = [x1_0,                                 x2max];
    x1x2(4,:) = [-1/sqrt(2)*dx1 + x1_0, 1/sqrt(2)*dx2 + x2_0];
    x1x2(5,:) = [x1min,                                 x2_0];
    x1x2(6,:) = [-1/sqrt(2)*dx1 + x1_0,-1/sqrt(2)*dx2 + x2_0];
    x1x2(7,:) = [x1_0,                                 x2min];
    x1x2(8,:) = [1/sqrt(2)*dx1 + x1_0, -1/sqrt(2)*dx2 + x2_0];
    x1x2(9,:) = [x1_0,                                  x2_0];
    it = 1;
    for i = 1:9
        if x1x2(i,2) > 2*x1x2(i,1)
            x1x2good(it,:) = x1x2(i,:);
            t1t2good(it,:) = [t1(i), t2(i)];
            it = it+1;
        end
    end
    cd ../output
    dlmwrite('cci-x1x2.txt',x1x2good,'delimiter',' ','precision','%.2f');
    save("-ascii","cci-t1t2.txt","t1t2good");