function [dominoPos] = M_position(dominoProps, cameraParams, FrameR, FrameT)

dominoPos = zeros(size(dominoProps,3));

for i=1:size(dominoProps,1)
%     area = dominoProps(i,6);  
    centroid = dominoProps(i,1:2);
    
    dominoPos(i, 1:2) = pointsToWorld(cameraParams, FrameR, FrameT, centroid);
    dominoPos(i, 3) = 0;
    
end
    
end
