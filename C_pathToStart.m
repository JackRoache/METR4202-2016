function  [waypoints] = C_pathToStart(chosenCentroid, roboStartPoint)

    waypoints = chosenCentroid;
    waypoints = cat(1, waypoints, roboStartPoint);

end