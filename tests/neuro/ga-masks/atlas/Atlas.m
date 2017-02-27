classdef Atlas < handle
    %ATLAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private)
        id = '';
        name = '';
        filename = '';
        tmpfile = '';
        file = '';
        img;
        areas; %cell
    end
    
    methods
        
        function obj = Atlas( atlas )
            if( exist('atlas','var') )
                obj.setAtlas(atlas);
            end
        end
        
        function setAtlas(obj, atlas)
            obj.img = [];
            obj.id = atlas.id;
            obj.name = atlas.name;
            obj.filename = atlas.filename;
            obj.file = fullfile( fileparts(mfilename('fullpath')), atlas.filename);
            obj.areas = atlas.areas;
            obj.tmpfile = fullfile(CONSTS.TEMP_DIR, obj.name);
            obj.carregar();
        end
        
        function carregar(obj)
            if( ~exist( obj.tmpfile, 'file' ) )
                gunzip( obj.file, CONSTS.TEMP_DIR );
            end
            obj.img = load_nii( fullfile( obj.tmpfile ) );
        end
        
        function visualizar(obj)
            view_nii( obj.img );
        end        
    end
    
end

