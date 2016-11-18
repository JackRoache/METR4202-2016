% Takes a grid co-ordinate that is not necessarily discrete points and
% snaps it to the nearest grid point.
function [grid] = C_gridSnap(gridi)
    
    
    grid_x = round(gridi(1));
    grid_y = round(gridi(2));
    grid = [grid_x grid_y];
end