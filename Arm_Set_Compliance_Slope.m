%Arm_Set_Compliance_Slope Sets the Compliance Slopes for all motors.
%Arm_Set_Compliance_Slope(s1,s2,s3,s4)
%s1-4 are the slopes for motors 1(base)-4(tip)
%sX has must be an integer from 1-7
%setting this slope changes the toruqe level near the goal position
%Having a higher value increases flexibility
%Dynamixel connection must be initialised prior to using the function
function Arm_Set_Compliance_Slope(s1,s2,s3,s4)
%No error checking for s<1 or s>7 or s is not an integer
%Plz be aware
set_slope(1,2^s1)
set_slope(2,2^s2)
set_slope(3,2^s3)
set_slope(4,2^s4)
end

function set_slope(id,value)
    P_CW_COMPLIANCE_SLOPE = 28;
    P_CCW_COMPLIANCE_SLOPE = 29;
    calllib('dynamixel','dxl_write_word',id,P_CW_COMPLIANCE_SLOPE,value);
    calllib('dynamixel','dxl_write_word',id,P_CCW_COMPLIANCE_SLOPE,value);
end