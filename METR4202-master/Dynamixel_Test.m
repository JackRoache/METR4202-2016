%loadlibrary('dynamixel', 'dynamixel.h')
%libfunctions('dynamixel')
%unloadlibrary('dynamixel')

DEFAULT_PORTNUM = 6;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

%initilisation
%open device
%res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);

id=3;
P_GOAL_POSITION =30; %address value
P_PRESENT_POSITION = 36; %address value of low byte
P_MOVING_SPEED = 32;
P_Moving = 46;
P_LED = 25;

LED = 1; %1 for on 0 for off
GoalPos = 300; %0-1024, 300 degree range. 512=center
Speed = 100; %0-1023 ~0.111RPM (FOR AX-12A)

%set LED
calllib('dynamixel','dxl_write_word',id,P_LED,LED);

%write speed
calllib('dynamixel','dxl_write_word',id,P_MOVING_SPEED,Speed);

%Write goal position
calllib('dynamixel','dxl_write_word',id,P_GOAL_POSITION,GoalPos);

%check moving
Moving = int32(calllib('dynamixel','dxl_read_byte',id,P_Moving));

%while(Moving)
    %Read Present position
%    PresentPos = int32(calllib('dynamixel','dxl_read_word',id,P_PRESENT_POSITION));
%    Moving = int32(calllib('dynamixel','dxl_read_byte',id,P_Moving));
%end

disp([GoalPos PresentPos])

%termination
%Close Device
%calllib('dynamixel','dxl_terminate');