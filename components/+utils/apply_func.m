function [ output_args ] = apply_func( fhandle, args )
%APPLY_FUNC Function to simplify function_handle use
%   Attempt to facilitate manipulation of parameters passed to function_handles

[output_args] = fhandle(args{:});

end

