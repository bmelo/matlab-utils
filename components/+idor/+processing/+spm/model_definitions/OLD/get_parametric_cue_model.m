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
function model = get_parametric_cue_model()

    categories = { 'cue.*FLA', 'cue.*STI' ,'cue.*SELF', 'cueEFFORTONLY' 'ClipFla.*', 'ClipAvai.*'  };
    spm_names  = { 'FLA', 'STI' ,'SELF' , 'CUE EFFORT', 'CLIP FLA', 'CLIP AVAI' };

    for k=1:length( categories )-2

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = 1.5;
        def(k).spm_pmod.name = @get_force_of_trial;
        def(k).spm_pmod.str = 'maxforceblock:';
    end

     for k=length(categories)-1:length(categories)
        def(k).pres_type = 'Video';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = { 'fixposclip' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = [];
        def(k).spm_pmod = '';
    end
    
    
    model.name = 'PARAM_CUE';
    model.def  = def;
    
    ci = 1;
    model.contrast(ci).vec  = [ 1 0 -1 0 0 0];
    model.contrast(ci).name = 'CUE FLA > CUE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 0 1 0 0 0];
    model.contrast(ci).name = 'CUE STI > CUE FLA';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 1 0 0 0 -1 0];
    model.contrast(ci).name = 'CUE FLA > CUE SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ -1 0 0 0 1 0];
    model.contrast(ci).name = 'CUE SELF > CUE FLA';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 1 0 -1 0];
    model.contrast(ci).name = 'CUE STI > CUE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 -1 0 1 0];
    model.contrast(ci).name = 'CUE SELF > CUE STI';
    
    %% contrastes com baseline
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 0 0 0 -1 0];
    model.contrast(ci).name = 'CUE FLA > CUE EFFORT';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 -1 0];
    model.contrast(ci).name = 'CUE STI > CUE EFFORT';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 1 0 -1 0];
    model.contrast(ci).name = 'CUE SELF > CUE EFFORT';
    
     %% videos
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,8) 1 0 ];
    model.contrast(ci).name = 'VIDEO FLA';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,8) 0 1];
    model.contrast(ci).name = 'VIDEO AVAI';
    

    model.regressor_function_handle = '';

end