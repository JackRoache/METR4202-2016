%%
% clear
% clc

%%
% [colorVid, depthVid] = M_StartKinect();

% Basic testing code. Takes in the webcam input.
delete colorVid;
clear colorVid;
colorVid = videoinput('winvideo', 1);
colorVid.FramesPerTrigger = 1;
colorVid.TriggerRepeat = Inf;
triggerconfig(colorVid, 'manual');

%%
[cameraParams, estimateError, frames] = M_Calibration(colorVid);

%%
[FrameT,FrameR] = M_SensorPlacement(colorVid, frames);

pause;
start(colorVid);
trigger(colorVid);
[f, time, meta] = getdata(colorVid);
stop(colorVid);

%1000 is whats measured. 1250mm^2 for the domino. 
distance = M_Distance(pixelArea, 1000, 1250) - FrameT(3);
[x,y] = cameraParams.pointsToWorld(FrameR, FrameT, undistortPoints(pixelPoint, cameraparams));
%x,y and z are wrt to the real world.





