%% inizializzazione
clearvars
clc
%% Dimensionamento Platea
% La platea è considerata come trave incastrata-incastrata con carico
% agente distribuito Fd pari a 96.19 kN/m2 in condizioni SLU. In funzione
% del'armatura scelta, si ricava il momento resistente da cui ottenere la
% luce massima ammissibile per ottenere un momento sollecitante inferiore
% in camapata.

Fd = 66.3; %[kN/m2]
diam_platea = [10; 12; 14; 16; 18]; % diametri delle barre [mm]
passo = 200; % distanza tra le barre [mm]
Mrd = zeros(size(diam_platea));
Area = pi*diam_platea.^2/4 * 1000/passo; % area di armatura al m [mm2/m]
Lp_max = zeros(size(diam_platea));

%% dati generali 
% dati dell'area di indagine e lunghezza delle barre utilizzate
Lx = 56;    % [m] direzione principale
Ly = 79;    % [m] direzione secondaria
l_barra = 12;   % [m] lunghezze delle barre di armatura 
cua = 0.80; % costo unitatio acciaio [€/kg]
cup = 600;  % costo unitario palo [€/kg]


% definizione della curva di deformazione
def_not.ecu = 3.5e-3;
def_not.ec2 = 2.0e-3;
def_not.ec3 = 1.75e-3;
def_not.esu = 10e-3;
def_not.eyd = 450/1.15/210e3;

% parametri da passare alla funzione calcoloNM
fcd = 0.85*25/1.5;
fyd = 450/1.15;


%%
for fi = 1:length(diam_platea)
    % dimensioni sezione in mm
    B = [1000];
    H = [300];
    x0 = [0];
    y0 = [0];
    rettH = 1000;
    rettB = 1;
    sezione = rettangolo(B, H, x0, x0, rettB, rettH);
    
    % sollecitazione
    sollecitazioni.Ned = 0;
    %sollecitazioni.Med = 100;
    
    % definizione della posizione delle armature    
    d = [40;260];
    A = [Area(fi);Area(fi)];
    
    % metodo dicotomico
    dicotomico('x','[N, M]', 'calcoloNM(x,sezione,d,A,def_not,fcd,fyd,''elastica'');', sollecitazioni.Ned, -1e9, +1e9, 12)
    
    % salvataggio dei risultati
    Mrd(fi) = M*1e-6;   % salvo il momento resistente in kNm
    Lp_max(fi) = sqrt(24*Mrd(fi)/Fd);
    % computo quantità acciaio
    [Lbp_tot, ratio_Lbp] = computoBarre(Lx, l_barra, diam_platea(fi));
    nBarre_platea = Ly/(passo*1e-3);
    peso.platea(fi,1) = nBarre_platea * Lbp_tot * Area(fi)*1e-6 * 7850;
    
    
end
tab = table(diam_platea, Area, Mrd, Lp_max, peso.platea)
%% Dimensionamento delle travi di fondazione
% In funzione della massima luce si ottiene il carico agente sulle travi di
% fondazione in kN/m. Analogamente si ricava l'interasse massimo tra i
% pali in funzione dell'armatura in campata della trave.

diam_trave = 14:2:24; % diametri delle barre [mm]
num_barre = 4; % distanza tra le barre [mm]
Mrd_t = zeros(length(diam_trave), length(Lp_max));
Area = pi*diam_trave.^2/4 * num_barre; % area di armatura [mm2]
Lt_max = zeros(length(diam_trave),  length(Lp_max));


%%
for fi = 1:length(diam_trave);
    for l = 1:length(Lp_max)
        % dimensioni sezione in mm
    B = [500];
    H = [800];
    x0 = [0];
    y0 = [0];
    rettH = 1000;
    rettB = 1;
    sezione = rettangolo(B, H, x0, x0, rettB, rettH);
    
    % sollecitazione
    sollecitazioni.Ned = 0;
    %sollecitazioni.Med = 100;
    
    % definizione della posizione delle armature    
    d = [50;270;530;750];
    area_inter = pi*diam_trave(fi)^2/4 * 2; %area delle barre intermedie
    A = [Area(fi);area_inter;area_inter;Area(fi)];
    
    % metodo dicotomico
    dicotomico('x','[N, M]', 'calcoloNM(x,sezione,d,A,def_not,fcd,fyd,''elastica'');', sollecitazioni.Ned, -1e9, +1e9, 12)
    
    % salvataggio dei risultati
    Mrd_t(fi, l) = M*1e-6;   % salvo il momento resistente in kNm
    Fd_t = Fd * Lp_max(l);  % carico agente in funzione dell'interasse delle travi
    Lt_max(fi, l) = sqrt(24*Mrd_t(fi, l)/Fd_t);
    
    % computo acciaio
    nTravi(l) = round(Lx/Lp_max(l)) + 1;   % numero delle travi di fondazione in funzione della luce della platea
    [Lbt_tot(fi), ratio_Lbt(fi)] = computoBarre(Ly, l_barra, diam_trave(fi));
    peso.travi(fi,l) = nTravi(l) * Lbt_tot(fi) * sum(A)*1e-6 * 7850;
    
    % stima del peso totale 
    peso.totale(fi,l) = peso.travi(fi,l) + peso.platea(l);
    
    % stima del numero di pali
    nPali(fi,l) = (round(Ly/Lt_max(fi,l)) + 1) * nTravi(l);    % stima del numero dei pali
    reazionePalo(fi,l) = Fd_t * Lt_max(fi,l);
    

    
    end
end
%%
% stima dei costi
costo.platea = peso.platea * cua;
costo.travi = peso.travi * cua;
costo.pali = nPali * cup;
costo.totale = peso.totale + costo.pali;
figure(1)
surf(diam_trave, Lp_max, costo.totale')
figure(2)
surf(diam_trave, Lp_max, peso.totale')

        