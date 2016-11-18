function NoPath = C_checkPath(start,endm,obstacles)
    
    NoPath1 = 0;
    NoPath2 = 0;
    NoPath3 = 0;
    NoPath4 = 0;    
    
    obstacles_p = cat(1,obstacles,endm);
    endm1=[endm(1),endm(2)+1];
    endm2=[endm(1),endm(2)-1];
    endm3=[endm(1)+1,endm(2)];
    endm4=[endm(1)-1,endm(2)];
    for i = 1:size(obstacles,1)
        if endm1 == obstacles{i}       
            NoPath1 = 1;
        end
        if endm2 == obstacles{i} 
            NoPath2 = 1;
        end
        if endm3 == obstacles{i}     
            NoPath3 = 1;
        end
        if endm4 == obstacles{i}  
            NoPath4 = 1;
        end
    end
    
    
    if (endm1(2) < 6)&&(~NoPath1)
        [~,NoPath1] = METR4202_MOTIONPLANNING(start, endm1, obstacles_p);
    else
        NoPath1 = 1;
    end
    if (endm2(2) > 0)&&(~NoPath2)
        [~,NoPath2] = METR4202_MOTIONPLANNING(start, endm2, obstacles_p);
    else
        NoPath2=1;
    end
    if (endm3(1) < 8) &&(~NoPath3)
        [~,NoPath3] = METR4202_MOTIONPLANNING(start, endm3, obstacles_p);
    else
        NoPath3=1;
    end
    if (endm4(1) > 0) &&(~NoPath4)
        [~,NoPath4] = METR4202_MOTIONPLANNING(start, endm4, obstacles_p);
    else
        NoPath4=1;
    end
    NoPath = NoPath1 && NoPath2 && NoPath3 && NoPath4;

end