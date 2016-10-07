function [domino_xyz_vel, domino_Prop_rotxyz, actual_domino] = M_dominoVelocity(domino, dominoPos, dominoProps, time, actual_domino)
    %% get domino in frame1 & 2
    %dominoPos = 
    % dominoProps = [centrepointx,centrepointy,rotx,roty,rotz,area]
    domino_xyz_vel = [];
    domino_Prop_rotxyz = [];
    
    
    domino_positions = [];
    dominos = [];
    domino_Props = [];
    frame_no = 5;
    %%%time_dif = ?
    if size(domino,2) == 4 || size(domino,2) == 3
        actual_domino = cat(1,actual_domino, [domino,dominoPos,dominoProps, time]);
    else
        for i=length(actual_domino)-5:length(actual_domino)
            if (actual_domino(i) ~= [])
                break;
            end
            if i == length(actual_domino)
                actual_domino = [];
            end
        end
    end
    if length(actual_domino) == 0
        dominos = [];
        domino_Poss = [];
        domino_Props = [];
        %actual_domino = [];
    end
    if size(actual_domino,1)>5
        for i=length(actual_domino)-5:length(actual_domino)
            dominos = dominos + [actual_domino{i,1}];
            domino_Poss = domino_positions + [actual_domino{i,2}];
            domino_Props = domino_Props + [actual_domino{i,3}];
        end
        
        domino_xyz_displacement = [mean(domino_Poss(:,1)/length(domino_Poss)), mean(domino_Poss(:,2)/length(domino_Poss)), mean(domino_Poss(:,3)/length(domino_Poss))];
        domino_mag_displacement = norm(domino_xyz_displacement);
        time = frame_no; %time of frames
        domino_xyz_vel = domino_xyz_displacement./(time_dif/frame_no);
%         domino_mag_vel = domino_mag_displacement/(time_dif/frame_no);
        domino_Prop_rotxyz = [mean(domino_Props(:,3)),mean(domino_Props(:,3)),mean(domino_Props(:,3))];
%         domino_Prop_rotmag = norm(domino_Prop_rotxyz);  
           
  
    end

end