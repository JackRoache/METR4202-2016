start([colorVid]);

trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);

stop([colorVid]);

%flip image
colorIm = fliplr(colorIm);
colorIm = imcrop(colorIm, [400 500 900 300]);
%colorIm = imgaussfilt(colorIm);

%show orignal image
%figure(2)
%image(colorIm)


I = rgb2gray(colorIm);
[~, threshold] = edge(I,'Canny');
BW = edge(I, 'Canny',threshold*0.8);

figure(1)
imshow(BW)
grid on;
hold on;

[centers, radii, metric] = imfindcircles(BW,[3 15]);
% %centersStrong5 = centers(1:5);
% %radiiStrong5 = radii(1:5);
% %metricStrong5 = metric(1:5);
viscircles(centers, radii,'EdgeColor','b');

[h,theta, rho] =hough(BW);
% imshow(imadjust(mat2gray(h)), [], 'XData', theta, 'YData', rho, 'InitialMagnification','fit');
% axis on
% axis normal
% hold on
% colormap(hot);
% 
P = houghpeaks(h,1000,'threshold',ceil(0.005*max(h(:))));
% 
lines = houghlines(BW, theta, rho, P, 'FillGap', 2, 'MinLength', 6);

% figure(1)
% imshow(BW)
% hold on;

max_len = 0;
points = zeros(7,length(lines));
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    gradient = rad2deg(atan2((xy(3)-xy(4)),(xy(2)-xy(1))));
    
    points(:,k) = [xy(1),xy(3),xy(2),xy(4),gradient,0,0];
    c = 'green';
    if (abs(gradient) < 1)
        c = 'yellow';
    end
    if (abs(gradient) > 85)
        c = 'red';
    end
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', c);
end

maxDistance = 100; %pixels
gradientThresh = 10; %degrees
for i = 1:length(points)
    currentLine = points(:,i);
    currentCP = [(currentLine(1)+currentLine(3))/2, (currentLine(2)+currentLine(4))/2];
    currentGrad = currentLine(5);
    closeLineCount = 0;
    closeCircleCount = 0;
    for j = 1:length(points)
        if(j~=i)
            testLine = points(:,j);
            testGrad = testLine(5);
            testCP = [(testLine(1)+testLine(3)), (testLine(2)+testLine(4))];
            
            if(abs(testGrad - currentGrad) <= gradientThresh)
                distance = sqrt((testCP(1)-currentCP(1))^2 + (testCP(2)-currentCP(2))^2);
                if(distance <= maxDistance)
                    closeLineCount = closeLineCount+1;
                end
            end
        end
    end
    
    for j = 1:length(centers)
        distance = sqrt((centers(1)-currentCP(2))^2 + (centers(2)-currentCP(2))^2);
        if(distance <= maxDistance)
            closeLineCount = closeLineCount+1;
        end
    end
    
    points(6,i) = closeLineCount;
    points(7,i) = closeCircleCount;
end