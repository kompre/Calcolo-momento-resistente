function dicotomico( varname, output, fx, f0, varA, varB, precisione )
%DICOTOMICO Metodo dicotomico applicato alla funzione fx, per la variabile
%var
%   Con il metodo dicotomico di ricercano gli zero della funzione fx,
%   rispetto al valore f0, variando la variabile var, nell'intervallo
%   specificato [varA, varB] (n.b. varA < varB)

if nargin  < 7
    precisione = 10;    % impostazione di default precisione del metodo 
end

errore = 10^-(precisione);
err = 1;  % inizializzazione variabile di controllo
while err >= errore
    var = (varB + varA)/2; % valore medio tra i due estremi
    evalin('base', [ varname '=' num2str(var,precisione) ';']);
    ris = evalin('base', fx);   % il risultato principale della funzione è salvato localmente
    fm = ris - f0;
    if fm < 0
        varA = var;
    else
        varB = var;
    end
    err = (varB - varA)/2;
end

evalin('base', [ output ' = ' fx]); % scrive i risultati della funzione fx nel ws base


end

