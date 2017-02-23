function out = qstat( varargin )
%QSTAT Summary of this function goes here
%   Detailed explanation goes here
import cluster.sge.*
output = qstat( varargin{:} );

if( nargout > 0 )
    out = output;
else
    disp(output);
end

end

