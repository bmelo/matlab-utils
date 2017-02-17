%% Corrige os contrastes para completar com zeros ou remover condições
function output = ajustaContrastes(contrastes, nCond, nSess, varargin)

if nargin>=4
    midLevel = varargin{1};
end

for k=1:length(contrastes)
    if length(contrastes{k,2}) > nCond
        contrastes{k,2}(nCond+1:end) = [];
    elseif length(contrastes{k,2}) < nCond
        contrastes{k,2}(end+1:nCond) = 0;
    end
    contrastes{k,2} = repmat(contrastes{k,2},1,nSess);
end
output = contrastes;

end