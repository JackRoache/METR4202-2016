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
[~, threshold] = edge(I,'sobel');
fudgeFactor = 0.7;
BW1 = edge(I,'sobel',threshold*0.5);
BW2 = edge(I,'sobel',threshold*0.2);
imshowpair(BW1,BW2,'montage');