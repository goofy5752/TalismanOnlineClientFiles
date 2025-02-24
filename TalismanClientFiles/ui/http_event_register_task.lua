function HttpEvent_Task_Locate_Default(argument)
    local px = tonumber(argument.px);
    local py = tonumber(argument.py);
    local hint = argument.hint;
    local mapid = tonumber(argument.mapid);
    uiTaskActiveLocate(mapid,px,py,hint);
end
BindCallBack("task", "locate", "default", HttpEvent_Task_Locate_Default);  


