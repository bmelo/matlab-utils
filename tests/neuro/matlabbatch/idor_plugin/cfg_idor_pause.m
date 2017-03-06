function pauseIdor = cfg_idor_pause
%{
% Author: Bruno Melo (bruno.raphael@gmail.com)
% Institution: D'Or Institute for Research and Education (IDOR)
% Site: www.idor.org
% License: Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0) 
% Date: 21-dec-2012
%}

rev = '$Rev$'; %#ok

%% Input Items


%% Executable Branch
pauseIdor      = cfg_exbranch;       % This is the branch that has information about how to run this module
pauseIdor.name = 'Pause';             % The display name
pauseIdor.tag  = 'cfg_idor_pause'; % The name appearing in the harvested job structure. This name must be unique among all items in the val field of the superior node
pauseIdor.val  = {};    % The items that belong to this branch. All items must be filled before this branch can run or produce virtual outputs
pauseIdor.prog = @cfg_idor_run_pausar;  % A function handle that will be called with the harvested job to run the computation
pauseIdor.help = {'Pause execution and wait for a ENTER input to continue.'};

%% Local Functions
function out = cfg_idor_run_pausar(job)
out = input('<Press ENTER to continue>');