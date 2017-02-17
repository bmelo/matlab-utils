classdef PRJPHANTOM < handle & ProjectSPM & PRJ1206
    properties
        %Atributos específicos do projeto
    end
    
    methods (Access = public)
        function obj=PRJPHANTOM()
            
            obj.numSessions = 1; %Quantidade de RUNs

            obj.baseDir = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_PHANTOM';
            obj.rawDir = 'C:\Documents and Settings\sebastian\Desktop\PRJ1206_PHANTOM\RAW_DATA';
            
            %Output
            obj.folderFL = 'STATS_PHANTOM';
            
            % Contrasts
            obj.contrastes = FirstLevel.importContrastsXls( '\\172.19.1.180\Users$\sebastian\My Documents\MATLAB\processingSPM\docs\PRJ1206_PHANTOM.xlsx' );

            obj.filter = 128;
            
        end
    end
    
    methods (Access = protected)
                
        function ajustaConditions(obj)
                obj.conditions.sess(1).cond(1).name = 'PHANT1';
                obj.conditions.sess(1).cond(1).onset = 11:20:200;
                obj.conditions.sess(1).cond(1).duration = 10;
                obj.conditions.sess(1).cond(2).name = 'PHANT2';
                obj.conditions.sess(1).cond(2).onset = 1:20:200;
                obj.conditions.sess(1).cond(2).duration = 10;
        end
    end
end