function [fnames, defaults] = mysubs_fields

% function [fnames, defaults] = mysubs_fields
% Additional fields for class cfg_files. See help of
% @cfg_item/subs_fields for general help about this function.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id$

rev = '$Rev$'; %#ok

fnames = {'filter','num','dir','ufilter'};
defaults = {'any',[0 Inf],'','.*'};