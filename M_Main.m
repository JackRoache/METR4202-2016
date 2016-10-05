%%
clear
clc

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




