function dominos = C_flatten_domino_box(dominoBox)

    dominos = {};
    
    for k = 1:length(dominoBox)
        list = dominoBox{k};
        if (length(list) <= 1)
            continue;
        end
        
        pips = [];
        for l = 1:length(list)
            if (list(l).dominoOrDice == 1)
                pips = cat(1, pips, list(l).pips);
            end
        end
        [m, f] = mode(pips, 1);
        s = std(pips,1);
        
        if sum(f > 0.8*length(list)) == 2
            d = list(1);
            d.pips = m;
            dominos = [dominos d];
        end
    end
end