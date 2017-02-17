%% Função que faz um join de strings com um caracter cola
function [output] = implode(glue,dados)

if ~iscell(dados)
    dados = num2cell(dados);
    for k=1:length(dados)
        if isnumeric(dados{k})
            dados{k} = num2str(dados{k});
        end
    end
end

P = dados(:)';
P(2,:) = {glue};
P{2,end} = [] ;
output = sprintf('%s',P{:});