function Arm_Wait_Moving(id)
Moving = int32(calllib('dynamixel','dxl_read_byte',id,46));
while(Moving)
    Moving = int32(calllib('dynamixel','dxl_read_byte',id,46));
end

end