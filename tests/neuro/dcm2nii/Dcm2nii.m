classdef Dcm2nii < handle
%%
%Dcm2nii
%
% Para converter uma imagem:
%    Dcm2nii.converteDCM( img, destino )
%    
    properties(Constant)
        exePath = fullfile(fileparts(mfilename('fullpath')), 'mricron', 'dcm2nii.exe');
        iniPath = fullfile(fileparts(mfilename('fullpath')), 'mricron', 'dcm2nii.ini');
    end
    
    properties(SetAccess = public)
        exclude = 0;
        inDir = '';
        outDir = '';
        gzip = false;
    end
    
    methods(Static=true)
        %Imagem, Dir Destino e informar se será com gzip
        function converteDCM( img, destino, gzip )
            [status imgAtrs] = fileattrib(img);
            if status
                [inDir inFile ext] = fileparts(imgAtrs(1).Name);
                if ~exist('destino', 'var'); destino = inDir; end
                if ~exist('gzip', 'var'); gzip = false; end
                dcm2nii = Dcm2nii;
                dcm2nii.inDir = inDir;
                dcm2nii.outDir = destino;
                dcm2nii.gzip = gzip;
                dcm2nii.converter(imgAtrs(1).Name)
            end
        end
    end
    
    methods(Access = public)
        function converter(obj, img)
            if strcmp(img(end-3:end), '.dcm')
                if ~isempty(obj.outDir) & ~isdir(obj.outDir)
                    mkdir(obj.outDir);
                end
                disp(obj.montaComando(img));
                system( obj.montaComando(img) );
                %s = evalc( ['system( ''' obj.montaComando(img) ''' ) ']);
                if obj.exclude
                    disp(['Excluindo arquivo:' img]);
                    delete(img);
                end
            end
        end
        
        function run(obj)
            obj.varrerDirs(obj.inDir);
        end
        
        function exec(obj, inDir, varargin)
            obj.recursive(inDir, varargin{:});
        end
        
        function recursive(obj, inDir, varargin)
            obj.inDir = inDir;
            obj.outDir = inDir;
            subDirs = '';
            if ~isempty(varargin)
                obj.outDir = varargin{1};
                if nargin == 4
                    subDirs = varargin{2};
                end
            end
            obj.varrerDirs(obj.inDir, subDirs); %Varre os diretórios limpando as imagens
        end
    end
    
    methods(Access = private)
        %Prepara o comando para a conversao
        function cmd=montaComando(obj, img)
            exe = [ '"' obj.exePath '"'];
            out = '';
            gzip = '';
            ini = [' -b "' obj.iniPath '"'];
            if ~isempty(obj.outDir)
                out = [' -o "' obj.outDir '"'];
            end
            if ~obj.gzip
                gzip = ' -g 0';
            else
                gzip = ' -g 1';
            end
            cmd = [exe out gzip ini ' "' img '"'];
        end
        
        function varrerDirs(obj, raiz, subDirs)
            if exist(raiz,'dir') %Verifica se o diretório existe
                if exist('subDirs', 'var') & ~isempty(subDirs)
                    for k=1:length(subDirs)
                        if exist( fullfile(raiz, subDirs{k}), 'dir' )
                            obj.percorrerSubDirs( fullfile(raiz, subDirs{k}) );
                        else
                            [status subDirsR] = fileattrib( fullfile(raiz, subDirs{k}) );
                            for subDir=subDirsR
                                if subDir.directory
                                    obj.percorrerSubDirs( subDir.Name );
                                end
                            end
                        end
                    end
                else
                    obj.percorrerSubDirs( raiz );
                end
            end
        end
        
        function percorrerSubDirs(obj, raiz)
            subDirs = dir(raiz);
            for k=1:length(subDirs)
                itempath = fullfile(raiz,subDirs(k).name);
                if isempty( find(strcmp(subDirs(k).name, {'.','..'}) == 1) ) & ~strcmp(itempath, obj.outDir)
                    switch exist(itempath)
                        case 7
                            if strcmp(subDirs(k).name(1:2),'3D')
                                if obj.exclude
                                    disp(['Excluindo diretorio:' itempath]);
                                    rmdir(itempath, 's');
                                end
                            else
                                obj.varrerDirs( fullfile(raiz, subDirs(k).name) )
                            end
                        otherwise
                            tempOutDir = obj.outDir;
                            obj.outDir = fullfile(obj.outDir, strrep(raiz, obj.inDir, '') );
                            obj.converter( fullfile(raiz, subDirs(k).name) ); %Faz a conversão
                            obj.outDir = tempOutDir;
                    end
                end
            end
        end
    end
end