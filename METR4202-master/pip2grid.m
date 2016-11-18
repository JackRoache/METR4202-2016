function gridpos = C_pip2grid(pip)
%     pip=[2,4];
    c=[];
    z = [];
    x = linspace(0,6,7);
    y = linspace(0,6,7);
    gz = [];
    %%pip2num
    for x1 = x(1):6
%         count = 0;
        for y1 = y(1):6
            z = cat(1,z,[x1,y1]);
%             c = cat(2,c,count)
%             count = count + 1;
        end
        y = y(2:end);
    end
    for a = 1:length(z)
        if pip(1) == z(a,1) && pip(2) == z(a,2)
            gridposnum = a;
        end
    end
    
    %%num2grid
    for gx = 1:7
        for gy = 1:5
            gz = cat(1,gz,[gx,gy]);
            if size(gz,1)==gridposnum;
                gridpos = [gz(end,1), gz(end,2)];
                break;
            end
        end
        if gridposnum == size(gz,1);
                break;
        end
    end
    



end