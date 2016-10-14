function varargout = Test_GUI(varargin)
% TEST_GUI MATLAB code for Test_GUI.fig
%      TEST_GUI, by itself, creates a new TEST_GUI or raises the existing
%      singleton*.
%
%      H = TEST_GUI returns the handle to a new TEST_GUI or the handle to
%      the existing singleton*.
%
%      TEST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_GUI.M with the given input arguments.
%
%      TEST_GUI('Property','Value',...) creates a new TEST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Test_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Test_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Test_GUI

% Last Modified by GUIDE v2.5 11-Jan-2015 13:03:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Test_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Test_GUI_OutputFcn, ...
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


% --- Executes just before Test_GUI is made visible.
function Test_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Test_GUI (see VARARGIN)

% Choose default command line output for Test_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Test_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Test_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Bandpass filter of 5Hz to 43 Hz

assignin('base','test_cases',100);
assignin('base','COM','COM1');
Channel_length=6;
Training_samples=500;
assignin('base','Channel_length',Channel_length);
assignin('base','Training_samples',Training_samples);

d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,5,8,40,43,250);
d.Stopband1Constrained = true; d.Astop1 = 30;
d.Stopband2Constrained = true; d.Astop2 = 30;
Hd = design(d,'equiripple');
% Get default command line output from handles structure
assignin('base','Hd',Hd);
varargout{1} = handles.output;


% --- Executes on button press in Class_1.
function Class_1_Callback(hObject, eventdata, handles)

% hObject    handle to Class_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor','red');
COM=evalin('base','COM');
Class1=acquireData(COM);
assignin('base','Class1',Class1);
set(hObject,'BackgroundColor','green');


% --- Executes on button press in Class_2.
function Class_2_Callback(hObject, eventdata, handles)
% hObject    handle to Class_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor','red');
COM=evalin('base','COM');
Class2=acquireData(COM);
assignin('base','Class2',Class2);
set(hObject,'BackgroundColor','green');


% --- Executes on button press in Class_3.
function Class_3_Callback(hObject, eventdata, handles)
% hObject    handle to Class_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor','red');
COM=evalin('base','COM');
Class3=acquireData(COM);
assignin('base','Class3',Class3);
set(hObject,'BackgroundColor','green');


% --- Executes on button press in Class_4.
function Class_4_Callback(hObject, eventdata, handles)
% hObject    handle to Class_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor','red');
COM=evalin('base','COM');
Class4=acquireData(COM);
assignin('base','Class4',Class4);
set(hObject,'BackgroundColor','green');


% --- Executes on button press in Train_Classifier.
function Train_Classifier_Callback(hObject, eventdata, handles)
% hObject    handle to Train_Classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor','red');
Class1=evalin('base','Class1');
Class2=evalin('base','Class2');
Class3=evalin('base','Class3');
Class4=evalin('base','Class4');
X=[Class1;Class2;Class3;Class4];

y=ones(size(Class1,1)*4,1);
y(size(Class1,1)*1+1:end)=y(size(Class1,1)*1+1:end)+1;
y(size(Class1,1)*2+1:end)=y(size(Class1,1)*2+1:end)+1;
y(size(Class1,1)*3+1:end)=y(size(Class1,1)*3+1:end)+1;
assignin('base','X',X);
assignin('base','y',y);
model=TrainSVM(X,y);
assignin('base','TrainedModel',model);
set(hObject,'BackgroundColor','green');


% --- Executes on button press in TestOutput.
function TestOutput_Callback(hObject, eventdata, handles)
% hObject    handle to TestOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'BackgroundColor','red');
set(handles.text1,'String','Processing');
model=evalin('base','TrainedModel');
COM=evalin('base','COM');
test_cases=evalin('base','test_cases');
a=PredictedOutput(model,COM,handles,test_cases);
assignin('base','a',a);
set(hObject,'BackgroundColor','green');
