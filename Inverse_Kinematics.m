function angles = Inverse_Kinematics(x,y,z)
    L1 = 103-45; %origin to first motor in mm
    L2 = 45;
    L3 = 95;
    L4 = 78;
    L5 = 63;
    
    theta1 = rad2deg(atan2(x,y));
    
    phi = transpose(135:1:225);
    
    %not valie for theta1=90, use x_dash instead
    %make a switch if theta=90
    y_dash = y/cosd(theta1) - L5*sind(phi);
    
    z_dash = z-L1-L2 - L5*cosd(phi);
    
    k = (y_dash.^2 + z_dash.^2 - L4^2 - L3^2)/(2*L4*L3);
    
    %find the real solutions of k
    I = find(abs(k)<=1);
    
    %limit to real solutions
    phi = phi(I);
    z_dash = z_dash(I);
    y_dash = y_dash(I);
    
    %find theta3 solutions for each phi
    theta3 = acosd(k(I));
    
    
    theta2 = acosd((z_dash.*(L4*cosd(theta3)+L3) + y_dash.*(L4*sind(theta3)))./(L4^2 + L3^2 + 2*L3*L4*cosd(theta3)));
    
    theta4 = phi-theta2-theta3;
    
    theta1 = theta1*ones(size(theta3));
    
    angles = [theta1,theta2,theta3,theta4,phi];
end