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
function model = get_complete_model()

    categories = { 'cue.*FLA', 'cue.*STI' ,'cue.*SELF', 'cueEFFORTONLY', 'squeezeFLA', 'squeezeSTI', 'squeezeSELF', 'squeezeEFFORTONLY', 'squeezeCUEONLY_FLA', 'squeezeCUEONLY_STI', 'squeezeCUEONLY_SELF', 'ClipFla.*', 'ClipAvai.*' };
    spm_names  = { 'CUE FLA', 'CUE STI' ,'CUE SELF', 'CUE EFFORT', 'SQUEEZE FLA', 'SQUEEZE STI', 'SQUEEZE SELF', 'SQUEEZE EFFORT', 'CUEONLY FLA', 'CUEONLY STI', 'CUEONLY SELF',  'CLIP FLA', 'CLIP AVAI' };
    durations = [ 1.5*ones(1,4) , 3*ones(1,4+3) ];
    
    for k=1:length( categories )-2

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = durations(k);
        def(k).spm_pmod = '';
    end

    ind = length(def)+1;
    
    for k=12:13
        def(k).pres_type = 'Video';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = { 'fixposclip' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = [];
        def(k).spm_pmod = '';
    end
    
    

    model.name = 'COMPLETE';
    model.def  = def;
    
    %% contrastes entre condicoes
    ci = 1;
    model.contrast(ci).vec  = [ 1 -1 0];
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
    
    %% contrastes com baseline
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 -1];
    model.contrast(ci).name = 'CUE FLA > CUE EFFORT';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 -1];
    model.contrast(ci).name = 'CUE STI > CUE EFFORT';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 -1];
    model.contrast(ci).name = 'CUE SELF > CUE EFFORT';


    %% contrastes squeeze entre condicoes
    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 1 -1 0];
    model.contrast(ci).name = 'SQUEEZE FLA > SQUEEZE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 -1 1 0];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE FLA';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 0 0 0 0 1 0 -1];
    model.contrast(ci).name = 'SQUEEZE FLA > SQUEEZE SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ 0 0 0 0 -1 0 1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE FLA';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 1 -1];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 -1 1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE STI';
    
    %% contrastes com baseline "do esforco"
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 1 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE FLA > SQUEEZE EFFORT';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 1 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE EFFORT';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE EFFORT';

     %% contrastes com baseline "do simbolo"
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 1 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE FLA > CUEONLY FLA';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 0 0 0 0 1 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > CUEONLY STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 0 0 0 0 1 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > CUEONLY SELF';

    %% videos
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,11) 1 0 ];
    model.contrast(ci).name = 'VIDEO FLA';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,11) 0 1];
    model.contrast(ci).name = 'VIDEO AVAI';

    %% motor
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)) 1];
    model.contrast(ci).name = 'MOTOR';

    model.regressor_function_handle = @get_motor_data;

end