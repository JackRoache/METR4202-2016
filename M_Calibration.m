%%Assumes Kinect is turned on and running

%% Take photos
function [params, estimateErrors, frames] = M_Calibration(colorVid)
squareSize = 25.125;
frames = [];
NumberOfPhotos = 2;

start(colorVid);
sumErrors = 100;

display(sprintf('Ready to take Frame 1. Press any key to take next frame...'));
pause
trigger(colorVid);
[f, ~, ~] = getdata(colorVid);

%Flips left and right to give real view with fliplr
frames = cat(4,frames, fliplr(f));

while sumErrors > 5;
    display(sprintf('Ready to take Frame %d. Press any key to take next frame...',NumberOfPhotos));
    pause
    trigger(colorVid);
    [f, ~, ~] = getdata(colorVid);
    
    %Flips left and right to give real view with fliplr
    frames = cat(4,frames, fliplr(f));
    try
        [imagePoints, boardSize, ~] = detectCheckerboardPoints(frames);
        
        worldPoints = generateCheckerboardPoints(boardSize, squareSize);
        
        [params, used, estimateErrors] = estimateCameraParameters(imagePoints, worldPoints);
        
        sumErrors = mean(estimateErrors.ExtrinsicsErrors.TranslationVectorsError);
        if used(end) > 0
            NumberOfPhotos = NumberOfPhotos + 1;
            displayErrors(estimateErrors, params);
        else
            display('Poor image taken, new frame needed');
        end
        
    catch ME
        display('Poor image taken, new frame needed');
    end
end
stop([colorVid]);

% figure(1);
showExtrinsics(params, 'CameraCentric');
displayErrors(estimateErrors, params);
display(sprintf('\n\n\nNumber of frames used: %d\n\n\n', sum(used)));

end