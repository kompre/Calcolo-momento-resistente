%% inizializzazione
clearvars
clc
% dimensioni sezione in mm
B = [1000];
H = [300];
x0 = [0];
y0 = [0];
rettH = 1000;
rettB = 1;
sezione = rettangolo(B, H, x0, x0, rettB, rettH);
% sollecitazione
sollecitazioni.Ned = 0;
sollecitazioni.Med = 100;
% definizione della posizione delle armature
d = [40;260];
A = [565;565];
% definizione della curva di deformazione
def_not.ecu = 3.5e-3;
def_not.ec2 = 2.0e-3;
def_not.ec3 = 1.75e-3;
def_not.esu = 10e-3;
def_not.eyd = 450/1.15/210e3;
%% parametri da passare alla funzione calcoloNM
fcd = 0.85*25/1.5;
fyd = 450/1.15;
%% metodo dicotomico
dicotomico('x','[N, M]', 'calcoloNM(x,sezione,d,A,def_not,fcd,fyd,''elastica'');', sollecitazioni.Ned, -1e9, +1e9, 12)


