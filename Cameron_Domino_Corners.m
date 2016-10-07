function [orderedCorners, ratio] = M_Corner_Organiser(cornerSet)

    %find the corners
    numPoints = size(cornerSet,1);
    allpoints = zeros(2*numPoints,2);
    allpoints(1:numPoints,:) = cornerSet(:,1:2);
    allpoints(numPoints+1:end,:) = cornerSet(:,3:4);
    
    uniquePoints = zeros(1,4); %x,y,count
    count = 1;
    exclude = 0;
    n=1;
    %consolidate all points into occurances
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
    
    %find the corners
    randomOrderCorners = uniquePoints(find(uniquePoints(:,3) == 2),1:2);

    cp = mean(randomOrderCorners);
    
    startingCorner = randomOrderCorners(1,:);
    
    for j=1:size(uniquePoints,1)
        a = startingCorner - cp;
        b = uniquePoints(j,1:2) - cp;

        angle = atan2d(a(2),a(1)) - atan2d(b(2),b(1));
        uniquePoints(j,4) = angle;
    end
    
    [V,I] = sort(uniquePoints(:,4));
    uniquePoints = uniquePoints(I,:);
    
    orderedCorners = uniquePoints(find(uniquePoints(:,3) == 2),1:2);
    perimIndex = find((uniquePoints(:,3) == 2) + (uniquePoints(:,3) == 3));
    orderedPerimeter = uniquePoints(perimIndex,1:3);
    
    indexesBetweenCorners = find(orderedPerimeter(:,3) == 2);
    ratio = [indexesBetweenCorners(2)-indexesBetweenCorners(1),indexesBetweenCorners(3)-indexesBetweenCorners(2)];
end
    




