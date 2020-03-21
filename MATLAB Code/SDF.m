function varargout = SDF(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SDF_OpeningFcn, ...
                   'gui_OutputFcn',  @SDF_OutputFcn, ...
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

function SDF_OpeningFcn(hObject, ~, handles, varargin)
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

function varargout = SDF_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function VarName_Callback(hObject, ~, handles) %#ok<*DEFNU>
handles.Variable_Name = get(hObject, 'String');
guidata(hObject, handles);

function VarName_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Select_Data_Callback(hObject, ~, handles)
str = get(handles.VarName, 'String');
handles.Variable = str;
handles.Data = evalin('base', str);
set(handles.Update,'Enable','on')
guidata(hObject, handles);

function X_limit_Callback(hObject, ~, handles)
handles.Xm = str2double(get(handles.X_limit,'String'));
guidata(hObject, handles);

function X_limit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Y_limit_Callback(hObject, ~, handles)
handles.Ym = str2double(get(handles.Y_limit,'string'));
guidata(hObject, handles);

function Y_limit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Number_Of_Bins_Callback(hObject, ~, handles)
handles.Spacing = str2double(get(hObject,'string'));
guidata(hObject, handles);

function Number_Of_Bins_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Update_Callback(hObject, ~, handles)
set(handles.Update,'Enable','off')
drawnow
try 
    [Xm, Ym, Hm] = SDF_Function(handles.Data, handles.Xm, handles.Ym, handles.Spacing);
    figure('Name','SDF','NumberTitle','off');
    s = surf(Xm, Ym, Hm);
    rotate3d on
    axis equal
    colorbar
    xlabel('X (px)')
    ylabel('Y (px)')
    s.EdgeColor = 'none';
    colormap('hot')
    
    shading(gca,'interp')
    az = 0;
    el = 90;
    view(az, el);
    set(handles.Update,'Enable','on')
catch
    msg = 'Something has gone wrong.  Check your inputs.';
    warndlg(msg);
    set(handles.Update,'Enable','on')
end
guidata(hObject, handles);

function Help_Callback(hObject, ~, handles)

run('Help_SDF.m')

guidata(hObject, handles);
