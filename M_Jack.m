% Variables
minShapeSize = 2000;

% Take Photo
start([colorVid]);
trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);
stop([colorVid]);

%figure(1)
%imshow(colorIm)

tic

%flip image
colorIm = fliplr(colorIm);
colorIm = imcrop(colorIm, [400 600 900 400]);
colorImoriginal = colorIm;
colorIm = imgaussfilt(colorIm,0.2);

red = (colorIm(:,:,1));
green = (colorIm(:,:,2));
blue = (colorIm(:,:,3));

% [~, threshold] = edge(red,'Canny');
% BWR = edge(red, 'Canny',threshold*2);
% [~, threshold] = edge(green,'Canny');
% BWG = edge(green, 'Canny',threshold*2);
% [~, threshold] = edge(blue,'Canny');
% BWB = edge(blue, 'Canny',threshold*2);

%BWR=bwareafilt(BWR,[100 10000]);
%BWG=bwareafilt(BWG,[100 10000]);
%BWB=bwareafilt(BWB,[100 10000]);

figure(1)
subplot(2,3,1);
imshow(red);
subplot(2,3,2);
imshow(green);
subplot(2,3,3);
imshow(blue);

%red = uint8(red.*(red/100).*(red/100));
%green = uint8(green.*(green/100).*(green/100));
%blue = uint8(blue.*(blue/100).*(blue/100));

% red = imgaussfilt(red,2);
% green = imgaussfilt(green,2);
% blue = imgaussfilt(blue,2);

%green = mat2gray(green, [200 255]);

% figure(1)
% subplot(3,3,4);
% imshow(red);
% subplot(3,3,5);
% imshow(green);
% subplot(3,3,6);
% imshow(blue);

[~, threshold] = edge(red,'Canny');
BWR = edge(red, 'Canny',threshold*2);
[~, threshold] = edge(green,'Canny');
BWG = edge(green, 'Canny',threshold*2);
[~, threshold] = edge(blue,'Canny');
BWB = edge(blue, 'Canny',threshold*2);

% [~, threshold] = edge(red,'Roberts');
% BWR = edge(red, 'Roberts',threshold/6);
% [~, threshold] = edge(green,'Roberts');
% BWG = edge(green, 'Roberts',threshold/6);
% [~, threshold] = edge(blue,'Roberts');
% BWB = edge(blue, 'Roberts',threshold/6);

%BWR=bwareafilt(BWR,[10 10000]);
%BWG=bwareafilt(BWG,[10 10000]);
%BWB=bwareafilt(BWB,[10 10000]);

subplot(2,3,4);
imshow(BWR);
subplot(2,3,5);
imshow(BWG);
subplot(2,3,6);
imshow(BWB);

%Basic image proessing. 
I = rgb2gray(colorIm);
A = I.*(I/100);

[~, threshold] = edge(I,'Canny');
BWC = edge(I, 'Canny',threshold*2);
BW1 = BWR | BWG | BWB;
%BW1 = BWC;

BW1 = imgaussfilt(BW1*255,1);

BW1 = im2bw(BW1, 0.5);

figure(4);
imshow(BW1);

%BW1f=bwareafilt(BW1,[100 10000]);
%BW1fill=imfill(BW1f, 'holes');

BW1fill=imfill(BW1, 'holes');
BW1f=bwareafilt(BW1fill,[300 50000]);
BW1lines=BW1.*BW1fill;

figure(3)
subplot(2,2,1)
imshow(BW1)
subplot(2,2,2)
imshow(BW1fill)
subplot(2,2,3)
imshow(BW1f)
subplot(2,2,4)
imshow(colorIm .* repmat(uint8(BW1f),1,1,3))

%find the large shapes

% Stats = regionprops(BW1fill, 'Basic');
% areas = [Stats.Area];
% 
% Shapes = [];
% for k = 1:length(Stats)
%     if (areas(k) > minShapeSize)
%         Shapes = [Shapes Stats(k)];
%     end
% end

%clf
%hold on
%imshow(BW1fill);

%Now have shapes that are large enough to move onwards.
toc


