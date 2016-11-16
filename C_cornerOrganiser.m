% Gets given a collection of lines, which have an x, a y and a distance of
% the line. If the set of lines given doesn't contain four corners then it
% just returns zeros: 
%    orderedCorners = [0,0], ratio = 0, orderedPerimeter = [0,0]
% Note: points are relative to the cropped image
function [orderedCorners, ratio, orderedPerimeter] = C_cornerOrganiser(cornerSet)
    
    % Makes the vector for all line points
    % Number of lines in set
    numPoints = size(cornerSet,1);
    % Two corners per line
    allpoints = zeros(2*numPoints,2);
    % All the first points of the lines
    allpoints(1:numPoints,:) = cornerSet(:,1:2);
    % All the second points of the lines
    allpoints(numPoints+1:end,:) = cornerSet(:,3:4);
    
    uniquePoints = zeros(1,4); %x,y,count
    count = 1;
    exclude = 0;
    n=1;
    
    % Makes a vector of only the unique points
    % Vector uniquePoints structure is [x y count_of_point 0]
    for m=1:length(allpoints)
        if(~any(exclude == m))
            uniquePoints(count,:) = [allpoints(m,:) 1 0];
            for(n=(m+1):length(allpoints))
                if(~any(exclude == m))
                    if(allpoints(m,:) == allpoints(n,:))
                        uniquePoints(count,3) = uniquePoints(count,3)+1;
                        exclude(end+1) = n;
                    end
                end
            end
            count = count + 1;
        end
    end
    
    % Find the points that appear in two lines
    % These will be the corners of the domino
    % If there aren't 4 corners then it returns zero for everything
    randomOrderCorners = uniquePoints(find(uniquePoints(:,3) == 2),1:2);
    if (size(randomOrderCorners, 1)~=4)
        orderedCorners = [0, 0];
        ratio = 0;
        orderedPerimeter = [0 0];
        return;
    end
   
    % finds the centre point
    cp = mean(randomOrderCorners);
    
    % Finds the angle of one point and the finds the difference between
    % that angle and all the other point's angles. 
    startingCorner = randomOrderCorners(1,:);
    for j=1:size(uniquePoints,1)
        a = startingCorner - cp;
        b = uniquePoints(j,1:2) - cp;

        angle = atan2d(a(2),a(1)) - atan2d(b(2),b(1));
        uniquePoints(j,4) = angle;
    end
    
    % Gets the ordered indexes
    [V,I] = sort(uniquePoints(:,4));
    % Orders the points by angle
    uniquePoints = uniquePoints(I,:);
    
    % ordered corners is just the corner's x and y points
    orderedCorners = uniquePoints(find(uniquePoints(:,3) == 2),1:2);
    % ordered perimeter is all the intersect points
    perimIndex = find((uniquePoints(:,3) == 2) + (uniquePoints(:,3) == 3));
    orderedPerimeter = uniquePoints(perimIndex,1:3);
    
    % Gets the ratio (not working)
    indexesBetweenCorners = find(orderedPerimeter(:,3) == 2);
    ratio = [indexesBetweenCorners(2)-indexesBetweenCorners(1),indexesBetweenCorners(3)-indexesBetweenCorners(2)];
    
end
    





















