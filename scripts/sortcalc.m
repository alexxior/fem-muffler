function [int_p2,k] = sortcalc(filename,fmin,fmax)
    cd ../output
    M = dlmread(filename,',');
    [w,k] = size(M);
    p = zeros(w,1);
    for i = [2,7,12,17]
        p = p + sqrt( M(:,i).^2 + M(:,i+1).^2 );
    end
    p2 = (p/4).^2;
    % sortowanie wynikow zgodnie z punktami
    fstep = M(2,22) - M(1,22);
    number = (fmax-fmin)/fstep + 1;
    p2sort = zeros(number,w/number);
    for i = 1:w/number
        p2sort(1:number,i) = p2(1+(i-1)*number : i*number);
    end
    f = fmin:fstep:fmax;
    [w,k] = size(p2sort);
    int_p2 = zeros(1,k);
    for i = 1:k
        int_p2(i) = trapz(f',p2sort(:,i));
    end
    cd ../scripts