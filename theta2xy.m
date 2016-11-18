function res = theta2xy(angles)
L1 = 210; %origin to first motor in mm
L2 = 115;
L3 = 150;
res = [angles zeros(size(angles,1),2)];
for i=1:size(angles,1)
    t1 = angles(i,1);
    t2 = angles(i,2);
    t3 = angles(i,3);
    x = L1*sind(t1)+L2*sind(t1+t2)+L3*sind(t1+t2+t3);
    y = L1*cosd(t1)+L2*cosd(t1+t2)+L3*cosd(t1+t2+t3);
    res(i,5:6) = [x y];
end

end