function varargout = Help_FFT(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Help_FFT_OpeningFcn, ...
                   'gui_OutputFcn',  @Help_FFT_OutputFcn, ...
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

function Help_FFT_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;
ax = handles.axes1;
set(ax,'visible', 'off');
help_overview = imread('H_FFT_1.png','png');
imshow(help_overview, 'parent', ax);
set(handles.Back, 'Enable', 'off')

handles.counter = 1;

guidata(hObject, handles);

function varargout = Help_FFT_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function Next_Callback(hObject, ~, handles) %#ok<*DEFNU>

handles.counter = handles.counter + 1;

if handles.counter > 3
    handles.counter = 3;
end

switch handles.counter
    case 2
        ax = handles.axes1;
        set(ax,'visible', 'off');
        help_overview = imread('H_FFT_2.png','png');
        imshow(help_overview, 'parent', ax);
        set(handles.Back, 'Enable', 'on')
        
    case 3
        ax = handles.axes1;
        set(ax,'visible', 'off');
        help_overview = imread('H_FFT_colormap.png','png');
        imshow(help_overview, 'parent', ax);
        set(handles.Next, 'Enable', 'off')
        
end

guidata(hObject, handles);

function Back_Callback(hObject, ~, handles)

handles.counter = handles.counter - 1;

if handles.counter < 1
    handles.counter = 1;
end


switch handles.counter
    case 1
        ax = handles.axes1;
        set(ax,'visible', 'off');
        help_overview = imread('H_FFT_1.png','png');
        imshow(help_overview, 'parent', ax);
        set(handles.Back, 'Enable', 'off')
        set(handles.Next, 'Enable', 'on')
        
    case 2
        ax = handles.axes1;
        set(ax,'visible', 'off');
        help_overview = imread('H_FFT_2.png','png');
        imshow(help_overview, 'parent', ax);
        set(handles.Next, 'Enable', 'on')
        
end

guidata(hObject, handles);