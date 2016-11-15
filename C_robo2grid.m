function [grid_x, grid_y] = C_robo2grid(robo_x, robo_y)
    
    square_size = 75;
    xOffset = 0;
    yOffset = 0;

    grid_x = (robo_x - xOffset)/square_size;
    grid_y = (robo_y - yOffset)/square_size;
end 