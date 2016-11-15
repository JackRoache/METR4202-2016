function [robo_x, robo_y] = C_positionGeneral(pixel_x, pixel_y, cameraParams, FrameR, FrameT, cropPoint)
 
    centroid = [pixel_x pixel_y];
    [robo_x, robo_y] = pointsToWorld(cameraParams, FrameR, FrameT, centroid + cropPoint);
        
end
