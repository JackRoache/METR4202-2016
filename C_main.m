close all

%%%%% Open camera or recorded video
% video = VideoReader('dark-5-bl.avi');
video = videoinput('kinect');
video.FramesPerTrigger = 1;
video.TriggerRepeat = Inf;
triggerconfig(video, 'manual');
start(video);

frameNum = 0;
% while video.hasFrame()
for loopcount = 1:100
    frameNum = frameNum + 1;
    
    % Take photo, flip, undistort and crop
    trigger(video);
    [images, times, metas] = getdata(video);
    frame = images(:,:,1:3);
    frame = fliplr(frame);
    frame = undistortImage(frame, cameraParams);
    cropParams.point = [285,100];
    cropParams.size = [1200,800];
    frame = imcrop(frame,[cropParams.point cropParams.size]);
        
    % Save the frame for later displaying
    displayIm = frame;
    
    % Make the black-white version of the picture
    hsv = rgb2hsv(frame);
    result1 = hsv(:,:,3).^4;
    bw = im2bw(result1, 0.4);
    bwf = bwareafilt(bw, [200 3000]);
    
    % Run blob analysis to create bounding boxes relative to frame (which
    % has been cropped from the raw image obtained)
    bboxes = M_Blob(bwf);
    % Increases the size of the bounding box for safety
    bboxes(:,1) = bboxes(:,1) - 10;
    bboxes(:,2) = bboxes(:,2) - 10;
    bboxes(:,3) = bboxes(:,3) + 20;
    bboxes(:,4) = bboxes(:,4) + 20;
    
    % Makes a set of lines of each domino. Each cell is a domino,
    % each entry in the cell is a start point, end point and distance.
    % Points are relative to their cropped boxes not the whole frame.
    dominoLines = {};
    for l = 1:size(bboxes,1)
        dominoLines{l} = M_Hough_Parallel(imcrop(result1, bboxes(l, 1:end)));
    end
    
    %     % Domino Struct Fields:
    %     %   dominoOrDice - 1 if domino, 0 if dice
    %     %   frameDetails (contains fields):
    %     %       Centroid - vector of x and y point
    %     %       4 Corners - vector of x's and y's
    %     %       Perimeter Points - vector of x's and y's
    %     %   boxDetails (contains fields):
    %     %       Centroid - vector of x and y point
    %     %       4 Corners - vector of x's and y's
    %     %       Perimeter Points - vector of x's and y's  
    %     %   roboDetails (contains fields):
    %     %       Centroid - vector of x,y,z
    %     %       
    %     %   bBox - x,y,width,height
    %     %   pips - vector of first value and then second value
    
    % Gives the dominos their boxDetails - 4 corners and perimeterpoints.
    % Also adds the bBox value.
    dominos = C_cornerFilter(dominoLines, bboxes);
    
    % Finds Pips. Adds the boxDetials.Centroid, adds the
    % frameDetails.Centroid and pips.
    for k = 1:numel(dominos)
        if isempty(dominos{k})
        else
            dominos{k} = C_countDots(dominos{k}, imcrop(bw, dominos{k}.bBox));
        end
    end
    
    % Assuming camera parameters are already saved in the workspace.
    % Require camera parameters, frame translation, frame rotation.
    % Adds the roboDetails.Centroid value. This is then offset from the
    % fiducial to the base of the arm. Might require a rotation as well if
    % fiducial not perfectly straight.
    xOffset = 1;
    yOffset = 1;
    zOffset = 1;
    for k = 1:numel(dominos)
        if isempty(dominos{k})
            continue;
        else
             dominos{k} =  C_position(dominos{k}, cameraParams, rot, trans, cropParams.point);
             dominos{k}.roboDetails.Centroid(1) = dominos{k}.roboDetails.Centroid(1) + xOffset;
             dominos{k}.roboDetails.Centroid(2) = dominos{k}.roboDetails.Centroid(2) + yOffset;
             dominos{k}.roboDetails.Centroid(3) = dominos{k}.roboDetails.Centroid(3) + zOffset;
        end
    end
        
    % pick random domino from dominos
    chosenDomino = C_pickRandomDomino(dominos);
    chosenCentroid = [chosenDomino.frameDetails.Centroid(1), chosenDomino.frameDetails.Centroid(2)];
    displayIm = insertMarker(displayIm, chosenCentroid, 'o', 'color', 'green', 'size', 5);
     
    %highlight 6-3
    gridStartPoint = [6 3];
    roboStartPoint = C_grid2robo(startpoint(1), startpoint(2));
    startWaypoints = C_pathToStart(chosenCentroid, roboStartPoint);
    
    
    % Plot grid on image and show for checking purposes.
    % generate the points as grid-coords then transform back to
    % assume minimal distortion.
    % place a 10x10 grid initially
    % Make the grid points
    gridsize = 6;
    gridedges = -0.5 : 1  : gridsize-0.5;
    low_vect = ones(1,gridsize+1)*(-0.5);
    high_vect = ones(1,gridsize+1)*(gridsize-0.5);
    % Change from grid to robot coords
    [robo_horiz_start_x, robo_horiz_start_y, robo_horiz_start_z] = C_grid2robo(gridedges, low_vect);
    [robo_horiz_end_x,   robo_horiz_end_y,   robo_horiz_end_z]   = C_grid2robo(gridedges, high_vect);
    [robo_vert_start_x,  robo_vert_start_y,  robo_vert_start_z]  = C_grid2robo(low_vect, gridedges);
    [robo_vert_end_x,    robo_vert_end_y,    robo_vert_end_z]    = C_grid2robo(high_vect, gridedges);
    % Get markers
    [robo_origin_x, robo_origin_y, robo_origin_z] = C_grid2robo(0, 0);
    [origin_x, origin_y] = C_robo2frame(robo_origin_x, robo_origin_y, robo_origin_z, cameraParams, trans, rot, cropParams.point);
    [robo_offset_x, robo_offset_y, robo_offset_z] = C_grid2robo(gridsize-1, 0);
    [offset_x, offset_y] = C_robo2frame(robo_offset_x, robo_offset_y, robo_offset_z, cameraParams, trans, rot, cropParams.point);
    
    displayIm = insertMarker(displayIm, [origin_x, origin_y], 'o', 'color', 'green', 'size', 5);
    displayIm = insertMarker(displayIm, [offset_x, offset_y], 'x', 'color', 'green', 'size', 5);
    
    % Change from robot to frame
    [horiz_start_x, horiz_start_y] = C_robo2frame(robo_horiz_start_x, robo_horiz_start_y, robo_horiz_start_z, cameraParams, trans, rot, cropParams.point);
    [horiz_end_x,   horiz_end_y]   = C_robo2frame(robo_horiz_end_x,   robo_horiz_end_y,   robo_horiz_end_z,   cameraParams, trans, rot, cropParams.point);
    [vert_start_x,  vert_start_y]  = C_robo2frame(robo_vert_start_x,  robo_vert_start_y,  robo_vert_start_z,  cameraParams, trans, rot, cropParams.point);
    [vert_end_x,    vert_end_y]    = C_robo2frame(robo_vert_end_x,    robo_vert_end_y,    robo_vert_end_z,    cameraParams, trans, rot, cropParams.point);
    % Plot markers for edges
    lineMatrixHoriz = [transpose(horiz_start_x) transpose(horiz_start_y) transpose(horiz_end_x) transpose(horiz_end_y)];
    lineMatrixVert = [transpose(vert_start_x) transpose(vert_start_y) transpose(vert_end_x) transpose(vert_end_y)];
    displayIm = insertShape(displayIm, 'Line', lineMatrixHoriz, 'color', 'red', 'LineWidth', 2);
    displayIm = insertShape(displayIm, 'Line', lineMatrixVert, 'color', 'red', 'LineWidth', 2);
    imshow(displayIm);

    
    % Put frame number in the picture    
    displayIm = insertText(displayIm, [0 0], num2str(frameNum), 'FontSize', 20);
    
    % Put pip values in the picture
    for k = 1:length(dominos)
        if isempty(dominos{k})
            
        else
            displayIm = insertText(displayIm,dominos{k}.frameDetails.Centroid,num2str(dominos{k}.pips),'FontSize', 30);
        end
    end
    
    % Put bounding boxes in the picture
    displayIm = insertShape(displayIm, 'Rectangle', bboxes);
    imshowpair(displayIm,bwf, 'montage');
    
    
    %     imshow(result1);
    %     hold on;
    %     for k = 1:size(dominoLines,2)
    %         lineSet = dominoLines{k};
    %         if(size(lineSet,1) > 1)
    %             for l = 1:size(lineSet,1)
    %                 c = zeros(1,4);
    %                 c(1) = lineSet(l,1) + bboxes(k,1);
    %                 c(3) = lineSet(l,3) + bboxes(k,1);
    %                 c(2) = lineSet(l,2) + bboxes(k,2);
    %                 c(4) = lineSet(l,4) + bboxes(k,2);
    %                 plot([c(1) c(3)],[c(2) c(4)], 'LineWidth',2,'Color','g');
    %             end
    %         end
    %     end
    
    
    
    
    
end

stop(video);