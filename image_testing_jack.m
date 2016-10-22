close all

video = VideoReader('dark-5-bl.avi');

frameNum = 0;
while video.hasFrame()
% for loopcount = 1:5
    frameNum = frameNum + 1;
    frame1 = video.readFrame();
    frame2 = video.readFrame();
    frame3 = video.readFrame();
    frame = uint16(frame1) + uint16(frame2) + uint16(frame3);
    frame = uint8(frame / 3);
    
    frame = fliplr(frame);
    
    frame = imcrop(frame,[500,0,1420,1080]);
    hsv = rgb2hsv(frame);
    
    result1 = hsv(:,:,3).^3;
    bw = im2bw(result1, 0.4);
    bwf = bwareafilt(bw, [300 2000]);
    
    result2 = bwf;
    
    bboxes = M_Blob(bwf);
    
    bboxes(:,1) = bboxes(:,1) - 10;
    bboxes(:,2) = bboxes(:,2) - 10;
    bboxes(:,3) = bboxes(:,3) + 20;
    bboxes(:,4) = bboxes(:,4) + 20;

    dominoLines = {};
    for l = 1:size(bboxes,1)
        dominoLines{l} = M_Hough_Parallel(imcrop(result1, bboxes(l, 1:end)));
    end   
    
    [clean_corners, boxes, ratios, orderedPerimeter] = M_Corner_Filter(dominoLines, bboxes);
    % Finds Pips    
    dominos = {};
    for k = 1:size(boxes)
        dominos{k} = M_countDots(clean_corners{k}, imcrop(bw, boxes(k, 1:end)), boxes(k,:), orderedPerimeter{k});
    end
    
    result1 = frame;
    result1 = insertText(result1, [0 0], num2str(frameNum), 'FontSize', 20);
    
    for k = 1:length(dominos)
        if (length(dominos{k}) == 3)
            result1 = insertText(result1,dominos{k}(1:2),num2str(dominos{k}(3)),'FontSize', 30);
        else
            result1 = insertText(result1,dominos{k}(1:2),num2str(dominos{k}(3:4)),'FontSize', 30);
        end
    end
    
    result1 = insertShape(result1, 'Rectangle', bboxes);
%     imshowpair(result1,result2, 'montage');
    imshow(result1);
    hold on;
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
end