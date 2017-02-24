%Exporta apenas imagens
function exportImgsNII()
addpath(pwd);
clear; clc;

dirAtual = pwd;
imgsSPM = ImgsSPM;
imgsSPM.pattern = '*';
imgsSPM.type = 'save';
imgsSPM.threshold = .05;
imgsSPM.extent = 0;
imgsSPM.FWE = true;
imgsSPM.goTo = 'glmax';
imgsSPM.cons = 1:9;
%imgsSPM.xyz = [2.76 -89.42 -2.0];
root = '';
outRootDir = '';

opts = {
%    [.001 0 false]
%    [.05 5 true]
%    [.005 0 false]
    [.05 0 '[dir]/Mask_VR_ROI.nii']
};

for opt = opts'
    imgsSPM.threshold = opt{1}(1);
    imgsSPM.extent = opt{1}(2);
    imgsSPM.FWE = opt{1}(3);
    exporta(imgsSPM, root, outRootDir); 
end

cd(dirAtual);
end

function exporta(imgsSPM, root, outRootDir)

dirs = dir(fullfile(root,'*'));
for nD=1:length(dirs)
    if( any( strcmp(dirs(nD).name, {'.', '..'}) ) ); continue; end;
    curDir = fullfile( root, dirs(nD).name );
    outDir = fullfile( outRootDir, dirs(nD).name );
    if( ~exist( fullfile(curDir,'SPM.mat'), 'file') )
        exporta(imgsSPM, curDir, outDir);
    else
        imgsSPM.inDir = fullfile( root, dirs(nD).name );
        imgsSPM.open();
        imgsSPM.xyz = ToolsSPM.goto('glmax'); %Go to global maxima
        imgsSPM.export( outDir );
    end
end

end