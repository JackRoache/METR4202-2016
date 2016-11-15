%Arm_Set_Angles Sets the angle for all motors.
%
%Arm_Set_Angles(theta1,theta2,theta3,theta4)
%theta1-4 are the angles for motors 1(base)-4(tip)
%thetaX = 0 sets the motor X to the mid point of its range
%Motors 1-4 have a range from -150 to 150 degrees
%Dynamixel connection must be initialised prior to using the function
function Arm_Set_Angles(theta1,theta2,theta3,theta4)
set_speed(1,50);
set_speed(2,50);
set_speed(3,50);
set_speed(4,50);

if(theta1 >= -90 && theta1 <=90)
    set_angle(1,512+theta1*1024/300);
else
    warning('Motor 1 out of range, did not move')
end

if(theta2 >= 0 && theta2 <=90)
    set_angle(2,512+theta2*1024/300);
else
    warning('Motor 2 out of range, did not move')
end

if(theta3 >= -90 && theta3 <=90)
    set_angle(3,512+theta3*1024/300);
else
    warning('Motor 3 out of range, did not move')
end

if(theta4 >= -90 && theta4 <=90)
    set_angle(4,512-theta4*1024/300);
else
    warning('Motor 4 out of range, did not move')
end

end

function set_angle(id,angle)
P_GOAL_POSITION =30;
calllib('dynamixel','dxl_write_word',id,P_GOAL_POSITION,angle);
end

function set_speed(id,speed)
    P_MOVING_SPEED = 32;
    calllib('dynamixel','dxl_write_word',id,P_MOVING_SPEED,speed);
end