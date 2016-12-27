function extractField( struttura )
%EXTRACTFIELD estrae i campi di una struttura creando delle variabile nel
% workspace


varnames = fields(struttura); % estrae i nomi dei campi della struttua
for vn = 1:length(varnames)
    var_ = struttura.(varnames{vn});
    assignin('caller',varnames{vn},var_);
end

% estrazione campi


end