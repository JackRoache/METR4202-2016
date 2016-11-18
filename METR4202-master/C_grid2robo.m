function [robo_x, robo_y, robo_z] = C_grid2robo(grid_x, grid_y)
    
    numPoints = numel(grid_x);

    square_size = 75;

    for i=1:numPoints
        robo_x(i) = (grid_x(i)-4.5)*square_size;
        robo_y(i) = (grid_y(i)+0.5)*square_size;
        robo_z(i) = 0;
    end
    
end 