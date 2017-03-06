% Extraction of Percent signal change using marsbar and SPM8: BATCH.
% The file structures are in this script are in Mac OS X format.
% PC users should find all the '/' in the script and replace with '\'.
% Also make sure your directory works in MATLAB as '/Volumes/Disk/Data'
% works on Mac where as 'C:\Data\' is a typical PC configuration.
% This script assumes you have a first level fMRI design which has been
% estimated in SPM, and has a set of contrasts specified.
% This script assumes your design is stored in /my/path/SPM.mat and you
% have an ROI stored in /my/path/my_roi.mat.
% The only four things you will hopefully need to change are:
% (1) the data root directory (a folder that contains all the participant subfolders);
% (2) the names of the participant subfolders; and,
% (3) the ROI you have created in marsbar.
% (4) the file name and type to which you want your percent signal change values to be saved.
% These are indicated below. See (5) if the script doesn't use all the
% contrasts available.
% The output file is saved as a single row and is comma delimited,
% so all you need to do is delete the first item (the title) that is delimited by a comma,
% insert a return before each of the 'sub' IDs (participant subfolders) so that each
% participants' data is on a new row, and then save the file.
% The final step is to import the data into Excel. File > Import... > Text
% file > Choose your file > Delimited Start import at row 1 > Delimiters
% tick comma > Finish > OK. The first column should be the participant subfolder
% and the last column should be '/n'. As Excel may find the values with minus signs
% as a formula, just Find All '=' and replace with nothing, and while you are at it
% do the '/n' as well.

%(1) Directories:
curdir = pwd;
data_dir = '';
rois_dir = '';
out_dir  = '';

%(2) the names of the participant subfolders
subjs = [2:16 18:26 28];
nsub = length(subjs);

%(3) the ROI you have created in marsbar. You can put multiple ROIs in
%here, but I thought it was easier to put in one at a time as the output is
%messy as is.
roi_files = {'Main_Effect_sphere5mm--3_53_-13_roi'};
%roi_files = {'Occipital_9_-85_-7_roi'};
n_roi = size (roi_files,1);
pcs_data = zeros(length(subjs),1);

spm('Defaults', 'fmri')

% global defaults
for n = 1: n_roi
    fprintf( 'loading ROI %s\n', roi_files{n} );
    roi_file = fullfile( rois_dir, roi_files{n} );
    load( roi_file );
    
    % pcs_data = [];
    for k = 1:length(subjs)
        subjid = sprintf('SUBJ%03d', subjs(k));
        subdir = fullfile( data_dir, subjid );
        sprintf('Working on participant %s\n',subdir)
        cd(subdir);
        load SPM;
        % Make marsbar design object
        D = mardo(SPM);
        % Make marsbar ROI object
        R = maroi( roi_file );
        % Fetch data into marsbar data object
        Y = get_marsy(R, D, 'mean');
        % Get contrasts from original design
        xCon = get_contrasts(D);
        % Estimate design on ROI data
        E = estimate(D, Y);
        % Put contrasts from original design back into design object
        E = set_contrasts(E, xCon);
        % get design betas
        % b = betas(E);
        % get stats and stuff for all contrasts into statistics structure
        % (5) I edited this so stop at the basic contrasts for the events
        % as the script didn't work for me with my design otherwise.
        % The original script had: marsS = compute_contrasts(E, 1:length(xCon));
        % marsS = compute_contrasts(E, 1:4);
        % Get definitions of all events in model
        [e_specs, e_names] = event_specs(E);
        n_events = size(e_specs, 2);
        dur = 6.5;
        pct_ev = [];
        % Return percent signal esimate for all events in design
        for e_s = 1:n_events
            pct_ev(e_s) = event_signal(E, e_specs(:,e_s), dur);
        end
        %Aloca memoria para as matrizes
        if( k==1 )
            pcs_data = zeros(length(subjs), n_events);
            nEvtS = max(e_specs(2,:)); %number of events per session
            pcs_data_mean = zeros(length(subjs), nEvtS);
        end
        pcs_data(k,:) = pct_ev;
        pcs_data_mean(k,:) = mean( reshape( pct_ev, nEvtS, [] )' );
        
        
        %% FIR timecourses per session
        % Get definitions of all events in model
      %  [e_specs, e_names] = event_specs(E);
      %  n_events = size(e_specs, 2);
        % Bin size in seconds for FIR
      %  bin_size = tr(E);
        % Length of FIR in seconds
       % fir_length = 24;
        % Number of FIR time bins to cover length of FIR
      %  bin_no = fir_length / bin_size;
        % Options - here 'single' FIR model, return estimated
       % opts = struct('single', 1, 'percent', 1);
        % Return time courses for all events in fir_tc matrix
        %for e_s = 1:n_events
         %   fir_tc(:, e_s) = event_fitted_fir(E, e_specs(:,e_s), bin_size, ...
          %      bin_no, opts);
       % end
        
        %% FIR timecourses across session
        % Get compound event types structure
        %ets = event_types_named(E);
       % n_event_types = length(ets);
        % Bin size in seconds for FIR
        %bin_size = tr(E);
        % Length of FIR in seconds
       % fir_length = 24;
        % Number of FIR time bins to cover length of FIR
      %  bin_no = fir_length / bin_size;
        % Options - here 'single' FIR model, return estimated % signal change
     %   opts = struct('single', 1, 'percent', 1);
    %    for e_t = 1:n_event_types
     %       fir_tc_subject(:, e_t,k) = event_fitted_fir(E, ets(e_t).e_spec, bin_size, ...
      %          bin_no, opts);
    %    end


    end
    
    %fir_tc_ss_mean = squeeze( mean( fir_tc_subject, 3 ) );
    %fir_tc_ss_std  = squeeze( std( fir_tc_subject, 0, 3 ) );
    
    %x = [0:bin_size:fir_length-bin_size];
    
    %figure, plot( x, fir_tc_ss_mean ), xlabel( 'time (s)' ), ylabel( '% signal change'), title( roi_files{n}  ), legend( {ets.name} )

    %figure, 
    %cc=hsv(12);
    %for e_t = 1:n_event_types
    %    errorbar(x, fir_tc_ss_mean(:,e_t), fir_tc_ss_std(:,e_t), 'color',cc(e_t,:) );
    %    hold on,
    %end
    %xlabel( 'time (s)' ), ylabel( '% signal change'), title( roi_files{n}  )
    
    %out.fir_tc_ss_mean = fir_tc_ss_mean;
    %out.fir_tc_ss_std = fir_tc_ss_std;
    %out.fir_tc_subject = fir_tc_subject;
    %out.subjs = subjs;
    %out.ets = ets;
    %out.roi_file = roi_files{n};
    
    %save( fullfile(out_dir, ['timecourses_PSC_' out.roi_files{n} '_' datestr(now, 'yyyymmdd_HHMM') '.mat']), 'out' );
    
   % regname=char(SPM.xX.name(1,:));

    % (4) the file name (e.g., ROI co-ords) and type (e.g., .txt, .csv, .xls) to which you want your
    % percent signal change values to be saved.
    % regname = char (e_names);
    fvolumes = fopen( fullfile(out_dir, ['out_PSC' datestr(now, 'yyyymmdd_HHMM') '.txt']), 'w');
    fprintf( fvolumes, 'ROI =\t%s\n\n', roi_files{n} );
    fprintf( fvolumes, 'SUBJ x Eventos\t' );
    for nname=1:n_events
        nS = e_specs(1,nname);%numero da sessao
        fprintf(fvolumes, '%s (%d)\t',e_names{nname}, nS);
    end
    
    for nsub=1:length(subjs)
        subjid = sprintf('SUBJ%03d', nsub);
        fprintf( fvolumes, '\n%s\t', subjid );
        fprintf( fvolumes, '%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t', pcs_data(nsub,:));
    end;
    
    %Valores com as médias.
    fprintf( fvolumes, '\n\nMÉDIAS\n' );
    fprintf( fvolumes, 'SUBJ x Eventos\t' );
    for nname=1:n_events
        nS = e_specs(1,nname);%numero da sessao
        if ( nS > 1 ); break; end;
        fprintf(fvolumes, '%s\t',e_names{nname});
    end
    
    for nsub=1:length( subjs )
        subjid = sprintf('SUBJ%03d', nsub);
        fprintf( fvolumes, '\n%s\t', subjid );
        fprintf( fvolumes, '%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t', pcs_data_mean(nsub,:));
    end;
    
    fclose('all');
end
cd(curdir);