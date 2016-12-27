function [ N, M ] = calcoloNM( x, sezione, d, A, deformazioni_notevoli, fcd, fyd, tipo)
%CALCOLOFORZE calcola le sollecitazioni interne della sezione M, N
%   Calcolo del momento resistente M e sforzo normale N per la data sezione
%   di altezza H e spessore B, nell'ipotesi di deformazione piana della
%   sezione espressa dalle deformazioni ai lembi della sezione [e1,e2]
%       x:  posizione asse neutro
%       sezione:  struttura contenente la coppia di vettori H ed B,
%       che rappresentano le coordinate rispettivamente lungo l'altezza e
%       la larghezza della sezione
%       d: vettore che contiene le ordinate le distanze dal bordo
%       dell'armatura
%       A: vettore contenente le aree di armatura
%       deformazioni_notevoli: struttura che contiene tutte le
%       deformazioni notevoli della sezione in c.a. nel seguente ordine:
%           ecu:    deformazione ultima del cls
%           ec2:    deformazione al limite elastico per il diagramma parabola rettangolo 
%           ec3:    deformazione al limite elastico per il diagramma lineare-rettangolo
%           eyd:    deformazione al limite elastico dell'acciaio
%           esu:    deformazione al limite ultimo dell'acciaio
%       fcd: tensione di progetto del cls
%       fyd: tensione di progetto dell'acciaio
%       tipo: tipo di analisi svolta ("elastica" o "plastica")


%% estrazione dei vettori della struct "sezione"

varnames = fields(sezione);
h = sezione.(varnames{1});   % il primo campo è riservato all'altezza dei rettangoli
b = sezione.(varnames{2});   % il secondo campo è riservato alla larghezza dei rettangoli
H = max(h);     % Altezza totale della sezione
B = max(b);     % Larghezza totale della sezione
dh = h(2)-h(1); % altezza del rettangolo di base
db = b(2)-b(1); % larghezza del rettangolo di base

%% estrazione delle deformazioni dalla struct "deformazioni_notevoli"
% in questo caso le variabili in deformazioni_notevoli devono essere
% nominare in maniera accurata.

varnames = fields(deformazioni_notevoli);
for i = 1:length(varnames)
    assignin('caller',deformazioni_notevoli.(varnames{i}))
end

%%
[e1, e2] = deformazionePiana(x, H, max(d), ecu, ec2, esu);
% inizializzo il vettore ev, alla stessa lunghezza del vettore h



sc = legameCostituivo(ev, 2.0e-3, fcd, 'parabola');   %tensione nel cls
ss = legameCostituivo(ev, 1.863e-3, fyd, 'bilineare');      %tensione nell'acciaio
n = zeros(size(h));
m = zeros(size(h));
for i = 1:length(h)
    n(i) = t * dL * sc(i) + (d==h(i))*A'*ss(i);
    m(i) = n(i)*(L/2-h(i));
end
N = sum(n,2)/1e3;
M = sum(m,2)/1e6;

end

