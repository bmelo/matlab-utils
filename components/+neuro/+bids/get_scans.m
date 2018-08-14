function scans = get_scans( bids_dir, filter, runs )
%GET_SCANS (config, modality, runs)
% bids_dir = BIDS directory including modality (anat, dwi, func, fmap)
% filter = pattern to filter the images (Ex: 'task-ADHD', 'acq-multishell')
% runs = filter for specific runs (0 - all runs [default])
if nargin < 2, filter = 'sub-'; end;
if nargin < 3, runs = 0; end;

scans = utils.resolve_names( fullfile(bids_dir, [filter '*.nii*']) );

end