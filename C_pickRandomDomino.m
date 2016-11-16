function [chosenDomino] = C_pickRandomDomino(dominos)

    numDomino = numel(dominos);
    indexes = randperm(numDomino);

    chosenDomino = {};
    
    for k = 1:numDomino
        if ~isempty(dominos{indexes(k)})
            chosenDomino = dominos{indexes(k)};
            return
        end
    end
end