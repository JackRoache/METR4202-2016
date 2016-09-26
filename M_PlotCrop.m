figure(2)
for i = 1:size(croppedImages,2)
    subplot(4, ceil(size(croppedImages,2)/4), i);
    I = rgb2gray(croppedImages{i});
    I = imgaussfilt(I,0.5);
    [~, threshold] = edge(I,'Canny');
    %BW = edge(I, 'Canny',threshold*0.5);
    BW = im2bw(I);    
    imshow(BW);
    
    [centers, radii, metric] = imfindcircles(BW,[3 15],'ObjectPolarity','dark');

    viscircles(centers, radii,'EdgeColor','b');
    
     hold on
     stats = [regionprops(BW); regionprops(not(BW))];
     for j = 1:numel(stats)
         rectangle('Position', stats(j).BoundingBox, ...
             'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '--');
     end
end

