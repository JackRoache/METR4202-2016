



function [] = Arm_Move_XYZ(points)

res = calllib('dynamixel','dxl_initialize',6,1);

for i=1:size(points,1)-1;
    currPoint = points(i,:);
    nextPoint = points(i+1,:);
    
    distance = sqrt(sum((currPoint-nextPoint).^2));

    maxDistance = 10;
    
    pointNum = floor(distance/maxDistance)+1;

    for j=1:pointNum
        x = currPoint(1) + j/pointNum *(nextPoint(1)-currPoint(1));
        y = currPoint(2) + j/pointNum *(nextPoint(2)-currPoint(2));
        z = currPoint(3) + j/pointNum *(nextPoint(3)-currPoint(3));

        angleSet = Inverse_Kinematics_Test(x,y,z);

        %find the solution closest to the phi = 180
        I = find(angleSet(:,5) < 181,1,'last');

        solution = angleSet(I,:);

        %Test angles are within limits. Needs to be pulled into it's own
        %function
        test = abs(solution(1)) < 90 & abs(solution(2)) < 90 & abs(solution(3)) < 140 & abs(solution(4)) < 90;

        if(test)
            Arm_Set_Angles(solution(1),solution(2),solution(3),solution(4));

            Moving = int32(calllib('dynamixel','dxl_read_byte',3,46));
            while(Moving)
                Moving = int32(calllib('dynamixel','dxl_read_byte',3,46));
            end
        end
    end
end


calllib('dynamixel','dxl_terminate');
end
