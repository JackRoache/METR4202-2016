% applies blob analysis and returns bounding boxes.
function [boundingBoxs] = M_Blob(BWim)

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 150);
boundingBoxs = step(blobAnalysis, BWim);

% result = insertShape(colorImoriginal, 'Rectangle', bbox, 'Color', 'green');
% numCars = length(bbox);
% result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
%     'FontSize', 14);

end
