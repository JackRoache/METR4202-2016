% Take all photos and measure the thang

function [FrameTrans, FrameRot, params, estimErrors] = ReferencePlacement(colorVid)

frames = [];
for i = 1:13
    imageFileName = sprintf('cal%d.png', i);
    frame = imread(imageFileName, 'png');
    frames = cat(4,frames,fliplr(frame));
end

imagesUsed = [0];
start(colorVid);

while (imagesUsed(end)~=1)
    display(sprintf('Ready to place frame. Press any key to continue...'));
    pause
    trigger(colorVid);
    [f, ~, ~] = getdata(colorVid);
    frames = cat(4,frames, fliplr(f));
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(frames);
    
end
    
stop(colorVid);

for i = 1:13
    I = frames(:,:,:,i);
    subplot(4,4,i);
    imshow(I);
    hold on;
    plot(imagePoints(:,1,i), imagePoints(:,2,i), 'ro');
end
I = frames(:,:,:,end);
subplot(4,4,14);
imshow(I);
hold on;
plot(imagePoints(:,1,end), imagePoints(:,2,end), 'ro');
    
squareSize = 14.25;
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
[params, ~, estimErrors] = estimateCameraParameters(imagePoints, worldPoints);
FrameRot = params.RotationMatrices(:,:,end);
FrameTrans = params.TranslationVectors(end,:);




