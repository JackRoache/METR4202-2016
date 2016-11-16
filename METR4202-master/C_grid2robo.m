function [robo_x, robo_y, robo_z] = C_grid2robo(grid_x, grid_y)
    temp = grid_y;
    grid_y = grid_x-1;
    grid_x = temp-1;
    
    numPoints = numel(grid_x);

    square_size = 75;
    % actually y
    xOffset = square_size/2+120;
    % actually x
    yOffset = square_size/2-75*5;

    for i=1:numPoints
        robo_x(i) = grid_x(i)*square_size + xOffset;
        robo_y(i) = grid_y(i)*square_size + yOffset;
        robo_z(i) = 0;
    end
    
end 