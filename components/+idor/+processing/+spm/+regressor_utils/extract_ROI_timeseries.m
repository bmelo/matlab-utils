% ROIs from e.g. Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FINGERPRINT\ROIs_ANOVA_design1_EOC

dest_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PREPROC_DATA/fMRI/NORM_ANAT';
spm_dir  = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/MOV_CUE_MOTOR/';

roi_dir  = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/SCRIPTS/MASKS';

subjs = [2];

% roi_files = spm_get(Inf,'*roi.mat', 'Select ROI files');
roi_files = { fullfile( roi_dir, 'csf3_1_12_61_roi.mat' ) , fullfile( roi_dir, 'csf3_0_-21_-15_roi.mat' ) }

for s=1:length(subjs)
    
    des_path = fullfile( spm_dir, sprintf( 'SUBJ%03i', subjs(s) ) , 'SPM.mat');
    rois = maroi('load_cell', roi_files); % make maroi ROI objects
    des = mardo(des_path);  % make mardo design object
    mY = get_marsy(rois{:}, des, 'mean'); % extract data into marsy data object
    y  = summary_data(mY);  % get summary time course(s)
    
    reg = region(mY);
    
    for r=1:3
        
        ddest_dir = fullfile( dest_dir, sprintf( 'SUBJ%03i', subjs(s) ), sprintf('RUN%i', r) );
        
        if ~isdir( ddest_dir ), mkdir( ddest_dir ), end
        
        inds = (r-1)*256+1 : r*256;
        
        for rr=1:length(reg)
            data = y(inds,rr);
            name = reg{rr}.name;
            
            save( fullfile( ddest_dir, [reg{rr}.name '.mat'] ), 'data', 'name' );
            
            y_tmp = y(inds,rr);
            dlmwrite( fullfile( ddest_dir, [ 'reg_' reg{rr}.name '.txt'] ), y_tmp, 'delimiter', '\t'  );
        end
        
        dlmwrite( fullfile( ddest_dir, [ 'reg_ROIS.txt'] ), y(inds,:), 'delimiter', '\t' );
        
    end
end

