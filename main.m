% dimensioni sezione in mm
L = 1000;
t = 250;
% altezza dei rettangoli
dL = 1;
Lv = 0:dL:L; % vettore delle coordinate dei rettangoli
% definizione della posizione delle armature
d1 = 50;
d2 = 950;
A1 = 154;
A2 = 154;
% definizione della curva di deformazione
ecu = 3.5e-3;
ec2 = 2.0e-3;
esu = -10e-3;
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
