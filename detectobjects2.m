foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);
tic;
colorVid = videoinput('kinect', 1, 'BGR_1920x1080');
colorVid.FramesPerTrigger = 1;  %Only request one frame per trigger call
colorVid.TriggerRepeat = Inf;   %Tell vi object to allow inf trigger calls

depthVid = videoinput('kinect', 2, 'Depth_512x424');

%Set input settings
depthVid.FramesPerTrigger = 1;  %Only request one frame per trigger call
depthVid.TriggerRepeat = Inf;   %Tell vi object to allow inf trigger calls

triggerconfig([colorVid depthVid], 'manual');

start([colorVid depthVid]);

figure('Position', [50, 50, 1800, 950]);

% There are many ways to plot an image
% 'imshow' tends to be the easiest how ever it is slow
% the following constructs and image object that can
% have its data overwritten directly improving image display
% performance

% Construct Color image subplot
subplot(1, 2, 1);
% Setup plot
set(gca,'units','pixels');
set(gca,'xlim',[0 255]);
set(gca,'ylim',[0 255]);

% Aquire size of video image format
size = colorVid.VideoResolution;

% Construct image display object
cim = image(...
    [1 size(1)],...
    [1 size(2)],...
    zeros(size(2), size(1), 3),...
    'CDataMapping', 'scaled'...
);

% Ensure axis is set to improve display
axis image;

% Construct Depth image subplot
subplot(1, 2, 2);

% Setup plot
set(gca,'units','pixels');
set(gca,'xlim',[0 255]);
set(gca,'ylim',[0 255]);

% Aquire size of video image format
size = depthVid.VideoResolution;

% Construct image display object
% Remember depth image is single channel where color is 3 channels
dim = image(...
    [1 size(1)],...
    [1 size(2)],...
    zeros(size(2), size(1)),...
    'CDataMapping', 'scaled'...
);

% Ensure axis is set to improve display
axis image;



%immovie(colorVid,'colorVid.avi')
videoReader = vision.VideoFileReader('colorVid.avi');
for i = 1:100
    trigger([colorVid depthVid])

    % Get the color frame and metadata.
    [colorIm, colorTime, colorMeta] = getdata(colorVid);

    % Get the depth frame and metadata.
    [depthIm, depthTime, depthMeta] = getdata(depthVid);

    % Update data in image display objects
    set(cim, 'cdata', colorIm); %Color
    set(dim, 'cdata', depthIm); %Depth
        
    frame = step(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
end
figure; imshow(frame); title('Video Frame');
figure; imshow(foreground); title('Foreground');

se = strel('square', 3);
filteredForeground = imopen(foreground, se);
figure; imshow(filteredForeground); title('Clean Foreground');

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 150);
bbox = step(blobAnalysis, filteredForeground);

result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');

numCars = size(bbox, 1);
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
    'FontSize', 14);
figure; imshow(result); title('Detected Cars');

videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
se = strel('square', 3); % morphological filter for noise removal



while ~isDone(videoReader)

    frame = step(videoReader); % read the next video frame

    % Detect the foreground in the current video frame
    foreground = step(foregroundDetector, frame);

    % Use morphological opening to remove noise in the foreground
    filteredForeground = imopen(foreground, se);

    % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    bbox = step(blobAnalysis, filteredForeground);

    % Draw bounding boxes around the detected cars
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');

    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);

    step(videoPlayer, result);  % display the results
end

release(videoReader); % close the video file
delete([colorVid depthVid]);
clear colorVid;
clear depthVid;
toc;