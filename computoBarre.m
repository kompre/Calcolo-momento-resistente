function [ lb_tot, ratio ] = computoBarre( L, lb, diam )
%COMPUTOBARRE Calcolo delle lunghezze delle barre reali, considerando le
%zone di sovrapposizione
%   Calcola la lunghezza totale delle barre, tenuto conto della lunghezza
%   massima della barra impiegabile, e delle zone di sovrapposizione.
%       L: dimensione da ricoprire con le barre;
%       lb: lunghezza massima della barra;
%       diam: diametro delle barre;

ls = 50 * diam*1e-3;    % lunghezza della zona di sovrapposizione 
lbr = lb - ls;  % lunghezza ridotta della barra
numBarreIntere = floor(L/lbr);  % numero delle barre intere utilizzate
lb_tot = numBarreIntere * lb + (L - numBarreIntere * lbr);  % computo delle barre utilizzate
ratio = lb_tot/L;   % rapporto tra dimesione reale e dimensione ideale

end

