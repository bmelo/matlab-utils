function renomeada = corrigePasta( dirRaiz )

renomeada = false;
subdirs = dir(dirRaiz);
for k=1:length(subdirs)
    if( ~subdirs(k).isdir | any(strcmp(subdirs(k).name, {'.', '..'})) )
        continue
    end
    subDir = fullfile(dirRaiz, subdirs(k).name);
    dcmFiles = dir( fullfile(subDir, '*.dcm') );
    
    for j=1:length(dcmFiles)
        dcmFiles(j)
        hdr = dicom_headers(fullfile( subDir, dcmFiles(j).name ), true);
        if ~isempty(hdr) & ~isempty(hdr{1}.PatientsName) & ~isempty(hdr{1}.StudyDate)
            hdr{1}.PatientsName = regexprep(hdr{1}.PatientsName, '(\s|[*])','_'); %Ajusta o nome
            hdr{1}.StudyDate = datestr(hdr{1}.StudyDate, 'yyyymmdd'); % Ajusta a data
            newDirName = sprintf('%s_%s', hdr{1}.PatientsName, hdr{1}.StudyDate);
            fprintf( '%s -> $s', dirRaiz, fullfile(dirRaiz, '..', newDirName));
            %movefile(dirRaiz, fullfile(dirRaiz, '..', newDirName));
            renomeada = true;
            break;
        end
    end
end