classdef Img < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fullPath = '';
        path = '';
        name = '';
        tempName = '';
        ext = '';
        timeCreate;
        originalData;
        dataImg;
        info;
        infoTemp;
        quality=88;
    end
    
    methods(Access = private)
        function saveTempFile(obj)
            obj.tempName = [num2str(tic) '_resizePhoto.tmp' ];
            if isfield(obj.info, 'Format') & strcmp(obj.info.Format, 'jpg')
                imwrite(obj.dataImg, fullfile(tempdir, obj.tempName), obj.info.Format, 'quality', obj.quality); %Default 88
            else
                imwrite(obj.dataImg, fullfile(tempdir, obj.tempName), obj.info.Format);
            end
            obj.infoTemp = imfinfo(fullfile(tempdir, obj.tempName), obj.info.Format);
        end
        
        function checkFilename(obj, pathDest ,num)
            if ~exist('num', 'var'); num=0; end
            comp = '';
            if num > 0
                comp = [' (' num2str(num) ')'];
            end
            infoDest = dir( fullfile(pathDest, [obj.name comp obj.ext]) );
            if ~isempty(infoDest) & infoDest.bytes~=obj.infoTemp.FileSize
                obj.checkFilename(pathDest, num+1);
                comp = '';
            end
            if num > 0
                obj.name = [obj.name comp];
            end
        end
        function temp2FinalFile(obj, pathDest)
            if ~strcmp(pathDest,obj.path)
                obj.checkFilename(pathDest);
            end
            movefile( fullfile(tempdir, obj.tempName), fullfile(pathDest, [obj.name obj.ext]), 'f' );
        end
        
    end
    
    methods
        function obj = Img( imgPath )
            obj.fullPath = imgPath;
            [obj.path obj.name obj.ext] = fileparts(imgPath);
            obj.ext = lower(obj.ext);
            if strcmp(obj.ext, '.jpeg'); obj.ext = '.jpg'; end;
            obj.dataImg = imread(imgPath);
            obj.info = imfinfo(imgPath);
            try
                dt = obj.info.DigitalCamera.DateTimeOriginal;
                if strcmp(dt(1:4),'0000')
                    throw(MException('Photo:InvalidDateCamera'));
                else
                    obj.timeCreate = datestr(datenum(dt, 'yyyy:mm:dd HH:MM:SS'), 'yyyy-mm-dd HH.MM.SS');
                end
            catch ME
                dt = obj.info.FileModDate;
                obj.timeCreate = datestr(datenum(dt, 'dd-mmm-yyyy HH:MM:SS'), 'yyyy-mm-dd HH.MM.SS');
            end
        end
        
        % bckpath - Path without filename
        function saveBackup(obj, bckpath)
            if ~isdir(bckpath)
                mkdir(bckpath);
            end
            copyfile( obj.path , bckpath );
        end
        
        function renameWithTime( obj, replace )
            if ~exist('replace', 'var'); replace=true; end
            if replace
                obj.name = [obj.timeCreate];
            else
                [obj.path obj.name] = fileparts(obj.fullPath);
                obj.name = [obj.name ' ' obj.timeCreate];
            end
        end
        
        function save(obj, savetopath)
            if ~isdir(savetopath)
                mkdir(savetopath);
            end
            obj.saveTempFile();
            while(savetopath(end)=='\')
                savetopath(end)=[];
            end
            obj.temp2FinalFile( savetopath );
        end
        
        function resize( obj, maxWH )
            % [w, h] is the width and height of original graph
            w = size(obj.dataImg, 1);
            h = size(obj.dataImg, 2);
            
            % [maxw, maxh]
            if numel(maxWH) == 1
                if w > h
                    maxw = maxWH;
                    maxh = maxWH*h/w;
                else
                    maxh = maxWH;
                    maxw = maxWH*w/h;
                end
            else
                maxw = maxWH(1);
                maxh = maxWH(2);
                if (w-h)*(maxw-maxh) < 0
                    [maxw, maxh] = deal(h, w);
                end
                
                if w/h < maxw/maxh
                    maxw = maxh*w/h;
                else
                    maxh = maxw*h/w;
                end
            end
            
            if maxw < w
                obj.dataImg = imresize(obj.dataImg, [maxw, maxh]);
            end
        end
    end 
end