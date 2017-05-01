function run(scriptname)
%RUN Run script.
%   Typically, you just type the name of a script at the prompt to
%   execute it. This works when the script is on your path.  Use CD
%   or ADDPATH to make the script executable from the prompt.
%
%   RUN is a convenience function that runs scripts that are not
%   currently on the path.
%
%   RUN SCRIPTNAME runs the specified script. If SCRIPTNAME contains
%   the full pathname to the script, then RUN changes the current
%   directory to where the script lives, executes the script, and then
%   changes back to the original starting point. The script is run
%   within the caller's workspace.
%

%   NOTES:
%     * If SCRIPTNAME attempts to CD into its own folder, RUN cannot detect
%       this change. In this case, RUN will revert to the starting folder
%       on exit.
%     * If SCRIPTNAME is a MATLAB file and there is a P-file in the same
%       folder, RUN silently executes the P-file.
%
%   See also CD, ADDPATH.

%   Copyright 1984-2014 The MathWorks, Inc.

if isempty(scriptname)
    return;
end
if ispc
    scriptname = strrep(scriptname,'/','\');
end

[fileDir,script,~] = fileparts(scriptname);
startDir = pwd;

% Finally, evaluate the script if it exists and isn't a shadowed script.
cd(fileDir);
evalin('caller', [script ';']);
cd(startDir);

end
