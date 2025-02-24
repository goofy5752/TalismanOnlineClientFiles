
function OnAreaLoaded()
    RenderLoad("maps/fb14/fb14.xml");
end

function OnAreaClosing()
    RenderClear();
end

function GetExtDisp(path)
    return 0;
end

function OnGridSetValue(path, value)
    return "";
end

function OnGridRClick(path, value)
    return "";
end
