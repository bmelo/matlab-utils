function onsets = determinarOnsetsCG(condition, log, varargin)

inSecs = false;
if nargin > 2
    inSecs = varargin{1};
end

% Tratando dados dos onsets
cValueUser = 2;
cValueOther = 3;
cPulse = 4;
onsets = [];

difVols = 3;

%% Verifica qual � a condi��o e calcula os onsets em cima disto
switch(condition)
    %% USER CHOICED HAWK
    case 'HAWK'
        posicoes = char(log{cValueUser})=='H';
        onsets = double( log{cPulse}(posicoes) - difVols );
    %% USER CHOICED DOVE
    case 'DOVE'
        posicoes = char(log{cValueUser})=='D';
        onsets = double( log{cPulse}(posicoes) - difVols );
    %% M�o direita
    case 'RIGHT HAND'
        posicoes = char(log{cValueUser})=='H';
        onsets = double( log{cPulse}(posicoes) );
    %% M�o esquerda
    case 'LEFT HAND'
        posicoes = char(log{cValueUser})=='D';
        onsets = double( log{cPulse}(posicoes) );
    case 'HAWK'
        posicoes = char(log{cValueUser})=='H';
        onsets = double( log{cPulse}(posicoes) - difVols );
    %% USER CHOICED DOVE
    case 'DOVE'
        posicoes = char(log{cValueUser})=='D';
        onsets = double( log{cPulse}(posicoes) - difVols );
    %% M�o direita
    case 'HAWK-POS'
        posicoes = char(log{cValueUser})=='H';
        onsets = double( log{cPulse}(posicoes) + 1 );
    %% M�o esquerda
    case 'DOVE-POS'
        posicoes = char(log{cValueUser})=='D';
        onsets = double( log{cPulse}(posicoes) + 1 );
end

if isempty(onsets)
    onsets=false;
end
if inSecs
    onsets = (onsets-1)*2;
end

end