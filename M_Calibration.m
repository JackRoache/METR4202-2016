%%Assumes Kinect is turned on and running

%% Take photos
function [params, estimateErrors, frames] = M_Calibration(colorVid)

frames = [];
NumberOfPhotos = 4;

start(colorVid);
for k = 1:NumberOfPhotos
    display(sprintf('Ready to take Frame %d/%d. Press any key to take next frame...', k, NumberOfPhotos));
    pause
    trigger(colorVid);
    [f, time, meta] = getdata(colorVid);
    
    %Flips left and right to give real view with fliplr
    frames = cat(4,frames, fliplr(f));
end
stop([colorVid]);

display('All Frames Captured. Calibrating...');

[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(frames);

squareSize = 25.125;
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

[params, ~, estimateErrors] = estimateCameraParameters(imagePoints, worldPoints);

% figure(1);
% showExtrinsics(params, 'CameraCentric');
% displayErrors(estimateErrors, params);
end