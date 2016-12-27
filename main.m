%% inizializzazione
clearvars
clc
% dimensioni sezione in mm
H = 300;
B = 1000;
rettH = 1001;
rettB = 10;
% sollecitazione
sollecitazioni.Ned = 0;
sollecitazioni.Med = 100;
% definizione della posizione delle armature
d1 = 40;
d2 = 260;
A1 = 565;
A2 = 565;
% definizione della curva di deformazione
def_not.ecu = 3.5e-3;
def_not.ec2 = 2.0e-3;
def_not.ec3 = 1.75e-3;
def_not.esu = 10e-3;
def_not.eyd = 450/1.15/210e3;
%% parametri da passare alla funzione calcoloNM
%sezione = [h;b]';
d = [d1;d2];
A = [A1;A2];
fcd = 0.85*25/1.5;
fyd = 450/1.15;
%% Preparazione del vettore sezione
h = 0;
pt_nt = [0, d', H]; % punti notevoli in h 
for i = 2:length(pt_nt)
    deltaH = pt_nt(i) - pt_nt(i-1);
    h_ = linspace(pt_nt(i-1),pt_nt(i), deltaH/H * rettH);
    h = [h h_];
end
h = unique(h);
%%
b = linspace(0,B,rettB);
k = 0;
sezione = zeros(length(b)*length(h),2);
for i = 1:length(b)
    for j = 1:length(h)
        k = k+1;
        sezione(k,1) = h(j);
        sezione(k,2) = b(i);
    end
end


%% metodo dicotomico
dicotomico('x','[N, M]', 'calcoloNM(x,sezione,d,A,def_not,fcd,fyd,''elastica'');', sollecitazioni.Ned, -1e9, +1e9, 12)


