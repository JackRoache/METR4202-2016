%same spot but moving arm;
res = calllib('dynamixel','dxl_initialize',6,1);
angleSet = Inverse_Kinematics(0, 100, 30);

for i=1:length(angleSet)
    theta1 = angleSet(i,1);
    theta2 = angleSet(i,2);
    theta3 = angleSet(i,3);
    theta4 = angleSet(i,4);
    
    iuotest = abs(theta1) < 90 & abs(theta2) < 90 & abs(theta3) < 140 & abs(theta4) < 90;
    if(test)
        Arm_Set_Angles(theta1,theta2,theta3,theta4);
        
        %calllib('dynamixel','dxl_initialize',6,1);
        Moving = int32(calllib('dynamixel','dxl_read_byte',2,46));
        while(Moving)
            Moving = int32(calllib('dynamixel','dxl_read_byte',2,46));
        end
        %calllib('dynamixel','dxl_terminate');
        %pause(0.005)
    end
end

calllib('dynamixel','dxl_terminate');