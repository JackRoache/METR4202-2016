function [grid] = C_robo2grid(robo)

    square_size = 75;
    robo_x = robo(1);
    robo_y = robo(2);
    
    grid_x = (robo_x)/square_size+4.5;
    grid_y = (robo_y)/square_size-0.5;
    grid = [grid_x, grid_y];
end 