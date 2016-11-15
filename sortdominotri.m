function sortdominotri(dominovalues, obstacles)     
    start = [dominovalues(2)(1)(1), dominovalues(2)(1)(2)];
    dominovalues(6)(1) = dominovalues(6)(1) + 1;
    dominovalues(6)(2) = dominovalues(6)(2) + 1;
    endm = [dominovalues(6)(1), dominovalues(6)(1)];
    [optpath] = motionplan(start, endm, obstacles);
    inversekin(optpath);
end