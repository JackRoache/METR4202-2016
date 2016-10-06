try 
    stop(colorVid);
catch ME
end

[colorVid, depthVid] = M_StartKinect();

% Basic testing code. Takes in the webcam input.
% delete colorVid;
% clear colorVid;
% colorVid = videoinput('winvideo', 1);
% colorVid.FramesPerTrigger = 1;
% colorVid.TriggerRepeat = Inf;
% triggerconfig(colorVid, 'manual');

%%
[cameraParams, estimateError, frames] = M_Calibration(colorVid);

%%
[FrameT,FrameR] = M_SensorPlacement(colorVid, frames, cameraParams);

start(colorVid);

% clf

while 1
    % Take Frame
    trigger(colorVid);
    [colorIm, time, meta] = getdata(colorVid);
    % Image Filter
    
    % Blob Analysis
    
     % Hough Lines Analysis
    
    % Object Filter
    
    % Positioning
    
    % Tracking
    
    % Display Data
    
    hold on
%     imshow(colorIm);
    
    hold off;
end



% pause;
% start(colorVid);
% trigger(colorVid);
% [f, time, meta] = getdata(colorVid);
% stop(colorVid);
% %1000 is whats measured. 1250mm^2 for the domino. 
% distance = M_Distance(ixelArea, 1000, 1250);
% [x,y] = cameraParams.pointsToWorld(FrameR, FrameT, undistortPoints(pixelPoint, cameraparams));
% z = Frame(t) - distance * FrameR;
% z = z(3);
%x,y and z are wrt to the real world.





