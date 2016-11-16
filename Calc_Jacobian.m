function Calc_Jobian(theta1,theta2,theta3,theta4)
 L1 = 103-45; %origin to first motor in mm
    L2 = 45;
    L3 = 95;
    L4 = 78;
    L5 = 63;

Jac = [  cos(theta1)*(L4*sin(theta2 + theta3) + L3*sin(theta2) + L5*sin(theta2 + theta3 + theta4)), sin(theta1)*(L4*cos(theta2 + theta3) + L3*cos(theta2) + L5*cos(theta2 + theta3 + theta4)), sin(theta1)*(L4*cos(theta2 + theta3) + L5*cos(theta2 + theta3 + theta4)), L5*cos(theta2 + theta3 + theta4)*sin(theta1);
 -sin(theta1)*(L4*sin(theta2 + theta3) + L3*sin(theta2) + L5*sin(theta2 + theta3 + theta4)), cos(theta1)*(L4*cos(theta2 + theta3) + L3*cos(theta2) + L5*cos(theta2 + theta3 + theta4)), cos(theta1)*(L4*cos(theta2 + theta3) + L5*cos(theta2 + theta3 + theta4)), L5*cos(theta2 + theta3 + theta4)*cos(theta1);
                                                                                          0,             - L4*sin(theta2 + theta3) - L3*sin(theta2) - L5*sin(theta2 + theta3 + theta4),             - L4*sin(theta2 + theta3) - L5*sin(theta2 + theta3 + theta4),            -L5*sin(theta2 + theta3 + theta4)]
                                                                                      
a = max(max(abs(Jac)))
inverseJ = inv(Jac/a)

end
 