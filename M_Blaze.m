time = tic;
% Take Photo
start([colorVid]);
trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);
stop([colorVid]);

times(1) = toc(time);
time = tic;

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
imshow(colorIm .* repmat(uint8(BW1f),1,1,3))

%colorX = colorIm .* repmat(uint8(BW1f),1,1,3);
%colorX = rgb2gray(colorX);
colorX = rgb2gray(colorImoriginal);
colorX = imgaussfilt(colorX,0.5);

redX = red .* uint8(BW1f);
greenX = green .* uint8(BW1f);
blueX = blue .* uint8(BW1f);

% Canny on each color
% [~, threshold] = edge(redX,'Sobel');
% BWRX = edge(redX, 'Sobel',threshold/6);
% [~, threshold] = edge(greenX,'Sobel');
% BWGX = edge(greenX, 'Sobel',threshold/6);
% [~, threshold] = edge(blueX,'Sobel');
% BWBX = edge(blueX, 'Sobel',threshold/6);
[~, threshold] = edge(colorX,'Canny');
BWCX = edge(colorX, 'Canny',threshold*3);

BWCX = BWCX & BW1f;

%BWCX = bwareafilt(BWCX,[1 30]);

BWCXALL = BWCX;

for i=-1:1
    for j=-1:1
        BWCXS = imtranslate(BWCX, [i, j]);
        BWCXALL = BWCXALL|BWCXS;
    end
end
        
% BWCXU = imtranslate(BWCX, [0, 2]);
% BWCXR = imtranslate(BWCX, [2, 0]);
% BWCXL = imtranslate(BWCX, [-2, 0]);
% BWCXD = imtranslate(BWCX, [0, -2]);
% BWCXUR = imtranslate(BWCX, [2, 2]);
% BWCXUL = imtranslate(BWCX, [-2, 2]);
% BWCXDR = imtranslate(BWCX, [2, -2]);
% BWCXDL = imtranslate(BWCX, [-2, -2]);

% BWCXALL = BWCX|BWCXU|BWCXR|BWCXL|BWCXD|BWCXUR|BWCXUL|BWCXDR|BWCXDL;

BWCXALLI = ~BWCXALL;
BWCXALLF = bwareafilt(BWCXALLI,[500 4000]);
BWCXALLFM =  colorIm .* repmat(uint8(BWCXALLF),1,1,3);

BWCXALLFILL = imfill(BWCXALL,'holes');
% A = BWCXALLFILL;
% shiftinboi = 10;
% times(2) = toc(time);
% time = tic;
% for i=-shiftinboi:shiftinboi
%     for j=-shiftinboi:shiftinboi
%         BWCXS = imtranslate(BWCXALLFILL, [i, j]);
%         A = A & BWCXS;
%     end
% end

% Plot Cannied Pictures
%figure(3)
%imshow(BWRX);
%figure(4)
%imshow(BWGX);
%figure(5)
%imshow(BWBX);
figure(6)
hold off
%imshow(~A & BWCXALLFILL);
imshow(BWCX)
hold on

% Finds cirlces on the image
%[centers, radii, metric] = imfindcircles(BWCX,[3 9]);
%viscircles(centers, radii,'EdgeColor','b');

times(3) = toc(time);
time = tic;

[h,theta, rho] =hough(BWCXALL);

P = houghpeaks(h,500,'threshold',ceil(0.05*max(h(:))));

lines = houghlines(BWCXALL, theta, rho, P, 'FillGap', 3, 'MinLength', 20);

times(4) = toc(time);
time = tic;

points = zeros(8,length(lines));
for k = 1:length(lines)
    % Get the start and end points of the line
    xy = [lines(k).point1; lines(k).point2];
    % Evaluate the gradient
    gradient = rad2deg(atan2((xy(3)-xy(4)),abs(xy(2)-xy(1)))); %gradient always between +-90 as abs(y1-y2)
        
    points(:,k) = [xy(1),xy(3),xy(2),xy(4),gradient,0,0,0];
    % Make most lines green
    c = 'green';
    % Make horizontal lines yellow
    if (abs(gradient) < 1)
        c = 'yellow';
    end
    % Make vertical lines red
    if (abs(gradient) > 85)
        c = 'red';
    end
    plot(xy(:,1), xy(:,2), 'LineWidth', 5, 'Color', c);
end

times(5) = toc(time);
time = tic;
times
