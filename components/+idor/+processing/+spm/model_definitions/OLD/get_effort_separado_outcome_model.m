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
function model = get_effort_separado_outcome_model()

    categories = { 'rewardFLA', 'rewardSTI' ,'rewardSELF', 'rewardEFFORTONLYFLA', 'rewardEFFORTONLYSTI', 'rewardEFFORTONLYSELF', ...
                   'rewardCUEONLY_FLA', 'rewardCUEONLY_STI', 'rewardCUEONLY_SELF', 'squeeze', 'ClipFla.*', 'ClipAvai.*' };
    spm_names  = { 'OUTCOME TEAM', 'OUTCOME STI' ,'OUTCOME SELF', 'OUTCOME EFFORT TEAM', 'OUTCOME EFFORT STI','OUTCOME EFFORT SELF','OUTCOME CUEONLY TEAM', 'OUTCOME CUEONLY STI', 'OUTCOME CUEONLY SELF',  'SQUEEZE', 'CLIP TEAM', 'CLIP AVAI' };
    durations = [ 2*ones(1,9) ];
    
    for k=1:length( categories )-3

        def(k).pres_type = 'Picture';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = durations(k);
        def(k).spm_pmod = '';
    end
    
    k = length( categories )-2;

    def(k).pres_type = 'Picture';
    def(k).pres_codes = { categories{k} };
    def(k).pres_termination_codes = [] ; % { 'squeeze.*' };
    def(k).pres_termination_types = { 'Picture' };
    def(k).spm_name = spm_names{k};
    def(k).spm_fix_duration = 3;
    def(k).spm_pmod = '';


    for k=length( categories )-1:length( categories )
        def(k).pres_type = 'Video';
        def(k).pres_codes = { categories{k} };
        def(k).pres_termination_codes = { 'fixposclip' };
        def(k).pres_termination_types = { 'Picture' };
        def(k).spm_name = spm_names{k};
        def(k).spm_fix_duration = [];
        def(k).spm_pmod = '';
    end
    
    

    model.name = 'EFFORT_SEP_OUTCOME';
    model.def  = def;
    
    %% contrastes entre condicoes
    ci = 1;
    model.contrast(ci).vec  = [ 1 -1 0 -1 1 0];
    model.contrast(ci).name = 'OUTCOME TEAM > OUTCOME STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ -1 1 0 1 -1 0];
    model.contrast(ci).name = 'OUTCOME STI > OUTCOME TEAM';
    
    ci= ci+1;
       
    model.contrast(ci).vec  = [ 1 0 -1 -1 0 1];
    model.contrast(ci).name = 'OUTCOME TEAM > OUTCOME SELF';

    ci= ci+1;
       
    model.contrast(ci).vec  = [ -1 0 1 1 0 -1];
    model.contrast(ci).name = 'OUTCOME SELF > OUTCOME TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 -1 0 -1 1];
    model.contrast(ci).name = 'OUTCOME STI > OUTCOME SELF';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 -1 1 0 1 -1];
    model.contrast(ci).name = 'OUTCOME SELF > OUTCOME STI';
    
    %% contrastes com baseline esforco
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 -1];
    model.contrast(ci).name = 'OUTCOME TEAM > OUTCOME EFFORT TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 0 -1];
    model.contrast(ci).name = 'OUTCOME STI > OUTCOME EFFORT STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 -1];
    model.contrast(ci).name = 'OUTCOME SELF > OUTCOME EFFORT SELF';


    %% contrastes com baseline sem esforco
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'OUTCOME TEAM > CUEONLY TEAM';

    ci = ci+1;
    model.contrast(ci).vec  = [ 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'OUTCOME STI > CUEONLY STI';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ 0 0 1 0 0 0 0 0 -1];
    model.contrast(ci).name = 'OUTCOME SELF > CUEONLY SELF';
    
    %% videos
    ci = ci+1;
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 1 0 ];
    model.contrast(ci).name = 'VIDEO TEAM';
    
    ci= ci+1;
    
    model.contrast(ci).vec  = [ zeros(1,length(categories)-2) 0 1];
    model.contrast(ci).name = 'VIDEO AVAI';

    model.regressor_function_handle = '';

end