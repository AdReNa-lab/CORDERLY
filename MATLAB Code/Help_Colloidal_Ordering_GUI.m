function varargout = Help_Colloidal_Ordering_GUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Help_Colloidal_Ordering_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Help_Colloidal_Ordering_GUI_OutputFcn, ...
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

function Help_Colloidal_Ordering_GUI_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;
ax = handles.axes1;
set(ax,'visible', 'off');
help_overview = imread('H_COG_1.png','png');
imshow(help_overview, 'parent', ax);

guidata(hObject, handles);

function varargout = Help_Colloidal_Ordering_GUI_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
