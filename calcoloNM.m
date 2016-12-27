function [ N, M ] = calcoloNM( x, sezione, d, A, def_not, fcd, fyd, tipo)
%CALCOLOFORZE calcola le sollecitazioni interne della sezione M, N
%   Calcolo del momento resistente M e sforzo normale N per la data sezione
%   di altezza H e spessore B, nell'ipotesi di deformazione piana della
%   sezione espressa dalle deformazioni ai lembi della sezione [e1,e2]
%       x:  posizione asse neutro
%       sezione:  vettore nx2 che contiena la coppia ordinata "h x b" dove
%       h e b rappresanto rispettivamente l'altezza e la larghezza del
%       rettangolo i-esimo;
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


%% estrazione dei vettori della struct "sezione"

h = sezione(:,1);   % il primo campo è riservato all'altezza dei rettangoli
b = sezione(:,2);   % il secondo campo è riservato alla larghezza dei rettangoli

H = max(h);     % Altezza totale della sezione
B = max(b);     % Larghezza totale della sezione

uniqueH = unique(h);    % vettore ordinato dell'altezza della sezione (elimina i valori ripetuti)
uniqueB = unique(b);    % vettore ordinato della base della sezione (elimina i valori ripetuti

% il vettore delle altezze ha sempre dimesioni 1xN dove N è maggiore di 1,
% mentre il vettore delle basi può avere dimensione unitaria
dh = uniqueH(2)-uniqueH(1); % altezza del rettangolo di base
if length(uniqueB) > 1
    db = uniqueB(2)-uniqueB(1); % larghezza del rettangolo di base
else
    db = uniqueB;
end

%% estrazione delle deformazioni dalla struct "deformazioni_notevoli"
% in questo caso le variabili in deformazioni_notevoli devono essere
% nominare in maniera accurata.

extractField(def_not)

%% estrazione del profilo di deformarzione
% calcolo delle deformazioni agli estremi della sezione
switch tipo
    case 'plastica'
        [e1, e2] = deformazionePianaSLU(x, H, max(d), ecu, ec2, -esu);
    case 'elastica'
        [e1, e2] = deformazionePianaSLE(x, H, max(d), ec3, -eyd);
end
% creazione del vettore delle deformazioni
if e1 ~= e2     
    de = (e1-e2)/(length(uniqueH)-1); % variazione delle deformazioni lungo l'altezza della sezione
    ev = e2:de:e1;  % vettore delle deformazioni
else
    ev = ones(size(uniqueH)) * e1; % se e1 == e2 allora la deformazione è costante lungo tutta l'altezza della sezione
end
%%
sc = legameCostituivo(ev, ec3, fcd, 'lineare');   %tensione nel cls
ss = legameCostituivo(ev, eyd, fyd, 'bilineare');      %tensione nell'acciaio
n = zeros(size(h));
m = zeros(size(h));
k = 0;  % indice di ciclo della sezione
for i = 1:length(uniqueH)
    for j = 1:length(uniqueB)
        k = k+1;
        n(k) = db * dh * sc(i) + sum(and(d==uniqueH(i), j==1) .* A .* ss(i)); % la condizione deve essere verificata per 
        m(k) = n(k)*(H/2 - h(k));
    end
end
N = sum(n);
M = sum(m);

end

