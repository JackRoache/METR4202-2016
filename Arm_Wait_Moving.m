function timeout = Arm_Wait_Moving(id,t,port)
if(port)
    calllib('dynamixel','dxl_initialize',port,1);
end

Moving = int32(calllib('dynamixel','dxl_read_byte',id,46));
time = tic;
while(Moving && (toc(time) < t))
    Moving = int32(calllib('dynamixel','dxl_read_byte',id,46));
end
timeout = 0;
if(toc(time)>t)
    timeout=1;
end

if(port)
    calllib('dynamixel','dxl_terminate');
end
end