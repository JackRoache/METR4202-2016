close all

start([colorVid]);

trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);

stop([colorVid]);

figure('Position',[50,50,1900,900])

%subplot(2,2,1)
%image(colorIm)
%axis image


%subplot(2,2,2)
%I = im2bw(colorIm,0.2);
I = rgb2gray(colorIm);
%I = imgaussfilt(I, 2);
[~, threshold] = edge(I,'sobel');
fudgeFactor = 0.7;
memes = histeq(I);
BW1 = edge(I,'Sobel',threshold*0.075);
BW2 = edge(I,'Sobel',threshold*0.1);
BW3 = edge(I,'Sobel',threshold*0.15);
BW4 = edge(memes,'Roberts',threshold*0.4);
BW5=(BW1+BW2+BW3+BW4)/4;
%BW2 = edge(I,'Canny',threshold*0.2);
%BW1 = edge(I,'Roberts',threshold*0.6);
%BW1 = edge(I,'Sobel',threshold*0.05);
%BW3=BW2-BW1;
%BW2=bwboundaries(BW1,[1 50]);
%imshowpair(BW1,BW5,'montage');
houghImage = BW4;

[h,theta, rho] =hough(houghImage);
imshow(imadjust(mat2gray(h)), [], 'XData', theta, 'YData', rho, 'InitialMagnification','fit');
axis on
axis normal
hold on
colormap(hot);

P = houghpeaks(h,100,'threshold',ceil(0.01*max(h(:))));

lines = houghlines(houghImage, theta, rho, P, 'FillGap', 2, 'MinLength', 7);

figure, imshow(houghImage), hold on;
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');

    
    plot(xy(1,1), xy(1,2), 'LineWidth', 2, 'Color', 'yellow');
    plot(xy(2,1), xy(2,2), 'LineWidth', 2, 'Color', 'red');
end
% boxImage = imread('test_11.jpg');
% boxImage2 = rgb2gray(boxImage);
% figure;
% imshow(boxImage2);
% title('Image of a Box');
% 
% imwrite(I, 'BW1test.jpg');
% sceneImage = imread('BW1test.jpg');
% figure;
% imshow(sceneImage);
% title('Image of a Cluttered Scene');
% 
% boxPoints = detectSURFFeatures(boxImage2);
% scenePoints = detectSURFFeatures(sceneImage);
% 
% figure;
% imshow(boxImage2);
% title('100 Strongest Feature Points from Box Image');
% hold on;
% plot(selectStrongest(boxPoints, 300));
% 
% figure;
% imshow(sceneImage);
% title('300 Strongest Feature Points from Scene Image');
% hold on;
% plot(selectStrongest(scenePoints, 300));
% 
% [boxFeatures, boxPoints] = extractFeatures(boxImage2, boxPoints);
% [sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
% 
% boxPairs = matchFeatures(boxFeatures, sceneFeatures);
% matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
% matchedScenePoints = scenePoints(boxPairs(:, 2), :);
% figure;
% showMatchedFeatures(boxImage2, sceneImage, matchedBoxPoints, ...
%     matchedScenePoints, 'montage');
% [tform, inlierBoxPoints, inlierScenePoints] = estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');
% 
% figure;
% showMatchedFeatures(boxImage2, sceneImage, inlierBoxPoints, inlierScenePoints, 'montage');
% title('Matched Points (Inliers Only)');
% 
% boxPolygon = [1, 1;...                           % top-left
%         size(boxImage2, 2), 1;...                 % top-right
%         size(boxImage2, 2), size(boxImage2, 1);... % bottom-right
%         1, size(boxImage2, 1);...                 % bottom-left
%         1, 1];                   % top-left again to close the polygon
%     
%     
% newBoxPolygon = transformPointsForward(tform, boxPolygon);
% figure;
% imshow(sceneImage);
% hold on;
% line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
% title('Detected Box');