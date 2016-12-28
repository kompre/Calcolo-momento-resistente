function [ sezione, rett ] = rettangolo( B, H, x0, y0, nX, nY )
%RETTANGOLO genera le coordinate dei rettangoli di larghezza B e altezza A
%con coordinate baricentriche (x0,y0)
%   Le variabili di input sono vettori di dimensioni uguali 1xN, dove N
%   indica il numero di rettangoli elementari che compongo la figura.
%   Le coordinate baricentriche hanno lo scopo di definire la posizione
%   relativa dei rettangoli elementari, successivamente la figura composta
%   viene traslata in modo che il lembo estremo coincida con l'origine
%   dell'asse y
%
%   B:  vettore delle dimensioni in x dei rettangoli
%   H:  vettore delle dimensioni in y dei rettangoli
%   x0: coordinata baricentrica del rettangolo
%   y0: coordinata baricentrica del rettangolo
%   nX: numero di rettangoli infinitesimi in cui discretizzare il rettangolo elementare
%   nY: numero di rettangoli infinitesimi in cui discretizzare il rettangolo elementare

numRett = length(B);    % numero di rettangoli elementari
for i = 1:numRett
    rett(i).B = [ (x0(i) - B(i)/2), (x0(i) + B(i)/2)];  % estremi del rettangolo
    rett(i).H = [ (y0(i) - H(i)/2), (y0(i) + H(i)/2)];  
end

DH = min(min(rett.H));    % ricava la lunghezza con cui traslare tutte le ordinate (bounding box)

for i = 1:numRett
    rett(i).H = rett(i).H - DH; % traslazione delle coordinate
end

for i = 1:numRett
    rett(i).b = linspace(rett(i).B(1), rett(i).B(2), nX+1); % vettore delle coordinate degli estremi dei rettagnoli infinitesimali
    rett(i).h = linspace(rett(i).H(1), rett(i).H(2), nY+1); % vettore
    % ricavo larghezza rettangoli infinitesi in x e coordinata baricentrica
    % dei rettangoli infinitesimi xm
    rett(i).db = zeros(1,length(rett(i).b)-1);
    rett(i).xm = zeros(1,length(rett(i).b)-1);
    for j = 2:length(rett(i).b)
        rett(i).db(j-1) = (rett(i).b(j) - rett(i).b(j-1));   
        rett(i).xm(j-1) = (rett(i).b(j) + rett(i).b(j-1))/2;   
    end
    % ricavo larghezza rettangoli infinitesi in y e coordinata baricentrica
    % dei rettangoli infinitesimi ym
    rett(i).dh = zeros(1,length(rett(i).h)-1);
    rett(i).ym = zeros(1,length(rett(i).h)-1);
    for j = 2:length(rett(i).h)
        rett(i).dh(j-1) = (rett(i).h(j) - rett(i).h(j-1));   
        rett(i).ym(j-1) = (rett(i).h(j) + rett(i).h(j-1))/2;   
    end
end

l = 0;  % indice globale
sezione = zeros(numRett*nX*nY, 4); 
for i = 1:numRett
    for j = 1:length(rett(i).xm)
        for k = 1:length(rett(i).ym)
            l = l+1;
            sezione(l,:) = [rett(i).xm(j); rett(i).ym(k); rett(i).db(j); rett(i).dh(k)];
        end
    end
end
    
end

