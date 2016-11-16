function sortdomino(dominovalues, obstacles)
    
    if dominovalues(1) == 1
        start = [dominovalues(2)(1)(1), dominovalues(2)(1)(2)];
        dominovalue = sum(dominovalues(6)(1), dominovalues(6)(2));
        if dominovalue < 7
            y = 1;
        else
            y = 3;
        end
        endm = [dominovalue, y];
        [optpath] = motionplan(start, endm, obstacles);
        inversekin(optpath);
    end
end


