start([colorVid]);

trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);

imwrite(colorIm, 'T-7-NC-ST.png');

stop([colorVid]);