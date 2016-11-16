
% function [domino] = M_countDots(corners, croppedImage, box, orderedPerimeter)
function [domino] = C_countDots(domino, croppedImage)
    boxX = domino.bBox(1);
    boxY = domino.bBox(2);
    corners = domino.boxDetails.corners;
    orderedPerimeter = domino.boxDetails.points;
%     domino(1) = 0;
%     domino(2) = 0;
    names = {'Centroid', 'BoundingBox', 'Area', 'Eccentricity'};
    Stats = regionprops(not(croppedImage), names);
    
%    Stats = [regionprops(croppedImage); regionprops(not(croppedImage))];
%     subplot(2,2,3)
%     hold off
%     imshow(croppedImage)
%     hold on
%     for j = 1:numel(Stats)
%     %    Plot as dotted rectangles
%         rectangle('Position', Stats(j).BoundingBox, ...
%             'Linewidth', 1, 'EdgeColor', 'r', 'LineStyle', '--');
%     end
%     
%     for j=1:size(orderedPerimeter,1)
%         scatter(orderedPerimeter(j,1),orderedPerimeter(j,2),100,'y','filled');
%     end
    
    a = sum(orderedPerimeter(:,3) == 3);
    % If no t junctions then its a dice
    if a == 0
        domino.dominoOrDice = 0;
        domino.boxDetails.Centroid = [mean(corners(:,1)) mean(corners(:,2))];
        frameCentX = mean(corners(:,1))+boxX;
        frameCentY = mean(corners(:,2))+boxY;
        domino.frameDetails.Centroid = [frameCentX frameCentY];
        domino.pips = M_Check_Area(corners, Stats);
    % If 2 t junctions then its a domino
    elseif (a == 2)
        domino.dominoOrDice = 1;
        %check rect
        edgePointInd = find(orderedPerimeter(:,3) == 3);
        firstEdgePointInd = edgePointInd(1);
        secondEdgePointInd = edgePointInd(2);
        firstEdgeValue = orderedPerimeter(firstEdgePointInd,1:2);
        secondEdgeValue = orderedPerimeter(secondEdgePointInd,1:2);
        
%         hold on
%         plot([firstEdgeValue(1) secondEdgeValue(1)], [firstEdgeValue(2) secondEdgeValue(2)], 'LineWidth', 2, 'Color', 'g'); 
%         hold off
        
        
        NumberOfPointsInFirstSquare = 1;
        FS(1) = firstEdgePointInd;
        newIndex = firstEdgePointInd;
        for i=2:4
            newIndex = newIndex + 1;
            if newIndex > 6
                newIndex = 1;
            end
            FS(i) = newIndex;
        end
        SS(1) = secondEdgePointInd;
        newIndex = secondEdgePointInd;
        for i=2:4
            newIndex = newIndex + 1;
            if newIndex > 6
                newIndex = 1;
            end
            SS(i) = newIndex;
        end 
        
        F1 = orderedPerimeter(FS(1),1:2);
        F2 = orderedPerimeter(FS(2),1:2);
        F3 = orderedPerimeter(FS(3),1:2);
        F4 = orderedPerimeter(FS(4),1:2);        
        Fcorners = [F1; F2; F3; F4];
        
        x = Fcorners(:,1);
        y = Fcorners(:,2);
%         plot(x,y,'LineWidth', 2, 'Color', 'b');
               
        S1 = orderedPerimeter(SS(1),1:2);
        S2 = orderedPerimeter(SS(2),1:2);
        S3 = orderedPerimeter(SS(3),1:2);
        S4 = orderedPerimeter(SS(4),1:2);
        Scorners = [S1; S2; S3; S4];
        
        x = Scorners(:,1);
        y = Scorners(:,2);
%         plot(x,y,'LineWidth', 2, 'Color', 'r');
        
        F_Num = M_Check_Area(Fcorners, Stats);
        S_Num = M_Check_Area(Scorners, Stats);
                
        domino.boxDetails.Centroid = [mean(corners(:,1)) mean(corners(:,2))];
        frameCentX = mean(corners(:,1))+boxX;
        frameCentY = mean(corners(:,2))+boxY;
        domino.frameDetails.Centroid = [frameCentX frameCentY];
        domino.pips = [min([F_Num, S_Num]) max([F_Num, S_Num])];
        
    % If it has not 0 or 2 t junctions then wig out
    else
        domino = [];
    end
        

    
%     a = norm(corners(1) - corners(2));
%     b = norm(corners(1) - corners(4));
%     if (a>b)
%         point1 = mean(corners(1)+corners
    
    
    
    %%Untransform Image
%     flatCorners = [0,0;0,100;200,100;200,0];    
%     try 
%         [tform, inlierPtsDistorted, inlierPtsOriginal] = ...
%             estimateGeometricTransform(corners,flatCorners,...
%             'projective');
% 
%         % outputView = imref2d(size(croppedImage));
%         outputView = imref2d([400 200]);
%         
%         Ir = imwarp(croppedImage,tform,'OutputView',outputView);
%         subplot(2,2,3);
%         imshow(Ir);
%     catch ME
%         domino = [];
%         return
%     end
    
    

%     subplot(2,2,3);
%     imshow(Ir);
    
%     cropX = mean(corners(:,1));
%     cropY = mean(corners(:,2));
%     domino(1) = boxX + cropX;
%     domino(2) = boxY + cropY;
        
end
