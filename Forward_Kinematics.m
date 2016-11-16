%Forward Kinematics
%calculates the forward kinematics equations for our 4R joint arm

%values are returned in terms of variables:
%Lengths between each frame (L1...L5)
%Angles of each pivot from the origin (theta1...theta5)

function Forward_Kinematics
syms 'x' 'y' 'z'
syms 'theta1' 'theta2' 'theta3' 'theta4'
% theta1 = deg2rad(0);
% theta2 = deg2rad(90);
% theta3 = deg2rad(0);
% theta4 = deg2rad(90);

syms 'L1' 'L2' 'L3' 'L4' 'L5'
% L1 = 50;
% L2 = 50;
% L3 = 50;
% L4 = 50;
% L5 = 50;

%Origin is a frame set below the first Revolute joint
%+ve Z is vertical
%+ve X is parallel to the base
%+vx Z is out from the base
ORA = diag([1,1,1]);    %Rotation from Origin to frame A
ARB = Rz(-theta1);      %Rotation from frame A to frame B
BRC = Rx(-theta2);      %Rotation from frame B to frame C
CRD = Rx(-theta3);      %Rotation from frame C to frame D
DRE = Rx(-theta4);      %Rotation from frame D to frame E

OPA = [0;0;L1];
APB = [0;0;L2];
BPC = [0;L3*sin(theta2);L3*cos(theta2)];
CPD = [0;L4*sin(theta3);L4*cos(theta3)];
DPE = [0;L5*sin(theta4);L5*cos(theta4)];

OTA = [ORA OPA; 0 0 0 1];
ATB = [ARB APB; 0 0 0 1];
BTC = [BRC BPC; 0 0 0 1];
CTD = [CRD CPD; 0 0 0 1];
DTE = [DRE DPE; 0 0 0 1];

OTE = OTA*ATB*BTC*CTD*DTE;

OTE = simplify(OTE)
disp(OTE(1:3,4))
fx = OTE(1,4);
fy = OTE(2,4);
fz = OTE(3,4);
%disp(simplify(OTE(1,4)/OTE(2,4)))

simplify(jacobian([fx,fy,fz],[theta1 theta2 theta3 theta4]))

end

%Rotate matricies about X,Y,and Z axes
function R = Rx(theta)
R = [1 0 0;0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
end

function R = Ry(theta)
R = [cos(theta) 0 sin(theta);0 1 0; -sin(theta) 0 cos(theta)];
end

function R = Rz(theta)
R = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0;0 0 1];
end

