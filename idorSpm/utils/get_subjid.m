function [ subjid ] = get_subjid( config, nS, treat )
import idor.utils.Var;

if ~exist('treat', 'var'); treat = true; end;

%GET_SUBJID returns the right name for the subj
if isnumeric(nS)
    name_subj = sprintf( '%s%03i', config.subj_prefix, nS );
else
    name_subj = nS{1};
    treat = 0;
end

sdirs = dir( fullfile( config.raw_base, [name_subj '*']) );
if ~treat || Var.get(config, 'subjid_complete', false)
    subjid = sdirs(1).name;
elseif iscell( Var.get(config, 'subjs_labels', false) )
    pos = config.subjs == nS;
    subjid = config.subjs_labels{pos};
elseif iscell( Var.get(config, 'subjs', false) )
    subjid = config.subjs{nS};
else
    subjid = name_subj;
end

end

