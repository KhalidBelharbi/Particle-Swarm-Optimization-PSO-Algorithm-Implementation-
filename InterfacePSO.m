function varargout = InterfacePSO(varargin)
% INTERFACEPSO MATLAB code for InterfacePSO.fig
%      INTERFACEPSO, by itself, creates a new INTERFACEPSO or raises the existing
%      singleton*.
%
%      H = INTERFACEPSO returns the handle to a new INTERFACEPSO or the handle to
%      the existing singleton*.
%
%      INTERFACEPSO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACEPSO.M with the given input arguments.
%
%      INTERFACEPSO('Property','Value',...) creates a new INTERFACEPSO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InterfacePSO_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InterfacePSO_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InterfacePSO

% Last Modified by GUIDE v2.5 12-Dec-2016 20:44:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InterfacePSO_OpeningFcn, ...
                   'gui_OutputFcn',  @InterfacePSO_OutputFcn, ...
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


% --- Executes just before InterfacePSO is made visible.
function InterfacePSO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InterfacePSO (see VARARGIN)

% Choose default command line output for InterfacePSO
handles.output = hObject;
% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('D:\Workspace MATLAB\Master 2 Matlab\IBI\Totale\PSO graphique\bk\InterfaceCentrale.png'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InterfacePSO wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InterfacePSO_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ImportButton.
function ImportButton_Callback(hObject, eventdata, handles)



global emplacement;
global matDistance;
global path;
global coordonner;
[FileName, dossier] = uigetfile('*.txt');
path = fullfile(dossier,FileName);

emplacement=get(handles.edit1,'string');


 matDistance=getMatriceDistances(path);

 set(handles.tableMatCoutTAG,'Data', matDistance);
 set(handles.tableMatCoutTAG,'visible','on');


axes(handles.axes1)

h = worldmap(emplacement);



ssss=strcat('\fontsize{16}{\color[rgb]{0 .5 .5}',emplacement,' }');


title([ssss]);
%h=worldmap({'Africa','India'})
landareas = shaperead('landareas.shp','UseGeoCoords', true);
%geoshow (landareas, 'FaceColor', [1 1 .5]);
geoshow(landareas, 'FaceColor', [0.15 0.5 0.15])



for i=1:size(coordonner,1)    
    geoshow(coordonner(i,1)/1000,coordonner(i,2)/1000, 'Marker','.','MarkerSize',10,'MarkerEdgeColor','yellow')
 %    textm(coordonner(i,1)/1000,(coordonner(i,2)/1000) + 0.001, strcat(num2str(i)));    
end
%set(handles.axes1,'visible','on');











function LancerButton_Callback(hObject, eventdata, handles)


global emplacement;
global matDistance;
global path;
global coordonner;

nbrIterMax=str2num(get(handles.Iterations,'string'));
nbrAgs=str2num(get(handles.nbrAgents,'string'));

alpha1=str2num(get(handles.Alpha1,'string'));
alpha2=str2num(get(handles.edit7,'string'));


betta1=str2num(get(handles.Beta1,'string'));
betta2=str2num(get(handles.Beta2,'string'));


Vitesse=str2num(get(handles.Vitesse,'string'));

inertie=str2num(get(handles.Inertie,'string'));


tic

%                                 path,nbrAgents,w,alpha1,beta1,alpha2,beta2,vitesseMax,iterationMax
[solution,cout,populationSolution] = Pso_Algorithme_PATH(path,nbrAgs,inertie,alpha1,betta1,alpha2,betta2,Vitesse,nbrIterMax);




toc

set(handles.tableSolutionTAG,'visible','on');
set(handles.tableSolutionTAG,'Data',solution);
set(handles.text4,'string',num2str(cout));





% dessiner le résultat

%axes(handles.axes1);

%-------------------------------------------------------------------------------------
figure;
h = worldmap(emplacement);
landareas = shaperead('landareas.shp','UseGeoCoords', true);
geoshow(landareas, 'FaceColor', [0.15 0.5 0.15])


for i=1:size(coordonner,1)    
    geoshow(coordonner(i,1)/1000,coordonner(i,2)/1000, 'Marker','.','MarkerSize',10,'MarkerEdgeColor','yellow')
    textm(coordonner(i,1)/1000,(coordonner(i,2)/1000) + 0.001, strcat(num2str(i)),'Color','yellow'); 
end

vectLat=[];
vectLong=[];

for i=1:size(solution,2)
    
    vectLat=[vectLat coordonner(solution(1,i),1)/1000];
    vectLong=[vectLong coordonner(solution(1,i),2)/1000];
    
end

geoshow(vectLat, vectLong,'LineWidth',2);

geoshow(coordonner(solution(1,1),1)/1000,coordonner(solution(1,1),2)/1000, 'Marker','.','MarkerSize',11,'MarkerEdgeColor','red');

%-------------------------------------------------------------------------------------



% 
% axes(handles.axes1); % afficher le cycle hamiltonien
% 
% for i=1:size(solution,2)-1
%     
%     plot3m(coordonner(solution(1,i),1),lon,z,'w','LineWidth',2)
% end
% 














function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
set(handles.text4,'string','');
set(handles.tableMatCoutTAG,'visible','off');
set(handles.tableSolutionTAG,'visible','off');

set(handles.axes1,'visible','off');


function Iterations_Callback(hObject, eventdata, handles)
% hObject    handle to Iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Iterations as text
%        str2double(get(hObject,'String')) returns contents of Iterations as a double


% --- Executes during object creation, after setting all properties.
function Iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nbrAgents_Callback(hObject, eventdata, handles)
% hObject    handle to nbrAgents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbrAgents as text
%        str2double(get(hObject,'String')) returns contents of nbrAgents as a double


% --- Executes during object creation, after setting all properties.
function nbrAgents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbrAgents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Alpha1_Callback(hObject, eventdata, handles)
% hObject    handle to Alpha1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Alpha1 as text
%        str2double(get(hObject,'String')) returns contents of Alpha1 as a double


% --- Executes during object creation, after setting all properties.
function Alpha1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Alpha1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Beta1_Callback(hObject, eventdata, handles)
% hObject    handle to Beta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Beta1 as text
%        str2double(get(hObject,'String')) returns contents of Beta1 as a double


% --- Executes during object creation, after setting all properties.
function Beta1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Beta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Segma_Callback(hObject, eventdata, handles)
% hObject    handle to Segma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Segma as text
%        str2double(get(hObject,'String')) returns contents of Segma as a double


% --- Executes during object creation, after setting all properties.
function Segma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Segma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Beta2_Callback(hObject, eventdata, handles)
% hObject    handle to Beta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Beta2 as text
%        str2double(get(hObject,'String')) returns contents of Beta2 as a double


% --- Executes during object creation, after setting all properties.
function Beta2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Beta2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Inertie_Callback(hObject, eventdata, handles)
% hObject    handle to Inertie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Inertie as text
%        str2double(get(hObject,'String')) returns contents of Inertie as a double


% --- Executes during object creation, after setting all properties.
function Inertie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Inertie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Vitesse_Callback(hObject, eventdata, handles)
% hObject    handle to Vitesse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vitesse as text
%        str2double(get(hObject,'String')) returns contents of Vitesse as a double


% --- Executes during object creation, after setting all properties.
function Vitesse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vitesse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
