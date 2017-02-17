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
function model = get_motor_model()

    def = [];

    model.name = 'MOTOR_ONLY';
    model.def  = def;
    
    ci = 1;
    model.contrast(ci).vec  = [1];
    model.contrast(ci).name = 'MOTOR';
    
    model.regressor_function_handle = @get_motor_data;

end