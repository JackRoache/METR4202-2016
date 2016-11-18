function timeout = Arm_Wait_Close2(desiredPos,angle,port)
%step = abs(desiredPos(1:3)-lastPos(1:3));
wait = 1;
time = tic;
while(wait && (toc(time) < 5))
    angles = Arm_Get_Angles(port);
    
    distances = abs(desiredPos(1:3)-angles(1:3));
    
    if(max(abs(distances)) < angle)
        wait = 0;
    end
    
end

timeout = 0;
if(toc(time)>5)
    timeout=1;
    %disp('distance;desiredPos')
    %disp([distances;desiredPos])
end
end