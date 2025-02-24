
function OnAreaLoaded()
    RenderLoad("maps/sfb014/sfb014.xml");
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
