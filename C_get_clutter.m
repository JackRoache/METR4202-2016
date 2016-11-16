function clutter_obstacles = C_get_clutter(wsbackground, wsclutter)
    I=wsclutter-wsbackground;
    BW = im2bw(I,0.2);
    BWf=BWareafilt(BW,[10 10000]);
    bbox = regionprops(BW).BoundingBox;
    px = [];
    robot=[];
    clutterbox=[];
    p1=[];
    for h=1:(length(bbox)/4)
        for i=(4*(h-1)+1):(4*h);
            bboxxy = [bbox(i),bbox(i+1)];
            bboxx1y = [bbox(i)+bbox(i+3),bbox(i+1)];
            bboxxy1 = [bbox(i),bbox(i+1)+bbox(i+4)];
            bboxx1y1 = [bbox(i)+bbox(i+3),bbox(i+1)+bbox(i+4)];
            p1=cat(2,p1,bboxxy,bboxx1y,bboxxy1,bboxx1y1);
            px = cat(1,px,p1);
        end
    end
    for j =1:size(px,1)
        rbt = C_px2robot(px(j));%need to know what this takes as input
        robot=cat(1,robot,rbt);
        grid = cat(1,grid,C_robo2grid(robot(j)));
    end
    for k =1:(length(grid)/4)
        clutterbbox = cat(1,clutterbox,grid((4*(k-1)+1):(4*k)));
    end
    for l=1:length(clutterbox)
        for m=1:4
            xy=clutterbox(l,m);
            xy1=clutterbox(l,m+1);
            x1y=clutterbox(l,m+2);
            x1y1=clutterbox(l,m+3);
        end
        for n=xy(1):(x1y(1)-xy(1))
            for o=xy(2):(xy1(2)-xy(2))
                clutter_obstacles = cat(2,clutter_obstacles,[n,o]);
            end
        end
    end
end
                

