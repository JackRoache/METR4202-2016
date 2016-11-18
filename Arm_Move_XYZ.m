
function [] = Arm_Move_XYZ(points,touch)
PORTNUM = 4;

%direction of the complete path in the x axis
direction = sign(points(end,1)-points(1,1));
if(direction == 0)
    direction = 1;
end

endAngle = 0;
if(touch)
    endAngle = 40;
end
reinitialize = 1;
lastSolution = Arm_Get_Angles(PORTNUM);
maxSpeed = 150;
for i=1:size(points,1)-1;
    currPoint = points(i,:);
    nextPoint = points(i+1,:);
    
    distance = sqrt(sum((currPoint-nextPoint).^2));

    maxDistance = 20;
    
    pointNum = floor(distance/maxDistance);

    for j=0:pointNum
        x = currPoint(1) + j/pointNum *(nextPoint(1)-currPoint(1));
        y = currPoint(2) + j/pointNum *(nextPoint(2)-currPoint(2));
        %disp([x,y])
        angleSet = Arm_Find_Solution(x,y);

        %find the solution closest to the phi = 90*direction
        [Y,I] = min(abs(angleSet(:,4) - 90*direction));
        
        solution = angleSet(I,:);
        %disp(solution)
        if(size(solution,1) == 0)
            warning('no solution found, arm not moved')
            continue
        end
        %Arm_Set_Speeds(80,80,80,80);
        
        if(touch && j==0 && i==1)
            Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
            Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
            if(Arm_Wait_Moving(1,5,PORTNUM))
            %if(Arm_Wait_Close(solution,lastSolution,0.9,PORTNUM))
                warning('timeout @ firstMove 1')
                Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
                Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
            end
            %if(Arm_Wait_Moving(2,5,PORTNUM))
            if(Arm_Wait_Close(solution,lastSolution,0.9,PORTNUM))
                warning('timeout @ firstMove 2')
                Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
                Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
            end
            Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
            Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
            Arm_Wait_Moving(4,2,PORTNUM);
            
            reinitialize = 1;
        end
        
        if((max(abs(solution-lastSolution)) > 40) && ~(j==0 && i==1))
            %disp([solution,lastSolution])
            if(sign(solution(4)) ~= sign(direction))
                direction = direction*-1;
            end
            Arm_Set_Angles(300,300,300,0,PORTNUM);
            if(Arm_Wait_Moving(4,2,PORTNUM))
                warning('timeout @ switching direction 1')
                Arm_Set_Angles(300,300,300,0,PORTNUM);
            end
            
            x = currPoint(1) + (j-1)/pointNum *(nextPoint(1)-currPoint(1));
            y = currPoint(2) + (j-1)/pointNum *(nextPoint(2)-currPoint(2));
            
            angleSet = Arm_Find_Solution(x,y);
            %find the solution closest to the phi = 90*direction
            [Y,I] = min(abs(angleSet(:,4) - 90*direction));
            solution2 = angleSet(I,:);
            
            Arm_Set_Speeds(100,100,100,100,PORTNUM);
            Arm_Set_Angles(solution2(1),solution2(2),solution2(3),0,PORTNUM);
            %if(Arm_Wait_Moving(1,10,PORTNUM)||Arm_Wait_Moving(2,10,PORTNUM))
            if(Arm_Wait_Close(solution2,lastSolution,0.9,PORTNUM))
                warning('timeout @ switching direction 2')
                Arm_Set_Speeds(100,100,100,100,PORTNUM);
                Arm_Set_Angles(solution2(1),solution2(2),solution2(3),0,PORTNUM);
            end
            
            Arm_Set_Speeds(100,100,100,100,PORTNUM);
            Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
            %if(Arm_Wait_Moving(1,10,PORTNUM))
            if(Arm_Wait_Close(solution,lastSolution,0.9,PORTNUM))
                warning('timeout @ switching direction 2')
                Arm_Set_Speeds(100,100,100,100,PORTNUM);
                Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
            end
            %if(Arm_Wait_Moving(2,10,PORTNUM))
            if(Arm_Wait_Close(solution,lastSolution,0.9,PORTNUM))
                warning('timeout @ switching direction 3')
                Arm_Set_Speeds(100,100,100,100,PORTNUM);
                Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
            end
            
            reinitialize = 1;
        end
        
        change = abs(solution-lastSolution);
        change = maxSpeed.*change./max(change);
        change(find(change==0  | isnan(change))) = 20;
        
        if(reinitialize)
            calllib('dynamixel','dxl_initialize',PORTNUM,1);
            reinitialize = 0;
        end
        
        Arm_Set_Speeds(change(1),change(2),change(3),50,0);
        Arm_Set_Angles(solution(1),solution(2),solution(3),endAngle,0);
        Arm_Wait_Close(solution, lastSolution,0.6,0);
        if(Arm_Wait_Moving(4,2,0))
            warning('timeout @ basic move')
            reinitialize=1;
        end
        lastSolution = solution;
    end
end

Arm_Set_Angles(-300,-300,-300,0,0);
calllib('dynamixel','dxl_terminate');
end
