function [rbt] = C_positionGeneral(pixel, cameraParams, FrameR, FrameT, cropPoint)
 
    fid2robo_x = 32;
    fid2robo_y = 55+13*3;

    robo_xy = pointsToWorld(cameraParams, FrameR, FrameT, pixel + cropPoint);
    
    robo_y = robo_xy(1) - fid2robo_x;
    robo_x = robo_xy(2) - fid2robo_y;
    rbt = [robo_x robo_y];
    
end
