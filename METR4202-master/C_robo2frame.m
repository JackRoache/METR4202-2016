function [frame_x, frame_y] = C_robo2frame(robo_x, robo_y, robo_z, cameraParams, trans, rot, cropPoint)
    
    fid2robo_x = 94;
    fid2robo_y = 32;
    fid2robo_z = -25;

    robo_x = robo_x + fid2robo_x;
    robo_y = robo_y + fid2robo_y;
    robo_z = robo_z + fid2robo_z;
    
    trans = transpose(trans);
    rot = transpose(rot);
    principle_x = cameraParams.PrincipalPoint(1);
    principle_y = cameraParams.PrincipalPoint(2);
    f = mean(cameraParams.FocalLength);
    cropX = cropPoint(1);
    cropY = cropPoint(2);
    
    numPoints = numel(robo_x);
    
    for i=1:numPoints
        
        robo_point = [robo_y(i); robo_x(i); robo_z(i)];
        camera_point = trans+rot*robo_point;
        camera_x = camera_point(1);
        camera_y = camera_point(2);
        camera_z = camera_point(3);

        frame_x(i) = f*camera_x/camera_z+principle_x-cropX;
        frame_y(i) = f*camera_y/camera_z+principle_y-cropY;
    
    end
end