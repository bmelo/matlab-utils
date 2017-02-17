function output = geradorContrastes(input)

combinacao = {};
tam = length(input);

for k=1:tam-1 %Remove o último, que é igual a 1:tam
    temp = combnk(1:tam,k);
    for j=1:size(temp,1)
        combinacao = [combinacao {temp(j,:)}];
    end
end
arranjo = combnk(combinacao,2);
remover = [];
for k=1:length(arranjo)
    for j=arranjo{k,2}
        if find((arranjo{k,1}==j))
            remover = [remover k];
            break;
        end
    end
end
arranjo(remover,:) = [];
auxComb = cell(length(combinacao),2);
auxComb(:,1) = combinacao;
contrastes = [auxComb; arranjo; fliplr(arranjo); {1:tam []}];
contrastes = ordenar(contrastes);
%% Formatando os contrastes
output = cell(length(contrastes), 2);
for k=1:length(contrastes)
    output{k, 1} = nameConstraste(input,contrastes(k,:));
    output{k, 2} = zeros(1,tam);
    output{k, 2}(contrastes{k,1}) = 1;
    if ~isempty(contrastes{k,2})
        output{k, 2}(contrastes{k,2}) = -1;
    end
end

end

function out = ordenar(contrastes)
tam = length(contrastes);
for k=1:tam
    cols(k) = contrastes{k,1}(1);
end
[lixo ordem] = sort(cols);
out = contrastes(ordem,:);
end

function text = nameConstraste(names, nums)
parte1 = nums2contrastes(nums{1}, names);
parte2 = '';
if ~isempty(nums{2})
    parte2 = [' - ' nums2contrastes(nums{2}, names)];
end
text = [parte1 parte2];
end

function text=nums2contrastes(nums, names)
text = '';
for k=nums
    text = [text ' ' names{k}];
end
text = strtrim(text);
end







