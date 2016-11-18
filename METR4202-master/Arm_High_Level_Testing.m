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
points = [300,300;
          200,400;
          0,400;
          0,280;
          200,280;
          200,150;
          -200,150;
          -200,400;];

Arm_Move_XYZ(points,1);
      
PORTNUM = 6;  %COM3
BAUDNUM = 1;  %1Mbps

%%
%Move to position
% % calllib('dynamixel','dxl_initialize',PORTNUM,BAUDNUM);
% % Arm_Set_Speeds(50,30,30,30)
% % Arm_Set_Angles(30.878,0.557,30.32,10)
% % calllib('dynamixel','dxl_terminate');

%%
% % %Test moving at various speeds
% % calllib('dynamixel','dxl_initialize',PORTNUM,BAUDNUM);
% % %Set all angles to their origins
% % Arm_Set_Compliance_Slope(7,7,7,7)
% % Arm_Set_Speeds(30,30,30,30)
% % Arm_Set_Angles(0,0,0,0)
% % Arm_Wait_Moving()
% % 
% % for i=1:2:6
% %     a=30; %incriment in speed each move
% %     c=20; %starting speed
% %     s=a*i+c;
% %     angle = 90;
% % 
% %     %Move to one point
% %     Arm_Set_Speeds(s,s,s,s)
% %     Arm_Set_Angles(0,angle,-angle,0)
% %     Arm_Wait_Moving()
% % 
% %     s=a*(i+1)+c;
% % 
% %     Arm_Set_Speeds(s,s,s,s)
% %     Arm_Set_Angles(0,-angle,angle,0)
% %     Arm_Wait_Moving()
% % end
% % calllib('dynamixel','dxl_terminate');