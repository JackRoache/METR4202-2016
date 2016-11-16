start([colorVid]);

trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);

stop([colorVid]);

%flip image
colorIm = fliplr(colorIm);
colorIm = imcrop(colorIm, [400 500 900 300]);
colorImoriginal = colorIm;
colorIm = imgaussfilt(colorIm,0.2);

%show orignal image
%figure(2)
%image(colorIm)


I = rgb2gray(colorIm);
[~, threshold] = edge(I,'Canny');
BW1 = edge(I, 'Canny',threshold*2);
BW1f=bwareafilt(BW1,[200 500]);
BW1fill=imfill(BW1f, 'holes');
BW1x=BW1.*BW1fill;
BW1xb = imgaussfilt(BW1x,2.5);

% Icrop = imcrop(BW1, [435 0 140 140]);
% Icroprgb = imcrop(BW1, [435 0 140 140]);
% BW=imfill(Icrop, 'holes');
% figure(1)
% imshow(BW1x);
% totalarea = bwarea(Icrop);
% afIc=bwareafilt(BW,[2000 5000]);
% afIcrgb=bwareafilt(Icrop,[2000 5000]);
% BW2 = edge(afIc, 'Canny',threshold*2);
% %BW3 = edge(afIcrgb, 'Canny',threshold*2);
% afIc2 = -(afIc-1);
% Imfinal=Icrop.*afIc;
% Ix = imgaussfilt(Imfinal,2.5);

%imshow(Icrop);
%BWf = edge(Imfinal, 'Canny',threshold*2);

%foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
%    'NumTrainingFrames', 50);
%foreground = step(foregroundDetector, Icrop);
%figure; imshow(foreground); title('Foreground');

% blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%     'AreaOutputPort', false, 'CentroidOutputPort', false, ...
%     'MinimumBlobArea', 150);
% bbox = step(blobAnalysis, afIc);
% result = insertShape(Imfinal, 'Rectangle', bbox, 'Color', 'green');
% numCars = size(bbox, 1);
% result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
%     'FontSize', 14);
% result1 = imcrop(Imfinal, [bbox(1) bbox(2) bbox(3) round(bbox(4)/2)]);
% result1x = imcrop(Ix, [bbox(1) bbox(2) bbox(3) round(bbox(4)/2)]);
% result2 = imcrop(Imfinal, [bbox(1) bbox(2)+round(bbox(4)/2) bbox(3) round(bbox(4)/2)]);
% result2x = imcrop(Ix, [bbox(1) bbox(2)+round(bbox(4)/2) bbox(3) round(bbox(4)/2)]);



%imshow(Imfinal);
%figure(2)
%grid on;

hold on;

%%
% Finds cirlces on the image
[centers, radii, metric] = imfindcircles(BW1xb,[1 6]);

% %centersStrong5 = centers(1:5);
% %radiiStrong5 = radii(1:5);
% %metricStrong5 = metric(1:5);

% numCircles = length(centers);
% result3 = insertText(Imfinal, [bbox(1)+round(bbox(3)/2)-5 bbox(2)+round(bbox(4))-10], numCircles, 'BoxOpacity', 1, ...
%     'FontSize', 10);

%figure; imshow(BW1); title('Detected Dominos');
% Displays the circles on the plot
viscircles(centers, radii,'EdgeColor','b');


%%
% Applies the hough transform
[h,theta, rho] =hough(BW1x);

% imshow(imadjust(mat2gray(h)), [], 'XData', theta, 'YData', rho, 'InitialMagnification','fit');
% axis on
% axis normal
% hold on
% colormap(hot);

% Finds the peaks in the hough transform
P = houghpeaks(h,1000,'threshold',ceil(0.005*max(h(:))));
% Finds the lines from the peaks found
lines = houghlines(BW1x, theta, rho, P, 'FillGap', 2, 'MinLength', 2);

%%
% figure(1)
% imshow(BW)
% hold on;
%0,0 is top left
%plot([250,250],[150,250], 'LineWidth', 5, 'Color', 'blue');
%% Calculate the gradient of the lines found in degrees

points = zeros(8,length(lines));
for k = 1:length(lines)
    % Get the start and end points of the line
    xy = [lines(k).point1; lines(k).point2];
    % Evaluate the gradient
    gradient = rad2deg(atan2((xy(3)-xy(4)),abs(xy(2)-xy(1)))); %gradient always between +-90 as abs(y1-y2)
        
    points(:,k) = [xy(1),xy(3),xy(2),xy(4),gradient,0,0,0];
    % Make most lines green
    c = 'green';
    % Make horizontal lines yellow
    if (abs(gradient) < 1)
        c = 'yellow';
    end
    % Make vertical lines red
    if (abs(gradient) > 85)
        c = 'red';
    end
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', c);
end

%% For each line, count how many circles and parallel/perpendicular 
%  lines are nearby.

% How far to check for nearby objects
radiusThresh = 35; %pixels
% Angle difference to be still counted as parrallel/perpendicular
gradientThresh = 10; %degrees

for i = 1:length(points)
    % Get the two points of the line
    currentLine = points(:,i);
    % Get the midpoint of it
    currentCP = [(currentLine(1)+currentLine(3))/2, (currentLine(2)+currentLine(4))/2];
    % Get the gradient of it
    currentGrad = currentLine(5);
    
    closeLineCount = 0;
    closeCircleCount = 0;
    
    % Now iterate through all the other lines
    for j = 1:length(points)
        if(j~=i)
            % Get the other line's details
            testLine = points(:,j);
            testGrad = testLine(5);
            testLength = sqrt((testLine(1)-testLine(3))^2 + (testLine(2)-testLine(4))^2);
            testCP = [(testLine(1)+testLine(3))/2, (testLine(2)+testLine(4))/2];
            
            % Get the angle difference
            anglebetween = abs(testGrad - currentGrad);
            % Check for parallel
            parCheckLow = anglebetween < gradientThresh/2; %parallel check 1
            parCheckHigh = anglebetween > 180 - gradientThresh/2; %parallel check 2
            % Check for perpendicular
            perCheckLow = anglebetween < 90 + gradientThresh/2; %perpendicular check 1
            perCheckHigh = anglebetween > 90 - gradientThresh/2; %perpendicular check 2
            % If parallel
            if(parCheckLow || parCheckHigh)
                % Find distance between midpoints
                distance = sqrt((testCP(1)-currentCP(1))^2 + (testCP(2)-currentCP(2))^2);
                if(distance <= radiusThresh)
                    % Increase chance of being a domino by one
                    closeLineCount = closeLineCount+1;
                end
            end
            % If perpendicular
            if(perCheckLow && perCheckHigh)
                distance = sqrt((testCP(1)-currentCP(1))^2 + (testCP(2)-currentCP(2))^2);
                if(distance <= radiusThresh)
                    % Increase chance of being a domino by the length of
                    % the line (Dominos tend to be the longest lines.
                    closeLineCount = closeLineCount+testLength*1;
                end
            end
        end
    end
    % Count how many circles are in range
    for j = 1:length(centers)
        distance = sqrt((centers(j,1)-currentCP(1))^2 + (centers(j,2)-currentCP(2))^2);
        if(distance <= radiusThresh)
            closeCircleCount = closeCircleCount+1;
        end
    end
    
    %points(6,i) = closeLineCount;
    %points(7,i) = closeCircleCount;
    
    % Weight the points by how many lines and circles are near them
    % With 4 times the weight on lines over circles
    points(8,i) = 4*closeLineCount+1*closeCircleCount;
end

%%
% Sort the points in descending order of their nearby objects score

% [Y,I]=sort(points(6,:),'descend');
% [Y2,I2]=sort(points(7,:),'descend');
[Y3,I3]=sort(points(8,:),'descend');

% The lines with the top 50% of scores are proposed as possible dominos
topx = ceil(0.5*length(I3));
% Make a vector of radii for plotting purposes
radii = true(topx,1)*radiusThresh;

%% Code for plotting lines and circles (Unweighted)

% strongCloseLine = points(:,I(1:topx));
% strongCloseCircle = points(:,I2(1:topx));
% lineCP = transpose([(strongCloseLine(1,:)+strongCloseLine(3,:))/2; (strongCloseLine(2,:)+strongCloseLine(4,:))/2]);
% circleCP = transpose([(strongCloseCircle(1,:)+strongCloseCircle(3,:))/2; (strongCloseCircle(2,:)+strongCloseCircle(4,:))/2]);
% viscircles(lineCP, radi,'EdgeColor','r');
% viscircles(circleCP, radi,'EdgeColor','g');

%% Plotting circles around strongly weighted lines

% Get line points
StrongWeighted = points(:,I3(1:topx));
% Get centre points
TopCPs = transpose([(StrongWeighted(1,:)+StrongWeighted(3,:))/2; (StrongWeighted(2,:)+StrongWeighted(4,:))/2]);
% Plot the circles (gets pretty thick)
%viscircles(TopCPs, radi,'EdgeColor','g');

%% Cluster calculation (I use the words cluster and set interchangably)

% Set first mid point to the first line proposed as a domino
SetMidPoints = [TopCPs(1,:),1];
% Set largets distance from cluster centre
radiusThresh = 50;
% Iterate through all the proposed lines
for i = 2:length(TopCPs)
    % Get line centre point
    nextPoint = TopCPs(i,:);
    % Calculate distance to each cluster set
    Distances = hypot(SetMidPoints(:,1) - nextPoint(1),SetMidPoints(:,2) - nextPoint(2));
    % Find the minimum distance to a cluster
    [d,I] = min(Distances);
    % If it is close enough to a current set
    if (d <= radiusThresh)
        % Third entry is the number of items in the cluster
        SetPop = SetMidPoints(I,3);
        % Weight the current cluster midpoint by how many are there
        AvgSum = SetMidPoints(I,1:2)*SetPop;
        % Find the new average midpoint after adding the current line
        AvgSum = AvgSum + nextPoint;
        Avg = AvgSum / (SetPop+1);
        % Update cluster
        SetMidPoints(I,:) = [Avg, SetPop+1];
    else
        % Make a new set
        SetMidPoints(size(SetMidPoints,1)+1,:) = [nextPoint, 1];
    end         
end




%% CLUSTER CALCS ON MY CLUSTER CALCS
%% CLUSTER 2 : CLUSTER RISING
 
 % Set first mid point to the first cluster point
DominoCPs = [SetMidPoints(1,1:2),1];
% Set largets distance from cluster centre
radiusThresh = 70;
% Iterate through all the proposed lines
for i = 2:length(SetMidPoints)
    % Get line centre point
    nextPoint = SetMidPoints(i,1:2);
    % Calculate distance to each cluster set
    Distances = hypot(DominoCPs(:,1) - nextPoint(1),DominoCPs(:,2) - nextPoint(2));
    % Find the minimum distance to a cluster
    [d,I] = min(Distances);
    % If it is close enough to a current set
    if (d <= radiusThresh)
        % Third entry is the number of items in the cluster
        SetPop = DominoCPs(I,3);
        % Weight the current cluster midpoint by how many are there
        AvgSum = DominoCPs(I,1:2)*SetPop;
        % Find the new average midpoint after adding the current line
        AvgSum = AvgSum + nextPoint;
        Avg = AvgSum / (SetPop+1);
        % Update cluster
        DominoCPs(I,:) = [Avg, SetPop+1];
    else
        % Make a new set
        DominoCPs(size(DominoCPs,1)+1,:) = [nextPoint, 1];
    end         
end
%%
% Make radius for plotting to show cluster size
radii = true(size(DominoCPs,1),1)*radiusThresh;
% Plot clusters on edge image
viscircles(DominoCPs(:,1:2), radii,'EdgeColor','r');
%% Cropping images of each domino for future processing

reg_width = 100;
reg_height = 100;
% Delete old item to prevent type errors
clear croppedImages;
for i = 1:size(DominoCPs,1)
    % Get the centre of the crop window
    x_c = DominoCPs(i,1);
    y_c = DominoCPs(i,2);
    % Get the width and height of the crop window
    width = (reg_width/2) + DominoCPs(i,3)*5;
    height = (reg_height/2) + DominoCPs(i,3)*5;   
    % Get the top left corner of the crop window
    x_a = ceil(x_c - width);
    y_a = ceil(y_c - height);
    % Crop the image
    croppedImages{i} = imcrop(colorIm, [x_a y_a width height]);
end

result3 = colorImoriginal;
for i=1:length(DominoCPs)
    %% Crop each domino
    x_rc = DominoCPs(i,1);
    y_rc = DominoCPs(i,2);
    x_crop = x_rc-70;
    y_crop = y_rc-70;
    Icrop = imcrop(BW1, [x_crop y_crop 140 140]);
    %%Filter cropped dominoes
    BW=imfill(Icrop, 'holes');
    afIc=bwareafilt(BW,[200 10000]);
    afIcrgb=bwareafilt(Icrop,[200 5000]);
    BW2 = edge(afIc, 'Canny',threshold*2);
    %BW3 = edge(afIcrgb, 'Canny',threshold*2);
    afIc2 = -(afIc-1);
    Imfinal=Icrop.*afIc;
    Ix = imgaussfilt(Imfinal,2.5);
    imshow(afIc);
    BWf = edge(Imfinal, 'Canny',threshold*2);
    %% BlobAnalysis
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ...
        'MinimumBlobArea', 150);
    bbox = step(blobAnalysis, afIc);
    result = insertShape(Imfinal, 'Rectangle', bbox, 'Color', 'green');
    numCars = size(bbox, 1);
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);
    
%     result1 = imcrop(Imfinal, [bbox(1) bbox(2) bbox(3) round(bbox(4)/2)]);
%     result1x = imcrop(Ix, [bbox(1) bbox(2) bbox(3) round(bbox(4)/2)]);
%     result2 = imcrop(Imfinal, [bbox(1) bbox(2)+round(bbox(4)/2) bbox(3) round(bbox(4)/2)]);
%     result2x = imcrop(Ix, [bbox(1) bbox(2)+round(bbox(4)/2) bbox(3) round(bbox(4)/2)]);

    %imshow(Imfinal);
    %figure(2)
    %grid on;

%     hold on;
% 
%     %% Count Circles & Insert number onto Image
%     % Finds cirlces on the image
%     [centers, radii, metric] = imfindcircles(result2x,[1 6]);
% 
%     numCircles = length(centers);
    if bbox(3)<bbox(4)
        result1 = imcrop(Imfinal, [bbox(1) bbox(2) bbox(3) round(bbox(4)/2)]);
        result1x = imcrop(Ix, [bbox(1) bbox(2) bbox(3) round(bbox(4)/2)]);
        result2 = imcrop(Imfinal, [bbox(1) bbox(2)+round(bbox(4)/2) bbox(3) round(bbox(4)/2)]);
        result2x = imcrop(Ix, [bbox(1) bbox(2)+round(bbox(4)/2) bbox(3) round(bbox(4)/2)]);

        hold on;

        %% Count Circles & Insert number onto Image
        % Finds cirlces on the image
        [centers, radii, metric] = imfindcircles(result1x,[1 6]);
        [centers2, radii2, metric2] = imfindcircles(result2x,[1 6]);

        numCircles1 = length(centers);
        numCircles2 = length(centers2);
        if numCircles1+numCircles2==0
            result3 = insertText(result3, [x_crop+bbox(1)+round(bbox(3)/2)-5 y_crop+bbox(2)+round(bbox(4)/2)+5], 'Flipped', 'BoxOpacity', 1, ...
            'FontSize', 10);
        else
            result3 = insertText(result3, [x_crop+bbox(1)+round(bbox(3)/2)-5 y_crop+bbox(2)+round(bbox(4))+5], numCircles1, 'BoxOpacity', 1, ...
                'FontSize', 10);

            result3 = insertText(result3, [x_crop+bbox(1)+round(bbox(3)/2)-5 y_crop+bbox(2)+round(bbox(4))+5], numCircles2, 'BoxOpacity', 1, ...
                'FontSize', 10);
        end
        
    elseif bbox(3)>bbox(4)
        result1 = imcrop(Imfinal, [bbox(1) bbox(2) round(bbox(3)/2) bbox(4)]);
        result1x = imcrop(Ix, [bbox(1) bbox(2) round(bbox(3)/2) bbox(4)]);
        result2 = imcrop(Imfinal, [bbox(1)+round(bbox(3)/2) bbox(2) round(bbox(3)/2) bbox(4)]);
        result2x = imcrop(Ix, [bbox(1)+round(bbox(3)/2) bbox(2) round(bbox(3)/2) bbox(4)]);
        
        hold on;
        
        [centers, radii, metric] = imfindcircles(result1x,[1 6]);
        [centers2, radii2, metric2] = imfindcircles(result2x,[1 6]);
        %% Count Circles & Insert number onto Image
        % Finds cirlces on the image
        [centers, radii, metric] = imfindcircles(result2x,[1 6]);
        numCircles1 = length(centers);
        numCircles2 = length(centers2);
        if numCircles1+numCircles2==0
            result3 = insertText(result3, [x_crop+bbox(1)+round(bbox(3)/2)-5 y_crop+bbox(2)+round(bbox(4)/2)-5], 'Flipped', 'BoxOpacity', 1, ...
            'FontSize', 10);
        else
            result3 = insertText(result3, [x_crop+bbox(1)-5 y_crop+bbox(2)+round(bbox(4)/2)-5], numCircles1, 'BoxOpacity', 1, ...
                'FontSize', 10);
            result3 = insertText(result3, [x_crop+bbox(1)+bbox(3)-5 y_crop+bbox(2)-5], numCircles2, 'BoxOpacity', 1, ...
                'FontSize', 10);
        end
    else
        %no clue what to do if both sides are equal
    end

    % Displays the circles on the plot
    %viscircles(centers, radii,'EdgeColor','b');
end
figure; imshow(result3); title('Detected Dominos');