I = imread('test (1).jpg');
G = rgb2gray(I);
%sorta interesting, but a little too low level for what I want to do
% imcontour(G)

% find circles, really easy
%http://au.mathworks.com/help/images/examples/detect-and-measure-circular-objects-in-an-image.html
% Takes a long time, so left out for the moment
% [centre, radius] = imfindcircles(G, [50, 200], 'ObjectPolarity','Dark','Sensitivity', 0.9);


% rectangles / Boundary finding
%http://au.mathworks.com/help/images/examples/identifying-round-objects.html
BW = im2bw(I);
% imshow(BW);
% pause;
BW = bwareaopen(BW, 300);
BW = imfill(BW, 'holes');
% imshow(BW);


[B,L] = bwboundaries(BW, 'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]));
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'lineWidth', 2);
end
hold off

% something to discriminate towards rectangles....

