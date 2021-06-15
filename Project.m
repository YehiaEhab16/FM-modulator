function varargout = Project(varargin)
% PROJECT MATLAB code for Project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project

% Last Modified by GUIDE v2.5 07-Jun-2021 05:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project_OpeningFcn, ...
                   'gui_OutputFcn',  @Project_OutputFcn, ...
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

% --- Executes just before Project is made visible.
function Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project (see VARARGIN)
clc;
global first;
global flag;
flag=0;
first=0;

% Choose default command line output for Project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Sec_Callback(hObject, eventdata, handles)
% hObject    handle to Sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sec as text
%        str2double(get(hObject,'String')) returns contents of Sec as a double


% --- Executes during object creation, after setting all properties.
function Sec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Imp.
function Imp_Callback(hObject, eventdata, handles)
% hObject    handle to Imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag;
global filename;
global filepath;
flag=1;
[filename, filepath] = uigetfile({'*.*';'*.wav';'*.mp3'}, 'Choose a song to play');


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global first;
global flag;
global filename;
global filepath;
global p1;
global p2;
global y;
global t;
global fs;
global N_sec;
global y_freq;
global f_vec;

first=first+1;
if(flag~=1)
    [song,fs] = audioread('eric.wav');
else
    [song,fs] = audioread(fullfile(filepath, filename));
end
if(isnan(str2double(get(handles.Sec,'string')))==1)
    N_sec = 8;
else
    N_sec = str2double(get(handles.Sec,'string'));
end
t = linspace(0,N_sec,N_sec*fs);
y = song(1:N_sec*fs);
N_samples = length(y);
y_freq = fftshift(fft(y));
y_mag = abs(y_freq);
y_phase = angle(y_freq);
f_vec = linspace(-fs/2,fs/2,N_samples);
axes(handles.Time);
if(first>1)
    delete(p1);
end
p1 = plot(f_vec,y_mag);
axes(handles.Freq);
if(first>1)
    delete(p2);
end
p2 = plot(f_vec,y_phase);
clear sound;
sound(y,fs);
flag=0;

set(handles.graph1, 'String', 'Magnitude Spectrum');
set(handles.graph2, 'String', 'Phase Spectrum');

set(handles.Filter_Lp ,'enable' ,'on');
set(handles.cut_freq ,'enable' ,'on');
set(handles.Imp ,'enable' ,'off');
set(handles.Sec ,'enable' ,'off');
set(handles.play ,'enable' ,'off');

% --- Executes on button press in Filter_Lp.
function Filter_Lp_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Lp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs;
global y_freq;
global y_filter;
global p1;
global p2;
global f_vec;
global t;


spH=double(length(y_freq)/double(fs));
if(isnan(str2double(get(handles.cut_freq,'string')))==1)
    frequency = 4000;
else
    frequency = str2double(get(handles.cut_freq,'string'));
end
f_cut=uint32(((fs/2)-frequency)*spH);
y_freq([1:f_cut end-f_cut+1:end])=0;
y_filter=real(ifft(ifftshift(y_freq)));

clear sound;
sound(y_filter,fs);
axes(handles.Time);
delete(p1);
p1 = plot(t,y_filter);
set(handles.graph1, 'String', 'Time Domain');                                      
axes(handles.Freq);
delete(p2);
y_plot=abs(y_freq);
p2 = plot(f_vec,y_plot);
set(handles.graph2, 'String', 'Frequency Domain');

set(handles.Cmp ,'enable' ,'on');

% --- Executes on button press in Cmp.
function Cmp_Callback(hObject, eventdata, handles)
% hObject    handle to Cmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p2;
global t;
global y;
set(handles.graph1, 'String', 'Signal after filter');
set(handles.graph2, 'String', 'Signal before filter');

axes(handles.Freq);
delete(p2);
p2 = plot(t,y);

set(handles.Cmp ,'enable' ,'off');
set(handles.Filter_Lp ,'enable' ,'off');
set(handles.cut_freq ,'enable' ,'off');
set(handles.Fc ,'enable' ,'on');
set(handles.Mod ,'enable' ,'on');

% --- Executes on button press in Mod.
function Mod_Callback(hObject, eventdata, handles)
% hObject    handle to Mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y_filter;
global NBFM_Signal;
global t;
global p1;
global p2;

if(isnan(str2double(get(handles.Fc,'string')))==1)
    fc = 10000;
else
    fc = str2double(get(handles.Fc,'string'));
end

A=10;
kf=0.1;
fs2=5*fc;

if((size(t,1))==(size(y_filter,1)))
    NBFM_Signal = A*cos(2*pi*fc.*t+kf*cumsum(y_filter));
else
    NBFM_Signal = A*cos(2*pi*fc.*t'+kf*cumsum(y_filter));
end
NBFM_Signal_f=abs(fftshift(fft(NBFM_Signal)));
f2 = linspace(-fs2/2,fs2/2,length(NBFM_Signal_f));

axes(handles.Time);
delete(p1);
p1 = plot(f2,NBFM_Signal_f);

axes(handles.Freq);
delete(p2);

set(handles.graph1, 'String', 'Modulated signal in freq domain');
set(handles.graph2, 'String', '');

set(handles.Mod ,'enable' ,'off');
set(handles.Fc ,'enable' ,'off');
set(handles.demod ,'enable' ,'on');

% --- Executes on button press in demod.
function demod_Callback(hObject, eventdata, handles)
% hObject    handle to demod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NBFM_Signal;
global fs;
global t;
global p2;

DEMOD_Signal=diff(NBFM_Signal);
envelope = abs(hilbert(DEMOD_Signal));
mean_signal=mean(envelope);
RECEIVED_Signal=envelope-mean_signal;
RECEIVED_Signal(end+1) = 0;

clear sound;
sound(RECEIVED_Signal,fs);


axes(handles.Freq);
ylim([-0.2 0.2]);
p2 = plot(t,RECEIVED_Signal);

set(handles.graph2, 'String', 'Recieved Signal');

set(handles.demod ,'enable' ,'off');

function Fc_Callback(hObject, eventdata, handles)
% hObject    handle to Fc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fc as text
%        str2double(get(hObject,'String')) returns contents of Fc as a double


% --- Executes during object creation, after setting all properties.
function Fc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function c_freq_Callback(hObject, eventdata, handles)
% hObject    handle to c_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_freq as text
%        str2double(get(hObject,'String')) returns contents of c_freq as a double


% --- Executes during object creation, after setting all properties.
function c_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Nimp_Callback(hObject, eventdata, handles)
% hObject    handle to Nimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nimp as text
%        str2double(get(hObject,'String')) returns contents of Nimp as a double


% --- Executes during object creation, after setting all properties.
function Nimp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cut_freq_Callback(hObject, eventdata, handles)
% hObject    handle to cut_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cut_freq as text
%        str2double(get(hObject,'String')) returns contents of cut_freq as a double


% --- Executes during object creation, after setting all properties.
function cut_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cut_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Ext.
function Ext_Callback(hObject, eventdata, handles)
% hObject    handle to Ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
clear sound;
close all;


% --- Executes on button press in Res.
function Res_Callback(hObject, eventdata, handles)
% hObject    handle to Res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;

set(handles.demod ,'enable' ,'off');
set(handles.Mod ,'enable' ,'off');
set(handles.Fc ,'enable' ,'off');
set(handles.cut_freq ,'enable' ,'off');
set(handles.Filter_Lp ,'enable' ,'off');
set(handles.Cmp ,'enable' ,'off');
set(handles.Imp ,'enable' ,'on');
set(handles.Sec ,'enable' ,'on');
set(handles.play ,'enable' ,'on');
