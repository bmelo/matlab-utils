%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
clear matlabbatch;

matlabbatch{1}.spm.stats.fmri_design.dir = {spec_dir};
matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_design.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t0 = 1;

for k=1:length(sessions)

%     for vol = 1:num_vol        
%         matlabbatch{1}.spm.stats.fmri_design.sess(k).scans{vol,1} = [dir_base,name_subj{s},'/run', num2str(k),'_',name_subj{s},'.nii,' num2str(vol)];
%     end
    
    matlabbatch{1}.spm.stats.fmri_design.sess(k).nscan = num_scans;
    
    for co = 1:length(sessions(k).names)
    
        matlabbatch{1}.spm.stats.fmri_design.sess(k).cond(co).name        = sessions(k).names{co};
        matlabbatch{1}.spm.stats.fmri_design.sess(k).cond(co).onset       = sessions(k).onsets{co};
        matlabbatch{1}.spm.stats.fmri_design.sess(k).cond(co).duration    = sessions(k).durations{co};
        matlabbatch{1}.spm.stats.fmri_design.sess(k).cond(co).tmod        = 0;


        if ~isempty( pmod )
            matlabbatch{1}.spm.stats.fmri_design.sess(k).cond(co).pmod = sessions(k).pmod(co);
        else
            matlabbatch{1}.spm.stats.fmri_design.sess(k).cond(co).pmod = struct('name', {}, 'param', {}, 'poly', {});
        end

    end

    matlabbatch{1}.spm.stats.fmri_design.sess(k).multi = {''};
    matlabbatch{1}.spm.stats.fmri_design.sess(k).regress = struct('name', {}, 'val', {});
    if isfield( sessions, 'regfile' ) && ~isempty( sessions(k).regfile )
        matlabbatch{1}.spm.stats.fmri_design.sess(k).multi_reg = {sessions(k).regfile};
    else
        matlabbatch{1}.spm.stats.fmri_design.sess(k).multi_reg = {''};
    end
    matlabbatch{1}.spm.stats.fmri_design.sess(k).hpf = 128;

end

matlabbatch{1}.spm.stats.fmri_design.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_design.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_design.volt = 1;
matlabbatch{1}.spm.stats.fmri_design.global = 'None';
matlabbatch{1}.spm.stats.fmri_design.cvi = 'none';

% matlabbatch{2}.spm.stats.fmri_est.spmmat = {[dir_base,name_subj{s},'/',design,'/SPM.mat']};
% matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
