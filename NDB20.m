n = 7; % virsuniu skaicius
V = 1:n; % virsuniu sarasas
B = [1 2; 2 5; 5 6; 3 4; 1 7]; % briaunu matrica
I = [1 2 6 5 7]; % nurodytos virsunes
U = [;]; % tik briaunos, sudarytos is nurodytu virsuniu
A = []; % aplankytos virsunes
briaunuSk = 0; % briaunu, kuriu galai yra I virsunes, skaicius

% nubraizome grafa ekrane
m = length(B(:, 1));
 
Ucell = [];

for BriaunosNr = m:-1:1
    Ucell{BriaunosNr} = B(BriaunosNr, :);
end
 
Vkor = [];
orgraf = 0;
arc=0; poz=0; Fontsize=10; lstor=1; spalva='b';
figure(1)
title('Duotasis grafas')
plotGraphVU(V, Ucell, orgraf, arc, Vkor, poz, Fontsize, lstor, spalva)

% pradedame algoritmo darba
tic

% atrenkame tik reikalingas briaunas
indeksas = 1;

for i = 1:length(B)
    if ismember(B(i, 1), I) && ismember(B(i, 2), I)
        U(indeksas, 1) = B(i, 1);
        U(indeksas, 2) = B(i, 2); 
        
        briaunuSk = briaunuSk + 1;
        indeksas = indeksas + 1;
    end
end

% nustatome, ar nurodytos virsunes indukuoja junguji grafa
% randame virsunes, gretimas pirmajai, jeigu tokiu nera, vadinasi virsunes neindukuoja jungiojo grafo
lankytinosVirsunes = gretimos(briaunuSk, 1, I, U, []);

A(end + 1) = I(1);

while length(lankytinosVirsunes) > 0
    virsunes = lankytinosVirsunes; % virsunes, aplankomos sios iteracijos metu
    lankytinosVirsunes = []; % virsunes, kurios bus aplankytos kitos iteracijos metu
    
    m = length(virsunes); % virsuniu vektoriaus ilgis
    
    % aplankome virsunes ir randame joms gretimas virsunes
    for i = 1:m
        A(end + 1) = virsunes(i);
        lankytinosVirsunes = [lankytinosVirsunes gretimos(briaunuSk, find(I == virsunes(i)), I, U, [A virsunes])];
    end
end

% nustatome, ar visos reikiamos virsunes buvo aplankytos
indukuojaJungujiGrafa = true;

for i = 1:length(I)
    if ~ismember(I(i), A)
        indukuojaJungujiGrafa = false;
        break;
    end
end

% randame skaiciavimo trukme
laikas = toc;

% isvedame rezultatus
if indukuojaJungujiGrafa
    disp("Nurodytos virsunes indukuoja junguji grafa");
else
    disp("Nurodytos virsunes neindukuoja jungiojo grafo");
end

disp("Skaiciavimu laikas sekundemis:");
disp(laikas);

%{
 funkcija, randanti x virsunei gretimas virsunes
 y - gretimu virsuniu vektorius
 n - briaunu skaicius
 x - nurodytos virsunes indeksas virsuniu sarase
 J - virsuniu sarasas
 M - grafo briaunu matrica
 e - virsuniu, kurios bus ignoruojamos, vektorius
%}
function y = gretimos(n, x, J, M, e) 
    y = [];
    
    for i = 1:n
        if M(i, 1) == J(x)
            if ~ismember(M(i, 1), y) && ~ismember(M(i, 2), e) 
                y(end + 1) = M(i, 2);
            end
        elseif M(i, 2) == J(x)
            if ~ismember(M(i, 2), y) && ~ismember(M(i, 1), e) 
                y(end + 1) = M(i, 1);
            end
        end
    end
end
