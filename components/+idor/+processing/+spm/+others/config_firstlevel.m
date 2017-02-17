% def structure with following fields:
% pres_type: type name of event
% pres_codes: list of numerical codes that define a condition in SPM
% spm_termination_codes: list of numerical codes that defines the end
% of the condition in SPM, i.e. the duration will be calculated between
% events
% spm_termination_types: list of types
% spm_name: name of condition in SPM
% spm_fix_duration: duration of event (equal for all matched events), if
% left empty, and spm_termination_codes is not defined or empty, duration
% will be set to zero
% spm_pmod: list of values for parametric modulation matching the list of
% pres_codes

clear def;

categories = { 'cueA', 'cueB' };
spm_names  = { 'cueA', 'cueB' };
durations  = [ 6 , 6 ];

for k=1:length( categories )
    
    def(k).pres_type = 'Picture';
    def(k).pres_codes = { categories{k} };
    def(k).pres_termination_codes = [];
    def(k).pres_termination_types = [];
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = durations(k);
    def(k).spm_pmod = '';
end

ind = length(def)+1;

def(ind).pres_type = 'Response';
def(ind).pres_codes = { 1, 2 };
def(ind).pres_termination_codes = [];
def(ind).pres_termination_types = [];
def(ind).spm_name = 'MOTOR';
def(ind).spm_fix_duration = 0;
def(ind).spm_pmod = '';

ind = length(def)+1;

model_name = 'CUE_MOTOR';

%% transform
if isunix
    logdir = '/dados1/PROJETOS/PRJ1403_UMBRELLA_TDAH/03_PROCS/LOG_FILES/RM/';
else    
    logdir = 'Z:\PRJ1403_UMBRELLA_TDAH\03_PROCS\LOG_FILES\RM';
end

logfiles = { ...
    'SUBJ001-Run1.log', ...
    'SUBJ001-Run2.log', ...
    'SUBJ001-Run3.log', ...
    };

for f=1:length(logfiles)

    logfile = logfiles{f};
    
    conditions = log_to_condition( fullfile(logdir, logfile), def )

    names = conditions.names;
    onsets = conditions.onsets;
    durations = conditions.durations;

    if isfield( conditions, 'pmod' )
        pmod = conditions.pmod;
    else
        pmod = struct( 'name', {''}, 'param', {}, 'poly', {} ); 
    end

    [a b] = fileparts( logdir );
    design_dir = fullfile( a, 'SPM_DESIGNS' );  
    if ~isdir( design_dir ), mkdir( design_dir ), end

    save( fullfile( design_dir, [logfile(1:end-4) '_' model_name '_conditions.mat']), 'names', 'onsets', 'durations', 'pmod' );

    %%
    sessions(f).names = names;
    sessions(f).onsets = onsets;
    sessions(f).durations = durations;
    
    
end

spec_dir = design_dir;
num_scans = 290;

design_only_template
% design_template

save( fullfile( design_dir, [logfile(1:end-4) '_' model_name '_design.mat']), 'matlabbatch' );
