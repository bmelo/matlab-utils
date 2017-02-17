function runSPM( PRJ, varargin)

if nargin>=2
    PRJ.subjects = varargin{1};
end

init; %Inicializa framework

%% Definindo parametros geral de processamento
PRJ.stopIfError = 0; %Irá parar o processamento caso aconteça algum erro
PRJ.onlyExportScripts = 0;
PRJ.rewrite = 1;
PRJ.export = 1;
PRJ.openSPM=0;

PRJ.execBatch();
%PRJ.execBatchIndividualmente();
%PRJ.clean();

clear all;
close all;

end