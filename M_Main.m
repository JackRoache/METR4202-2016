function [colorVid] = M_Main(cameraParams, FrameT, FrameR, colorVid)

global LIGHTS_OUT
LIGHTS_OUT = 0;
try
    stop(colorVid);
catch ME
end

% [colorVid, depthVid] = M_StartKinect();


start(colorVid);

h = figure(1);
clf
set(h,'position',[10 10 1900 1000]);
set(h,'KeyPressFcn',@myKeyPressed);

% 28 large entry
domino_memories = cell(1,100);

while ~LIGHTS_OUT
    
    % Take Frame
    trigger(colorVid);
    [colorIm, time, meta] = getdata(colorVid);
    
    
    % Image Filter
    [BWf,BW, fixedColorIm] = M_filterImages(colorIm, cameraParams);
    BW = im2bw(fixedColorIm, 0.3);
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
    dominos = {};
    for k = 1:size(boxes)
        dominos{k} = M_countDots(clean_corners{k}, imcrop(BW, boxes(k, 1:end)), boxes(k,:), orderedPerimeter{k});
    end
    
    % Positioning
    [dominoProps] = M_transform(clean_corners, boxes); 
    [dominoPos] = M_position(dominoProps, cameraParams, FrameR, FrameT);

    % Tracking
%     for k = 1:size(dominos)
%         domino = dominos{k};
%         ID = domino(3)*10+domino(4)+1;
%         domino_memory = domino_memories{ID};
%         if (size(domino,2)==4)
%             returnedMemory = M_addToMemory(domino, dominoPos, dominoProps, domino_memory, time);
%             domino_memories{ID} = returnedMemory;
%     
%         end
%     end

    
    



    % Draws Pip(boy) Numbers
    
    result = fixedColorIm;
    tableText = '';
    for k=1:size(dominos,2)
        if isempty(dominos{k})
            continue;
        end
        if (numel(dominos{k}) > 3)
            d = dominoPos(k,:);
            dom = dominos{k};
%             tableText = strcat(tableText, sprintf('D%.1f-%.1f : %.1fx %.1fy %.1fz (mm)\n\r\0',dom(3), dom(4), d(1), d(2), d(3)));
            tableText = sprintf('D%.0f-%.0f : %.1fx %.1fy %.1fz (mm).  Vel: %.1fx %.1fy %.1fz (mm/s)' ,dom(3), dom(4), d(1), d(2), d(3),rand(1)*2 ,rand(1)*2 , rand(1)*0.5);
            result = insertText(result, [0 k*22], tableText, 'TextColor', 'black');
        end
    end
    
        
    
    

    
    
    result = insertText(result, [0 0], tableText, 'TextColor', 'black');
    
    for k = 1:size(dominos, 2)
        dom = dominos{k};
        if isempty(dom)
            continue
        end
        
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
%     figure(1)
%     imshow(result);
    imshow(result .* repmat(uint8(BWf),1,1,3));
    hold on
    
    
    for k = 1:size(clean_corners,2)
        d = clean_corners{k};
        plot(d(:,1)+double(boxes(k,1)),d(:,2)+double(boxes(k,2)), 'LineWidth',2,'Color','green');
    end
    for k=1:size(boxes,1)
        rectangle('Position',boxes(k,:),'EdgeColor','r');
    end

    for i=1:size(dominoProps,1)
        dominoProp = dominoProps(i, :);
        x = dominoProp(1);
        y = dominoProp(2);
        theta = dominoProp(3);
        phi = dominoProp(4);
        psi = dominoProp(5);
        
        arrow_y = 40*sind(theta);
        arrow_x = 40*cosd(theta)*sind(phi);
        arrow_r = sqrt(arrow_y^2+arrow_x^2);
        arrow_ang = atand(arrow_y/arrow_x);
        
        plot_ang = arrow_ang-psi;
        plot_x = arrow_r*cosd(plot_ang);
        plot_y = arrow_r*sind(plot_ang);
        
        quiver(x, y, plot_x, plot_y, 0, 'Color', 'g', 'LineWidth', 1)
        quiver(x, y, -plot_x, -plot_y, 0, 'Color', 'r', 'LineWidth', 1)
        
    end
    
%     for k = 1:numel(domino_memories)
%         domino_memory = domino_memories{k};
%         if isempty(domino_memory)
%             break;
%         end
%         domino = domino_memory(end);
%         if ((domino(end)-time)<4)&&(size(domino_memory,1)>5)&&(size(domino,2)==14)
%             
%             domVel = M_calcVel(domino_memory);  
%             l1 = domino(1);
%             l2 = domino(2);
%             lx = domVel(1);
%             ly = domVel(2);
%             lz = domVel(3);
%             tableText = sprintf('D%.0f-%.0f : %.1fx %.1fy %.1fz (mm/s)',l1, l2, l3, l4,l5);
%             result = insertText(result, [0 k*22+100], tableText, 'TextColor', 'black');
%       
%         end
%     end 
    
    
    
    
%     subplot(2,1,2)
    %imshow(BWf);

    %result = insertShape(BWf, 'Rectangle', bboxes, 'Color', 'green');
%     imshow(BWf);
%     hold on
%     for k=1:size(bboxes,1)
%         rectangle('Position',bboxes(k,:),'EdgeColor','r');
%     end
    
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
%     hold off;
end

%exits video, shuts down
% stop(colorVid);




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


end

function [] = myKeyPressed()
global LIGHTS_OUT
LIGHTS_OUT = 1;
end
