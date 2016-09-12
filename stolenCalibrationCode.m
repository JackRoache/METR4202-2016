% vid = videoinput('kinect', 1); %//colour camera
vid.FramesPerTrigger = 1;
frame = [];

for k = 1:4
    start(vid);
    trigger(vid);
    
    [f, time, meta] = getdata(vid);
    frame = cat(4,frame, f);
    stop(vid);
    display('frame captured');
    pause(2)
end

[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(frame);

squareSize = 24;
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

[params, ~, estimateErrors] = estimateCameraParameters(imagePoints, worldPoints);

figure;
showExtrinsics(params, 'CameraCentric');
pause
figure;
showExtrinsics(params, 'PatternCentric');
