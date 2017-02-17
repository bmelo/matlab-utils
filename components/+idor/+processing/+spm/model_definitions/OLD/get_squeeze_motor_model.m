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
function model = get_squeeze_motor_model()

    categories = { 'squeezeFLA', 'squeezeSTI' ,'squeezeSELF', 'squeezeEFFORTONLY', 'squeezeCUEONLY_FLA', 'squeezeCUEONLY_STI', 'squeezeCUEONLY_SELF', 'ClipFla.*', 'ClipAvai.*' };
    spm_names  = { 'SQUEEZE FLA', 'SQUEEZE STI' ,'SQUEEZE SELF', 'SQUEEZE EFFORT', 'CUEONLY FLA', 'CUEONLY STI', 'CUEONLY SELF',  'CLIP FLA', 'CLIP AVAI' };
    durations = [ 3*ones(1,7) ];
    
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
    
    for k=length( categories )-1:length( categories )
        def(k).pres_type = 'Video';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = { 'fixposclip' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = [];
        def(k).spm_pmod = '';
    end
    
    

    model.name = 'SQUEEZE_MOTOR';
    model.def  = def;
    
    %% contrastes entre condicoes
    ci = 1;
    model.contrast(ci).vec  = [ 1 -1 0];
    model.contrast(ci).name = 'SQUEEZE FLA > SQUEEZE STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 1 0];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE FLA';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 1 0 -1];
    model.contrast(ci).name = 'SQUEEZE FLA > SQUEEZE SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ -1 0 1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE FLA';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 -1];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE STI';
    
    %% contrastes com baseline esforco
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE FLA > SQUEEZE EFFORT';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > SQUEEZE EFFORT';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > SQUEEZE EFFORT';


    %% contrastes com baseline sem esforco
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE FLA > CUEONLY FLA';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE STI > CUEONLY STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 -1];
    model.contrast(ci).name = 'SQUEEZE SELF > CUEONLY SELF';
    
    %% videos
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 1 0 ];
    model.contrast(ci).name = 'VIDEO FLA';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 0 1];
    model.contrast(ci).name = 'VIDEO AVAI';

    %% motor
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)) 1];
    model.contrast(ci).name = 'MOTOR';

    model.regressor_function_handle = @get_motor_data;

end