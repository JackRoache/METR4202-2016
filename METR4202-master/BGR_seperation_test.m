%% Delete previous input if it's running already
try 
    delete([colorVid]);
    catch ME
     fprintf('Error thrown deleting colorvid');
end
 %% Remove previous input if it exists
clear colorVid;

%% Initialize color video device

%%Get videoinput (vi) object
colorVid = videoinput('kinect', 1, 'BGR_1920x1080');

%Set input settings
colorVid.FramesPerTrigger = 1;  %Only request one frame per trigger call
colorVid.TriggerRepeat = Inf;   %Tell vi object to allow inf trigger calls

%% Set trigger config for vi objects
triggerconfig([colorVid], 'manual');

%% Start vi devices
start([colorVid]);

%% Get and display 200 frames from vi devices

%Set up viewing figure. Position of window and width and height.
figure('Position', [50, 50, 1800, 950]);


% Setup plot
set(gca,'units','pixels');
set(gca,'xlim',[0 255]);
set(gca,'ylim',[0 255]);

% Aquire size of video image format
size = colorVid.VideoResolution;

%Take photo
trigger([colorVid])

%Save photo into 3 matrices
[colorIm, colorTime, colorMeta] = getdata(colorVid);

%extract red, green and blue channels
red = colorIm(:,:,1);
green = colorIm(:,:,2);
blue = colorIm(:,:,3);

%make a zero matrix of the same photo size
a = zeros(size(2),size(1));

%Make purely red, green or blue images
colorIm_Red = cat(3,red,a,a);
colorIm_Green = cat(3,a,green,a);
colorIm_Blue = cat(3,a,a,blue);
%Reconstruct Image from colour channels
colorIm_fucked = cat(3,red,green,blue);

%plot each image
subplot(2, 2, 1);
im = image(colorIm_Red);
im.CDataMapping = 'scaled'
axis image;

subplot(2, 2, 2);
im = image(colorIm_Green);
im.CDataMapping = 'scaled'
axis image;

subplot(2, 2, 3);
im = image(colorIm_Blue);
im.CDataMapping = 'scaled'
axis image;

subplot(2, 2, 4);
im = image(colorIm_fucked);
im.CDataMapping = 'scaled'
axis image;

%% Cleanup vi devices
delete([colorVid]);
clear colorVid;