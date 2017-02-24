function varargout = app(varargin)
% APP M-file for app.fig
%      APP, by itself, creates a new APP or raises the existing
%      singleton*.
%
%      H = APP returns the handle to a new APP or the handle to
%      the existing singleton*.
%
%      APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APP.M with the given input arguments.
%
%      APP('Property','Value',...) creates a new APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help app

% Last Modified by GUIDE v2.5 05-Jun-2012 16:06:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @app_OpeningFcn, ...
    'gui_OutputFcn',  @app_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before app is made visible.
function app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to app (see VARARGIN)

% Choose default command line output for app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = app_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bOpen.
function bOpen_Callback(hObject, eventdata, handles)
global pathCur;
if isempty(pathCur) || pathCur==0
    pathCur = pwd;
end
[filename, pathCur] = uigetfile({'*.par', 'PAR-Files (*.par)'; '*.*',  'All Files (*.*)'}, 'Pick a file', pathCur);
if filename~=0
    set(handles.eFile, 'string', fullfile(pathCur,filename));
end
set(handles.pDados,'visible','off');


% --- Executes on button press in oDir.
function oDir_Callback(hObject, eventdata, handles)
dir = get(handles.eDir, 'String');
if isempty( dir )
    dir = pwd;
end
dir = uigetdir('Pick a directory', dir);
if dir~=0
    set(handles.eDir, 'string', dir);
    set(handles.eOutDir, 'string', dir);
end


% --- Executes on button press in bRun.
function bRun_Callback(hObject, eventdata, handles)
if get(handles.rFile, 'Value')==1
    set(handles.pDados,'visible','on');
    run_file( handles, get(handles.eFile, 'string') );
else
    inDir = get(handles.eDir, 'string');
    outDir = get(handles.eOutDir, 'string');
    if ~exist(outDir,'dir')
        mkdir(outDir)
    end
    files = ls([inDir '/*.par']);
    for k=1:length(files)
        filename = files(k,:);
        run_file( handles, fullfile(inDir, filename), outDir);
    end
end

function run_file(handles, fullfilename, varargin)
outputPath = [];
if nargin>=3
    outputPath = varargin{1};
end
global pathCur;
contentArq = readlog(fullfilename);
sPatientName = contentArq.head(2, find(strcmp(contentArq.head(1,:), 'Patient name')==1) );
set(handles.tName, 'string', sPatientName);
sAngulation = contentArq.head(2, find(strcmp(contentArq.head(1,:), 'Angulation midslice(ap,fh,rl)[degr]')==1) );
set(handles.tAngulation, 'string', sAngulation);
totalGradients = str2double(contentArq.head(2, find(strcmp(contentArq.head(1,:), 'Max. number of gradient orients')==1) ));

%Tratando resultados e preparando arquivo BVEC

bvecData = [0; 0; 0];
colAP = 46;
colFH = 47;
colRL = 48;
for k=1:totalGradients-1
    posicao = find( (contentArq.data{43} == k) == 1, 1);
    bvecData(:,end+1) = [
        -1*contentArq.data{colRL}(posicao);
        contentArq.data{colAP}(posicao);
        -1*contentArq.data{colFH}(posicao);
    ];
end

%Escrevendo o arquivo de saída
bvecData(bvecData==-0)=0; %Para corrigir bug que fazia aparecer no arquivo bvec -0
filename = [sPatientName{1} '.bvec'];
if isempty(outputPath)
    [filename outputPath] = uiputfile({'*.bvec', 'BVEC-file (*.bvec)'; '*.txt', 'TEXT-file (*.txt)'}, 'Save as', fullfile(pathCur, [sPatientName{1} '.bvec']));
end
if filename~=0
    dlmwrite(fullfile(outputPath,filename), bvecData, 'delimiter',' ', 'precision', 3, 'newline', 'pc');
end


function [dados, cont] = extrairCabecalho(fullfile)
file = fopen(fullfile, 'r');
tline = fgetl(file);
cont=1;
dados = [];
while (tline(1)=='.' || tline(1)=='#') && ~feof(file)
    if(tline(1)=='.')
        [key, value] = strtok(tline,':');
        dados(end+1).key = strtrim(key(2:end));
        dados(end).value = strtrim(value(2:end));
    end
    tline = fgetl(file);
    if(isempty(tline))
        break;
    end
    cont=cont+1;
end
fclose(file);

%%Function that reads the PAR file and determines the PATIENTE NAME and
% other values
function out = readlog(fullfilepath)
[dados cont] = extrairCabecalho(fullfilepath);

file = fopen(fullfilepath, 'r');
out.head = struct2cell(dados(:));
out.data = textscan(file, '%d%d%d%d%d%d%d%d%d%d%d%f%f%f%d%d%f%f%f%f%f%f%f%f%d%d%d%d%f%f%f%f%f%f%d%f%d%d%d%d%f%d%d%d%d%f%f%f%d', 'Headerlines', cont, 'CommentStyle', '#');
fclose(file);


% --- Executes on button press in bChangeDir.
function bChangeDir_Callback(hObject, eventdata, handles)
dir = get(handles.eOutDir, 'string');
dir = uigetdir('Pick a directory', dir);
if dir~=0
    set(handles.eOutDir, 'string', dir);
end


% --- Executes on button press in rFolder.
function rFolder_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
    set(handles.pDados, 'Visible', 'off');
    set([handles.tOutput handles.eOutDir handles.bChangeDir handles.tInput handles.eDir handles.oDir], 'Visible', 'on');
end


% --- Executes on button press in rFile.
function rFile_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
    set([handles.tOutput handles.eOutDir handles.bChangeDir handles.tInput handles.eDir handles.oDir], 'Visible', 'off');
end
