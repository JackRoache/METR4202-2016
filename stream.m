vid = videoinput('kinect', 1, 'RGB_640x480');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;

% preview(vid)

while 1    
    start(vid);
    [frame, ts, metaData] = getdata(vid);
%     imshow(frame);
    bw = rgb2gray(frame);
    imshow(bw);
end