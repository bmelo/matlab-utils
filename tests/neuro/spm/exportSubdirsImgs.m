clear all;
imgsSPM = ImgsSPM;
imgsSPM.pattern = 'CON_*';
imgsSPM.dirSpmMat = '';
imgsSPM.type = 'save';

dirsRootSD = {
    ''
}';
outDirBase = '';

for j = 1:length(dirsRootSD)
    dirRootSD = dirsRootSD{j};
    [dirAtual proc] = fileparts(dirRootSD);
    dirsSD = dir( dirRootSD );
    for k = 1:length(dirsSD)
        if nonzeros( strcmp(dirsSD(k).name, {'.', '..'}) )
            continue;
        end
        if strcmp(dirsSD(k).name,'FEEDBACK x NOFEED')
            imgsSPM.cons = [1 2];
        else
            imgsSPM.cons = 1;
        end
        imgsSPM.outDir = fullfile(outDirBase, proc, dirsSD(k).name );
        imgsSPM.export( fullfile(dirRootSD, dirsSD(k).name) );
    end
    cd( dirRootSD );
end