function display(dep)

% function display(dep)
% Display a configuration dependency
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id$

rev = '$Rev$'; %#ok

disp(' ');
disp([inputname(1),' = ']);
disp(' ');
disp(dep);
disp(' ');
