%Arm_Set_Speeds Sets the speed for all motors.
%Arm_Set_Speeds(speed1,speed2,speed3,speed4)
%speed1-4 are the speeds for motors 1(base)-4(tip)
%All speed values have a range from 0-1023 where 1023 is the maximum speed
%Dynamixel connection must be initialised prior to using the function
function Arm_Set_Speeds(speed1,speed2,speed3,speed4,port)
if(port)
    calllib('dynamixel','dxl_initialize',port,1);
end
set_speed(1,speed1);
set_speed(2,speed2);
set_speed(3,speed3);
set_speed(4,speed4);

if(port)
calllib('dynamixel','dxl_terminate');
end
end

function set_speed(id,speed)
    P_MOVING_SPEED = 32;
    calllib('dynamixel','dxl_write_word',id,P_MOVING_SPEED,speed);
end