classdef SecondLevel < handle & ProcessamentoSPM
    
    properties(SetAccess = public)
        %PROJECT NEEDS
        subjects = [];
        groups = [];
        contraste = 0; %informa que constrastes serão utilizados
        contrasteName;
        folder = ''; %Diretorio para separar as analises
    end
    
    methods(Access = public)
        %In separated files
        processar(obj, varargin);
        
        function obj=SecondLevel( varargin )
            obj.openSPM = 0;
            if nargin == 1
                obj.populateData(varargin{1});
            end
        end
    end
    
    methods(Access = private)
        %In separated files
        populaMatlabbatch(obj);
        
        %Retorna o diretório de um sujeito onde os contrastes podem ser localizados
        function dirSub = subjDirSL(obj, subject)
            if strfind(obj.inDir, '<SUBJECT>')
                dirSub = strrep( obj.inDir, '<SUBJECT>', subject.code);
            else
                dirSub = fullfile(obj.inDir, subject.code);
            end
        end
        
        %Retorna a imagem do contraste de um sujeito específico
        function imgCon = getImgSubj(obj, subject)
            dirSub = obj.subjDirSL( subject );
            strCon = sprintf('con*_%04d.img', obj.contraste);
            files = dir( fullfile(dirSub, strCon) );
            if isempty(files)
                error( 'SecondLevel:FileMissing', 'Sujeito %s não possui o arquivo %s', subject.code, strCon);
            end
            imgCon = fullfile(dirSub, [files(1).name ',1']);
        end
        
        function imgs = getImgsGroup(obj, group)
            imgs = {};
            tempSubjs = obj.subjects;
            for nsub = group
                for k=1:length(tempSubjs)
                    if nsub==tempSubjs{k}.num
                        imgs{end+1} = obj.getImgSubj( tempSubjs{k} );
                        tempSubjs(k) = [];
                        break;
                    end
                end
            end
        end
        
        function preparaRun(obj)
            obj.populaMatlabbatch();
        end
    end    
end