function [domino] = C_position(domino, cameraParams, FrameR, FrameT, cropPoint)
    
    fid2robo_x = 32;
    fid2robo_y = 55+13*3;
    fid2robo_z = -25;
    
    centroid = double(domino.frameDetails.Centroid);
    xy = pointsToWorld(cameraParams, FrameR, FrameT, centroid + cropPoint);
    
    % Swap axis from fid to robo
    y = xy(1) - fid2robo_x;
    x = xy(2) - fid2robo_y;
    z = 0 - fid2robo_z;
    
    domino.roboDetails.Centroid = [x y z];
    
end
