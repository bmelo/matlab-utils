classdef Var < utils.Generic
    %VAR Helper to manipulate variables
    %   This class has methods to be used in variables
    
    methods (Static = true)
		% Function from http://www.mathworks.com/matlabcentral/fileexchange/7842-catstruct
        A = catstruct(varargin);
		
        % Convert varargin passed in pairs to struct.
        function stArgs = argin2struct( args )
            stArgs = struct();
            nArgs = length( args );
            for k=nArgs:-2:1
                stArgs.( args{k-1} ) = args{k};
            end
        end
        
        function value = pos( varargin )
            var = varargin{1};
            pos = varargin{2};
            value = [];
            %Default values
            if nargin == 3
                value = varargin{3};
            end;
            
            %Return the value in the position
            if pos <= length(var)
                value = var{pos};
            end
        end
        
        %Generate struct mapping names and values
        function out = mapNames( names, values, mapfunc )
            nV = length(values); %Number of values to map
            for k=1:length(names)
                if( k > nV )
                    value = [];
                else
                    value = values{k};
                    if( exist('mapfunc', 'var')  ) %Apply function in variable
                        value = mapfunc(value);
                    end
                end
                out.(names{k}) = value;
            end
        end
        
        % Return value of struct or default value
        function value = get( struct, field, default )
            if nargin<3, default = false; end;
            if( isstruct(struct) && isfield( struct, field ) )
                value = struct.(field);
            else
                value = default;
            end
        end
        
        % Return value of struct or default value
        function value = arg_exist( args, field )         
            pos = find(strcmp(field,args));
            
            value = false;
            if ~isempty(pos)
                value = pos(1);
            end
        end
        
    end
    
end

