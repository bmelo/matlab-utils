function onsets = determinarOnsets(condition, log, CEs)

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

%% Verifica qual é a condição e calcula os onsets em cima disto
switch(condition)
    %% Risco
    case 'RISK DECISION'
        posicoes = log{cType}==4;
        onsets = double( (log{cPuls}(posicoes)-6)+1 );
    %% Seguro
    case 'SECURE DECISION'
        posicoes = log{cType}==3;
        onsets = double( (log{cPuls}(posicoes)-6)+1 );
    %% Mão direita
    case 'RIGHT HAND'
        posicoes = log{cHand}==1;
        onsets = double( (log{cPuls}(posicoes)-1)+1 );
    %% Mão esquerda
    case 'LEFT HAND'
        posicoes = log{cHand}==2;
        onsets = double( (log{cPuls}(posicoes)-1)+1 );
    %% Alto Risco
    case 'HIGH RISK DECISION'
        for k=1:length(CEs)
            posicoes = log{cType}==4 & log{cPerc}==(CEs(k,1)/100) & log{cValo}>=CEs(k,3);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-6)+1;
    %% Baixo Risco
    case 'VERY SECURE DECISION'
        for k=1:length(CEs)
            posicoes = log{cType}==3 & log{cPerc}==(CEs(k,1)/100) & log{cValo}<=CEs(k,4);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-6)+1;
    %% Risco não alto
    case 'NOT HIGH RISK DECISION'
        for k=1:length(CEs)
            posicoes = log{cType}==4 & log{cPerc}==(CEs(k,1)/100) & log{cValo}<CEs(k,3);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-6)+1;
    %% Seguro não extremo
    case 'NOT VERY SECURE DECISION' 
        for k=1:length(CEs)
            posicoes = log{cType}==3 & log{cPerc}==(CEs(k,1)/100) & log{cValo}>CEs(k,4);
            onsets = [onsets; double( log{cPuls}(posicoes)) ];
        end
        onsets = sort(onsets);
        onsets = (onsets-6)+1;
end

if isempty(onsets)
    onsets=false;
end
if inSecs
    onsets = (onsets-1)*2;
end

end