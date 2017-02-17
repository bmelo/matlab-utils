import idor.utils.Var;
matlabbatch{1}.spm.stats.factorial_design.dir = {dest_dir};

fl_base = fullfile( config.proc_base, 'STATS', 'FIRST_LEVEL',  subdir_name);
is_two_sample = ~isempty( config.sec.g2 );

subjs1 = get_cons_path(config, config.sec.g1, ci, fl_base);
if ~is_two_sample
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = subjs1;
else
    subjs2 = get_cons_path(config, config.sec.g2, ci, fl_base);
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = subjs1;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = subjs2;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
end

%%
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});

if ( iscell( Var.get(config.sec, 'covfiles') ) )
    matlabbatch{1}.spm.stats.factorial_design.multi_cov.files = config.sec.covfiles;
    matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCC = 1;
end

matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile( dest_dir,'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


matlabbatch{3}.spm.stats.con.spmmat = {fullfile( dest_dir,'SPM.mat')};

if ~is_two_sample
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = contrast_name;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['-',contrast_name];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = -1;
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
else
    g1_name = Var.get(config.sec, 'g1_name', 'G1');
    g2_name = Var.get(config.sec, 'g2_name', 'G2');
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = sprintf('%s > %s (%s)', g1_name, g2_name,contrast_name);
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = sprintf('%s > %s (%s)', g2_name, g1_name,contrast_name);
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
end

matlabbatch{3}.spm.stats.con.delete = 0;
