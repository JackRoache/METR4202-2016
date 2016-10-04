% Take Photo
start([colorVid]);
trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);
stop([colorVid]);

%flip image
colorIm = fliplr(colorIm);
colorIm = imcrop(colorIm, [400 600 900 400]);
colorImoriginal = colorIm;
colorIm = imgaussfilt(colorIm,0.2);

% Separate RGB
red = (colorIm(:,:,1));
green = (colorIm(:,:,2));
blue = (colorIm(:,:,3));

% Plot Outputs
% % figure(1)
% % subplot(2,3,1);
% % imshow(red);
% % subplot(2,3,2);
% % imshow(green);
% % subplot(2,3,3);
% % imshow(blue);

% Canny on each color
[~, threshold] = edge(red,'Canny');
BWR = edge(red, 'Canny',threshold*2);
[~, threshold] = edge(green,'Canny');
BWG = edge(green, 'Canny',threshold*2);
[~, threshold] = edge(blue,'Canny');
BWB = edge(blue, 'Canny',threshold*2);

% Plot Cannied Pictures
% % subplot(2,3,4);
% % imshow(BWR);
% % subplot(2,3,5);
% % imshow(BWG);
% % subplot(2,3,6);
% % imshow(BWB);

BW1 = BWR | BWG | BWB;
BW1 = imgaussfilt(BW1*255,1);
BW1 = im2bw(BW1, 0.5);
BW1fill=imfill(BW1, 'holes');
BW1f=bwareafilt(BW1fill,[300 30000]);

figure(2)
subplot(2,2,1)
imshow(BW1)
subplot(2,2,2)
imshow(BW1fill)
subplot(2,2,3)
imshow(BW1f)
subplot(2,2,4)
imshow(colorIm .* repmat(uint8(BW1f),1,1,3));

tic
 %% BlobAnalysis
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ...
        'MinimumBlobArea', 150);
    bbox = step(blobAnalysis, BW1f);
    result = insertShape(colorImoriginal, 'Rectangle', bbox, 'Color', 'green');
    numCars = length(bbox);
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);
toc


imshow(result)

clear croppedImages;
for i = 1:length(bbox)
    % Crop the image
    croppedImages{i} = imcrop(colorImoriginal, bbox(i, :));
end

figure(3)
clf
for i = 1:length(croppedImages)
    % Select subplot
    subplot(4, ceil(length(croppedImages)/4), i);
    % Make gray
    I = rgb2gray(croppedImages{i});
    % Blur
    I = imgaussfilt(I,0.5);
    % Edge detect
    [~, threshold] = edge(I,'Canny');
    BW = edge(I, 'Canny',threshold*0.2);
    
    %[h,theta, rho] = hough(BW);
    %P = houghpeaks(h,1000,'threshold',ceil(0.005*max(h(:))));
    %lines = houghlines(BW, theta, rho, P, 'FillGap', 2, 'MinLength', 2);
    
    %BW = im2bw(I);
    c = croppedImages{i};
%     HSV = rgb2hsv(c);
    % "20% more" saturation:
%     HSV(:, :, 2) = HSV(:, :, 2) * 3;
%     HSV(HSV > 1) = 1;  % Limit values
%     I =rgb2gray(hsv2rgb(HSV));
%     [~, threshold] = edge(I,'Canny');
%     BW = edge(I, 'Canny',threshold*0.2);
    imshow(c);
    %imshow(c(:,:,1));
    %BW=bwareafilt(BW,[1 50]);
    %imshow(BW);
    
%     hold on
%     % Get boxes around black area
%     stats = [regionprops(BW); regionprops(not(BW))];
%     for j = 1:numel(stats)
%         % Plot as dotted rectangles
%         rectangle('Position', stats(j).BoundingBox, ...
%             'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '--');
%     end
%     
     %[centers, radii, metric] = imfindcircles(c,[2 8], 'ObjectPolarity', 'dark');
     [centers, radii, metric] = imfindcircles(c,[2 8]);
     
     viscircles(centers, radii,'EdgeColor','b');

 
end



    
    
    
    
    
    

