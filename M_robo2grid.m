function [grid_x, grid_y] = M_robo2grid(robo_x, robo_y)
    gridsize = 75;
    xOffset = -200;
    yOffset = 50;

    grid_x = (robo_x - xOffset)/gridsize;
    grid_y = (robo_y - yOffset)/gridsize;
end 