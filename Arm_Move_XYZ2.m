
function Arm_Move_XYZ2(points,touch)
PORTNUM = 6;

%direction of the complete path in the x axis
direction = -1;
% direction = sign(points(end,1)-points(1,1));
% if(direction == 0)
%     direction = 1;
% end

endAngle = 0;
if(touch)
    endAngle = 40;
end
%reinitialize = 1;
maxSpeed = 100;

maxDistance = 20;
xyPath = points(1,:);

%interpolate inbetween points
for i=1:size(points,1)-1
    currPoint = points(i,:);
    nextPoint = points(i+1,:);
    
    distance = sqrt(sum((currPoint-nextPoint).^2));
    
    pointNum = floor(distance/1);

    for j=1:pointNum
        x = currPoint(1) + j/pointNum *(nextPoint(1)-currPoint(1));
        y = currPoint(2) + j/pointNum *(nextPoint(2)-currPoint(2));
        xyPath(end+1,:) = [x,y];

     end
end

solutionPath = zeros(size(xyPath,1),4);
for i=1:size(xyPath,1)
    angleSet = Arm_Find_Solution(xyPath(i,1),xyPath(i,2));
    
    %find the solution closest to the phi = 90*direction
    [Y,I] = min(abs(angleSet(:,4) - 90*direction));
    %[Y,I2] = min(abs(angleSet(:,4) + 90*direction));
    
    %solution = [angleSet(I,:) angleSet(I2,:)];
    solution = angleSet(I,:);
    if(size(solution,1) == 0)
        warning('no solution found, arm not moved')
        continue
    end
    
    solutionPath(i,:) = solution;
end

startIndex = 1;
startSign = sign(solutionPath(1,4));
finalSolution = solutionPath(1,:);
for i=2:size(solutionPath,1)
    currSign = sign(solutionPath(i,4));
    if(currSign ~= startSign)
        finalSolution(end+1,:) = solutionPath(i-1,:);
        finalSolution(end+1,:) = solutionPath(i,:);
        startIndex = i;
        startSign = currSign;
    elseif((i-startIndex) >= maxDistance)
        finalSolution(end+1,:) = solutionPath(i,:);
        startIndex = i;
        %startSign = currSign;
    end
end

%move arm to first position
solution = finalSolution(1,:);
Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
if(Arm_Wait_Close2(solution,2,PORTNUM))
    disp('timeout @ first move')
    %disp([solution; lastSolution])
    %warning('timeout @ firstMove 1')
    Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
    Arm_Set_Angles(solution(1),solution(2),solution(3),0,PORTNUM);
    Arm_Wait_Close2(solution,2,PORTNUM);
end
Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
Arm_Set_Angles(solution(1),solution(2),solution(3),endAngle,PORTNUM);
Arm_Wait_Moving(4,2,PORTNUM);
reinitialize = 1;

lastSign = sign(solution(4));
for i=2:size(finalSolution,1)
    solution = finalSolution(i,:);
    
    %if change direction, lift up
    if(lastSign ~= sign(solution(4)))
        moveEnd(1,endAngle,PORTNUM,maxSpeed);
        reinitialize = 1;
        endAngle = 0;
    end
    
    %move to point
    if(reinitialize)
        calllib('dynamixel','dxl_initialize',PORTNUM,1);
        reinitialize = 0;
    end
    
    Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,0);
    Arm_Set_Angles(solution(1),solution(2),solution(3),endAngle,0);
    if(Arm_Wait_Close2(solution,2,0))
        disp('timeout @ moving')
        Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
        Arm_Set_Angles(solution(1),solution(2),solution(3),endAngle,PORTNUM);
        Arm_Wait_Close2(solution,2,PORTNUM)
        reinitialize = 1;
    end

    %if change direction, place down
    if(lastSign ~= sign(solution(4)))
        disp('move down')
        endAngle = 40;
        moveEnd(0,endAngle,PORTNUM,maxSpeed);
        reinitialize = 1;
        Arm_Wait_Moving(4,3,PORTNUM);
    end
    
    lastSign = sign(solution(4));
end

%res = finalSolution;
%Lift arm up
Arm_Set_Angles(-300,-300,-300,0,0);
calllib('dynamixel','dxl_terminate');
end


function moveEnd(up,angle,PORTNUM,maxSpeed)
if(up)
    angle = 0;
end
Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
Arm_Set_Angles(300,300,300,angle,PORTNUM);
if(Arm_Wait_Moving(4,2,PORTNUM))
    disp('timeout @ moveEndPoint')
    Arm_Set_Speeds(maxSpeed,maxSpeed,maxSpeed,maxSpeed,PORTNUM);
    Arm_Set_Angles(300,300,300,angle,PORTNUM);
end
end
