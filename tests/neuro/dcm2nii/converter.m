function varargout = converter(varargin)
% CONVERTER M-file for converter.fig
%      CONVERTER, by itself, creates a new CONVERTER or raises the existing
%      singleton*.
%
%      H = CONVERTER returns the handle to a new CONVERTER or the handle to
%      the existing singleton*.
%
%      CONVERTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVERTER.M with the given input arguments.
%
%      CONVERTER('Property','Value',...) creates a new CONVERTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before converter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to converter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help converter

% Last Modified by GUIDE v2.5 14-Jun-2013 14:39:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @converter_OpeningFcn, ...
                   'gui_OutputFcn',  @converter_OutputFcn, ...
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

% --- Executes just before converter is made visible.
function converter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to converter (see VARARGIN)

% Choose default command line output for converter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes converter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = converter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in fileName.
function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname;
%[filename, pathname] = uigetfile( { '*.dcm', 'Dicom Files (*.dcm)' }, 'Pick a file');
pathname = uigetdir(getenv('USERPROFILE'), 'Pick a Directory');
if( pathname )
    %set(handles.tFile, 'string', fullfile(pathname, filename));
    set(handles.tFile, 'string', pathname);
end
 


% --- Executes on button press in dirOut.
function dirOut_Callback(hObject, eventdata, handles)
% hObject    handle to dirOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in convert.
global pathname;
dfPath = getenv('USERPROFILE');
if(~isempty(pathname))
    dfPath = pathname;
end
directoryname = uigetdir(dfPath, 'Pick a Directory');
if( directoryname )
    set(handles.tDirOut, 'string', directoryname);
end


function convert_Callback(hObject, eventdata, handles)
% hObject    handle to convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d2n = Dcm2nii;
dirIn = get(handles.tFile, 'string');
dirOut = get(handles.tDirOut, 'string');
if exist(dirIn) > 0
    d2n.inDir = dirIn;
    if  exist( dirOut, 'dir' )
        d2n.outDir = dirOut;
    end
    d2n.gzip = get(handles.gzip, 'value');
    d2n.run();
end
