function angles=Arm_Get_Angles(port)
if(port)
    calllib('dynamixel','dxl_initialize',port,1);
end

P_PRESENT_POSITION = 36;
theta1 = (calllib('dynamixel','dxl_read_word',1,P_PRESENT_POSITION)-512)*300/1024;
theta2 = (calllib('dynamixel','dxl_read_word',2,P_PRESENT_POSITION)-512)*300/1024;
theta3 = (calllib('dynamixel','dxl_read_word',3,P_PRESENT_POSITION)-512)*300/1024;
theta4 = (calllib('dynamixel','dxl_read_word',4,P_PRESENT_POSITION)-512)*300/1024;

res = int32(calllib('dynamixel','dxl_get_result'));
if(res ~= 0 && res ~= 1)
    calllib('dynamixel','dxl_initialize',port,1);
    display('error in dxl result')
end

if(port)
    calllib('dynamixel','dxl_terminate');
end

angles = [-theta1,-theta2,theta3,-theta4];
end