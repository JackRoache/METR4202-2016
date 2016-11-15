% Gets given the set of lines (here known as 'corners') where each entry is
% of the form [startpoint endpoint distance]

% function [dominoCorners, boundingBoxs, ratios, orderedPerimeters] = M_Corner_Filter(corners, boxes)
function [dominos] = M_Corner_Filter(corners, boxes)
    
    dominos = []; 
    for k = 1:length(corners)
       c = corners{k};
       if (size(c, 1) > 3)
           % corner organiser only returns those dominos with 4 corners,
           % with the corners sorted in clockwise order.
           % organisedCorners is just x and y points.
           [organisedCorners,~,orderedPerimeter] = M_Corner_Organiser(c);
           % Returns only those dominos that have 4 corners
           if size(organisedCorners,1) == 4
               domino.boxDetails.corners = organisedCorners;
               domino.boxDetails.points = orderedPerimeter;
               domino.bBox = boxes(k, 1:end);
               dominos(k) = domino;
           end
       end
    end
    
end