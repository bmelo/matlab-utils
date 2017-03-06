classdef Generic < handle
    %GENERIC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function params = toStruct(obj)
            props = properties(obj);
            for k=1:length(props)
                params.(props{k}) = obj.(props{k});
            end
        end
    end
    
end

