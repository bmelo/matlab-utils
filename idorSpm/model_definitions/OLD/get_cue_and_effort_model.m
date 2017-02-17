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
function model = get_cue_and_effort_model()

    categories = { 'cueFLA', 'cueSTI' ,'cueSELF', 'cueCUEONLY_FLA', 'cueCUEONLY_STI' ,'cueCUEONLY_SELF', 'cueEFFORTONLY'};
    spm_names  = { 'FLA', 'STI' ,'SELF', 'CUEONLY_FLA', 'CUEONLY_STI' ,'CUEONLY_SELF', 'EFFORT_ONLY' };
    durations  = [];

    for k=1:length( categories )

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [];
        def(k).pres_termination_types = [];
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = 4.5;
        def(k).spm_pmod = '';
    end

    ind = length(def)+1;

    model.name = 'CUE_AND_EFFORT';
    model.def  = def;
    
    ci = 1;
    model.contrast(ci).vec  = [ 1 -1 0 ];
    model.contrast(ci).name = 'CUE FLA > CUE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 1 0];
    model.contrast(ci).name = 'CUE STI > CUE FLA';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 1 0 -1];
    model.contrast(ci).name = 'CUE FLA > CUE SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ -1 0 1];
    model.contrast(ci).name = 'CUE SELF > CUE FLA';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 -1];
    model.contrast(ci).name = 'CUE STI > CUE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 1];
    model.contrast(ci).name = 'CUE SELF > CUE STI';
    
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1];
    model.contrast(ci).name = 'MOTOR';
    
    model.regressor_function_handle = '';
end