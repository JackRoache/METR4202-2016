% Load Photo
colorIm = imread('Photos/Photos/T-7-NC.png');

% Flip Image
colorIm = fliplr(colorIm);
colorIm = imcrop(colorIm, [300 600 800 350]);
colorImoriginal = colorIm;
colorIm = imgaussfilt(colorIm,0.2);

% Separate RGB
red = (colorIm(:,:,1));
green = (colorIm(:,:,2));
blue = (colorIm(:,:,3));

% Canny on each color
[~, threshold] = edge(red,'Canny');
BWR = edge(red, 'Canny',threshold*2);
[~, threshold] = edge(green,'Canny');
BWG = edge(green, 'Canny',threshold*2);
[~, threshold] = edge(blue,'Canny');
BWB = edge(blue, 'Canny',threshold*2);

hold off
% Plot Outputs
% figure(1)
% subplot(2,3,1);
% imshow(red);
% subplot(2,3,2);
% imshow(green);
% subplot(2,3,3);
% imshow(blue);

% Plot Cannied Pictures
% subplot(2,3,4);
% imshow(BWR);
% subplot(2,3,5);
% imshow(BWG);
% subplot(2,3,6);
% imshow(BWB);

% Mixing and Altering Lines
BW1 = BWR | BWG | BWB;
BW2 = imgaussfilt(BW1*255,1);
BW3 = im2bw(BW2, 0.5);
BWf=bwareafilt(BW3,[500 30000]);
BWfill=imfill(BWf, 'holes');

% figure(2);
% imshow(BWfill);

% BlobAnalysis
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', false, 'CentroidOutputPort', false, ...
            'MinimumBlobArea', 150);
bbox = step(blobAnalysis, BWfill);
result = insertShape(colorImoriginal, 'Rectangle', bbox, 'Color', 'green');
numCars = length(bbox);
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
            'FontSize', 14);

% figure(3);
% imshow(result);
        
clear croppedImages;
for i = 1:length(bbox)
    % Crop the image
    croppedImages{i} = imcrop(colorImoriginal, bbox(i, :));
end

CI = croppedImages{3};

figure(1);
imshow(CI);

% Define Points
w1 = [4,25];
w2 = [76,22];
w3 = [70,37];
w4 = [0,40];

% Plot points and lines
hold on;
plot(w1(1), w1(2),'r.','MarkerSize', 10);
plot(w2(1), w2(2),'r.','MarkerSize', 10);
plot(w3(1), w3(2),'r.','MarkerSize', 10);
plot(w4(1), w4(2),'r.','MarkerSize', 10);
% plot([w1(1), w2(1)],[w1(2), w2(2)], 'Color', 'b', 'LineWidth', 1);
% plot([w2(1), w3(1)],[w2(2), w3(2)], 'Color', 'b', 'LineWidth', 1);
% plot([w3(1), w4(1)],[w3(2), w4(2)], 'Color', 'b', 'LineWidth', 1);
% plot([w4(1), w1(1)],[w4(2), w1(2)], 'Color', 'b', 'LineWidth', 1);
Centre_X = (w1(1)+w2(1)+w3(1)+w4(1))/4;
Centre_Y = (w1(2)+w2(2)+w3(2)+w4(2))/4;
plot(Centre_X, Centre_Y,'r.','MarkerSize', 10);

line1 = [w1,w2];
line2 = [w2,w3];
line3 = [w3,w4];
line4 = [w4,w1];
lines = [line1;line2;line3;line4];

% Distance
lines(1,5) = norm(lines(1,1:2)-lines(1,3:4));
lines(2,5) = norm(lines(2,1:2)-lines(2,3:4));
lines(3,5) = norm(lines(3,1:2)-lines(3,3:4));
lines(4,5) = norm(lines(4,1:2)-lines(4,3:4));

% Gradient
lines(1,6) = (lines(1,4)- lines(1,2)) / (lines(1,3)- lines(1,1));
lines(2,6) = (lines(2,4)- lines(2,2)) / (lines(2,3)- lines(2,1));
lines(3,6) = (lines(3,4)- lines(3,2)) / (lines(3,3)- lines(3,1));
lines(4,6) = (lines(4,4)- lines(4,2)) / (lines(4,3)- lines(4,1));

% Y Intercept
lines(1,7) = lines(1,2)-lines(1,1)*lines(1,6);
lines(2,7) = lines(2,2)-lines(2,1)*lines(2,6);
lines(3,7) = lines(3,2)-lines(3,1)*lines(3,6);
lines(4,7) = lines(4,2)-lines(4,1)*lines(4,6);

% Angle with X axis
lines(1,8) = atan(lines(1,6));
lines(2,8) = atan(lines(2,6));
lines(3,8) = atan(lines(3,6));
lines(4,8) = atan(lines(4,6));

% Sort by length
lines = sortrows(lines,5);

plot([lines(4,1),lines(4,3)],[lines(4,2),lines(4,4)], 'Color', 'g', 'LineWidth', 1);
plot([lines(3,1),lines(3,3)],[lines(3,2),lines(3,4)], 'Color', 'g', 'LineWidth', 1);
plot([lines(2,1),lines(2,3)],[lines(2,2),lines(2,4)], 'Color', 'b', 'LineWidth', 1);
plot([lines(1,1),lines(1,3)],[lines(1,2),lines(1,4)], 'Color', 'b', 'LineWidth', 1);

% Get CP of longer lines
longCP1 = [(lines(4,1)+lines(4,3))/2,(lines(4,2)+lines(4,4))/2];
longCP2 = [(lines(3,1)+lines(3,3))/2,(lines(3,2)+lines(3,4))/2];

% Get average angle of longer lines
avg_long_ang = (lines(4,8)+lines(3,8))/2;
avg_long_grad = tan(avg_long_ang);

avg_short_ang = (lines(2,8)+lines(1,8))/2;
avg_short_grad = tan(avg_short_ang);

y_int1 = longCP1(2)-longCP1(1)*avg_long_grad;
y_int2 = longCP2(2)-longCP2(1)*avg_long_grad;
delta_y = abs(y_int1-y_int2);
perp_dist = delta_y*cos(avg_long_ang);

% Get average length of lines
avg_long_len = (lines(4,5)+lines(3,5))/2;
avg_short_len = (lines(2,5)+lines(1,5))/2;

% Ratio of length to perp dist
ratio = avg_long_len/perp_dist;
theta = acos(2/ratio)*180/pi;

% Get angle between long and short lines
ang_diff = avg_short_ang-avg_long_ang;
A = tan(ang_diff)

% Get ratio of long and short line
B = avg_long_len/avg_short_len

% Solve for angles
syms x y;
eqn1 = A == 1/(tan(x)*sin(y));
eqn2 = B == 2*cos(y) / sqrt( cos(x)^2 + sin(x)^2*sin(y)^2 );
S = vpasolve(eqn1, eqn2, 1.57);
theta = double(S.x*180/pi);
phi = double(S.y*180/pi);

theta = mod(theta,360);
if(theta>90)
    theta = 180 - theta;
    phi = phi * -1;
end

arrow_y = 10*sin(theta);
arrow_x = 10*cos(theta)*sin(phi);
arrow_r = sqrt(arrow_y^2+arrow_x^2);
arrow_ang = atan(arrow_y/arrow_x);

plot_ang = arrow_ang-avg_long_ang;
plot_x = arrow_r*cos(plot_ang);
plot_y = arrow_r*sin(plot_ang);

quiver(Centre_X, Centre_Y, plot_x, plot_y, 0, 'Color', 'g', 'LineWidth', 1)
quiver(Centre_X, Centre_Y, -plot_x, -plot_y, 0, 'Color', 'r', 'LineWidth', 1)

% Specifyin the pose in extrinsic rotation order
x_rot = theta;
y_rot = phi;
z_rot = avg_long_ang;


% [tform, inlierPtsDistorted, inlierPtsOriginal] = ...
%     estimateGeometricTransform(W,O,...
%     'projective');
% 
% outputView = imref2d(size(CI));
% Ir = imwarp(CI,tform,'OutputView',outputView);
% 
% imshow(Ir)
%  
% hold on
% plot(o1,'r.','MarkerSize', 10);
% plot(o2,'r.','MarkerSize', 10);
% plot(o3,'r.','MarkerSize', 10);
% plot(o4,'r.','MarkerSize', 10);












