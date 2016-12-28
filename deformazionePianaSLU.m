function [ e1, e2 ] = deformazionePianaSLU( x, h, d, ecu, ec2, esu )
%DEFORMAZIONEPIANA calcolo della deformazioni agli estremi della sezione 
%   calcolo dei valori di deformazione ai lembi estremi della sezione di
%   altezza L, dato la distanza x dell'asse neutro da un lembo della
%   sezione. L'origine è coincidente con il valore di deformazione e1
%
%   Varibiali di input:
%       ecu:    deformazione ultima del cls
%       ec2:    deformazione cls per sezione interamente reagente      
%       esu:    deformazione ultima dell'acciaio [DEVE ESSERE NEGATIVO]
%       x:  distanza dell'asse neutro dall'origine
%       h:  altezza totale della sezione
%       d:  distanza dell'armatura dal'origine
%
%   Variabili di output:
%       e1: deformazione della sezione al lembo coincidente con l'origine
%       e2: deformazione della sezione al lembo estremo della sezione


limite_campo2_campo3 = ecu/(ecu - esu)*d;
limite_campo5_campo6 = h;
x_c = (ecu-ec2)/ecu*h;

if x == -Inf
    e1 = esu;
    e2 = esu;
elseif x == Inf
    e1 = ec2;
    e2 = ec2;
elseif x <= limite_campo2_campo3
    % x in campo 1, 2: esu = costante! 
    e1 = x/(d-x)*(-esu);
    e2 = (h-x)/(d-x)*esu;
elseif x <= limite_campo5_campo6
    % x in campo 3, 4, 5: ecu = costante!
    e1 = ecu;   
    e2 = -(h-x)/x*ecu;
else
    % x in campo 6: punto di rotazione attorno a C: x_C = 3/7*L 
    e1 = x/(x-x_c)*ec2;
    e2 = (x-h)/(x-x_c)*ec2;
end

ev = zeros(size(h));
ev(1) = e1;
if e1 ~= e2
    de = (e2-e1)/(length(h)-1); % incremento infinitesimale della deformazione
    for i = 2:length(h)
        ev(i) = ev(i-1) + de;
    end
else
    ev = e1*ones(size(h));  % caso in cui x tende verso l'infinito
end
end

