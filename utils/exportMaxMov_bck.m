
prefixF = 'SUBJ';
fileSaida = 'dadosMovimentos.txt';

dados = [];
maxR = 0;
maxT = 0;
fPatt = 'rp_*.txt';
dirRoot = '/dados1/PROJETOS/PRJ1406_SINTAXE_E_VALORES/03_PROCS/PREPROC_DATA/fMRI/NORM_ANAT';
for k=1:57
    subjDir = sprintf( '%s%03d', prefixF, k);
    for run=1:3
        folder = fullfile( dirRoot, subjDir, sprintf('RUN%d',run) );
        if(exist(folder,'dir'))
            files = dir( fullfile( folder, fPatt ));
            if( ~isempty(files) )
                dadosMov = textread( fullfile(folder,files(1).name) );
                dados(end+1).subjFolder = fullfile(subjDir, sprintf('RUN%d',run));
                dados(end).maximos = max(dadosMov) - min(dadosMov);
                dados(end).maximos(4:6) = dados(end).maximos(4:6) ./(pi/180) ; %Convert RADIANS to DEGREES
                maxR = max( [maxR max(dados(end).maximos(1:3))] );
                maxT = max( [maxT max(dados(end).maximos(4:6))] );
            end
        end
    end
end

%escrevendo resultados
fid = fopen(fileSaida, 'w');
fprintf(fid, 'SUJEITO\t\tTRANSL.\t\tROTACAO\n');
for k=1:length(dados)
    fprintf(fid, '%s\t%.4f\t%.4f\n', dados(k).subjFolder, max(dados(k).maximos(1:3)), max(dados(k).maximos(4:6)));
end
fprintf(fid, '\n\nMAXIMOS:\t%.4f\t%.4f', maxR, maxT);
fclose(fid);