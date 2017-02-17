cd /dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/
old_cs = load( 'OLD/CUE_AND_SQUEEZE_MOTOR/TESTE001/SPM.mat' );
new_cs = load( 'CUE_AND_SQUEEZE_MOTOR/TESTE001/SPM.mat' );
collintest( zscore( old_cs.SPM.xX.X(:,1:end-1) ) )
collintest( zscore( new_cs.SPM.xX.X(:,1:end-1) ) )
