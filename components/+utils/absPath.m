function [ paths ] = absPath( varargin )
%ABSPATH - returns the absolute path of a file
%  How use: absPath( pattern, params, limit )
%  Params needs to be a struct with the fields matching to the pattern
%  templates 
%
%  Example:
%    absPath( '/{subjid}/RUN1/*.nii', params, 100 );

import utils.*;

paths = {};

pat = Var.pos( varargin, 1 );
params = Var.pos( varargin, 2, struct() );
limit = Var.pos( varargin, 3 );

[stat,files] = fileattrib( pat );
if( stat )
    if( isempty(limit) || limit > length(files) )
        limit = length(files);
    end
    paths = { files(1:limit).Name };
    %% @todo: Aplicar params nos caminhos
end

end