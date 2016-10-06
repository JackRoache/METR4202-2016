function [distance_mm] = M_Distance(Area, focal, knownArea)
%focal length needs to be calibrated with a kinect. Its currently
%1000 for my webcam. This can be done by solving the formula
%   F = sqrt(pixealArea) * distance(mm) / sqrt(actual Area (mm^2)
% this should be roughly the same for all values measured, regardless
% the distance from teh camera. 
% 
%%%% This may be a value thats calculated from the camera properties?? 
%http://www.pyimagesearch.com/2015/01/19/find-distance-camera-objectmarker-using-python-opencv/

distance_mm = sqrt(knownArea)*focal/sqrt(Area);
end

