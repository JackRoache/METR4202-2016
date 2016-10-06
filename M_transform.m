function  [dominoProps] = M_transform(dominos)
% Make object to record dominos
dominoProps = zeros(length(dominos),6);

for i=1:length(dominos)
    c = dominos{i};
    
    % Define Points
    w1 = c(1,1:2);
    w2 = c(2,1:2);
    w3 = c(3,1:2);
    w4 = c(4,1:2);

    % Define Centre
    dominoProps(i,1) = (w1(1)+w2(1)+w3(1)+w4(1))/4;
    dominoProps(i,2) = (w1(2)+w2(2)+w3(2)+w4(2))/4;
    
    % Define Lines
    line1 = [w1,w2];
    line2 = [w2,w3];
    line3 = [w3,w4];
    line4 = [w4,w1];
    lines = [line1;line2;line3;line4];
    
    % Distance
    lines(1,5) = norm(lines(1,1:2)-lines(1,3:4));
    lines(2,5) = norm(lines(2,1:2)-lines(2,3:4));
    lines(3,5) = norm(lines(3,1:2)-lines(3,3:4));
    lines(4,5) = norm(lines(4,1:2)-lines(4,3:4));

    % Gradient
    lines(1,6) = (lines(1,4)- lines(1,2)) / (lines(1,3)- lines(1,1));
    lines(2,6) = (lines(2,4)- lines(2,2)) / (lines(2,3)- lines(2,1));
    lines(3,6) = (lines(3,4)- lines(3,2)) / (lines(3,3)- lines(3,1));
    lines(4,6) = (lines(4,4)- lines(4,2)) / (lines(4,3)- lines(4,1));

    % Y Intercept
    lines(1,7) = lines(1,2)-lines(1,1)*lines(1,6);
    lines(2,7) = lines(2,2)-lines(2,1)*lines(2,6);
    lines(3,7) = lines(3,2)-lines(3,1)*lines(3,6);
    lines(4,7) = lines(4,2)-lines(4,1)*lines(4,6);

    % Angle with X axis
    lines(1,8) = atan(lines(1,6));
    lines(2,8) = atan(lines(2,6));
    lines(3,8) = atan(lines(3,6));
    lines(4,8) = atan(lines(4,6));

    % Sort by length
    lines = sortrows(lines,5);

    % Get average angle of lines
    avg_long_ang = (lines(4,8)+lines(3,8))/2;
    avg_short_ang = (lines(2,8)+lines(1,8))/2;
    
    % Get average length of lines
    avg_long_len = (lines(4,5)+lines(3,5))/2;
    avg_short_len = (lines(2,5)+lines(1,5))/2;
    
    % Get angle between long and short lines
    ang_diff = avg_short_ang-avg_long_ang;
    A = tan(ang_diff);

    % Get ratio of long and short line
    B = avg_long_len/avg_short_len;

    % Solve for angles
    syms x y;
    eqn1 = A == 1/(tan(x)*sin(y));
    eqn2 = B == 2*cos(y) / sqrt( cos(x)^2 + sin(x)^2*sin(y)^2 );
    S = vpasolve(eqn1, eqn2, 1.57);
    if (any(size(S.x) == 0))
       theta = 0;
       phi = 0;
    else
       theta = double(S.x*180/pi);
       phi = double(S.y*180/pi);

       theta = mod(theta,360);
       if(theta>90)
           theta = 180 - theta;
           phi = phi * -1;
       end
    end

%     arrow_y = 10*sin(theta);
%     arrow_x = 10*cos(theta)*sin(phi);
%     arrow_r = sqrt(arrow_y^2+arrow_x^2);
%     arrow_ang = atan(arrow_y/arrow_x);
% 
%     plot_ang = arrow_ang-avg_long_ang;
%     plot_x = arrow_r*cos(plot_ang);
%     plot_y = arrow_r*sin(plot_ang);
% 
%     quiver(Centre_X, Centre_Y, plot_x, plot_y, 0, 'Color', 'g', 'LineWidth', 1)
%     quiver(Centre_X, Centre_Y, -plot_x, -plot_y, 0, 'Color', 'r', 'LineWidth', 1)

    % Specify the pose in extrinsic rotation order
    dominoProps(i,3) = theta;
    dominoProps(i,4) = phi;
    dominoProps(i,5) = avg_long_ang;
    
    % Find the area
    LS = avg_long_len/cos(phi*pi/180);
    SS = LS/2;
    dominoProps(i,6) = LS*SS;
    
end  
    
    
    
    

