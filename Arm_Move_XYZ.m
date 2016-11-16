
function [] = Arm_Move_XYZ(points,touch)

calllib('dynamixel','dxl_initialize',6,1);

%direction of the complete path in the x axis
direction = sign(points(end,1)-points(1,1));
if(direction == 0)
    direction = 1;
end

endAngle = 0;
if(touch)
    endAngle = 40;
end

lastSolution = Arm_Get_Angles();

for i=1:size(points,1)-1;
    currPoint = points(i,:);
    nextPoint = points(i+1,:);
    
    distance = sqrt(sum((currPoint-nextPoint).^2));

    maxDistance = 10;
    
    pointNum = floor(distance/maxDistance)+1;

    for j=1:pointNum
        x = currPoint(1) + j/pointNum *(nextPoint(1)-currPoint(1));
        y = currPoint(2) + j/pointNum *(nextPoint(2)-currPoint(2));

        angleSet = Arm_Find_Solution(x,y);

        %find the solution closest to the phi = 90*direction
        [Y,I] = min(abs(angleSet(:,4) - 90*direction));

        solution = angleSet(I,:);
        
        Arm_Set_Speeds(40,40,40,40);
        if(touch && j==1 && i==1)
            Arm_Set_Angles(solution(1),solution(2),solution(3),0);
            Arm_Wait_Moving(3)
            Arm_Wait_Moving(2)
        end
        Arm_Set_Angles(solution(1),solution(2),solution(3),endAngle);

        Arm_Wait_Close(solution, lastSolution)
        
        lastSolution = solution;
    end
end

Arm_Set_Angles(-300,-300,-300,0);
calllib('dynamixel','dxl_terminate');
end
