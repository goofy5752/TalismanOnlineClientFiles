OpenFlag = 1 --元神系统是否开放, 1 : 开放, 0 : 关闭

GodSysNeedMinLevel = 10 							--元神系统需要最小等级
GodPowerRecoverPerMinute = 1			--元神力每分钟回复
PractiseConsumeGodPowerPerHour = 20		--闭关时每小时消耗的元神力

ZxMinUseLev = 0	--紫玄果使用的最小等级

--取得每等级的闭关升级时间
function GetHourByLevel(nLevel)
	  return nLevel*2
end

--元神技能总列表
GodSkillSet = {1300}

--计算最大的元神力，参数是元神等级
function GetMaxGodPower(nGodLevel)
	local nMaxGodPower = 0;
    nMaxGodPower = 100 + math.floor(nGodLevel/10)*10;
	return nMaxGodPower
end

--最大可存贮的经验
function GetMaxStoredExp(nLevel, nGodLevel)
		return GetLevelExp(nLevel)
end

--最大可存储的灵力
function GetMaxStoredNimbus(nLevel, nGodLevel)
		return GetLevelNimbus(nLevel)*2
end

--闭关时每小时经验增长,元神等级决定效率
function GetGodExpInc(nLevel, nGodLevel)
		local added = GetLevelExp(nLevel)/GetHourByLevel(nLevel)*0.2
		if(added < 30) then
			added = 30
		end
		return added
end

--闭关是每小时灵力增长,元神等级决定效率
function GetGodNimbusInc(nLevel, nGodLevel)
    local added = GetLevelNimbus(nLevel)/GetHourByLevel(nLevel)*0.2
    if(added < 20) then
    	added = 20
    end
    return added
end

--紫玄果+exp
function GetZiXuanGuoExpIncPerHour(nLevel, nGodLevel)
    local added = GetLevelExp(nLevel)/GetHourByLevel(nLevel)
    if(added < 30) then
    	added = 30
    end
    return added
end

--+nimbus
function GetZiXuanGuoNimbusIncPerHour(nLevel, nGodLevel)
    local added = GetLevelNimbus(nLevel)/GetHourByLevel(nLevel)
    if(added < 20) then
    	added = 20
    end
    return added
end

--消耗量，每小时
function GetZiXuanGuoExpandPerHour(nLevel, nGodLevel)
    local num = nLevel/2
    if(num < 1) then
    	num = 1
    end
    return num
end

--元灵精魂
function GetYuanLingJingHunNimbusIncPerHour(nLevel, nGodLevel)
    local added = GetLevelNimbus(nLevel)/GetHourByLevel(nLevel)*2
    if(added < 100) then
    		added = 100
    end
    return added
end

--数量
function GetYuanLingJingHunExpandPerHour(nLevel, nGodLevel)
    local num = nLevel/2
    if(num < 1) then
    	num = 1
    end
    return num
end

--元神升级
function OnGodLevUp(nUserId, nGodLev, nParty)
    if nGodLev == 2 then
        AddGodSkill(nUserId, 1300)
    end
end

--玩家进入游戏
function OnCreEnterWorld(nUserId, nLevel, nGodLev, nParty)
    if nGodLev >= 2 then
        AddGodSkill(nUserId, 1300)
    end
end

--元神称号
function GetGodTitle(nGodLevel)    
  if nGodLevel >=1 and nGodLevel <= 3 then
    	return "msg_god1_1";
 	elseif nGodLevel >= 4 and nGodLevel <= 6 then
			return "msg_god1_2";
	elseif nGodLevel >= 7 and nGodLevel <= 10 then
			return "msg_god1_3";
	
	elseif nGodLevel >= 11 and nGodLevel <= 13 then
			return "msg_god2_1";
	elseif nGodLevel >= 14 and nGodLevel <= 16 then
			return "msg_god2_2";
	elseif nGodLevel >= 17 and nGodLevel <= 20 then
			return "msg_god2_3";
	
	elseif nGodLevel >= 21 and nGodLevel <= 23 then
			return "msg_god3_1";
	elseif nGodLevel >= 24 and nGodLevel <= 26 then
			return "msg_god3_2";
	elseif nGodLevel >= 27 and nGodLevel <= 30 then
			return "msg_god3_3";
	
	elseif nGodLevel >= 31 and nGodLevel <= 33 then
			return "msg_god4_1";
	elseif nGodLevel >= 34 and nGodLevel <= 36 then
			return "msg_god4_2";
	elseif nGodLevel >= 37 and nGodLevel <= 40 then
			return "msg_god4_3";
	
	elseif nGodLevel >= 41 and nGodLevel <= 43 then
			return "msg_god5_1";
	elseif nGodLevel >= 44 and nGodLevel <= 46 then
			return "msg_god5_2";
	elseif nGodLevel >= 47 and nGodLevel <= 50 then
			return "msg_god5_3";
	
	elseif nGodLevel >= 51 and nGodLevel <= 53 then
			return "msg_god6_1";
	elseif nGodLevel >= 54 and nGodLevel <= 56 then
			return "msg_god6_2";
	elseif nGodLevel >= 57 and nGodLevel <= 60 then
			return "msg_god6_3";
	
	elseif nGodLevel >= 61 and nGodLevel <= 63 then
			return "msg_god7_1";
	elseif nGodLevel >= 64 and nGodLevel <= 66 then
			return "msg_god7_2";
	elseif nGodLevel >= 67 and nGodLevel <= 70 then
			return "msg_god7_3";
	
	elseif nGodLevel >= 71 and nGodLevel <= 73 then
			return "msg_god8_1";
	elseif nGodLevel >= 74 and nGodLevel <= 76 then
			return "msg_god8_2";
	elseif nGodLevel >= 77 and nGodLevel <= 80 then
			return "msg_god8_3";
	
	elseif nGodLevel >= 81 and nGodLevel <= 83 then
			return "msg_god9_1";
	elseif nGodLevel >= 84 and nGodLevel <= 86 then
			return "msg_god9_2";
	elseif nGodLevel >= 87 and nGodLevel <= 90 then
			return "msg_god9_3";   	
   
	else
	    return "msg_god1";
	end
end

--模型
function GetGodModel(nGodLevel)
    return "god"
end

function GetGodHint(nGodLevel, nGodState)
    if(nGodLevel==30 and nGodState<1) then
    	 	return "msg_godblock"
    elseif (nGodLevel==60 and nGodState<2) then	
    		return "msg_godblock"
    elseif (nGodLevel==90 and nGodState<3) then	
    		return "msg_godblock"
    else 
		    return "msg_godok"
		end
end



