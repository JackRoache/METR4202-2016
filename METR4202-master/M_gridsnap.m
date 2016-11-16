% Takes a grid co-ordinate that is not necessarily discrete points and
% snaps it to the nearest grid point.
function [grid_x, grid_y] = M_gridsnap(grid_x, grid_y)
    grid_x = round(grid_x);
    grid_y = round(grid_y);

end