clear cam

cam = webcam;
% preview(cam);
while 1
    img = snapshot(cam);
%     imshow(img);
    detectObjects(img);
end


% clear cam;