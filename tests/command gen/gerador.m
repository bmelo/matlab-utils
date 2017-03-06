%Fun��o principal
%Exemplo de chamada
% gerador('PRJ0000.xlsx', @rois)
function gerador( arquivoXLS, funcao )
if nargin<2
  error('IDOR:gerador:Inputs','A fun��o requer dois par�metros (nome do arquivo XLS, fun��o manipuladora).');
end
[~,~,parameters] = xlsread( arquivoXLS , 'PARAMETERS');
[~,~,subjects] = xlsread( arquivoXLS , 'SUBJECTS');

params = geraStruct( parameters );
params.XLS = arquivoXLS;
params.SUBJECTS = subjects;
funcao( params );

end

%Fun��o para extrair os parametros
function out = geraStruct( in )

out = struct();
for k = 2:size( in )
  if( isnan(in{k,1}) ) %Encerra se encontrar uma linha com valor NaN
    break;
  end
  out.(in{k,1}) = in{k,2};
end

end