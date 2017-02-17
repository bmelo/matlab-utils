function [ job ] = jobInfoFull( jobid )
%EXTRACTJOBINFO Summary of this function goes here
%   Detailed explanation goes here

[~, data] = system( ['qacct -j ' num2str(jobid)] );
params = regexp( data, '\n(?<name>\w+)\s+(?<value>[^\n]+)', 'names');
job = idor.utils.Var.mapNames( {params.name}, {params.value}, @strtrim );

end

