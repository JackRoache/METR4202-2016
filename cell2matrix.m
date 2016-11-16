function [im_matrix,objectsno] = cell2matrix(obstacles, endm)
    im_matrix = zeros(10,10);
    obstacles = obstacles + [endm(1), endm(2)];
    for i=1:size(obstacles,1)
        if ((obstacles{i}(1) ~= 0) || (obstacles{i}(2) ~= 0))
            im_matrix(obstacles{i}(1),obstacles{i}(2)) = 1;
        else
            im_matrix(obstacles{i}(1),obstacles{i}(2)) = 0;
            
        end
    end
    im_matrix = rot90(im_matrix);
    row = ones(1,size(im_matrix,1));
    col = ones(size(im_matrix,2)+2,1);
    im_matrix = [row; im_matrix;row];
    im_matrix = [col im_matrix col];
    NumObjects=bwconncomp(not(im_matrix));
    objectsno = NumObjects.NumObjects;
    
    
end