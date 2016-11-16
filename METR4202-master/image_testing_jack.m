close all

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
    trigger(video);
    [images, times, metas] = getdata(video);
    
    %     frame1 = video.readFrame();
    %     frame2 = video.readFrame();
    %     frame3 = video.readFrame();
    frame1 = images(:,:,1:3);
    %     frame2 = images(:,:,4:6);
    %     frame3 = images(:,:,7:9);
    
    %     frame = uint16(frame1) + uint16(frame2) + uint16(frame3);
    %     frame = uint8(frame / 3);
    frame = frame1;
    
    frame = fliplr(frame);
    
   
    frame = undistortImage(frame, cameraParams);
    cropParams.point = [500,0];
    cropParams.size = [1420,1080];
    frame = imcrop(frame,[cropParams.point cropParams.size]);
    hsv = rgb2hsv(frame);
    
    result1 = hsv(:,:,3).^4;
    bw = im2bw(result1, 0.4);
    bwf = bwareafilt(bw, [200 3000]);
    
    result2 = bwf;
    
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
    %     %   bBox - x,y,width,height
    %     %   pips - vector of first value and then second value
    
    % Because the lines are relative to their boxes, this function sorts
    % the corners into clockwise order and then adds the respective box to
    % the vector.
    dominos = M_Corner_Filter(dominoLines, bboxes);
    %[clean_corners, boxes, ratios, orderedPerimeter] = M_Corner_Filter(dominoLines, bboxes);
    
    % Finds Pips. where they are relative to the whole frame
    for k = 1:numel(dominos)
        if isempty(dominos{k})
        else
            dominos{k} = M_countDots(dominos{k}, imcrop(bw, dominos{k}.bBox));
        end
    end
    
    % Assuming camera parameters are already saved in the workspace.
    % Require camera parameters, frame translation, frame rotation.
    xOffset = 1;
    yOffset = 1;
    zOffset = 1;
    for k = 1:numel(dominos)
        if isempty(dominos{k})
            continue;
        else
             dominos{k} =  M_position(dominos{k}, cameraParams, rot, trans, cropParams.point);
             dominos{k}.roboDetails.Centroid(1) = dominos{k}.roboDetails.Centroid(1) + xOffset;
             dominos{k}.roboDetails.Centroid(2) = dominos{k}.roboDetails.Centroid(2) + yOffset;
             dominos{k}.roboDetails.Centroid(3) = dominos{k}.roboDetails.Centroid(3) + zOffset;
        end
    end
           
    % put in frame number on frame
    result1 = frame;
    result1 = insertText(result1, [0 0], num2str(frameNum), 'FontSize', 20);
    
    % label the dominos with their pip value
    for k = 1:length(dominos)
        if isempty(dominos{k})
            
        else
            result1 = insertText(result1,dominos{k}.frameDetails.Centroid,num2str(dominos{k}.pips),'FontSize', 30);
        end
    end
    
    result1 = insertShape(result1, 'Rectangle', bboxes);
    imshowpair(result1,result2, 'montage');
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