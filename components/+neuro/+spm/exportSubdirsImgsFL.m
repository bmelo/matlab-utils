dirRootFL = pwd;
dirsFL = dir();
cons = [69 71 85];

for k = 1:length(dirsFL)
    if nonzeros( strcmp(dirsFL(k).name, {'.', '..'}) )
        continue;
    end
    
    cd( fullfile(dirRootFL, dirsFL(k).name) );
    exportImgs;
end
cd( dirRootFL );