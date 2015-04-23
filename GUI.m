function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 11-Feb-2015 10:49:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.

function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
      %Read the original RGB input image
          image=imread('ab.jpg');
      %convert it to gray scale
          image_gray=rgb2gray(image);
      %resize the image to 300x300 pixels
          image_resize=imresize(image_gray, [300 300]);
      %apply im2double
          image_resize=im2double(image_resize);
      %show the image
          figure(1);
          imshow(image_resize);
          title('Input Image');

          %Gabor filter size 7x7 and orientation 90 degree
      %declare the variables
          gamma=0.3; %aspect ratio
          psi=0; %phase
          theta=90; %orientation
          bw=2.8; %bandwidth or effective width
          lambda=3.5; % wavelength
          pi=180;
          

          for x=1:160
              for y=1:160

          x_theta=image_resize(x,y)*cos(theta)+image_resize(x,y)*sin(theta);
          y_theta=-image_resize(x,y)*sin(theta)+image_resize(x,y)*cos(theta);

           gb(x,y)= exp(-(x_theta.^2/2*bw^2+ gamma^2*y_theta.^2/2*bw^2))*cos(2*pi/lambda*x_theta+psi);

              end
          end
         

          figure(2);
          imshow(gb);
          title('Gibor filtered image');
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
%% Step 1: Detect a Face To Track
faceDetector = vision.CascadeObjectDetector();
videoFileReader = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ...
'ROI', [1 1 640 480], ...
'ReturnedColorSpace', 'rgb');
videoFrame = step(videoFileReader);
bbox = step(faceDetector, videoFrame);
boxInserter = vision.ShapeInserter('BorderColor','Custom',...
'CustomBorderColor',[255 255 0]);
videoOut = step(boxInserter, videoFrame, bbox);
figure, imshow(videoOut), title('Detected face');
%% Step 2: Identify Facial Features To Track
[hueChannel,~,~] = rgb2hsv(videoFrame);

figure, imshow(hueChannel), title('Hue channel data');
rectangle('Position',bbox(1,:),'LineWidth',2,'EdgeColor',[1 1 0]);
%% Step 3: Track the Face
noseDetector = vision.CascadeObjectDetector('Nose');
faceImage = imcrop(videoFrame,bbox);
noseBBox = step(noseDetector,faceImage);
noseBBox(1:2) = noseBBox(1:2) + bbox(1:2);
tracker = vision.HistogramBasedTracker;
initializeObject(tracker, hueChannel, noseBBox);
videoInfo = info(videoFileReader);
videoPlayer = vision.VideoPlayer('Position',[300 100 670 510]);
nFrames = 0;
while (nFrames < 70)
videoFrame = step(videoFileReader);
[hueChannel,~,~] = rgb2hsv(videoFrame);
bbox = step(tracker, hueChannel);
videoOut = step(boxInserter, videoFrame, bbox);
step(videoPlayer, videoOut);
nFrames = nFrames + 1;
end
release(videoFileReader);
release(videoPlayer);
