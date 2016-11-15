if(~libisloaded('dynamixel'))
loadlibrary('dynamixel', 'dynamixel.h')
end

% points = [0,100,30;
%           0,100,50;
%           0,100,70;
%           0,150,70;
%           30,150,70;
%           60,150,70;
%           90,150,70;
%           90,150,30;
%           90,150,20;
%           0,150,20;
%           -90,150,20;];
%       
% 
% points = [0,130,50;
%           0,130,0;
%           60,130,0;
%           0,130,0];

%Arm_Move_XYZ(points);

PORTNUM = 6;  %COM3
BAUDNUM = 1;  %1Mbps

calllib('dynamixel','dxl_initialize',PORTNUM,BAUDNUM);
Arm_Set_Angles(-75,90,0,90)
calllib('dynamixel','dxl_terminate');