function replicStructDirs(dirIn, rootOut)

dirs = dir(dirIn);
for k=1:length(dirs)
    if ~isdir( fullfile(dirIn, dirs(k).name) ) | strcmp(dirs(k).name, '.') | strcmp(dirs(k).name, '..')
        continue;
    end
    
    if ~isdir(fullfile(rootOut, dirs(k).name))
        mkdir(fullfile(rootOut, dirs(k).name))
    end
    replicStructDirs( fullfile(dirIn, dirs(k).name), fullfile(rootOut, dirs(k).name) );
end

end