function raw = importXls(xlsFile, tipo, varargin)

[~,~,raw] = xlsread(xlsFile);
%limpando linhas nulas
for k = 1:size(raw,1)
  if(isnan(raw{k,1}))
    raw(k:end,:) = [];
    break;
  end
end
%limpando colunas nulas
for k = 1:size(raw,2)
  if(isnan(raw{1,k}))
    raw(:,k:end) = [];
    break;
  end
end

if(nargin >= 2)
  switch(tipo)
    case 'parametricModulation'
      raw = parametricModulation(raw, varargin{:});
  end
end

end

function pos = findStrCell(celula, text)
%Retorna posição da string na celula
comparacoes = strfind(celula, text);
pos = 0;
for k = 1:length(comparacoes)
  if any(comparacoes{k})
    pos = k;
    return
  end
end
end

%Ajusta dados para o formato trabalhado na modulação parametrica
function paramStruct = parametricModulation(data, varargin)
paramStruct = struct();
if ~isempty(varargin{1})
  numsParams = varargin{1};
else
  numsParams = 4:size(data,2);
end

header = data(1,:);
colRun = findStrCell(header, 'RUN');
colSub = findStrCell(header, 'SUBJ');
colCon = findStrCell(header, 'CONDITION');

for k=2:size(data,1)
  for params = numsParams
    %Prepara a struct para receber os valores
    try
      isempty( paramStruct.(data{k,colSub}).run(data{k,colRun}).(data{k,colCon}).(header{params}).vals );
    catch exc
      paramStruct.(data{k,colSub}).run(data{k,colRun}).(data{k,colCon}).(header{params}).vals = [];
    end
    paramStruct.(data{k,colSub}).run(data{k,colRun}).(data{k,colCon}).(header{params}).vals(end+1) = data{k,params};
  end
end

end