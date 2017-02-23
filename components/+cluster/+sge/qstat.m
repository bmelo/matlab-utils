function out = qstat( varargin )
%QSTAT Summary of this function goes here
%   Detailed explanation goes here

% When the user only want information about one job
if( nargin == 1 && utils.isnum(varargin{1}) )
    job = cluster.sge.jobInfoFull(varargin{1});
    out = job;
    return;
end

%Executa o comando e trata se exibe ou retorna output
params = sprintf( '%s ', varargin{:} );
[~,output] = system(['qstat ' params]);
if( nargout > 0 )
    out = output;
else
    disp(output);
end

end