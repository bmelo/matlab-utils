classdef Log < handle
    %LOG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Subject, Trial, EventType, Code, Time, TTime, def, first_pulse, timereal;
    end
    
    methods
        %Construtor
        function obj = Log( logfile )
            obj.treatFile( logfile );
        end
        
        %Abre arquivo e remove os dados para serem tratados
        function treatFile( obj, logfile)
            fid = fopen(logfile);
            ret = textscan(fid,'%s %s %s %s %f %f %*[^\n]','delimiter','\t','headerlines',5);
            fclose(fid);
            obj.Subject = ret{1};
            obj.Trial = ret{2};
            obj.EventType = ret{3};
            obj.Code = ret{4};
            obj.Time = ret{5};
            obj.TTime = ret{6};
            % Uncertainty = ret{7};
            % Duration = ret{8};
            % Uncertainty = ret{9};
        end
    end
    
    methods (Static = true)
        function code_matches = get_matches( codes, Code )
            code_matches = ones(length(Code),1) == 0;
            for c=1:length(codes)
                %    code_matches = [code_matches | strcmp( num2str( codes{c} ), Code )];
                hit = ~cellfun( @isempty, regexp( Code, num2str( codes{c} ) ) );
                code_matches = code_matches | hit;
            end
            
        end
        
        function code_matches = get_matches_separate( codes, Code )
            code_matches = cell(1,length(codes));
            for c=1:length(codes)
                %    code_matches{c} = strcmp( num2str( codes{c} ), Code );
                code_matches{c}  = ~cellfun( @isempty, regexp( Code, num2str( codes{c} ) ) );
            end
            
        end
    end
    
end

