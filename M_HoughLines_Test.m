start([colorVid]);

trigger(colorVid);
[colorIm, colorTime, colorMeta] = getdata(colorVid);

stop([colorVid]);

%flip image
colorIm = fliplr(colorIm);
colorIm = imcrop(colorIm, [400 500 900 300]);
colorIm = imgaussfilt(colorIm,0.2);

%show orignal image
%figure(2)
%image(colorIm)


I = rgb2gray(colorIm);
[~, threshold] = edge(I,'Canny');
BW = edge(I, 'Canny',threshold*0.8);

figure(1)
imshow(BW)
%grid on;
hold on;

%%
% Finds cirlces on the image
[centers, radii, metric] = imfindcircles(BW,[3 13]);

% %centersStrong5 = centers(1:5);
% %radiiStrong5 = radii(1:5);
% %metricStrong5 = metric(1:5);

% Displays the circles on the plot
viscircles(centers, radii,'EdgeColor','b');

%%
% Applies the hough transform
[h,theta, rho] =hough(BW);

% imshow(imadjust(mat2gray(h)), [], 'XData', theta, 'YData', rho, 'InitialMagnification','fit');
% axis on
% axis normal
% hold on
% colormap(hot);

% Finds the peaks in the hough transform
P = houghpeaks(h,1000,'threshold',ceil(0.005*max(h(:))));
% Finds the lines from the peaks found
lines = houghlines(BW, theta, rho, P, 'FillGap', 4, 'MinLength', 8);

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
radiusThresh = 50; %pixels
% Angle difference to be still counted as parrallel/perpendicular
gradientThresh = 15; %degrees

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
                    closeLineCount = closeLineCount+0.5;
                end
            end
            % If perpendicular
            if(perCheckLow && perCheckHigh)
                distance = sqrt((testCP(1)-currentCP(1))^2 + (testCP(2)-currentCP(2))^2);
                if(distance <= radiusThresh)
                    % Increase chance of being a domino by the length of
                    % the line (Dominos tend to be the longest lines.
                    closeLineCount = closeLineCount+testLength*2;
                end
            end
        end
    end
    % Count how many circles are in range
    for j = 1:length(centers)
        distance = sqrt((centers(j,1)-currentCP(1))^2 + (centers(j,2)-currentCP(2))^2);
        if(distance <= radiusThresh)
            closeCircleCount = closeCircleCount+2;
        end
    end
    
    %points(6,i) = closeLineCount;
    %points(7,i) = closeCircleCount;
    
    % Weight the points by how many lines and circles are near them
    % With 4 times the weight on lines over circles
    points(8,i) = 1*closeLineCount+1*closeCircleCount;
end

%%
% Sort the points in descending order of their nearby objects score

% [Y,I]=sort(points(6,:),'descend');
[Y2,I2]=sort(points(7,:),'descend');
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
StrongWeighted = points(:,I2(1:topx));
% Get centre points
TopCPs = transpose([(StrongWeighted(1,:)+StrongWeighted(3,:))/2; (StrongWeighted(2,:)+StrongWeighted(4,:))/2]);
% Plot the circles (gets pretty thick)
%viscircles(TopCPs, radii,'EdgeColor','g');

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

%%
% Make radius for plotting to show cluster size
radii = true(size(SetMidPoints,1),1)*radiusThresh;
% Plot clusters on edge image
viscircles(SetMidPoints(:,1:2), radii,'EdgeColor','r');

%% Cropping images of each domino for future processing

width = 100;
height = 100;
% Delete old item to prevent type errors
clear croppedImages;
for i = 1:size(SetMidPoints,1)
    % Get the corner of the crop window
    x = ceil(SetMidPoints(i,1)-(width/2));
    y = ceil(SetMidPoints(i,2)-(height/2));
    % Crop the image
    croppedImages{i} = imcrop(colorIm, [x y width height]);
end


    
    
    
    