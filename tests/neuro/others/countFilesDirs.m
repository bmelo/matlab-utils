function countFilesDirs(dirIn, fileExt)

if isempty(fileExt)
    fileExt = '*';
end
totalFiles = length(dir(fullfile(dirIn, ['*.' fileExt])));
[dirRoot nameDir] = fileparts(dirIn);
if strcmp(nameDir, 'DTD') | strcmp(nameDir, 'T1')
    fprintf('%s - total de arquivos *.dcm: %d\n', dirIn, totalFiles);
end
dirs = dir(dirIn);
for k=1:length(dirs)
    if ~isdir( fullfile(dirIn, dirs(k).name) ) | strcmp(dirs(k).name, '.') | strcmp(dirs(k).name, '..')
        continue;
    end
    
    countFilesDirs( fullfile(dirIn, dirs(k).name) , fileExt);
end

end