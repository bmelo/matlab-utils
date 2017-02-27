function sinais = AbreSinalPEB(Caminho)
%Abre_Sinal.m
%Seleciona e salva em disco segmentos de sinal
%

%referencia
%Maurício Cagy - março/1998
%Última revisão: 16/05/2006
%Alteração : Aluizio d'Affonsêca 25/11/2011

%Arquiva o caminho (Path) que contém os dados
if nargin == 0
    Dialogo = true;
end

%diretorio padrão vazio
path_arq = [];

if (nargin == 1)
    [path_arq,arq_name,est_arq] = fileparts(Caminho);
    
    if isempty(arq_name) || isempty(est_arq),
        Dialogo = true;
        if isempty(est_arq) && ~isempty(arq_name),
            path_arq = [path_arq,'\',arq_name];
        end
    else
        Dialogo = false;
        NomeARQdig = Caminho;
    end
end
    
%abre dialogo para arquivo com diretorio padrão    
if Dialogo
    [Arq,PATH]=uigetfile('*.peb','Selecione o arquivo',path_arq);
    if Arq==0,
        sinais = [];      %retorna vazio caso abertura seja cancelada
        return;
    end
    NomeARQdig=[PATH,Arq];
end

ARQ=fopen(NomeARQdig,'rb');

if ARQ<0,
   error('Não foi possível abrir este arquivo!');
end;


sinais.F_amost_in=[]; % Inicializa a freq. amost. com uma matriz vazia;
% Serve para permitir a inclusão de um valor "default" no diálogo
% de freq. de amostragem, quando for possível obtê-lo do cabeçalho do arquivo.

%Arquivos formato PEB:
% elseif tipo==4,
Bph=1; %Bytes por elemento do cabeçalho
Bpa=2; %Bytes por amostra
preci='int16';

%Lê o cabeçalho:
fseek(ARQ,3,0);   %pula versão
NChar=fread(ARQ,1,'uint8');
sinais.TipoDeExame=setstr(fread(ARQ,NChar,'uchar')');
sinais.F_amost_in=fread(ARQ,1,'float32');
NChar=fread(ARQ,1,'uint8');
sinais.TimeUnit=setstr(fread(ARQ,NChar,'uchar')');
Ncan_in=fread(ARQ,1,'uint8');
sinais.Ncan_in = Ncan_in; %slava numero de cansi na estrutura
sinais.cAng=fread(ARQ,Ncan_in,'float64');
sinais.cLin=fread(ARQ,Ncan_in,'float64');
for i=1:Ncan_in,
    NChar=fread(ARQ,1,'uint8');
    sinais.ChNames{i}=setstr(fread(ARQ,NChar,'uchar')');
end;
for i=1:Ncan_in,
    NChar=fread(ARQ,1,'uint8');
    sinais.ChUnits{i}=setstr(fread(ARQ,NChar,'uchar')');
end;
TemEstim=fread(ARQ,1,'uint8');
sinais.Ncan_est = TemEstim;   %numero de canais de trigger
Ncan_in=Ncan_in+TemEstim;
sinais.cAng=[sinais.cAng;ones(TemEstim,1)];
sinais.cLin=[sinais.cLin;zeros(TemEstim,1)];
sinais.HighCutOff=fread(ARQ,1,'float32');
sinais.LowCutOff=fread(ARQ,1,'float32');
sinais.AnoExame=fread(ARQ,1,'uint16');
sinais.MesExame=fread(ARQ,1,'uint8');
sinais.DiaExame=fread(ARQ,1,'uint8');
sinais.HoraExame=fread(ARQ,1,'uint8');
sinais.MinExame=fread(ARQ,1,'uint8');
NChar=fread(ARQ,1,'uint8');
sinais.Comments=setstr(fread(ARQ,NChar,'uchar')');
tam_header=ftell(ARQ); %tamanho do cabeçalho

Ncanais=Ncan_in;
fseek(ARQ,0,'eof');                      %pula para o final do  arquivo
Tam_arq = (ftell(ARQ)-tam_header)/Bpa;   %tamanho do arquivo que contem as amostras
Numero_amostras=fix(Tam_arq/Ncanais);    %Tamanho do sinal em numero de amostras intercaladas
Tam_arq = Numero_amostras*(Ncanais);     % corrige tamanho para corresponder a um numero inteiro de bytes
fseek(ARQ,tam_header,'bof');             %pula o cabeçalho
[ARQdig,sr]=fread(ARQ,Tam_arq,preci);

ARQdig=reshape(ARQdig,Ncanais,Numero_amostras);   %monta matriz com canais nas linhas e amostras nas colunas
for k = 1:Ncanais,
    ARQdig(k,:) = (ARQdig(k,:) + sinais.cLin(k))*sinais.cAng(k);
end
%sinais.ARQdig = (ARQdig +sinais.cLin*ones(1,Numero_amostras)).*(sinais.cAng*ones(1,Numero_amostras));  %escalona os valores
sinais.ARQdig = ARQdig;
sinais.Numero_amostras = Numero_amostras;
sinais.Caminho = NomeARQdig;   %Caminho do arquivo escolhido
fclose(ARQ);