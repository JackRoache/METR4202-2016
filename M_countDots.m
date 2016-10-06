function [domino] = M_countDots(corners, croppedImage, box)
    boxX = box(1);
    boxY = box(2);
    
    flatCorners = [0,0;0,80;40,80;40,0];    
    
    [tform, inlierPtsDistorted, inlierPtsOriginal] = ...
        estimateGeometricTransform(corners,flatCorners,...
        'projective');
    
    outputView = imref2d(size(croppedImage));
    Ir = imwarp(croppedImage,tform,'OutputView',outputView);
    
    imshow(Ir);
    
    cropX = mean(corners(:,1));
    cropY = mean(corners(:,2));
    domino(1) = boxX + cropX;
    domino(2) = boxY + cropY;
    

    
end
