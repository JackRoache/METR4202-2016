%mathworks website example
% try 
%     delete([colorVid]);
%     delete([depthVid]);
%     catch ME
% end
% 
% colorVid = imaq.VideoDevice('kinect',1);
% depthVid = imaq.VideoDevice('kinect',2);
% colorVid.ReturnedDataType = 'uint8';

start([colorVid, depthVid]);
    
trigger(colorVid);
[colour_1080_1920, timeC, metaC] = getdata(colorVid);

trigger(depthVid);
[depth_424_512, timeD, metaD] = getdata(depthVid);

%example found on mathworks
% c = step(colorVid);
% d = step(depthVid);

stop([colorVid, depthVid]);

%flip the colour image
colour_1080_1920=fliplr(colour_1080_1920);

%show the original depth and colour images
figure(1);
subplot(2,2,1);
image(colour_1080_1920);
title('test1');
subplot(2,2,2);
imshow(mat2gray(depth_424_512, [0 2000]));
title('test2');

%resize the colour image to be the same pixles as the depth
%c = imresize(c, [424 512]);
colour_424_512 = imresize(colour_1080_1920, [424 754]);
colour_424_512 = imcrop(colour_424_512, [121 0 511 424]);
%c = imcrop(c, [(754-512)/2 0 (754/2+512) 424]);

%doubles the width and height of the depth image
%(allows for less scaling down of the colour image)
depth_848_1024 = uint16(zeros(848,1024));
for i = 1:size(depth_424_512,1) %1:424
    for j = 1:size(depth_424_512,2) %1:512
        value = depth_424_512(i,j);
        depth_848_1024(2*i,2*j) = value;
        depth_848_1024(2*i-1,2*j) = value;
        depth_848_1024(2*i,2*j-1) = value;
        depth_848_1024(2*i-1,2*j-1) = value;
    end
end

colour_848_1024 = imresize(colour_1080_1920, [848 1508]);
colour_848_1024 = imcrop(colour_848_1024, [242 0 1023 848]);

%show the edited images
subplot(2,2,3);
%image(colour_424_512);
image(colour_848_1024);
subplot(2,2,4);
imshow(mat2gray(depth_848_1024, [0 2000]));

%double sized depth
xyzPoints = depthToPointCloud(depth_424_512,depthVid);

%alignedColorImage = alignColorToDepth(depth_848_1024,colour_848_1024,depthVid);

xyzPoints_848_1024 = single(zeros(848,1024,3));
for i = 1:size(xyzPoints,1) %1:424
    for j = 1:size(xyzPoints,2) %1:512
        for z = 1:size(xyzPoints,3) %1:3
            value = xyzPoints(i,j,z);
            xyzPoints_848_1024(2*i,2*j,z) = value;
            xyzPoints_848_1024(2*i-1,2*j,z) = value;
            xyzPoints_848_1024(2*i,2*j-1,z) = value;
            xyzPoints_848_1024(2*i-1,2*j-1,z) = value;
        end
    end
end

figure(2)
pcshow(xyzPoints_848_1024,colour_848_1024,'VerticalAxis','y','VerticalAxisDir','down');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
axis([-1 1 -1 0.5 0 2]);

[xyzPoints, flippedDepthImage] = depthToPointCloud(depth_424_512,depthVid);

alignedColorImage = alignColorToDepth(depth_424_512,colour_424_512,depthVid);

figure(3)
%pcshow(xyzPoints,colour_424_512,'VerticalAxis','y','VerticalAxisDir','down');

% axis([-1 1 -1 0.5 0 2]);
px = double(xyzPoints(:,:,1));
px(~isfinite(px)) = 2;
py = double(xyzPoints(:,:,2));
py(~isfinite(py)) = 2;
pz = double(xyzPoints(:,:,3));
pz(~isfinite(pz)) = 6;
%F = TriScatteredInterp(double(xyzPoints(:,:,1)),double(xyzPoints(:,:,2)),double(xyzPoints(:,:,3)));
tx = -1:0.01:2;
ty = -1:0.01:0.5;
[qx,qy] = meshgrid(tx,ty);
qz = griddata(px,py,pz,qx,qy);

tri = delaunay(px,py);
h = trisurf(tri,px,py,pz);
%axis([-1 1 -1 1 0 2]);
axis([-0.2,0.2, -0.4,0.2, 0.3,1.4])

%surf(qx,qy,qz);

xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');