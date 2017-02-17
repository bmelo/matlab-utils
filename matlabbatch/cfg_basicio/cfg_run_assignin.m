function cfg_run_assignin(job)

% Assign the value of job.output to a workspace variable job.name.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id$

rev = '$Rev$'; %#ok

% check for existence of variable
vars = evalin('base','feval(@who);');
% generate new name
name = genvarname(job.name, vars);
assignin('base', name, job.output);
