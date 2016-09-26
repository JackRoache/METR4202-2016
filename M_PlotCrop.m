%% To be run after cropped images has been made

figure(2)
for i = 1:size(croppedImages,2)
    % Select subplot
    subplot(4, ceil(size(croppedImages,2)/4), i);
    % Make gray
    I = rgb2gray(croppedImages{i});
    % Blur
    I = imgaussfilt(I,0.5);
    % Edge detect
    %%[~, threshold] = edge(I,'Canny');
    %%BW = edge(I, 'Canny',threshold*0.5);
    
    % Make black and white
    BW = im2bw(I);
    % Plot
    imshow(BW);
    % Find black circles in white image
    [centers, radii, metric] = imfindcircles(BW,[3 15],'ObjectPolarity','dark');
    % Plot circles on image
    viscircles(centers, radii,'EdgeColor','b');
    
    hold on
    % Get boxes around black area
    stats = [regionprops(BW); regionprops(not(BW))];
    for j = 1:numel(stats)
        % Plot as dotted rectangles
        rectangle('Position', stats(j).BoundingBox, ...
            'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '--');
    end
end

