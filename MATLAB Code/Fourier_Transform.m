function varargout = Fourier_Transform(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fourier_Transform_OpeningFcn, ...
                   'gui_OutputFcn',  @Fourier_Transform_OutputFcn, ...
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

function Fourier_Transform_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
handles.colormap_name_string = 'parula';
set(handles.Crop,'Enable','off')
set(handles.Invert,'Enable','off')
set(handles.Plot,'Enable','off')
guidata(hObject, handles);

function varargout = Fourier_Transform_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function Upload_Callback(hObject, ~, handles) %#ok<*DEFNU>
set(handles.Upload,'Enable','off')
try
    %Uploads selected image
    [name,path, idx]=uigetfile({'*.*'});
    t = fullfile(path, name);
    A = imread(t);
    
    %Converts image into a grayscale image and converts it from an image
    %into a double 
    s = size(A);
    if length(s) == 3
        handles.A_calc = rgb2gray(im2double(A));
    else
        handles.A_calc = im2double(A);
    end
    figdef = get(0,'defaultfigureposition');
    handles.figpos = [100 100 figdef(3) figdef(4)];
    handles.f = figure('Position', handles.figpos);
    handles.ax = axes(handles.f);
    imagesc(handles.ax, handles.A_calc);
    colormap gray
    axis equal
    axis off
    
    %Performs FFT on the image data
    handles.Image_FFT = abs(fftshift(fft2(handles.A_calc)));
    set(handles.Crop,'Enable','on')
    set(handles.Invert,'Enable','on')
    set(handles.Plot,'Enable', 'on')
    
    
catch
    %Displays a warning if the FFT process fails
    if idx ~= 0
        msg = 'Something has gone wrong.  Check your image.';
        warndlg(msg);
        set(handles.Upload,'Enable','on')
    end
end

set(handles.Upload,'Enable','on')
   
guidata(hObject, handles)

function colormap_name_Callback(hObject, ~, handles)
handles.colormap_name_string = get(hObject,'String');
guidata(hObject, handles)

function colormap_name_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Plot_Callback(hObject, ~, handles)
set(handles.Plot,'Enable','off')

try
    %Creates a figure and shows the FFT, the colormap can be changed as
    %needed
    handles.colormap_name_string = get(handles.colormap_name,'String');
    figure('Name','Fourier Transform','NumberTitle','off');
    imagesc(handles.Image_FFT)
    axis equal
    set(gca, 'visible', 'off')
    colormap(gca,handles.colormap_name_string)
    set(handles.Plot,'Enable','on')
    
    try
        close(handles.f)
    catch
    end
    
catch
    %Displays a warning if the FFT process fails
    msg = 'Something has gone wrong.  Check your image.';
    warndlg(msg);
    set(handles.Upload,'Enable','on')
end


guidata(hObject, handles)

function Crop_Callback(hObject, ~, handles)

if ishghandle(handles.f) == 1 
    handles.A_calc = imcrop(handles.ax);
else
    figdef = get(0,'defaultfigureposition');
    handles.figpos = [100 100 figdef(3) figdef(4)];
    handles.f = figure('Position', handles.figpos);
    handles.ax = axes(handles.f);
    imagesc(handles.ax, handles.A_calc);
    colormap gray
    axis equal
    axis off
    
    handles.A_calc = imcrop(handles.ax);

end

handles.Image_FFT = abs(fftshift(fft2(handles.A_calc)));
close(handles.f)

figdef = get(0,'defaultfigureposition');
handles.figpos = [100 100 figdef(3) figdef(4)];
handles.f = figure('Position', handles.figpos);
handles.ax = axes(handles.f);
imagesc(handles.ax, handles.A_calc);
colormap gray
axis equal
axis off

guidata(hObject, handles)

function Invert_Callback(hObject, ~, handles)

close(handles.f)

handles.A_calc = imcomplement(handles.A_calc);
handles.Image_FFT = abs(fftshift(fft2(handles.A_calc)));

figdef = get(0,'defaultfigureposition');
handles.figpos = [100 100 figdef(3) figdef(4)];
handles.f = figure('Position', handles.figpos);
handles.ax = axes(handles.f);
imagesc(handles.ax, handles.A_calc);
colormap gray
axis equal
axis off

guidata(hObject, handles)

% --------------------------------------------------------------------
function Help_Callback(hObject, ~, handles)
run('Help_FFT.m')
guidata(hObject, handles)
