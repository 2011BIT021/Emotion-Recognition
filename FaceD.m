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
while (nFrames < 100)
videoFrame = step(videoFileReader);
[hueChannel,~,~] = rgb2hsv(videoFrame);
bbox = step(tracker, hueChannel);
videoOut = step(boxInserter, videoFrame, bbox);
step(videoPlayer, videoOut);
nFrames = nFrames + 1;
end
release(videoFileReader);
release(videoPlayer);
