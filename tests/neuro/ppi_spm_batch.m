% This batch script analyses the Attention to Visual Motion fMRI dataset
% available from the SPM site using PPI:
% http://www.fil.ion.ucl.ac.uk/spm/data/attention/
% as described in the SPM manual:
%  http://www.fil.ion.ucl.ac.uk/spm/doc/manual.pdf

% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin & Darren Gitelman
% $Id: ppi_spm_batch.m 17 2009-09-28 15:37:01Z guillaume $

% Directory containing the attention data
%---------------------------------------------------------------------
% data_path = 'C:\data\path-to-data';
data_path = spm_select(1,'dir','Select the attention data directory');

% Initialise SPM
%---------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg'); % SPM8 only (does nothing in SPM5)


% Working directory (useful for .ps outputs only)
%---------------------------------------------------------------------
clear jobs
jobs{1}.util{1}.cdir.directory = cellstr(data_path);
spm_jobman('run',jobs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLM SPECIFICATION, ESTIMATION, INFERENCE, RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load factors
%---------------------------------------------------------------------
factors = load(fullfile(data_path,'factors.mat'));

% OUTPUT DIRECTORY
%=====================================================================
clear jobs
jobs{1}.util{1}.md.basedir = cellstr(data_path);
jobs{1}.util{1}.md.name = 'GLM';
spm_jobman('run',jobs);

% MODEL SPECIFICATION
%=====================================================================
clear jobs

% Directory
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.dir = cellstr(fullfile(data_path,'GLM'));

% Timing
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.timing.units = 'scans';
jobs{1}.stats{1}.fmri_spec.timing.RT = 3.22;

% Session
%---------------------------------------------------------------------
f = spm_select('FPList', fullfile(data_path,'functional'), '^snf.*\.img$');
jobs{1}.stats{1}.fmri_spec.sess.scans = cellstr(f);
jobs{1}.stats{1}.fmri_spec.sess.cond(1).name = 'Stationary';
jobs{1}.stats{1}.fmri_spec.sess.cond(1).onset = factors.stat;
jobs{1}.stats{1}.fmri_spec.sess.cond(1).duration = 10;
jobs{1}.stats{1}.fmri_spec.sess.cond(2).name = 'No-Attention';
jobs{1}.stats{1}.fmri_spec.sess.cond(2).onset = factors.natt;
jobs{1}.stats{1}.fmri_spec.sess.cond(2).duration = 10;
jobs{1}.stats{1}.fmri_spec.sess.cond(3).name = 'Attention';
jobs{1}.stats{1}.fmri_spec.sess.cond(3).onset = factors.att;
jobs{1}.stats{1}.fmri_spec.sess.cond(3).duration = 10;

% Block effect to model the different sessions
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.sess.regress(1).name = 'Block 1';
jobs{1}.stats{1}.fmri_spec.sess.regress(1).val = [ones(90,1);zeros(270,1)];
jobs{1}.stats{1}.fmri_spec.sess.regress(2).name = 'Block 2';
jobs{1}.stats{1}.fmri_spec.sess.regress(2).val = [zeros(90,1);ones(90,1);zeros(180,1)];
jobs{1}.stats{1}.fmri_spec.sess.regress(3).name = 'Block 3';
jobs{1}.stats{1}.fmri_spec.sess.regress(3).val = [zeros(180,1);ones(90,1);zeros(90,1)];

% High-pass filter
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.sess.hpf = 192;

% MODEL ESTIMATION
%=====================================================================
jobs{1}.stats{2}.fmri_est.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));

spm_jobman('run',jobs);

% INFERENCE
%=====================================================================
clear jobs
jobs{1}.stats{1}.con.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
jobs{1}.stats{1}.con.consess{1}.fcon.name = 'Effects of interest';
fcont = [eye(3) zeros(3,4)];
for i=1:size(fcont,1)
	jobs{1}.stats{1}.con.consess{1}.fcon.convec{1,i} = fcont(i,:);
end
jobs{1}.stats{1}.con.consess{2}.tcon.name = 'Attention';
jobs{1}.stats{1}.con.consess{2}.tcon.convec = [0 -1 1 0 0 0 0];
jobs{1}.stats{1}.con.consess{3}.tcon.name = 'Motion';
jobs{1}.stats{1}.con.consess{3}.tcon.convec = [-2 1 1 0 0 0 0];
spm_jobman('run',jobs);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOLUME OF INTERESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXTRACTING TIME SERIES: V2
%=====================================================================

% DISPLAY THE MOTION CONTRAST RESULTS
%---------------------------------------------------------------------
clear jobs
jobs{1}.stats{1}.results.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
jobs{1}.stats{1}.results.conspec(1).titlestr = 'Extracting V2: Motion';
jobs{1}.stats{1}.results.conspec(1).contrasts = 3;
jobs{1}.stats{1}.results.conspec(1).threshdesc = 'FWE';
jobs{1}.stats{1}.results.conspec(1).thresh = 0.05;
jobs{1}.stats{1}.results.conspec(1).extent = 0;
jobs{1}.stats{1}.results.print = 0;
spm_jobman('run',jobs);

% EXTRACT THE EIGENVARIATE
%---------------------------------------------------------------------
xY.xyz  = spm_mip_ui('SetCoords',[15 -78 -9]);
xY.name = 'V2';
xY.Ic   = 1;
xY.Sess = 1;
xY.def  = 'sphere';
xY.spec = 6;
[Y,xY]  = spm_regions(xSPM,SPM,hReg,xY);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSYCHO-PHYSIOLOGIC INTERACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GENERATE PPI STRUCTURE
%=====================================================================
PPI = spm_peb_ppi(fullfile(data_path,'GLM','SPM.mat'),'ppi',xY,...
    [2 1 -1;3 1 1],'V2x(Att-NoAtt)',1);

% OUTPUT DIRECTORY
%---------------------------------------------------------------------
clear jobs
jobs{1}.util{1}.md.basedir = cellstr(data_path);
jobs{1}.util{1}.md.name = 'PPI';
spm_jobman('run',jobs);

% MODEL SPECIFICATION
%=====================================================================
clear jobs

% Directory
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.dir = cellstr(fullfile(data_path,'PPI'));

% Timing
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.timing.units = 'scans';
jobs{1}.stats{1}.fmri_spec.timing.RT = 3.22;

% Scans
%---------------------------------------------------------------------
f = spm_select('FPList', fullfile(data_path,'functional'), '^snf.*\.img$');
jobs{1}.stats{1}.fmri_spec.sess.scans = cellstr(f);

% Regressors
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.sess.regress(1).name = 'PPI-interaction';
jobs{1}.stats{1}.fmri_spec.sess.regress(1).val  = PPI.ppi;
jobs{1}.stats{1}.fmri_spec.sess.regress(2).name = 'V2-BOLD';
jobs{1}.stats{1}.fmri_spec.sess.regress(2).val  = PPI.Y;
jobs{1}.stats{1}.fmri_spec.sess.regress(3).name = 'Psych_Att-NoAtt';
jobs{1}.stats{1}.fmri_spec.sess.regress(3).val  = PPI.P;

% High-pass filter
%---------------------------------------------------------------------
jobs{1}.stats{1}.fmri_spec.sess.hpf = 192;

% MODEL ESTIMATION
%=====================================================================
jobs{1}.stats{2}.fmri_est.spmmat = cellstr(fullfile(data_path,'PPI','SPM.mat'));

 spm_jobman('run',jobs);

% INFERENCE & RESULTS
%=====================================================================
clear jobs
jobs{1}.stats{1}.con.spmmat = cellstr(fullfile(data_path,'PPI','SPM.mat'));
jobs{1}.stats{1}.con.consess{1}.tcon.name = 'PPI-Interaction';
jobs{1}.stats{1}.con.consess{1}.tcon.convec = [1 0 0 0];
spm_jobman('run',jobs);

clear jobs
jobs{1}.stats{1}.results.spmmat = cellstr(fullfile(data_path,'PPI','SPM.mat'));
jobs{1}.stats{1}.results.conspec(1).titlestr = 'PPI-Interaction';
jobs{1}.stats{1}.results.conspec(1).contrasts = 1;
jobs{1}.stats{1}.results.conspec(1).threshdesc = 'none';
jobs{1}.stats{1}.results.conspec(1).thresh = 0.01;
jobs{1}.stats{1}.results.conspec(1).extent = 3;
jobs{1}.stats{1}.results.print = 0;
spm_jobman('run',jobs);

% JUMP TO V5 AND OVERLAY ON A BRAIN
%---------------------------------------------------------------------
spm_mip_ui('SetCoords',[39 -72 0]);
spm_sections(xSPM,findobj(spm_figure('FindWin','Interactive'),'Tag','hReg'),...
    fullfile(data_path,'structural','nsM00587_0002.img'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSYCHO-PHYSIOLOGIC INTERACTION GRAPH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXTRACT THE V5 EIGENVARIATE  [39 -72 0]
%---------------------------------------------------------------------
clear jobs
jobs{1}.stats{1}.results.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
jobs{1}.stats{1}.results.conspec(1).titlestr = 'Motion';
jobs{1}.stats{1}.results.conspec(1).contrasts = 3;
jobs{1}.stats{1}.results.conspec(1).threshdesc = 'FWE';
jobs{1}.stats{1}.results.conspec(1).thresh = 0.001;
jobs{1}.stats{1}.results.conspec(1).extent = 3;
jobs{1}.stats{1}.results.print = 0;
spm_jobman('run',jobs);

xY.xyz  = spm_mip_ui('SetCoords',[39 -72 0]);
xY.name = 'V5';
xY.Ic   = 1;
xY.Sess = 1;
xY.def  = 'sphere';
xY.spec = 6;
[Y,xY]  = spm_regions(xSPM,SPM,hReg,xY);

% Generate PPI structures for V2 and V5 for ATTENTION and NO ATTENTION
% using the PPI machinery allows us to generate the interaction vectors
% properly by deconvolving the BOLD signal, forming the interaction and
% reconvolving
%=====================================================================
PPI2NATT = spm_peb_ppi(fullfile(data_path,'GLM','SPM.mat'),'ppi',...
    fullfile(data_path,'GLM','VOI_V2_1.mat '),[2 1 1],'V2xNoAtt',0);

PPI2ATT = spm_peb_ppi(fullfile(data_path,'GLM','SPM.mat'),'ppi',...
    fullfile(data_path,'GLM','VOI_V2_1.mat '),[3 1 1],'V2xAtt',0);

PPI5NATT = spm_peb_ppi(fullfile(data_path,'GLM','SPM.mat'),'ppi',...
    fullfile(data_path,'GLM','VOI_V5_1.mat '),[2 1 1],'V5xNoAtt',0);

PPI5ATT = spm_peb_ppi(fullfile(data_path,'GLM','SPM.mat'),'ppi',...
    fullfile(data_path,'GLM','VOI_V5_1.mat '),[3 1 1],'V5xAtt',0);


% PLOT THE PPI INTERACTION VECTORS UNDER EACH ATTENTIONAL CONDITION.
%=====================================================================
figure;
plot(PPI2NATT.ppi,PPI5NATT.ppi,'k.');
hold on
plot(PPI2ATT.ppi,PPI5ATT.ppi,'r.');

% BEST FIT LINES
% NO ATTENTION
%---------------------------------------------------------------------
x = PPI2NATT.ppi(:);
x = [x, ones(size(x))];
y = PPI5NATT.ppi(:);
B = x\y;
y1 = B(1)*x(:,1)+B(2);
plot(x(:,1),y1,'k-');

% ATTENTION
%---------------------------------------------------------------------
x = PPI2ATT.ppi(:);
x = [x, ones(size(x))];
y = PPI5ATT.ppi(:);
B = x\y;
y1 = B(1)*x(:,1)+B(2);
plot(x(:,1),y1,'r-');

legend('No Attention','Attention')
xlabel('V2 activity')
ylabel('V5 response')
title('Psychophysiologic Interaction')
