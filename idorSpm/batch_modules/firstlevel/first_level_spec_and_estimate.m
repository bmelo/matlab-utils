import idor.utils.Var;

if ~isdir( dest_dir_subj ), mkdir( dest_dir_subj ), end

matlabbatch{1}.spm.stats.fmri_spec.dir = {dest_dir_subj};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = config.TR;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

for k=1:nrun
    
    scans = get_scans( config, preproc_dir, nrun, nvol, [preproc_prefix run_file_prefix] , run_file_suffix );
    
    %% scans
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).scans = scans{k};
    
    %% loop over conditions
    for co = 1:length(sessions(k).names)
           
        %% Fixing duration, if necessary
        % For one session is better have one duration to each onset
        nOnsets = length(sessions(k).onsets{co});
        if Var.get(config, 'one_session') && ( length( sessions(k).durations{co} ) == 1 )
            sessions(k).durations{co} = repmat( sessions(k).durations{co}, 1, nOnsets );
        end  
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).name        = sessions(k).names{co};
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).onset       = sessions(k).onsets{co};
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).duration    = sessions(k).durations{co};
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).tmod        = 0;
        
        %% Parametric modulation
        if co <= length(sessions(k).pmod)
            matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).pmod = sessions(k).pmod{co};
        else
            matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(co).pmod = struct('name', {}, 'param', {}, 'poly', {});
        end      
    end
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi = {''};
    if( isstruct( Var.get(sessions(k), 'regress') ) )
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).regress = Var.get(sessions(k), 'regress');
    else
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).regress = struct('name', {}, 'val', {});
    end
    % Multiple regressors
    if isfield( sessions, 'regfile' ) && ~isempty( sessions(k).regfile )
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi_reg = {sessions(k).regfile};
    else
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi_reg = {''};
    end
    
    hpf = Var.get(config, 'HPF', 128);
    %If zero, computes the HPF as the max difference between onsets * 2
    if( hpf == 0 )
        for co = 1:length(sessions(k).names)
            onsets = unique(sessions(k).onsets{co});
            hpf = max([hpf diff( onsets(:)' )] );
        end
        hpf = ceil(hpf * 2);
        fprintf('HPF calculated = %d\n', hpf);
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).hpf = hpf;
    
end
clear hpf;

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
% time=[1 0]; all=[1 1];
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = Var.get(config,'hrf_derivate', [0 0]);
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = Var.get(config,'mthresh', 0.8);
matlabbatch{1}.spm.stats.fmri_spec.mask = config.mask;
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'none';

matlabbatch{2}.spm.stats.fmri_est.spmmat = { fullfile( dest_dir_subj, 'SPM.mat') };
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
