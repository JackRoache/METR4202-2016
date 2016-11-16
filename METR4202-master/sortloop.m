[~,objectsno] = cell2matrix(obstacles);
%%sort

if objectsno == 1 && domino(1) == 1
    sortdominotri(dominos(x), obstacles);
end
%%reset
inversekin(0,0,0); % reset pos   
%%take new picture