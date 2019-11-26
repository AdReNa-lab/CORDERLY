function varargout = CORDERLY(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CORDERLY_OpeningFcn, ...
                   'gui_OutputFcn',  @CORDERLY_OutputFcn, ...
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

function CORDERLY_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;

% Creates Reference message and url
url = 'https://doi.org/10.1021/acs.langmuir.9b02877';
labelStr = ['<html>Reference: "Application of the Spatial Distribution Function to Colloidal Ordering" by Niamh Mac Fhionnlaoich et al.; Langmuir DOI: <a href="">' url '</a></html>' ];
jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
[hjLabel,~] = javacomponent(jLabel, [15,26,350,52], gcf);
hjLabel.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
hjLabel.setToolTipText('Visit the reference website');
set(hjLabel, 'MouseClickedCallback', @(h,e)web(url, '-browser'))
labelStr = '<html>Thank you for citing. <a href="">';
jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
[~,~] = javacomponent(jLabel, [15,10,350,17], gcf);

axis off
imshow(imread('Splash.png', 'png'))

guidata(hObject, handles);

function varargout = CORDERLY_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function Fourier_Transform_Push_Callback(hObject, ~, handles) %#ok<*DEFNU>
run('Fourier_Transform.m')
guidata(hObject, handles)

function The_RDF_Button_Callback(hObject, ~, handles)
run('RDF.m')
guidata(hObject, handles)

function The_SDF_Button_Callback(hObject, ~, handles)
run('SDF.m')
guidata(hObject, handles)

function Angular_Distribution_Button_Callback(hObject, ~, handles)
run('Angular_Distribution.m')
guidata(hObject, handles)


% --------------------------------------------------------------------
function Help_Callback(hObject, ~, handles)
run('Help_Colloidal_Ordering_GUI.m')
guidata(hObject, handles)
