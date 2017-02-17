%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev$)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.dir = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

%% RUN 01
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {};
% CONDITION 01
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'NEUTRO';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = []; %Matriz de double
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 15;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 02
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'TERNURA';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = []; %Matriz de double
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 03
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'ORGULHO';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = []; %Matriz de double
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
% Demais parametros
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;

%% RUN 02
matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {};
% CONDITION 01
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'NEUTRO';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 15;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 02
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'TERNURA';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 03
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = 'ORGULHO';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
% Demais parametros
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;

%% RUN 03
matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {};
% CONDITION 01
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).name = 'NEUTRO';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).duration = 15;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 02
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).name = 'TERNURA';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 03
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).name = 'ORGULHO';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
% Demais parametros
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;

%% RUN 04
matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = {};
% CONDITION 01
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).name = 'NEUTRO';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).duration = 15;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 02
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).name = 'TERNURA';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
% CONDITION 03
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).name = 'ORGULHO';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).onset = []; %Matriz de doubles
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).duration = 22;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
% Demais parametros
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = 128;

%%
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = { [which('apriori\brainmask.nii') ',1' ] };
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
%% DEFINICAO DOS CONTRASTES
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'RISK - SECURE';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1 0 0 1 -1 0 0 1 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
