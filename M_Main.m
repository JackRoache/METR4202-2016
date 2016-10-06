global LIGHTS_OUT
LIGHTS_OUT = 0;
try
    stop(colorVid);
catch ME
end

[colorVid, depthVid] = M_StartKinect();

% Basic testing code. Takes in the webcam input.
% delete colorVid;
% clear colorVid;
% colorVid = videoinput('winvideo', 1);
% colorVid.FramesPerTrigger = 1;  
% colorVid.TriggerRepeat = Inf;
% triggerconfig(colorVid, 'manual');

%%
% [cameraParams, estimateError, frames] = M_Calibration(colorVid);
% 
%%
% [FrameT,FrameR] = M_SensorPlacement(colorVid, frames, cameraParams);
% display(sprintf('Translation vector of frame from camera: x = %d, y = %d, z = %d', FrameT(1), FrameT(2), FrameT(3)));
% display(sprintf('Magnitude of translation vector: %d mm', norm(FrameT)));
% Eul = round(rad2deg(M_rot2eu('xyx', FrameR)));
% display(sprintf('Rotation matrix of frame from camera: x = %d, y = %d, x = %d', Eul(1), Eul(2), Eul(3)));

start(colorVid);

h = figure(1);
clf
set(h,'position',[10 10 1900 1000]);
set(h,'KeyPressFcn',@myKeyPressed)

while ~LIGHTS_OUT
    % Take Frame
    trigger(colorVid);
    [colorIm, time, meta] = getdata(colorVid);
    % Image Filter
    [BWf, fixedColorIm] = M_filterImages(colorIm, cameraParams);
    BW = im2bw(fixedColorIm);
    % Blob Analysis
    bboxes = M_Blob(BWf);
    % Hough Lines Analysis
    dominoLines = {};
    for k = 1:size(bboxes,1)
        dominoLines{k} = M_Hough_Parallel(imcrop(fixedColorIm, bboxes(k, 1:end)));
    end   
    % Object Filter
    [clean_corners, boxes, ratios, orderedPerimeter] = M_Corner_Filter(dominoLines, bboxes);
    % Finds Pips    
    for k = 1:size(boxes)
        dominos{k} = M_countDots(clean_corners{k}, imcrop(BW, boxes(k, 1:end)), boxes(k,:), orderedPerimeter{k});
    end
    
    % Positioning
    [dominoProps] = M_transform(clean_corners); 
    [dominoPos] = M_position(dominoProps, cameraParams, FrameR, FrameT);

    % Tracking
%      = M_


    % Draws Pip(boy) Numbers
    result = fixedColorIm;
    for k = 1:size(dominos, 2)
        dom = dominos{k};
        x = dom(1);
        y = dom(2);
        if size(dom,2) == 3
            Text = sprintf('Dice: %d', dom(3));
            result = insertText(result, [x y], Text, 'TextColor', 'green');
        elseif size(dom,2) == 4
            Text = sprintf('%d; %d', dom(3), dom(4));
            result = insertText(result, [x y], Text, 'TextColor', 'red');
        end
    end


    % Display Data
    subplot(2,2,1)
    imshow(result);
    hold on
    
    
    for k = 1:size(clean_corners,2)
        d = clean_corners{k};
        plot(d(:,1)+double(boxes(k,1)),d(:,2)+double(boxes(k,2)), 'LineWidth',2,'Color','green');
    end
    for k=1:size(boxes,1)
        rectangle('Position',boxes(k,:),'EdgeColor','r');
    end


    
    
    
    
    subplot(2,2,2)
    %imshow(BWf);

    %result = insertShape(BWf, 'Rectangle', bboxes, 'Color', 'green');
    imshow(BWf);
    hold on
    for k=1:size(bboxes,1)
        rectangle('Position',bboxes(k,:),'EdgeColor','r');
    end
    
    for k = 1:size(dominoLines,2)
        lineSet = dominoLines{k};
        if(size(lineSet,1) > 1)
            for l = 1:size(lineSet,1)
                c = zeros(1,4);
                c(1) = lineSet(l,1) + bboxes(k,1);
                c(3) = lineSet(l,3) + bboxes(k,1);
                c(2) = lineSet(l,2) + bboxes(k,2);
                c(4) = lineSet(l,4) + bboxes(k,2);        
                plot([c(1) c(3)],[c(2) c(4)], 'LineWidth',2,'Color','g');
            end
        end
    end


    
    

%     hold off;
end

%exits video, shuts down
stop(colorVid);




% pause;
% start(colorVid);
% trigger(colorVid);
% [f, time, meta] = getdata(colorVid);
% stop(colorVid);
% %1000 is whats measured. 1250mm^2 for the domino.
% distance = M_Distance(pixelArea, 1000, 1250);
% [x,y] = cameraParams.pointsToWorld(FrameR, FrameT, undistortPoints(pixelPoint, cameraparams));
% z = Frame(t) - distance * FrameR;
% z = z(3);
%x,y and z are wrt to the real world.





