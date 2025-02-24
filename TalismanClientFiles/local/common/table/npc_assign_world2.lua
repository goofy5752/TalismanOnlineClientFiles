
gPath=""

function OnAreaLoaded()
    RenderLoad("maps/world2/world2.xml");
    TableLoad("monster", "local/common/table/npc.csv", "ID");
end

function OnAreaClosing()
    RenderClear();
    TableClose("monster");
end

function GetExtDisp(path)
    if path=="NpcAssign.id" then
		gPath=path
        return 1;
    end
    return 0;
end

function OnGridSetValue(path, value)
    if path=="NpcAssign.id" then
        return TableFind("monster", "mapname", "ID", value)
    end
    return value;
end

function OnGridRClick(path, value)
    if path=="NpcAssign.id" then
        return TableLineSelecter("monster", "ID,Name,Exp,Nimbus", "ID", value)
    end
    return value;
end

function OnGridRClick_Multi(path, value)
    if path=="NpcAssign.id" then
        return TableMultiLineSelecter("monster", "ID,Name,Exp,Nimbus", "ID,Name", value)
    end
    return value;
end

function GetPath()
	return gPath
end
