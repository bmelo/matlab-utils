function sitem = cfg2struct(item)

% function sitem = cfg2struct(item)
% Return a struct containing all fields of item plus a field type. This is
% the method suitable for cfg_choice and repeat classes. It descends down
% the values field to convert the cfg_items in this field into structs.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id$

rev = '$Rev$'; %#ok

% Get parent struct, re-classify as field 'type'
sitem = cfg2struct(item.cfg_item);
sitem.type = class(item);

% Need to cycle through added fields
fn = mysubs_fields;
for k = 1:numel(fn)
    sitem.(fn{k}) = item.(fn{k});
end;

% Treat values{:} fields
if numel(item.values) > 0
    for k = 1:numel(item.values)
        sitem.values{k} = cfg2struct(item.values{k});
    end;
end;
