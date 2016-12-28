function [ s ] = legameCostituivo( def, ey, fd, tipo )
%LEGAMECOSTITUIVO calcola la tensione in funzione della deformazione e del
%legame costituitivo del materiale
%   calcolo della tensione s in funzione della deformazione def e del tipo
%   di legame. Ciascun legame costitutivo è caratterizzato dai seguenti
%   parametri:
%       ey:     deformazione al limite elastico
%       fd:     tensione limite
%       tipo:   andamento delle tensioni nella fase elastica (parabola,
%       lineare,stress-block)
%
%       def:    variabile della deformazione
s = zeros(size(def));
for i = 1:length(def)
    switch tipo
        case 'lineare'
            if def(i) < 0;
                s(i) = 0;
            elseif def(i) < ey
                s(i) = fd/ey * def(i);
            else
                s(i) = fd;
            end
        case 'parabola'
            if def(i) < 0;
                s(i) = 0;
            elseif def(i) < ey
                % parametri della parabola f(x) = a x^2 + b x
                b = 2 * fd / ey;
                a = - b / (2 * ey);
                s(i) = a * def(i)^2 + b * def(i);
            else
                s(i) = fd;
            end
        case 'bilineare'
            if abs(def(i)) < ey
                s(i) = fd/ey * def(i);
            else
                s(i) = fd * sign(def(i));
            end
        case 'stress-block'
            if def(i) < ey
                s(i) = 0;
            else
                s(i) = fd;
            end               
    end
end

end

