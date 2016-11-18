function timeout = Arm_Wait_Close(desiredPos,lastPos,percent,port)
step = abs(desiredPos-lastPos);
wait = 1;
time = tic;
while(wait && (toc(time) < 5))
    angles = Arm_Get_Angles(port);
    
    distances = abs(desiredPos-angles);
    
    if(max(distances./step) > percent)
        wait = 0;
    end
    
end

timeout = 0;
if(toc(time)>t)
    timeout=1;
end

end