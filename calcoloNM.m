function [ N, M ] = calcoloNM( x, sezione, d, A, def_not, fcd, fyd, tipo)
%CALCOLOFORZE calcola le sollecitazioni interne della sezione M, N
%   Calcolo del momento resistente M e sforzo normale N per la data sezione
%   di altezza H e spessore B, nell'ipotesi di deformazione piana della
%   sezione espressa dalle deformazioni ai lembi della sezione [e1,e2]
%       x:  posizione asse neutro
%       sezione:  vettore Nx4 che contiene i vettori ordinati [xm; ym; db;
%       dh] dove la coppia (xm, ym) sono le coordinate del baricentro del
%       rettangolo i-esimo, mentre la coppia (db, dh) ne repparesentano le
%       dimensioni infinitesime.
%       d: vettore che contiene le ordinate le distanze dal bordo
%       dell'armatura;
%       A: vettore contenente le aree di armatura;
%       def_not: struttura che contiene tutte le deformazioni notevoli della sezione in c.a. nel seguente ordine:
%           ecu:    deformazione ultima del cls
%           ec2:    deformazione al limite elastico per il diagramma parabola rettangolo
%           ec3:    deformazione al limite elastico per il diagramma lineare-rettangolo
%           eyd:    deformazione al limite elastico dell'acciaio
%           esu:    deformazione al limite ultimo dell'acciaio
%       fcd: tensione di progetto del cls;
%       fyd: tensione di progetto dell'acciaio;
%       tipo: tipo di analisi svolta ("elastica" o "plastica");


%% estrazione dei vettori della matrice "sezione"

xm = sezione(:,1);  % il primo campo alla coordinata in xm del baricentro dei rettangoli
ym = sezione(:,2);  % il secondo campo è riservato alla coordinata in ym del baricentro dei rattngoli
db = sezione(:,3);  % il terzo campo è riservato alla larghezza in x dei rettangoli
dh = sezione(:,4);  % il quarto campo è riservato alla larghezza in y dei rettangoli

Av = zeros(size(ym));   % questo vettore è riservato per l'area di acciaio. È zero ovunque tranne nei punti in cui ym == d

[~, ih, ~] = unique(ym);    % elimina le componenti duplicate
H = sum(dh(ih));    % massima altezza della sezione (somma solo una volta dh alla quota ym)

%% inserimento delle coordindate dell'armatura
for i = 1:length(d)
    % aggiunge le righe dell'armatura ai vettori della sezione
    % NOTA: per il calcolo della flessione deviata sarà necessario
    % specificare anche xm
    xm = [xm; 0];
    ym = [ym; d(i)];
    db = [db; 0];
    dh = [dh; 0];
    Av = [Av; A(i)];    
end

%% estrazione delle deformazioni dalla struct "deformazioni_notevoli"
% in questo caso le variabili in deformazioni_notevoli devono essere
% nominare in maniera accurata.

ecu = def_not.ecu;
ec2 = def_not.ec2;
ec3 = def_not.ec3;
eyd = def_not.eyd;
esu = def_not.esu;

%% estrazione del profilo di deformarzione
% calcolo delle deformazioni agli estremi della sezione
switch tipo
    case 'plastica'
        [e1, e2] = deformazionePianaSLU(x, H, max(d), ecu, ec2, -esu);
    case 'elastica'
        [e1, e2] = deformazionePianaSLE(x, H, max(d), ec3, -eyd);
end
%%
n = zeros(size(ym));
m = zeros(size(ym));
ev = e1 - (e1 - e2)*ym/H;    % deformazione nel punto ym(i)
sc = legameCostituivo(ev, ec3, fcd, 'lineare');   %tensione nel cls
ss = legameCostituivo(ev, eyd, fyd, 'bilineare'); %tensione nell'acciaio
n = db.*dh.*sc + Av.*ss;
m = n .* (H/2 - ym);
N = sum(n);
M = sum(m);

end

