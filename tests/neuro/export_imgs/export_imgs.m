%Exporta apenas imagens
function export_imgs()
clear; clc;

run('vendors/matlab-utils/init.m');

dirAtual = pwd;
imgsSPM = neuro.spm.ImgsSPM;
imgsSPM.pattern = '*';
%
imgsSPM.type = 'ativacao';
imgsSPM.threshold = .05;
imgsSPM.extent = 0;
imgsSPM.export_pdf = false;
imgsSPM.FWE = true;
imgsSPM.goTo = 'glmax';
imgsSPM.cons = 3;
imgsSPM.xyz = [0 11 -4];
root = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PROC_DATA/fMRI/exclui_subj005/STATS/FIRST_LEVEL/MOTOR';
outRootDir = '/dados1/PROJETOS/PRJ1502_NFB_MOTOR_II/03_PROCS/PROC_DATA/fMRI/exclui_subj005/STATS/EXPORTED_IMGS';

opts = {
    %% { p k fwe nCon coord }
    % {.005 0 false 3 [0 11 -4]}
    % {.005 0 false 4 [27 -10 -10]}
    {0.005 5 false 3:9 [-2 -1 55]}
    %{.01 0 false 8 [24 44 -13]}
    %[.001 0 false 4 [27 -10 -10]]
    %[.05 5 true]
    %[.05 0 '/dados1/PROJETOS/PRJ1411_NFB_VR/03_PROCS/EXPORTED_IMGS/bruno/ROIS/Mask_VR_ROI.nii']
};

for opt = opts'
    imgsSPM.threshold = opt{1}{1};
    imgsSPM.extent = opt{1}{2};
    imgsSPM.FWE = opt{1}{3};
    imgsSPM.cons = opt{1}{4};
    imgsSPM.xyz = opt{1}{5};
    exporta(imgsSPM, root, outRootDir); 
end

cd(dirAtual);
end

function exporta(imgsSPM, root, outRootDir)

spmfiles = utils.find(root, '.*/SPM.mat', 'f');
for nD=1:length(spmfiles)
    in_dir = fileparts(spmfiles{nD});
    subjid = regexp(in_dir, 'SUBJ\d{3,}','match', 'once');
    
    imgsSPM.inDir = in_dir;
    imgsSPM.open();
    imgsSPM.outDir = outRootDir;
    imgsSPM.prefix = sprintf('%s_', subjid);
    neuro.spm.ToolsSPM.goto(imgsSPM.xyz); %Go to xyz
    imgsSPM.export( outRootDir );
end

end