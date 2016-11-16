function [domino] = M_position(domino, cameraParams, FrameR, FrameT, cropPoint)
 
    centroid = double(domino.frameDetails.Centroid);
    xy = pointsToWorld(cameraParams, FrameR, FrameT, centroid + cropPoint);
    domino.roboDetails.Centroid = [xy(1) xy(2) 0];
    
end
