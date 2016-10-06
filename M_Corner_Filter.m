function [dominoCorners, boundingBoxs, ratios] = M_Corner_Filter(corners, boxes)
    dominoCorners = {};
    boundingBoxs = [];
    ratios = [];
    for k = 1:length(corners)
       c = corners{k};
       if size(c, 1) >= 3
           [dominoCorners{end +1}, r] = M_Corner_Organiser(c);
           ratios = [ratios r];
           boundingBoxs = cat(1, boundingBoxs, boxes(k, 1:end));
       end
    end
end