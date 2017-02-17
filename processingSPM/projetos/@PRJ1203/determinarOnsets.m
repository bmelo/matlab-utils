function onsets = determinarOnsets(condition, log, CEs, varargin)

inSecs = false;
if nargin > 3
    inSecs = varargin{1};
end

% Tratando dados dos onsets
cPerc = 3;
cValo = 4;
cHand = 6;
cType = 7;
cPuls = 8;
onsets = [];

difRS = 3;

%% Verifica qual é a condição e calcula os onsets em cima disto
switch(condition)
    %% Risco
    case 'RISK DECISION'
        posicoes = log{cType}==4;
        onsets = double( log{cPuls}(posicoes)-difRS );
    %% Seguro
    case 'SECURE DECISION'
        posicoes = log{cType}==3;
        onsets = double( log{cPuls}(posicoes)-difRS );
    %% Mão direita
    case 'RIGHT HAND'
        posicoes = log{cHand}==1;
        onsets = double( log{cPuls}(posicoes) );
    %% Mão esquerda
    case 'LEFT HAND'
        posicoes = log{cHand}==2;
        onsets = double( log{cPuls}(posicoes) );
    %% Alto Risco
    case 'HIGH RISK DECISION'
        for k=1:length(CEs)
            posicoes = log{cType}==4 & log{cPerc}==(CEs(k,1)/100) & log{cValo}>=CEs(k,3);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-difRS);
    %% Baixo Risco
    case 'VERY SECURE DECISION'
        for k=1:length(CEs)
            posicoes = log{cType}==3 & log{cPerc}==(CEs(k,1)/100) & log{cValo}<=CEs(k,4);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-difRS);
    %% Risco não alto
    case 'NOT HIGH RISK DECISION'
        for k=1:length(CEs)
            posicoes = log{cType}==4 & log{cPerc}==(CEs(k,1)/100) & log{cValo}<CEs(k,3);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-difRS);
    %% Seguro não extremo
    case 'NOT VERY SECURE DECISION' 
        for k=1:length(CEs)
            posicoes = log{cType}==3 & log{cPerc}==(CEs(k,1)/100) & log{cValo}>CEs(k,4);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-difRS);
end

if isempty(onsets)
    onsets=false;
end
if inSecs
    onsets = (onsets-1)*2;
end

end