function renomeada = corrigePasta( dirRaiz )
tempo = tic;
renomeada = false;
subdirs = dir(dirRaiz);
filesToRead = cell(length(subdirs),1);
numFiles = 0;
for k=1:length(subdirs)
    if( ~subdirs(k).isdir | any(strcmp(subdirs(k).name, {'.', '..'})) )
        continue
    end
    subDir = fullfile(dirRaiz, subdirs(k).name);
    dcmFiles = dir( fullfile(subDir, '*.dcm') );
    if ~isempty(dcmFiles)
        if dcmFiles(1).bytes < 1000000
            renomeada = renomearArquivo( fullfile(subDir, dcmFiles(1).name), dirRaiz, tempo );
            if renomeada
                return;
            end
        else
            numFiles = numFiles+1;
            filesToRead{numFiles,1} = fullfile(subDir, dcmFiles(1).name);
            filesToRead{numFiles,2} = dcmFiles(1).bytes;
        end
    end
end
if numFiles>0
    filesToRead = sortrows(filesToRead, 2);

    for k=1:numFiles
        renomeada = renomearArquivo( filesToRead{k,1}, dirRaiz, tempo );
        if renomeada
            return;
        end
    end
end
end

function status=renomearArquivo( fileDir, dirRaiz, tempo )

[raiz dirRenomear] = fileparts(dirRaiz);
%fSH = fopen( 'renomear.sh', 'a' );
%fLog = fopen( 'pastas.log', 'a' );
status = false;
try
    hdr = dicom_headers(fileDir, true);
    if ~isempty(hdr) & ~isempty(hdr{1}.PatientsName) & ~isempty(hdr{1}.StudyDate)
        hdr{1}.PatientsName = regexprep(hdr{1}.PatientsName, {'(\s|[*])','^_|_$'}, {'_',''}); %Ajusta o nome
        hdr{1}.StudyDate = datestr(hdr{1}.StudyDate, 'yyyymmdd'); % Ajusta a data
        novaPasta = sprintf('%s_%s', hdr{1}.PatientsName, hdr{1}.StudyDate);
        %fprintf(fSH, 'mv ''%s'' ''%s''\n', dirRenomear, novaPasta);
        tempoTotal = datestr(datenum(0,0,0,0,0,toc(tempo)),'HH:MM:SS.FFF');
        %fprintf( fLog, '%s -> %s (%s segundos)\n', dirRaiz, novaPasta, tempoTotal);
        fprintf( '%s -> %s (%s segundos)\n', dirRaiz, novaPasta, tempoTotal);
        status = true;
    end
catch Me
    disp(Me.message);
end
%fclose(fSH);
%fclose(fLog);
end