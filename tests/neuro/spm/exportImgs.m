
dirAtual = pwd;
imgsSPM = ImgsSPM;
imgsSPM.pattern = '*';
imgsSPM.type = {'ativacao','save'};
imgsSPM.threshold = 0.005;
imgsSPM.extent = 5;
imgsSPM.FWE = true;
imgsSPM.goTo = 'glmax';
imgsSPM.exportAllCons = true;
%imgsSPM.xyz = [2.76 -89.42 -2.0];

subjdir = '';
subjects = dir( fullfile(root, 'SUBJ*') );
outDirBase = '';
for nsubj=1:length(subjects)
    imgsSPM.inDir = fullfile( root, subjects(nsubj).name );
    imgsSPM.open();
    outDir = fullfile(outDirBase, subjects(nsubj).name);
    imgsSPM.xyz = ToolsSPM.goto('glmax'); %Go to global maxima
    imgsSPM.export( outDir );
    %cd( imgsSPM.outDir );
    convertPsFiles();
end

cd(dirAtual);