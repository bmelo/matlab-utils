function runMestre_Test()

% pathSessions = {'Motor_+ghost1_0401', 'Motor_+ghost2_0601', 'Motor_normal1_0301', 'Motor_normal2_0501','no_sense_+ghost_0801','no_sense_norm_0701'};

%pathSessions = { 'fMRI_EXE_PRJ1206_0401', 'fMRI_EXE_PRJ1206_0501' };
pathSessions = { 'fMRI_EXE' };

for k=1:length(pathSessions)

% definicoes usuario
subjects = 3;
   
obj = PRJ1206_SEP_EXE();
obj.subjects = subjects;

obj.baseDir = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_TEST_SCANS\';
obj.inDir   = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_TEST_SCANS\PREPROC_DATA';
obj.outDir   = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_TEST_SCANS\STATS';
obj.rawDir  = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_TEST_SCANS\RAW_DATA';

obj.pathSessions = pathSessions(k);

obj.midLevel = [];
obj.dcm2nii();
obj.processarPreproc();

runSPM( obj );

end



end

%{
% unificado necessita do detrend
    obj.processarPreproc( 'unificado', 1, 'etapas', {'realign', 'slicetiming', 'detrend', 'normalization', 'smooth'} );


% sessoes separadas
obj = prepareObj( PRJ1206_SEP_EXE(), subjects );
obj.dcm2nii();
obj.processarPreproc();

obj = prepareObj( PRJ1206_SEP_1P(), subjects );
obj.dcm2nii();
obj.processarPreproc();

obj = prepareObj( PRJ1206_SEP_3P(), subjects );
obj.dcm2nii();
obj.processarPreproc();
%}


function obj = prepareObj( obj, subjects )
    obj = initParamsGeral( obj );
    obj.subjects = subjects;
end