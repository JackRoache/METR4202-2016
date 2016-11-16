function [domino_memory] = M_addToMemory(domino, dominoPos, dominoProps, domino_memory, time)
    
    % calc velocity as well
    domino_memory = cat(1, domino_memory, [domino, dominoPos, dominoProps, time]);

end