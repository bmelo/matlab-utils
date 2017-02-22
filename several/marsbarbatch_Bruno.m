% MarsBaR batch script to show off MarsBaR batching
%  See http://marsbar.sourceforge.net
%Adapted by J Grahn
%Re-Adapted by Bruno Melo%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Need to be IN directory where con images are. [No more]
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% FIRST LEVEL %%%

root_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/SECOND_LEVEL/RESP_MOV_EFFORT_SEP_CSO';
root_fl_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/PROC_DATA/fMRI/NORM_ANAT/STATS/FIRST_LEVEL/RESP_MOV_EFFORT_SEP_CSO';

% Directory to store (and load) ROIs
% roi_dir = fullfile(root_dir, 'ROIs/Functional Localizaer'); %where rois are, subdirectory of root directory
roi_dir = '/dados1/PROJETOS/PRJ1410_FUTEBOL/03_PROCS/ROIs/';
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
roinames = dir(fullfile(roi_dir, '*-3_53_-13_roi.mat'))

clear data P;
data = [];
P = {};
for subjid=[2:16 18:26 28]
    subjdir = sprintf('SUBJ%03d', subjid);
    con_dir = fullfile(root_fl_dir, subjdir);
    P{end+1} = {};
    for nc = [13 14 15 19 20 21]
        conimg = sprintf('con_%04d.img', nc);
        P{end}{end+1} = fullfile(con_dir,conimg);       % get images from contrast directory where they are stored
    end
    %V = spm_vol(P);
    D = char(P{end}); %load images into format for Marsbar
    
    for roi_no = 1:length(roinames)
        roi_array{roi_no} = maroi(fullfile(roi_dir, roinames(roi_no).name));
        
        % Extract data
        Y = get_marsy(roi_array{roi_no}, D, 'mean');%get the values
        
        [datamean datavar o] = summary_data(Y, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
        regionname{roi_no}  = char(region_name(Y)); %note the regionname
        
        data = [data datamean];
        regionnames = char(regionname{roi_no});
    end
end
%assign concatenated data to file and save data, regionnames, and image
%file list to 3 separate files.

con_dirname = root_fl_dir;
fname = fullfile(con_dirname, 'extracteddata.txt') %this file contains as many columns as ROIS extracted, and as many rows as you have con images
data = data';
save(fname, 'data', '-ascii');

fname2 = [con_dirname 'imgnames.txt']; %the list of the con images extracted from
fid = fopen(fname2, 'w');
for nS = 1:length(P)
    fprintf(fid,'%s\n', P{nS}{:});
end
fclose(fid);

fname3 = [con_dirname 'regions.txt']; %the list of the rois extracted
fid = fopen(fname3, 'w');
fprintf(fid, regionnames);
fclose(fid);

