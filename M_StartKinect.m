%% Delete previous input if it's running already
try 
    delete([colorVid]);
    delete([depthVid]);
    catch ME
end

 %% Remove previous input if it exists
clear colorVid;

%% Initialize color video device

%%Get videoinput (vi) object
colorVid = videoinput('kinect', 1, 'BGR_1920x1080');

%Set input settings
colorVid.FramesPerTrigger = 1;  %Only request one frame per trigger call
colorVid.TriggerRepeat = Inf;   %Tell vi object to allow inf trigger calls

%% Initialize color video device
depthVid = videoinput('kinect', 2, 'Depth_512x424');

%Set input settings
depthVid.FramesPerTrigger = 1;  %Only request one frame per trigger call
depthVid.TriggerRepeat = Inf;   %Tell vi object to allow inf trigger calls


%% Set trigger config for vi objects
triggerconfig([colorVid depthVid], 'manual');

%% Start vi devices
%start([colorVid]);
