% Variables
minShapeSize = 2000;


start([colorVid]);

trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);

stop([colorVid]);

%flip image
colorIm = fliplr(colorIm);
colorIm = imcrop(colorIm, [400 500 900 300]);
colorImoriginal = colorIm;
colorIm = imgaussfilt(colorIm,0.2);

%Basic image proessing. 
I = rgb2gray(colorIm);
[~, threshold] = edge(I,'Canny');
BW1 = edge(I, 'Canny',threshold*2);
BW1f=bwareafilt(BW1,[200 20000]);
BW1fill=imfill(BW1f, 'holes');
BW1lines=BW1.*BW1fill;

%find the large shapes

Stats = regionprops(BW1fill, 'Basic');
areas = [Stats.Area];

Shapes = [];
for k = 1:length(Stats)
    if (areas(k) > minShapeSize)
        Shapes = [Shapes Stats(k)];
    end
end

clf
hold on
imshow(BW1fill);

for k = 1:length(Shapes)
end

%Now have shapes that are large enough to move onwards.


