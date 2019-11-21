function varargout = Angular_Distribution(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Angular_Distribution_OpeningFcn, ...
                   'gui_OutputFcn',  @Angular_Distribution_OutputFcn, ...
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

function Angular_Distribution_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
set(handles.Update,'Enable','off')
handles.Variable_Name = 'Data';

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

guidata(hObject, handles);

function varargout = Angular_Distribution_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function VarName_Callback(hObject, ~, handles) %#ok<*DEFNU>
handles.Variable_Name = get(hObject, 'String');
guidata(hObject, handles);

function VarName_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Select_Data_Callback(hObject, ~, handles)
str = handles.Variable_Name;
handles.Data = evalin('base', str);
set(handles.Update,'Enable','on')
guidata(hObject, handles);

function R_min_limit_Callback(hObject, ~, handles)
handles.Rmin = str2double(get(handles.R_min_limit,'String'));
guidata(hObject, handles);

function R_min_limit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function R_max_limit_Callback(hObject, ~, handles)
handles.Rmax = str2double(get(handles.R_max_limit,'string'));
guidata(hObject, handles);

function R_max_limit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Spacing_Callback(hObject, ~, handles)
handles.Theta_Spacing = str2double(get(hObject,'string'));
guidata(hObject, handles);

function Spacing_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Update_Callback(hObject, ~, handles)
set(handles.Update,'Enable','off')
drawnow
try 
    [Tm, Theta] = Angular_Distribution_Function(handles.Data, handles.Rmin, handles.Rmax, handles.Theta_Spacing);
    figure('Name','Angular Distribution','NumberTitle','off');
    polarplot(Tm, Theta)
    ax = gca;
    ax.RAxisLocation = 0;
    thetaticks(0:45:315)
    set(handles.Update,'Enable','on')
catch
    msg = 'Something has gone wrong.  Check your inputs.';
    warndlg(msg);
    set(handles.Update,'Enable','on')
end
guidata(hObject, handles);


function Help_Callback(hObject, ~, handles)

run('Help_AD.m');

guidata(hObject, handles);
