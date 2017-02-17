function processar( obj )
%PROCESSAR Summary of this function goes here
%   Detailed explanation goes here
tempOutDir = obj.outDir;
obj.outDir = fullfile(obj.outDir, obj.folder, sprintf('CON_%04d_%s', obj.contraste, obj.contrasteName));
if ~isdir(obj.outDir)
    mkdir(obj.outDir);
end
processar@ProcessamentoSPM(obj);

%% ORGANIZANDO SCRIPT DO SPM
obj.matlabbatch = obj.batch();
obj.executar(obj.outDir, obj.matlabbatch);

obj.outDir = fullfile(tempOutDir, obj.folder);
obj.execFinished();
obj.outDir = tempOutDir;

end

