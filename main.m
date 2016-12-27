%% inizializzazione
clearvars
clc
% dimensioni sezione in mm
H = 300;
B = 1000;
% altezza dei rettangoli
dh = 1;
h = 0:dh:H; % vettore delle coordinate dei rettangoli
b = ones(size(h))*B;
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
%%
[N, M] = calcoloNM(30.28,[h;b]',[d1;d2],[A1;A2],def_not,(0.85*25/1.5),450/1.15,'plastica')
%%
x = -1000:2000;
for i_x = 1:length(x)
    [e1, e2] = deformazionePiana(x(i_x), L, max(d1,d2), ecu, ec2, esu);
    de = (e1-e2)/(length(Lv)-1);
    ev = e2:de:e1;  % vettore delle deformazioni
    sc = legameCostituivo(ev,2.0e-3,14.17,'parabola');   %tensione nel cls
    ss = legameCostituivo(ev,1.957e-3,391.3,'bilineare');      %tensione nell'acciaio
    for i = 1:length(Lv)
        nsd(i_x,i) = t * dL * sc(i) + (d1==Lv(i))*A1*ss(i) + (d2==Lv(i))*A2*ss(i);
        msd(i_x,i) = nsd(i_x,i)*(L/2-Lv(i));
    end
end
Nsd = sum(nsd,2)/1000;
Msd = sum(msd,2)/1e6;
