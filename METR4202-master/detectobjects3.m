foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);
start([colorVid]);

trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);

stop([colorVid]);
figure('Position',[50,50,1900,900])
%videoReader = vision.VideoFileReader('visiontraffic.avi');
frame = imread('test_1.jpg'); % read the next video frame
foreground = step(foregroundDetector, frame);


figure; imshow(frame); title('Video Frame');

figure; imshow(foreground); title('Foreground');