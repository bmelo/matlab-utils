%Função principal
%Exemplo de chamada
% gerador('PRJ0000.xlsx', @rois)
function gerador( arquivoXLS, funcao )
if nargin<2
  error('IDOR:gerador:Inputs','A função requer dois parâmetros (nome do arquivo XLS, função manipuladora).');
end
[~,~,parameters] = xlsread( arquivoXLS , 'PARAMETERS');
[~,~,subjects] = xlsread( arquivoXLS , 'SUBJECTS');

params = geraStruct( parameters );
params.XLS = arquivoXLS;
params.SUBJECTS = subjects;
funcao( params );

end

%Função para extrair os parametros
function out = geraStruct( in )

out = struct();
for k = 2:size( in )
  if( isnan(in{k,1}) ) %Encerra se encontrar uma linha com valor NaN
    break;
  end
  out.(in{k,1}) = in{k,2};
end

end