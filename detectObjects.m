function [img] = detectObjects(imgIn)
gray = rgb2gray(imgIn);
bw = im2bw(gray);
bw = bwareaopen(bw, 20);
bw = imfill(bw, 'holes');
[B,L] = bwboundaries(bw, 'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]));

hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'lineWidth', 2);
end
hold off;

img = bw;