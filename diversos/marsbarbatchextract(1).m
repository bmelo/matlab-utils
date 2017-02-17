% MarsBaR batch script to show off MarsBaR batching
%  See http://marsbar.sourceforge.net
%Adapted by J Grahn

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Need to be IN directory where con images are.
%%%%%%%%%%%%%%%%%%%%%%%%%%%

 root_dir = '/imaging/jessica/Beat/RFX/';
%sesses = {'sess1','sess2' 'sess3'};
con_dir = 'cons/' %where contrast images are, subdirectory of root directory
con_dirname = 'AudVis' %this is prefixed to the text files that contain the extracted data
% Directory to store (and load) ROIs
roi_dir = fullfile(root_dir, 'ROIs'); %where rois are, subdirectory of root directory
%  roi_dir = '/imaging/jessica/anatomy toolboxes/rois'; 
% MarsBaR version check
if isempty(which('marsbar'))
  error('Need MarsBaR on the path');
end
v = str2num(marsbar('ver'));
if v < 0.35
  error('Batch script only works for MarsBaR >= 0.35');
end
marsbar('on');  % needed to set paths etc

% SPM version check. We need this to guess which model directory to use and
% to get the SPM configured design name. 
spm_ver = spm('ver');
sdirname = [spm_ver '_ana'];
if strcmp(spm_ver, 'SPM99') 
  conf_design_name = 'SPMcfg.mat';
else
  spm_defaults;
  conf_design_name = 'SPM.mat';
end

% Set up the SPM defaults, just in case
spm('defaults', 'fmri');

% We will do estimation for all ROIs in this directory: remove prefix as
% necessary to get right filter to load the files
roinames = dir(fullfile(roi_dir, 'roi*_roi.mat'))

P = dir(fullfile(root_dir,con_dir,'*.img'));       % get images from contrast directory where they are stored
V = spm_vol(P);
D = strvcat(V(:).name); %load images into format for Marsbar

 for roi_no = 1:length(roinames)
    roi_array{roi_no} = maroi(fullfile(roi_dir, roinames(roi_no).name));

    % Extract data
  Y = get_marsy(roi_array{roi_no}, D, 'mean');%get the values
%mars_arm('save', 'roi_data', 'test.mat');
[datamean datavar o] = summary_data(Y, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
regionname{roi_no}  = char(region_name(Y)); %note the regionname
if roi_no ==1
    data = datamean;
    regionnames = char(regionname{roi_no});
else
    data = [data datamean];
    regionnames = strvcat([regionnames ' ' char(regionname{roi_no})]);
end
%data{roi_no} = datamean;

%[Y Yvar o] = summary_data(o, 'median');
%      % MarsBaR estimation
%      E = estimate(D, Y);
%      
%      % Add contrast, return model, and contrast index
%      [E Ic] = add_contrasts(E, 'stim_hrf', 'T', [1 0 0]);
%      
%      % Get, store statistics
%      stat_struct(ss) = compute_contrasts(E, Ic);
%      
%      % And fitted time courses
%      [this_tc dt] = event_fitted(E, event_spec, event_duration);
%  
%      % Make fitted time course into ~% signal change
%      tc(:, ss) = this_tc / block_means(E) * 100;
 end
%assign concatenated data to file and save data, regionnames, and image
%file list to 3 separate files.

fname = [con_dirname 'extracteddata.txt'] %this file contains as many columns as ROIS extracted, and as many rows as you have con images
save(fname, 'data', '-ascii');

fname2 = [con_dirname 'imgnames.txt']; %the list of the con images extracted from
fid = fopen(fname2, 'w');
fprintf(fid,'%s\n', P.name);
fclose(fid);

fname3 = [con_dirname 'regions.txt']; %the list of the rois extracted 
fid = fopen(fname3, 'w');
fprintf(fid, regionnames);
fclose(fid);

