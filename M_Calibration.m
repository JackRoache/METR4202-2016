%%Assumes Kinect is turned on and running

%% Take photos

frame = [];
NumberOfPhotos = 4;

start([colorVid]);
for k = 1:NumberOfPhotos
    display(sprintf('Ready to take Frame %d/%d. Press any key to take next frame...', k, NumberOfPhotos));
    pause
    trigger(colorVid);
    [f, time, meta] = getdata(colorVid);
    
    %Flips left and right to give real view with fliplr
    frame = cat(4,frame, fliplr(f));
end
stop([colorVid]);

display('All Frames Captured. Calibrating...');

[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(frame);

squareSize = 25.125;
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

[params, ~, estimateErrors] = estimateCameraParameters(imagePoints, worldPoints);

figure(1);
showExtrinsics(params, 'CameraCentric');
displayErrors(estimateErrors, params);