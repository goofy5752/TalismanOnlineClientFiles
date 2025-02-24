GodPowerRecoverPerMinute = 0.25				--元神力每分钟回复

ZxMinUseLev = 30	--紫玄果使用的最小等级
ExpIncMax = 10000
NimIncMax = 850

--闭关时每小时经验增长,元神等级决定效率
function GetGodExpInc(nLevel, nGodLevel)
		local added = GetLevelExp(nLevel)/GetHourByLevel(nLevel)*0.2
		if(added < 30) then
			added = 30
		end
		if(added > ExpIncMax) then
			added = ExpIncMax
		end
		return added
end

--闭关是每小时灵力增长,元神等级决定效率
function GetGodNimbusInc(nLevel, nGodLevel)
    local added = GetLevelNimbus(nLevel)/GetHourByLevel(nLevel)*0.2
    if(added < 20) then
    	added = 20
    end
    if(added > NimIncMax) then
			added = NimIncMax
		end
    return added
end

--紫玄果+exp
function GetZiXuanGuoExpIncPerHour(nLevel, nGodLevel)
    --local added = GetLevelExp(nLevel)/GetHourByLevel(nLevel)
    local added = GetZxExpByTable(nLevel)
    if(added < 30) then
    	added = 30
    end
    return added
end

--+nimbus
function GetZiXuanGuoNimbusIncPerHour(nLevel, nGodLevel)
    --local added = GetLevelNimbus(nLevel)/GetHourByLevel(nLevel)
    local added = GetZxNimbusByTable(nLevel)
    if(added < 20) then
    	added = 20
    end
    return added
end

--消耗量，每小时
function GetZiXuanGuoExpandPerHour(nLevel, nGodLevel)
    --local num = nLevel/2
    if(nLevel < 30) then
    	return 0
    end
    
    local num = GetZxExpandByTable(nLevel)
    return num
end

--元灵精魂
function GetYuanLingJingHunNimbusIncPerHour(nLevel, nGodLevel)
    --local added = GetLevelNimbus(nLevel)/GetHourByLevel(nLevel)*2
    local added = GetYlNimbusByTable(nLevel)
    if(added < 100) then
    		added = 100
    end
    return added
end

--数量
function GetYuanLingJingHunExpandPerHour(nLevel, nGodLevel)
    --local num = nLevel/2
    if(nLevel < 30) then
    	return 0
    end
    local num = GetYlExpandByTable(nLevel)
    return num
end


