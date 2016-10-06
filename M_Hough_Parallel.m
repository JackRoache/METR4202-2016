function [dominoCorners] = M_Hough_Parallel(cropIm)
% Threshold Variables
    gradientThresh = 20; %degrees
    offsetThresh = 0.3; %pecentage (make this a percentage of the image height later?)
    a = 0;
    I = rgb2gray(cropIm);
    % Blur
    I = imgaussfilt(I,1);
    % Edge detect
    [~, threshold] = edge(I,'Canny');
    BW = edge(I, 'Canny',threshold*0.3);
    
    %% Hough Transform
    [h,theta, rho] = hough(BW);
    P = houghpeaks(h,100,'threshold',ceil(0.005*max(h(:))));
    lines = houghlines(BW, theta, rho, P, 'FillGap', 4, 'MinLength', 20);
    bestLines = zeros(length(lines),3);
    for k = 1:length(lines)
        % Get the start and end points of the line
        xy = [lines(k).point1; lines(k).point2];
        CP = [(xy(1)+xy(2))/2 , (xy(3)+xy(4))/2];
        % Evaluate the gradient
        gradient = rad2deg(atan2((xy(3)-xy(4)),(xy(2)-xy(1)))); %gradient always between +-90 as abs(y1-y2)
        if(gradient(1) > 90)
            gradient(1) = gradient(1) - 180;

        elseif(gradient(1) <= -90)
            gradient(1) = gradient(1) + 180;
        end
        
        xmin = 0;
        xmax = size(BW,2);
        ymin = CP(2) - tand(gradient)*(xmin-CP(1)); %offset at x=0
        ymax = CP(2) - tand(gradient)*(xmax-CP(1));
        
        if(gradient == 90)
            xintercept = -CP(1);
        else
            xintercept = ymin/tand(gradient);
        end
        
        bestLines(k,:) = [gradient, ymin, xintercept];
    end

    mergedLines = zeros(size(bestLines,1),4); %grad,offset,number of lines it used to be
    exclude = 0;
    for k = 1:size(bestLines,1)
        currLine = bestLines(k,:);
        if(~any(exclude==k)) %if this line has already been merged
            mergedLines(k,:) = [currLine(1), currLine(2), currLine(3), 1];
            for j = (k+1):size(bestLines,1)
                a = a+1;
                if(~any(exclude==j))
                    compLine = bestLines(j,:);
                    
                    % Get the angle difference
                    anglebetween = abs(compLine(1) - currLine(1));
                    % Check for parallel
                    parCheckLow = anglebetween < gradientThresh/2; %parallel check 1
                    %parCheckHigh = anglebetween > 180 - gradientThresh; %parallel check 2
                    

                    % If parallel
                    if(parCheckLow)
                        % Find distance between midpoints
                        offsetDiffX = abs((compLine(2)-currLine(2))/size(BW,1)); %compares the y axis intercepts (x=0)
                        currXintercept = currLine(3);
                        compXintercept = compLine(3);
                        offsetDiffY = abs((currXintercept-compXintercept)/size(BW,2));
                        if(min(offsetDiffX,offsetDiffY) <= offsetThresh)
                            %confirmed lines are close
                            avgCount = mergedLines(k,4);
                            mergedLines(k,1) = (mergedLines(k,1)*avgCount+compLine(1))/(avgCount+1);
                            mergedLines(k,2) = (mergedLines(k,2)*avgCount+compLine(2))/(avgCount+1);
                            mergedLines(k,3) = (mergedLines(k,3)*avgCount+compLine(3))/(avgCount+1);
                            mergedLines(k,4) = avgCount+1;
                            exclude(end+1) = j;
                        end
                    end
                end
            end
        end
    end
    
    Indexes = find(mergedLines(:,4) ~= 0);
    foundGroups = zeros(length(Indexes),2);
    exclude = 0;
    parallelThresh = 10;
    perpThresh = 20;
    for k = 1:length(Indexes)
        currAngle = mergedLines(Indexes(k),1);
        if(~any(exclude==k))
            foundGroups(k,:) = [1 Indexes(k) zeros(1,size(foundGroups,2)-2)];
            for j = (k+1):length(Indexes)
                compAngle = mergedLines(Indexes(j),1);

                angleBetween = abs(currAngle - compAngle);
                
                perCheckLow = angleBetween < (90 + perpThresh/2); %perpendicular check 1
                perCheckHigh = angleBetween > (90 - perpThresh/2); %perpendicular check 2
                
                if((angleBetween < parallelThresh))
                    foundGroups(k,1) = foundGroups(k,1) + 1;
                    foundGroups(k,end+1) = Indexes(j);
                    exclude(end+1) = j;
                end
            end
        end
    end
    
    Indexes = find(foundGroups(:,1) >= 2);
    Intersects = zeros(2,2,(length(Indexes)-1));
    %perpThresh = 10;
    
    %for each set
    if((sum(foundGroups(:,1) ~= 0) < 5)&&(sum(mergedLines(:,4) ~= 0) < 10))
        for k = 1:(length(Indexes)-1)
            currentSet = foundGroups(Indexes(k),2:end);
            last = 1;
            %for each inxed specified in current set
            exclude = 0;
            for j = 1:length(currentSet)
                currIndex = currentSet(j);
                if(currIndex ~= 0)
                    %currentLine
                    currAngle = mergedLines(currIndex,1);
                    %for each other set
                    for m = (k+1):length(Indexes)
                        if(m ~= k)
                            compSet = foundGroups(Indexes(m),2:end);
                            for n = 1:length(compSet)
                                compIndex = compSet(n);
                                if(compIndex ~= 0)
                                    %compared line
                                    compAngle = mergedLines(compIndex,1);
                                    currOffsetY = mergedLines(currIndex,2);
                                    compOffsetY = mergedLines(compIndex,2);

                                    if(compAngle == 90)
                                        xIntercept = -mergedLines(compIndex,3);
                                        yIntercept = tan(currAngle) * xIntercept + currOffsetY;
                                    elseif(currAngle == 90)
                                        xIntercept = -mergedLines(currIndex,3);
                                        yIntercept = tan(compAngle) * xIntercept + compOffsetY;
                                    else
                                        xIntercept = (compOffsetY-currOffsetY)/(tand(currAngle)-tand(compAngle));
                                        yIntercept = tand(compAngle) * xIntercept + compOffsetY;
                                    end
                                    Intersects(last,:,k) = [xIntercept yIntercept];
                                    last = last + 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    acceptableGrads = unique(foundGroups(Indexes,2:end));
    acceptableGrads = acceptableGrads(2:end);
    acceptableGrads = mergedLines(acceptableGrads,1);
    count = 0;
    gradTolerance = 1;
    distTolerance = 5;
    outLines = zeros(1,5);
    if(size(Intersects,3) ~= 0)
        for k = 1:size(Intersects,3)
            Intersects(:,1,k) = -1*Intersects(:,1,k);
            
            for m = 1:size(Intersects,1)
                currPoint = Intersects(m,:,k);
                for n = (m+1):size(Intersects,1)
                    if( m ~= n)
                        compPoint = Intersects(n,:,k);
                        if((compPoint(1) > -10)&&(currPoint(1)> -10))
                            CP = [(compPoint(1)+currPoint(1))/2 , (compPoint(2)+currPoint(2))/2];
                            gradient = rad2deg(atan2((currPoint(2)-compPoint(2)),(compPoint(1)-currPoint(1))));
                            if(gradient(1) > 90)
                                gradient(1) = gradient(1) - 180;

                            elseif(gradient(1) <= -90)
                                gradient(1) = gradient(1) + 180;
                            end

                            yintercept = CP(2) + tand(gradient)*CP(1); %offset at x=0

                            if(gradient == 90)
                                xintercept = -CP(1);
                            else
                                xintercept = yintercept/tand(gradient);
                            end

                            if(any(abs(acceptableGrads - gradient) < gradTolerance))
                                %check there is no intersect already between
                                %these points
                                check = false(1);
                                for p = 1:size(Intersects,1)
                                    if((p ~= m) && (p ~= n))
                                        xpoint = Intersects(p,1,k);
                                        xdesired = [currPoint(1) compPoint(1)];
                                        if((xpoint < max(xdesired)) && (xpoint > min(xdesired)))
                                            ypoint = Intersects(p,2,k);
                                            ydesired =[currPoint(2) compPoint(2)];
                                            
                                            grad1 = atan2(ydesired(1)-ypoint,xdesired(1)-xpoint);
                                            grad2 = atan2(ypoint-ydesired(2),xpoint-xdesired(2));
                                            
                                            if(grad1 > 90)
                                                grad1 = grad1 - 180;

                                            elseif(grad1 <= -90)
                                                grad1 = grad1 + 180;
                                            end
                                            
                                            if(grad2 > 90)
                                                grad2 = grad2 - 180;

                                            elseif(grad2 <= -90)
                                                grad2 = grad2 + 180;
                                            end

                                            if(abs(grad1 - grad2) < gradTolerance)
                                                check = true(1);
                                            end
                                        end
                                    end
                                end
                                if(check == false(1))
                                    distance = sqrt((currPoint(1)-compPoint(1))^2+(currPoint(2)-compPoint(2))^2);
                                    count = count +1;
                                    outLines(count,:) = [currPoint,compPoint,distance];
                                    
                                end
                            end
                        end
                    end
                    
                end
            end
        end
    end
    dominoCorners = outLines();
end
