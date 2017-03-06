function cfg = cfg_idor
%{
% Author: Bruno Melo (bruno.raphael@gmail.com)
% Institution: D'Or Institute for Research and Education (IDOR)
% Site: www.idor.org
% License: Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0) 
% Date: 21-dec-2012
%}

rev = '$Rev$'; %#ok

%% Configure IDOR module
cfg        = cfg_repeat;
cfg.name   = 'IDOR';
cfg.tag    = 'cfg_idor';
cfg.values = {cfg_idor_pause}; % Items on menu IDOR
cfg.forcestruct = true;
cfg.help   = {'Tasks developed by D''Or Institute for Research and Education (IDOR).'};