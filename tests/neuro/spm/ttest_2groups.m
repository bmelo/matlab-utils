
matlabbatch{1}.spm.stats.factorial_design.dir = { fullfile(dir_base, 'STATS\SECOND_LEVEL', design_2ndlevel_dest, contrast{k} ) };
    
contr = sprintf( 'con_%04d.img,1', k );

for s=1:length(subjs{1})
    subj = sprintf( 'SUBJ%03i', subjs{1}(s) );
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1{s,1} = fullfile(dir_base, 'STATS\FIRST_LEVEL', design, subj, contr);
end
for s=1:length(subjs{2})
    subj = sprintf( 'SUBJ%03i', subjs{2}(s) );
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2{s,1} = fullfile(dir_base, 'STATS\FIRST_LEVEL', design, subj, contr);
end

matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
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
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = sprintf('%s_%s > %s', contrast{k} ,groupname{1}, groupname{2});
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = sprintf('%s_%s > %s', contrast{k} ,groupname{2}, groupname{1});
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;