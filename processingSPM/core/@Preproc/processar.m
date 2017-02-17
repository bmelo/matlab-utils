function processar(obj)
%PROCESSAR Summary of this function goes here
%   Detailed explanation goes here
processar@ProcessamentoSPM(obj);

%%Processamento principal da parte de pré-processamento
%Alterando o diretório que irá armazenar o arquivo ps
jobs{1}.cfg_basicio.cfg_cd.dir = cellstr(obj.subject.fullPath);
spm_jobman('run',jobs);
clear jobs;

if obj.checkDataToProcess() %Verifica se o sujeito pode ser processado
    try
        obj.executarPreproc();
    catch Er
        obj.error = MException('Preproc:Execute', 'Erro na execução do processamento');
        obj.error = obj.error.addCause(Er);
    end
end

%Lista arquivos .ps e converte para .pdf
psFiles = dir( fullfile(obj.subject.fullPath, '*.ps') );
for k = 1:length(psFiles)
    try
        pdfname = [obj.prefixoAtual '_' psFiles(k).name(1:end-3) '.pdf'];
        ps2pdf('psfile', fullfile(obj.subject.fullPath, psFiles(k).name), 'pdffile', fullfile(obj.subject.fullPath, pdfname), 'deletepsfile', 1);
    catch Er
        obj.error = MException('Preproc:psfile', '!! Não foi possivel converter o arquivo %s para o formato pdf.', psFiles(k).name);
        obj.error = obj.error.addCause(Er);
    end
end

obj.execFinished();

end