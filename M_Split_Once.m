function [corners] = M_Split_Once(c, ratio)
    threshold = .9;
    minLen = min(c(:,end));
    maxLen = max(c(:,end));
    corners = {};
    if sum(ratio ~= [1 2]) ~= 2 && sum(ratio ~= [2 1]) ~= 2
        indexes = [];
        for k = 1:size(c, 1)
           if c(k,end) >  maxLen * threshold
               indexes = [indexes k];
           end
        end
        %%remove and add new indexes
        add = [];
        for k = length(indexes):-1:1
            temp = c(indexes(k),:);
            cp = zeros(1,2);
            cp(1) = mean([temp(1) temp(3)]);
            cp(2) = mean([temp(2) temp(4)]);
            
            
            a1 = [temp(1) temp(2) cp(1) cp(2) norm(temp(1:2) - cp(1:2))];
            a2 = [temp(3) temp(4) cp(1) cp(2) norm(temp(3:4) - cp(1:2))];
            
            add = cat(1, add, a1);
            add = cat(1, add, a2);
        end 
        
        for k = length(indexes):-1:1
           c(indexes(k), :) = [];
        end
        
        CP(1) = mean([add(:,1);add(:,3)]);
        CP(2) = mean([add(:,2);add(:,4)]);
        
        index = 0;
        pos = 0;
        for k = 1:length(add)
            if sum(add(1:2) == CP)==2 
               index = k;
               pos = 1;
               break;
            elseif sum(add(3:4) == CP) == 2
                index = k;
                pos = 2;
            end
        end
        
        if index == 0
            return;
        end
        
        
        
        
        
    end
end