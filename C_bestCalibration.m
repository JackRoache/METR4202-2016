function [cameraParams, trans, rot] = C_bestCalibration(video)
% Define images to process
imageFileNames = {'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal1.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal3.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal5.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cala6.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal7.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal8.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal9.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal10.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal11.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal13.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal14.png',...
    'C:\Users\Seeing The Invisible\Google Drive\Uni\Courses\2016 Semester 2\METR4202\Lab 3\METR4202-master\Calibration\cal15.png',...
    };
frames = [];
for i=1:numel(imageFileNames)
    frames = cat(4,frames, fliplr(imread(imageFileNames{i})));
end

start(video);

display(sprintf('Ready to take reference frame. Press any key to take photo...'));
pause
trigger(video);
[f, ~, ~] = getdata(video);
stop(video);

%Flips left and right to give real view with fliplr
frames = cat(4,frames, fliplr(f));


% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(frames);
% imageFileNames = imageFileNames(imagesUsed);

if (imagesUsed(end) == 0)
    error('You are in trouble mister');
end

% Generate world coordinates of the corners of the squares
squareSize = 1.341600e+01;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', []);

% View reprojection errors
% h1=figure; showReprojectionErrors(cameraParams, 'CameraCentric');

% Visualize pattern locations
% h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
originalImage = imread(imageFileNames{1});
undistortedImage = undistortImage(originalImage, cameraParams);

trans = cameraParams.TranslationVectors(end, :);
rot = cameraParams.RotationMatrices(:,:,end);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
end