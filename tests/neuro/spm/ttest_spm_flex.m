%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
if ~exist( 'design_2ndlevel_dest', 'var' )
    design_2ndlevel_dest = design;
end

matlabbatch{1}.spm.stats.factorial_design.dir = { fullfile(dir_base, 'STATS\SECOND_LEVEL', design_2ndlevel_dest, contrast{k} ) };
    
contr = sprintf( 'con_%04d.img,1', k );

for s=1:length(subjs)
    
    subj = sprintf( 'SUBJ%03i', subjs(s) );
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans{s,1} = fullfile(dir_base, 'STATS\FIRST_LEVEL', design, subj, contr);
    
end

%%
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


matlabbatch{2}.spm.stats.fmri_est.spmmat = { fullfile( dir_base,'STATS\SECOND_LEVEL',design_2ndlevel_dest, contrast{k},'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;



matlabbatch{3}.spm.stats.con.spmmat = { fullfile( dir_base, 'STATS\SECOND_LEVEL',design_2ndlevel_dest, contrast{k},'SPM.mat') };
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = contrast{k};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['-',contrast{k}];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = -1;
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
