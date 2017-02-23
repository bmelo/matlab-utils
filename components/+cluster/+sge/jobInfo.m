function [ job ] = jobInfo( jobid )
%EXTRACTJOBINFO Summary of this function goes here
%   Detailed explanation goes here

names = {'id', 'prior', 'name', 'user', 'state', 'start', 'queue slots', 'task-id'};
job = struct();
list = qstat('-s az');
pat = ['\s+' num2str(jobid) '\s[^\n]+'];
lineJob = regexp( list, pat, 'match');
if( isempty( lineJob ) ), return; end % Nothing to do
params = regexp( strtrim(lineJob), '\s*', 'split');
job = idor.utils.Var.mapNames( names, params{1} );

switch job.state
    case 'qw', job.state = 'Finished';
    case 'r', job.state = 'Running';
    case 'p', job.state = 'Pending';
    case 's', job.state = 'Suspended';
end

end

