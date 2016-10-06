function [dominoPos] = M_position(dominoProps, FrameR, FrameT)

dominoPos = zeros(size(dominoProps,3));

for i=1:length(dominoProps)
    area = dominoProps(i,6);  
    centroid = dominoProps(i,1:2);
    
    dominoPos(i, 1:2) = cameraParams.pointsToWorld(FrameR, FrameT, centroid);
    dominoPos(i, 3) = 0;
end
    
end
