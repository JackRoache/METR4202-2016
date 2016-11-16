%Arm_Set_Angles Sets the angle for all motors.
%Arm_Set_Angles(theta1,theta2,theta3,theta4)
%theta1-4 are the angles for motors 1(base)-4(tip)
%thetaX = 0 sets the motor X to the mid point of its range
%Motors 1-4 have a range from -150 to 150 degrees
%Dynamixel connection must be initialised prior to using the function
function Arm_Set_Speeds(theta1,theta2,theta3,theta4)
DEFAULT_PORTNUM = 6;  %COM6
DEFAULT_BAUDNUM = 1;  %1Mbps

if(abs(theta1) < 150)
    %throw error here
end
set_speed(1,100);
set_speed(2,100);
set_speed(3,100);
set_speed(4,100);

%set Base servo
set_angle(1,512+theta1*1024/300);

set_angle(2,512+theta2*1024/300);

set_angle(3,512+theta3*1024/300);

set_angle(4,512-theta4*1024/300);

%Close Device
%calllib('dynamixel','dxl_terminate');
end

function set_angle(id,angle)
P_GOAL_POSITION =30;
calllib('dynamixel','dxl_write_word',id,P_GOAL_POSITION,angle);
end

function set_speed(id,speed)
    P_MOVING_SPEED = 32;
    calllib('dynamixel','dxl_write_word',id,P_MOVING_SPEED,speed);
end