function [robo_x, robo_y] = M_grid2robo(grid_x, grid_y)
    gridsize = 75;
    xOffset = -200;
    yOffset = 50;

    robo_x = grid_x*gridsize + xOffset;
    robo_y = grid_y*gridsize + yOffset;
end 