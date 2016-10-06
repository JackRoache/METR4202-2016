function [BWf, colorIm] = M_filterImages(colorIm, cameraParams)

%flip image
colorIm = fliplr(colorIm);
colorIm = undistortImage(colorIm, cameraParams);
colorIm = imcrop(colorIm, [400 600 900 400]);
colorIm = imgaussfilt(colorIm, 0.2);

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
BW1fill = imfill(BW1, 'holes');
BWf = bwareafilt(BW1fill,[300 30000]);

% Plot Filtered Pictures
% figure(2)
% subplot(2,2,1)
% imshow(BW1)
% subplot(2,2,2)
% imshow(BW1fill)
% subplot(2,2,3)
% imshow(BW1f)
% subplot(2,2,4)
% imshow(colorIm .* repmat(uint8(BW1f),1,1,3));