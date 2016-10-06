function [dominoCorners, boundingBoxs, ratios, orderedPerimeters] = M_Corner_Filter(corners, boxes)
    dominoCorners = {};
    orderedPerimeters = {};
    boundingBoxs = [];
    ratios = [];
    for k = 1:length(corners)
       c = corners{k};
       if (size(c, 1) > 3)
           [organisedCorners,r,orderedPerimeter] = M_Corner_Organiser(c);
           if size(organisedCorners,1) == 4
               dominoCorners{end +1} = organisedCorners;
               orderedPerimeters{end +1} = orderedPerimeter;
               ratios = [ratios r];
               boundingBoxs = cat(1, boundingBoxs, boxes(k, 1:end));
           end
       end
    end
end