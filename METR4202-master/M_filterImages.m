function [BWf, BWL, colorIm] = M_filterImages(colorIm, cameraParams)

%flip image
colorIm = fliplr(colorIm);
colorIm = undistortImage(colorIm, cameraParams);
colorIm = imcrop(colorIm, [400 600 900 400]);
colorIm = colorIm * 0.8;
colorIm = imgaussfilt(colorIm, 0.2);

% Separate RGB
red = (colorIm(:,:,1));
green = (colorIm(:,:,2));
blue = (colorIm(:,:,3));

% srgb2lab = makecform('srgb2lab');
% lab2srgb = makecform('lab2srgb');
% 
% shadow_lab = applycform(colorIm, srgb2lab); % convert to L*a*b*
% 
% % the values of luminosity can span a range from 0 to 100; scale them
% % to [0 1] range (appropriate for MATLAB(R) intensity images of class double)
% % before applying the three contrast enhancement techniques
% max_luminosity = 100;
% L = shadow_lab(:,:,1)/max_luminosity;
% 
% colorIm = shadow_lab;
% colorIm(:,:,1) = imadjust(L)*max_luminosity;
% colorIm = applycform(colorIm, lab2srgb);

% red = imadjust(red);
% green = imadjust(green);
% blue = imadjust(blue);
% 
% % % grayImage = rgb2gray(colorIm); % Convert to gray so we can get the mean luminance.
% % % meanR = mean2(red);
% % % meanG = mean2(green);
% % % meanB = mean2(blue);
% % % meanGray = mean2(grayImage);
% % % Make all channels have the same mean
% % % red = uint8(double(red) * meanGray / meanR);
% % % green = uint8(double(green) * meanGray / meanG);
% % % blue = uint8(double(blue) * meanGray / meanB);
% % % Recombine separate color channels into a single, true color RGB image.
% colorIm = cat(3, red, green, blue);

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
BWL = imgaussfilt(BW1*255,0.2);
BWL = im2bw(BWL, 0.5);
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