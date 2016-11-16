function [FrameR, FrameT, cameraParams] = M_Run_Cal

try
    stop(colorVid);
catch ME
end

[colorVid, depthVid] = M_StartKinect();

%%
[cameraParams, estimateError, frames] = M_Calibration(colorVid);
% 
%%
[FrameT,FrameR] = M_SensorPlacement(colorVid, frames, cameraParams);
display(sprintf('Translation vector of frame from camera: x = %d, y = %d, z = %d', FrameT(1), FrameT(2), FrameT(3)));
display(sprintf('Magnitude of translation vector: %d mm', norm(FrameT)));
Eul = round(rad2deg(M_rot2eu('xyx', FrameR)));
display(sprintf('Rotation Vector of frame from camera: x = %d, y = %d, x = %d', Eul(1), Eul(2), Eul(3)));
end