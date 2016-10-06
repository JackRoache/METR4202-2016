function [NumberOfCentroidsInArea] = M_Check_Area(corners, Stats)
    NumberOfCentroidsInArea = 0;
    [V, I] = max(corners(:,2));
    topInd = I;
    rightInd = mod(I,4)+1;
    bottomInd = mod(rightInd,4)+1;
    leftInd = mod(bottomInd,4)+1;
    
    %grad 1 is top left, grad2 top right, grad 3 bottom right, g4 BL
    grad1 = (corners(topInd,2)-corners(leftInd,2))/(corners(topInd,1)-corners(leftInd,1)+0.001);
    grad2 = (corners(topInd,2)-corners(rightInd,2))/(corners(topInd,1)-corners(rightInd,1)+0.001);
    grad3 = (corners(bottomInd,2)-corners(leftInd,2))/(corners(bottomInd,1)-corners(leftInd,1)+0.001);
    grad4 = (corners(bottomInd,2)-corners(rightInd,2))/(corners(bottomInd,1)-corners(rightInd,1)+0.001);
    
    c1 = corners(topInd,2)-grad1*corners(topInd,1);
    c2 = corners(topInd,2)-grad2*corners(topInd,1);
    c3 = corners(bottomInd,2)-grad3*corners(bottomInd,1);
    c4 = corners(bottomInd,2)-grad3*corners(bottomInd,1);
    
    
    %%%CHECK IF CENTROIDS IS RIGHT DIMENSIONS
    for i=1:size(Stats, 1)
        centreX = Stats(i).Centroid(1);
        centreY = Stats(i).Centroid(2);
        l1=centreX*grad1+c1;
        l2=centreX*grad2+c2;
        l3=centreX*grad3+c3;
        l4=centreX*grad4+c4;

        if (l1>centreY)&&(l2>centreY)&&(l3<centreY)&&(l4<centreY)
            NumberOfCentroidsInArea = NumberOfCentroidsInArea + 1;
        end
    end
   
    
    
end
        
    
    
    
    
    