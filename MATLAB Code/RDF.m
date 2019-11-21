function varargout = RDF(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RDF_OpeningFcn, ...
                   'gui_OutputFcn',  @RDF_OutputFcn, ...
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

function RDF_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
set(handles.Update,'Enable','off')
handles.Variable_Name = 'Data';
handles.RDF_Option = 0;

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

function varargout = RDF_OutputFcn(~, ~, handles)
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
set(handles.popupmenu1,'Value', 1);
handles.RDF_Option = 0;
set(handles.R_Limit, 'string', ' ')
handles.Rlim =  [];
drawnow
    
guidata(hObject, handles);

function R_Limit_Callback(hObject, ~, handles)
handles.Rlim = str2double(get(handles.R_Limit,'String'));
guidata(hObject, handles);

function R_Limit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Number_Of_Bins_Callback(hObject, ~, handles)
handles.NumOfBins = str2double(get(hObject,'string'));
guidata(hObject, handles);

function Number_Of_Bins_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu1_Callback(hObject, ~, handles)
handles.RDF_Option = get(hObject,'Value') - 1;

try
    Data = handles.Data; %#ok<NASGU>
    data_test = 1;
catch
    data_test = 0;
end

if data_test == 1
    if handles.RDF_Option == 0
        set(handles.R_Limit, 'string', ' ')
        handles.Rlim =  [];
        drawnow

    elseif handles.RDF_Option == 2
        Xlim = max(handles.Data(:,1))/2;
        Ylim = max(handles.Data(:,2))/2;
        Lims = min([Xlim, Ylim]);
        Rlim = abs(Lims)/2;
        set(handles.R_Limit, 'string', Rlim)
        handles.Rlim =  Rlim;
        drawnow

    elseif handles.RDF_Option == 3
        Xlim = max(handles.Data(:,1))/2;
        Ylim = max(handles.Data(:,2))/2;
        Lims = min([Xlim, Ylim]);
        Rlim = abs(Lims);
        set(handles.R_Limit, 'string', Rlim)
        handles.Rlim =  Rlim;
        drawnow

    else
        Xlim = max(handles.Data(:,1))/2;
        Ylim = max(handles.Data(:,2))/2;
        Rlim = sqrt(Xlim^2 + Ylim^2);
        set(handles.R_Limit, 'string', Rlim)
        handles.Rlim =  Rlim;
        drawnow

    end
    
else
    set(handles.R_Limit, 'string', ' ')
    handles.Rlim =  [];
    drawnow
    
end

guidata(hObject, handles);


function popupmenu1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Update_Callback(hObject, ~, handles)
set(handles.Update,'Enable','off')
drawnow
try 
    
    switch handles.RDF_Option
        case 1
            [X, Y] = RDF_Function(handles.Data, handles.Rlim, handles.NumOfBins);
            
        case 2
            [X, Y] = RDF_GA_Function(handles.Data, handles.Rlim, handles.NumOfBins);
            
        case 3
            [X, Y] = RDF_PCBs_Function(handles.Data, handles.Rlim, handles.NumOfBins);
            
    end
    
    figure('Name','RDF','NumberTitle','off');
    plot(X, Y)
    xlabel('Distance')
    ylabel('g(R)')
    set(handles.Update,'Enable','on')
    drawnow
catch
    msg = 'Something has gone wrong.  Check your inputs.';
    warndlg(msg);
    set(handles.Update,'Enable','on')
end
guidata(hObject, handles);

function Help_Callback(hObject, ~, handles)

run('Help_RDF.m');

guidata(hObject, handles);
