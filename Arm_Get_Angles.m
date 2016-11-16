function angles=Arm_Get_Angles()
P_PRESENT_POSITION = 36;
theta1 = calllib('dynamixel','dxl_read_word',1,P_PRESENT_POSITION)-512;
theta2 = calllib('dynamixel','dxl_read_word',2,P_PRESENT_POSITION)-512;
theta3 = calllib('dynamixel','dxl_read_word',3,P_PRESENT_POSITION)-512;
theta4 = calllib('dynamixel','dxl_read_word',4,P_PRESENT_POSITION)-512;

angles = [theta1,theta2,theta3,theta4];
end