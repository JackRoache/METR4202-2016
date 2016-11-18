function angles = Arm_Find_Solution(x,y)
    L1 = 210; %origin to first motor in mm
    L2 = 115;
    L3 = 150;
    
    %phi = theta1+theta2+theta3
    phi = transpose(-160:1:160);
    
    y_dash = y - L3*cosd(phi);
    
    x_dash = x - L3*sind(phi);
    
    k = (y_dash.^2 + x_dash.^2 - L1^2 - L2^2)./(2*L1*L2);
    
    %find the real solutions of k
    I = find(abs(k)<=1);
    
    %limit to real solutions
    phi = phi(I);
    x_dash = x_dash(I);
    y_dash = y_dash(I);
    
    %find theta2 solutions for each phi
    phi(find(phi==0))=1;
    theta2 = acosd(k(I)).*sign(phi);
    
    %theta1 = acosd((y_dash.*(L2*cosd(theta2)+L1) + x_dash.*(L2*sind(theta2)))./(L2^2 + L1^2 + 2*L1*L2*cosd(theta2)));
    
    c1 = (L1+L2*cosd(theta2));
    c2 = (L2*sind(theta2));
    
   ctheta1 = (y_dash.*c1 + x_dash.*c2)./(c1.^2+c2.^2);
   stheta1 = (y_dash.*c2 - x_dash.*c1)./(c1.^2+c2.^2);
    
    theta1 = -1*atan2d(stheta1,ctheta1);
    
    
    theta3 = phi-theta1-theta2;
    
    angles = [theta1,theta2,theta3,phi];
    
    angles = angles(find(abs(angles(:,1))<=90),:);
    angles = angles(find(abs(angles(:,2))<=125),:);
    angles = angles(find(abs(angles(:,3))<=90),:);
end