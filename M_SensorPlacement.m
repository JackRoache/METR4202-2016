%%
if exist('frame', 'var')==0
    display('Can Not Place Axis Without Calibration');
else
    display('Ready to detect Central Frame. Press Any Key to Continue...');
    pause
    
    start([colorVid]);
    
    trigger(colorVid);
    [f, time, meta] = getdata(colorVid);

    stop([colorVid]);
    
    %Flips left and right to give real view with fliplr
    frame = cat(4,frame, fliplr(f));

    display('Central Frame Captured. Estimating...');

    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(frame);

    squareSize = 25.125;
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    [params, ~, estimateErrors] = estimateCameraParameters(imagePoints, worldPoints);
            
    %Assumes there is 3 or more photos
    l = length(params.TranslationVectors);
    FrameTrans = params.TranslationVectors(l,:,:)
    FrameRot = params.RotationVectors(l,:,:)

end