% posortuj wynik i wyznacz srednie IL plaskiego falowodu
path = strcat("./output/plaski-optimized.txt");
M = dlmread(path,',');
[w,k] = size(M);
pbez = zeros(w,1);
for i = [2,7,12,17]
    pbez = pbez + sqrt( M(:,i).^2 + M(:,i+1).^2 );
end
pbez = pbez/4;
% posortuj wynik i wyznacz srednie IL tlumika
path = strcat("./output/tlumik-optimized.txt");
M = dlmread(path,',');
[w,k] = size(M);
ptlum = zeros(w,1);
for i = [2,7,12,17]
    ptlum = ptlum + sqrt( M(:,i).^2 + M(:,i+1).^2 );
end
ptlum = ptlum/4;
% wyznacz charakterystyke czestotliwosciowa IL
IL = 20*log10(pbez./ptlum);
f = 100:1:500;
figure('Position', [500 300 1050 500]);
plot(f,IL,'LineWidth',2);
set(gca,'XGrid','on','LineWidth',1,'XMinorTick','on','YGrid','on','YMinorTick','on');
box(gca,'on');
xlabel("Czestotliwość [Hz]");
ylabel("Strata wtracenia IL [dB]");
title("Charakterystyka częstotliwościowa straty wtrącenia IL_{tot} dla zoptymalizowanego tłumika");
input("Press Enter to close...");