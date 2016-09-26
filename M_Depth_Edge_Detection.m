start([colorVid, depthVid]);
    
trigger(colorVid);
[colourIm, timeC, metaC] = getdata(colorVid);

trigger(depthVid);
[depthIm, timeD, metaD] = getdata(depthVid);

%example found on mathworks
% c = step(colorVid);
% d = step(depthVid);

stop([colorVid, depthVid]);

figure(1)
I = mat2gray(depthIm, [400 1000]);
[~, threshold] = edge(I,'Canny');
BW = edge(I, 'Canny',threshold*0.8);
imshowpair(I,BW,'montage');