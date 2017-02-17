if ~isdir( dest_dir_subj ), mkdir( dest_dir_subj ), end

matlabbatch{1}.spm.stats.fmri_spec.dir = {dest_dir_subj};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = config.TR;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

scans = get_scans( preproc_dir, nrun, nvol, [preproc_prefix run_file_prefix] , run_file_suffix );

for k=1:nrun
    
    %% scans
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).scans = scans{k};
    
    %% loop over conditions
    for co = 1:length(sessions(k).names)
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).name        = sessions(k).names{co};
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).onset       = sessions(k).onsets{co};
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).duration    = sessions(k).durations{co};
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).tmod        = 0;
        
        
        if ~isempty( sessions(k).pmod ) && co <= length(sessions(k).pmod)
            matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).pmod = sessions(k).pmod(co);
        else
            matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).pmod = struct('name', {}, 'param', {}, 'poly', {});
        end
        
    end
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).regress = struct('name', {}, 'val', {});
    if isfield( sessions, 'regfile' ) && ~isempty( sessions(k).regfile )
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi_reg = {sessions(k).regfile};
    else
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi_reg = {''};
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).hpf = config.HPF;
    
end

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'none';

matlabbatch{2}.spm.stats.fmri_est.spmmat = { fullfile( dest_dir_subj, 'SPM.mat') };
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
