function [ obj ] = convert_object( jobj )
%CONVERT_OBJECT Automatic convrt java types to MATLAB types
%    Following https://www.mathworks.com/help/matlab/matlab_external/handling-data-returned-from-java-methods.html

if ~isjava(jobj)
    obj = jobj;
    return
end

className = class(jobj);
switch( className)
    case {'java.lang.String', 'java.lang.StringBuffer', 'java.lang.Character'}
        obj = char(jobj);
    case 'java.lang.Boolean'
        obj = logical(jobj);
    case {'java.lang.Byte', 'java.lang.Short', 'java.lang.Integer', 'java.lang.Long', 'java.lang.Float', 'java.lang.Double'}
        obj = double(jobj);
    otherwise
        if regexp(className, '\[\]$') > 0
            obj = cell(jobj);
        else
            % For other cases, try to create a struct
            try
                obj = struct();
                newobj = struct(jobj);
                fs = fields(newobj);
                for n = 1:length(fs)
                    val = newobj.(fs{n});
                    obj.(fs{n}) = utils.java.convert_object( val );
                end
            catch
                obj = jobj;
            end
        end
end

end

