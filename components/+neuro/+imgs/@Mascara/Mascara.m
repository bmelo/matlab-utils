classdef Mascara < utils.Generic
    %MASCARA Summary of this class goes here
    % Detailed explanation goes here
    
    properties(SetAccess = private)
        atlas;
        img; %Irá armazenar a imagem da máscara
        id = '';
    end
    
    methods
        function obj = Mascara( atlas ) %Construtor
            if nargin > 0
                obj.setAtlas( atlas );
            end
            obj.limparImg();
        end
        
        %Define um atlas que ficará atrelado à máscara
        function setAtlas(obj, atlas)
            if( isstruct(atlas) )
                obj.atlas = Atlas(atlas);
            elseif( ischar(atlas) )
                eval( ['obj.atlas = Atlas(' atlas ');'] );
            elseif( strcmp(class(atlas), 'Atlas') )
                obj.atlas = atlas;
            end
            obj.limparImg();
        end
        
        %usa o atlas inteiro
        function loadAtlas(obj)
            obj.img = obj.atlas.img;
            obj.gerarId();
        end
        
        %limpa a imagem
        function limparImg(obj)
            obj.createImg();
        end
        
        %Preenche a mascara com todas as áreas do atlas
        function fill( obj )            
            obj.addAreas( 1:length( obj.atlas.areas ) );
        end
        
        %adicionar areas pelos valores do atlas
        function addAreas(obj, numbers)
            if(obj.atlasCarregado())
                for k=numbers
                    obj.img.img( obj.atlas.img.img==k ) = k;
                end
            end
            obj.gerarId();
        end
        
        %remove areas pelos valores das areas
        function removeAreas(obj, numbers)
            if(~isempty(obj.img))
                for k=numbers
                    obj.img.img( obj.img.img==k ) = 0;
                end
            end
            obj.gerarId();
        end
        
        function visualizar(obj)
            view_nii( obj.img );
        end
        
        function exportImg(obj, filename)
            save_nii(obj.img, filename);
        end
        
        %Verifica se uma area já faz parte da mascara
        function existe = hasArea(obj, area)
            areas = obj.listValues();
            existe = any( areas==area );
        end
        
        %faz a conversão para o espaco do volume passado como parâmetro
        function converterBaseSubj(obj, volBase, output)
            %verificações
            if( isempty( fileparts(volBase) ) ) %Caso só exista o nome do arquivo, coloca o diretório atual
                volBase = fullfile(pwd, volBase);
            end
            [dirVol nameVol] = fileparts(volBase);
            if ~exist('output', 'var')
                output = fullfile(CONSTS.OUTPUT_DIR, obj.id);
            end
            if ~exist(output, 'dir')
                mkdir(output);
            end
            dirAtual = pwd;
            obj.copiarMats(dirVol, output, nameVol);
            ini = load('default.mat');
            cd(output);
            tmpVolBase = [tempname(output) '.nii']; %gera nome temporário
            copyfile( volBase, tmpVolBase );
            mask = fullfile(output, 'mask.nii'); %gera nome temporário
            obj.exportImg(mask); %exporta mascara atual
            %Montando arquivo params
            ini.general.typeprocess = 'CONVERTMASK';
            ini.general.silent = '1'; %Sempre usar com este modo
            ini.general.dirout = output;
            ini.convertmask.volumesujeito = tmpVolBase;
            ini.convertmask.mascara =  mask;
            %Executando AnaliseRisco.exe
            AnaliseRisco( ini );
            %limpando arquivos temporários
            delete(tmpVolBase);
            obj.copiarMats(output, dirVol, nameVol, false );
            delete *.mat *RFI2MNI_RFI2.nii *_std.nii mask.nii; %Apagando sujeira
            cd(dirAtual);
        end
        
        %Exibe a lista das áreas presentes na mascara
        function values = listValues(obj)
            values = unique(obj.img.img);
            values = sort( values(values > 0) );
        end
    end
    
    methods(Access = private)   
        
        %Copia os arquivos .mat para acelerar a conversão do espaço da mask
        function copiarMats(obj, origem, destino, nameVol, toConvert )          
            patPrefix = '%1$s.%2$s.%3$s';
            prefixoBusca = '';
            if( ~exist('toConvert', 'var') | toConvert )
                patPrefix = '%3$s';
                prefixoBusca = sprintf('%s.%s', nameVol, obj.atlas.id);
            end
            files = dir(fullfile(origem, [prefixoBusca '*.mat'])); %Lista os arquivos
            for k=1:length(files) %Percorre os arquivos e copia o que for necessário
                idMat = regexp(files(k).name, '([\w\d_]*)\.mat$', 'match');
                filename = sprintf(patPrefix, nameVol, obj.atlas.id, idMat{1});
                fileDest = fullfile( destino, filename );
                if(~exist(fileDest, 'file'))
                    copyfile( fullfile(origem, files(k).name), fileDest );
                end
            end
        end
        
        %Gera uma imagem limpa
        function createImg(obj)
            if(isempty(obj.atlas.img))
                dim = [181   217   181];
                datatype = 2;
            else
                dim = size(obj.atlas.img.img);
                datatype = obj.atlas.img.hdr.dime.datatype;
            end
            imgData = zeros(dim(1),dim(2),dim(3));
            obj.img = make_nii( imgData, [1 1 1], dim/2, datatype );
            obj.id = '';
        end
        
        function out=atlasCarregado(obj)
            out = ~isempty(obj.atlas);
        end
        
        function gerarId(obj)
            %Monta um identificador único para a mascara
            % Estrutura: idAtlas_numAreas-numBits-(sequencia de bits em decimal)
            totalAreas = size(obj.atlas.areas,2);
            nBits = 16;
            numsMask = zeros(1,totalAreas);
            numsMask( obj.listValues() ) = 1;
            sNums = sprintf('%d',numsMask);
            if(~isempty(obj.atlas))
                obj.id = [obj.atlas.id '_'];
            end
            obj.id = sprintf('%s%d-%d', obj.id, length(numsMask), nBits);
            for k=1:nBits:totalAreas
                nEnd = k+(nBits-1);
                if(nEnd > totalAreas)
                    nEnd = totalAreas;
                end
                dec = bin2dec(sNums(k:nEnd));
                obj.id = sprintf('%s-%d', obj.id, dec);
            end
        end
    end
    
    methods (Static = true)
        function mask = getMaskByCode( code )
            parts = regexp(code, '([\w\d]+)_\d+\-\d+\-[\d\-]*', 'tokens');
            mask = Mascara( parts{1}{1} );
            mask.addAreas( Mascara.CodeToAreas(code) );
        end
        
        function areas = CodeToAreas( code )
            nums = regexp(code, '[\w\d]+_\d+\-(\d+)\-([\d\-]*)', 'tokens');
            sizeBin = nums{1}{1};
            partsNumBin = tokenize(nums{1}{2},'-');
            binNum = '';
            for k=partsNumBin
                binNum = sprintf( ['%s%0' sizeBin 's'], binNum, dec2bin( str2num(k{1}) ) );
            end
            areas = [];
            for k = 1:length(binNum)
                if( binNum(k)=='1' )
                    areas(end+1) = k;
                end
            end
        end
        
        function mascara = combineMasks(mask1, mask2)
            if(ischar(mask1))
                mask1 = Mascara.getMaskByCode(mask1);
            end
            if(ischar(mask2))
                mask2 = Mascara.getMaskByCode(mask2);
            end
            mascara = mask1;
            mascara.addAreas( mask2.listValues()' );
        end
    end
end

