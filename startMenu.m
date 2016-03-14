function varargout = startMenu(varargin)
%STARTMENU MATLAB code file for startMenu.fig
%      STARTMENU, by itself, creates a new STARTMENU or raises the existing
%      singleton*.
%
%      H = STARTMENU returns the handle to a new STARTMENU or the handle to
%      the existing singleton*.
%
%      STARTMENU('Property','Value',...) creates a new STARTMENU using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to startMenu_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      STARTMENU('CALLBACK') and STARTMENU('CALLBACK',hObject,...) call the
%      local function named CALLBACK in STARTMENU.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help startMenu

% Last Modified by GUIDE v2.5 08-Mar-2016 16:36:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @startMenu_OpeningFcn, ...
    'gui_OutputFcn',  @startMenu_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before startMenu is made visible.
function startMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for startMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes startMenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = startMenu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function seed_Callback(hObject, eventdata, handles)
% hObject    handle to seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seed as text
%        str2double(get(hObject,'String')) returns contents of seed as a double
global SEED;
SEED = str2double(hObject.String);


% --- Executes during object creation, after setting all properties.
function seed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string',num2str(platformEvolution.defaultSeed));


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clf;
close;
platformEvolution.beginExecution(0);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clf;
close;
platformEvolution.beginExecution(1);


function minGenTime_Callback(hObject, eventdata, handles)
% hObject    handle to minGenTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minGenTime as text
%        str2double(get(hObject,'String')) returns contents of minGenTime as a double


% --- Executes during object creation, after setting all properties.
function minGenTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minGenTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
