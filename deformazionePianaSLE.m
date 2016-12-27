function [ e1, e2 ] = deformazionePianaSLE( x, L, d, ec3, eyd )
%DEFORMAZIONEPIANA calcolo della deformazioni agli estremi della sezione in
%   condizioni elastiche
%   calcolo dei valori di deformazione ai lembi estremi della sezione di
%   altezza L, dato la distanza x dell'asse neutro da un lembo della
%   sezione. L'origine è coincidente con il valore di deformazione e1
%
%   Varibiali di input:
%       ec3:    deformazione limite del cls per essere in condizioni
%       elastiche
%       esd:    deformazione elastica dell'acciaio [DEVE ESSERE NEGATIVO]
%       x:  distanza dell'asse neutro dall'origine [0,+inf]
%       L:  altezza totale della sezione
%       d:  distanza dell'armatura dal'origine
%
%   Variabili di output:
%       e1: deformazione della sezione al lembo coincidente con l'origine
%       e2: deformazione della sezione al lembo estremo della sezione

% ipotesi acciao al limite elastico e deformazione cls incognita

limite_campo = d * ec3/(ec3 - eyd); % limite

if x == Inf
    e1 = ec3;
    e2 = ec3;
elseif x <= limite_campo % significa che l'acciaio ha raggiunto il limite elastico e la deformazione del cls è inferiore a quella elastica
    e1 = x/(d-x)*(-eyd);   % deformazione al lembo compresso, ruotando attorno al punto (esd,d)
    e2 = (L-x)/(d-x)*eyd;   % deformazione al lembo teso
elseif x >= limite_campo
    e1 = ec3;   % il cls ha raggiunto il limite elastico e la sezione ruota attorno al punto (ec3,0)
    e2 = (L-x)/x*ec3;
end
    
    
end

