%%
function [FrameTrans, FrameRot] = M_SensorPlacement(colorVid, frame, params)

if exist('frame', 'var')==0
    display('Can Not Place Axis Without Calibration');
else
    noPic = 1;
    while noPic == 1
        display('Ready to detect Central Frame. Press Any Key to Continue...');
        pause

        start([colorVid]);

        trigger(colorVid);
        [f, time, meta] = getdata(colorVid);

        stop([colorVid]);

        %Flips left and right to give real view with fliplr
         frame = cat(4,frame, fliplr(f));
%         frame = f;

        display('Central Frame Captured. Estimating...');

        [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(frame);

        squareSize = 25.125;
        worldPoints = generateCheckerboardPoints(boardSize, squareSize);
        [params, imagesUsed, ~] = estimateCameraParameters(imagePoints, worldPoints);
        if imagesUsed(end)==0
            display('Poor image for frame reference. Please take again');
        else
            FrameRot = params.RotationMatrices(:,:,end);
            FrameTrans = params.TranslationVectors(end,:);
            noPic = 0;
            norm(FrameTrans)
        end    
    end
    
    %Assumes there is 3 or more photos
%     l = length(params.TranslationVectors);
%     FrameTrans = params.TranslationVectors;%(l,:,:);
%     FrameRot = params.RotationVectors(l,:,:);

end