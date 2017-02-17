function [regfile name columns] = create_resp_regressor( logfile, nvol, nslices, TR, outdir )

% adapted to create respiration regressor 

% Note:
% - This is the input script to the PhysIO toolbox. Only this file has to be adapted for your study.
% - For documentation of any of the defined substructures here, please
% see also tapas_physio_new.m or the Manual_PhysIO-file.
%
% Copyright (C) 2013, Institute for Biomedical Engineering, ETH/Uni Zurich.
%
% This file is part of the PhysIO toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.
%
% $Id: main_ECG3T.m 407 2014-01-17 17:09:27Z kasperla $
%
%% 0. Put code directory into path; for some options, SPM should also be in the path

if ~exist( 'tapas_physio_new' )
    pathRETROICORcode = '/dados1/PROJETOS/PRJ1210_EMOCODE/03_PROCS/ENCODING_SCRIPTS/Physiologic/tapas_r534/tapas/PhysIO/code';
    addpath(genpath(pathRETROICORcode));
end
    
    regfile = fullfile( outdir, 'reg_resp.txt' );
    if exist( regfile, 'file' )
        R = load( regfile );
        name = 'RESP';
        columns = size(R,2);
        return
    end
    
        
        physio      = tapas_physio_new();         % create structure, numbering according to *PhysIO_PhysNoiseBackground.pptx
        log_files   = physio.log_files;     % 1a) Read logfiles
        sqpar       = physio.sqpar;         % 1b) Sequence timing
        thresh      = physio.thresh;        % 2) Preprocess phys & align scan-timing
        model       = physio.model;         % 3)/4) Model physiological time series
        verbose     = physio.verbose;       % Auxiliary: Output
        
        
        %% 1. Define Input Files
        
        log_files.vendor            = 'Philips';
        
        log_files.cardiac           = '';
        log_files.respiration       = logfile;
        
        
        %% 2. Define Nominal Sequence Parameter (Scan Timing)
        
        sqpar.Nslices           = nslices;
        sqpar.NslicesPerBeat    = nslices;
        sqpar.TR                = TR;
        sqpar.Ndummies          = 0;
        sqpar.Nscans            = nvol;
        sqpar.onset_slice       = sqpar.Nslices/2;
        sqpar.Nprep             = []; % set to >=0 to count scans and dummy
        % volumes from beginning of run, i.e. logfile,
        % includes counting of preparation gradients
        sqpar.TimeSliceToSlice  = sqpar.TR / sqpar.Nslices;
        sqpar.PtsSliceToSlice   = sqpar.TR * 500 / sqpar.Nslices ; 
        
        
        %% 3. Define Gradient Thresholds to Infer Gradient Timing (Philips only)
        % 3.1. Determine volume start solely by marking every Nslices-th scan slice
        % event as volume event
        
        use_gradient_log_for_timing = true; % true or false
        
        if use_gradient_log_for_timing
            thresh.scan_timing.grad_direction = 'z';
            %     thresh.scan_timing.zero         = 1700;
            %     thresh.scan_timing.slice        = 1800;
            thresh.scan_timing.zero         = 950;
            thresh.scan_timing.slice        = 1000;
            thresh.scan_timing.vol          = [];   % leave [], if unused; set value >=.slice,
            % if volume start gradients are higher than slice gradients
            thresh.scan_timing.vol_spacing  = [];   % leave [], if unused; set to e.g. 50e-3 (seconds),
            % if there is a time gap between last slice of a volume
            % and first slice of the next
        else
            thresh.scan_timing = [];
        end
        
        
        %% 4. Define which Cardiac Data Shall be Used
        
        thresh.cardiac.modality = 'ECG';
        thresh.cardiac.initial_cpulse_select.method = 'load_from_logfile';
        thresh.cardiac.posthoc_cpulse_select.method = 'manual';
        
        
        %% 5. Order of RETROICOR-expansions for cardiac, respiratory and
        %% interaction terms. Option to orthogonalise regressors
        
        %model.type = 'RETROICOR';
        model.type = 'RETROICOR_RVT';
        model.order = struct('c',0,'r',4,'cr',0, 'orthogonalise', 'none');
        model.input_other_multiple_regressors = []; % either .txt-file or .mat-file (saves variable R)
        
        regfile = fullfile( outdir, 'reg_resp.txt' );
        
        model.output_multiple_regressors =  regfile;
        %    model.input_other_multiple_regressors = files{fs,2}; % either .txt-file or .mat-file (saves variable R)
        %    model.output_multiple_regressors = [files{fs,1}(1:4) '_' model.type '_' files{fs,2}];
        
        
        %% 6. Output Figures to be generated
        
        verbose.level           = 3; % 0 = none; 1 = main plots (default);  2 = debugging plots, for setting up new study; 3 = all plots
        verbose.fig_output_file = 'PhysIO_output_level2.fig'; % Physio.tiff, .ps, .fig possible
        
        
        %% 7. Run the main script with defined parameters
        
        physio.log_files    = log_files;
        physio.thresh       = thresh;
        physio.sqpar        = sqpar;
        physio.model        = model;
        physio.verbose      = verbose;
        
        [physio_out, R, ons_secs] = tapas_physio_main_create_regressors(physio);
        
        %% copy plots and save data variable
        if ~isdir(outdir), mkdir(outdir), end;
        save( fullfile( outdir, 'PHYSIO.mat' ), 'physio_out' );
        
        name = 'RESP';
        columns = size(R,2);
       
end