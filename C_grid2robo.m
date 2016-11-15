function [robo_x, robo_y, robo_z] = C_grid2robo(grid_x, grid_y)
    temp = grid_y;
    grid_y = grid_x;
    grid_x = temp;
    
    numPoints = numel(grid_x);

    square_size = 75;
    xOffset = square_size/2+120;
    yOffset = square_size/2-75*5;

    for i=1:numPoints
        robo_x(i) = grid_x(i)*square_size + xOffset;
        robo_y(i) = grid_y(i)*square_size + yOffset;
        robo_z(i) = 0;
    end
    
end 