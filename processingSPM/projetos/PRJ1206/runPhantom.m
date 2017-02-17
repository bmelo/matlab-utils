obj = PRJPHANTOM();
obj.subjects = 1;
    
obj = initParamsGeral( obj );
obj.numSessions = 1;
% pathSessions = {'fMRI_EXE_PRJ1206_0501', 'fMRI_IMAG_1P_PRJ1206_0601', 'fMRI_IMAG_3P_PRJ1206_0701', 'fMRI_IMAG_3P_SEM_ACELER_0901'};
pathSessions = {'fMRI_EXE'};
obj.pathSessions = pathSessions;
obj.inDir = fullfile( obj.baseDir, obj.folderPre );
obj.outDir = fullfile( obj.baseDir, obj.folderFL );

    

% obj.dcm2nii();
obj.processarPreproc();
%obj.processarPreproc( 'etapas', {'realign', 'slicetiming', 'smooth'} );

for k=1:length(pathSessions)
    
    obj.pathSessions = pathSessions(k);
    obj.numSessions = 1;
    obj.midLevel = [];
    obj.outDir = fullfile(obj.baseDir, obj.folderFL, 'NORMAL_REST_SEM_MASCARA', obj.pathSessions{1} );
    obj.processarFirstLevel('prefix', 'swar*');

end
