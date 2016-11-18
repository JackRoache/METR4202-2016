function Arm_Reset
PORTNUM = 4;  %COM3
BAUDNUM = 1;  %1Mbps

%calllib('dynamixel','dxl_initialize',PORTNUM,BAUDNUM);

Arm_Set_Speeds(20,30,50,100,PORTNUM)
Arm_Set_Angles(-300,-300,-300,-20,PORTNUM)
Arm_Wait_Moving(4,5,PORTNUM)
Arm_Set_Angles(90,0,0,-20,PORTNUM)

%calllib('dynamixel','dxl_terminate');
end