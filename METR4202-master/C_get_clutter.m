function obstacle_list = C_get_clutter(wsbackground, wsclutter, cameraParams, FrameR, FrameT, cropPoint)
    I=wsclutter-wsbackground;
    BW = im2bw(I,0.2);
    BWf=bwareafilt(BW,[10 10000]);
    bbox = regionprops(BWf,'BoundingBox');
    px = [];
    robot=[];
    clutterbox=[];
    for h=1:(length(bbox))
        p1=[];
        bboxA = bbox(h).BoundingBox;
        i=1;
        bboxxy = [bboxA(i),bboxA(i+1)];
        bboxx1y = [bboxA(i)+bboxA(i+2),bboxA(i+1)];
        bboxxy1 = [bboxA(i),bboxA(i+1)+bboxA(i+3)];
        bboxx1y1 = [bboxA(i)+bboxA(i+2),bboxA(i+1)+bboxA(i+3)];
        p1=cat(1,p1,bboxxy,bboxx1y,bboxxy1,bboxx1y1);
        px = cat(3,px,p1);
    end
    
    grid_obstacles = [];
    if ~isempty(px)
        for j=1:size(px,3)
            obstacle_pixel = px(:,:,j);
            point_rec = [];
            for p=1:4
                row_pixel = obstacle_pixel(p,:);
                robo_obs = C_positionGeneral(row_pixel, cameraParams, FrameR, FrameT, cropPoint);
                grid_obs = C_robo2grid(robo_obs);
                snap_obs = C_gridsnap(grid_obs);
                point_rec = cat(1,point_rec,snap_obs);
            end    
            grid_obstacles = cat(3,grid_obstacles,point_rec);
        end
        
        obstacle_list = {[8 5]};
        for l=1:size(grid_obstacles,3)
            obstacle = grid_obstacles(:,:,l);
            maxX = max(obstacle(:,1));
            minX = min(obstacle(:,1));
            maxY = max(obstacle(:,2));
            minY = min(obstacle(:,2));
            for a=minX:maxX
                for b=minY:maxY
                    obstacle_list = cat(1,obstacle_list,[a,b]);
                end
            end
        end
    else
        obstacle_list = {[8 5]};
    end
    
end
                

