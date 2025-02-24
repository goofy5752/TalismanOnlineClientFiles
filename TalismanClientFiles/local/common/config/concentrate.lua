OpenFlag = 1; --凝神系统是否开放, 1 : 开放, 0 : 关闭

ConcentrateMinLev = 30;

function GetMaxConcentrateCount(nLevel)
    if nLevel < 30 then
        return 0;
    end

    local nMaxConcentrateCount = (nLevel - 30) * 40 + 40;
    if nMaxConcentrateCount < 0 then
        nMaxConcentrateCount = 0;
    elseif nMaxConcentrateCount > 400 then
        nMaxConcentrateCount = 400;
    end

    return nMaxConcentrateCount;
end

function GetMonsterExp(nLev)
	return 50 * (1 + nLev / 10) + 5;
end

function GetLimitUser(nUserLev)
	local nLimitLevel = GetLimitLevel();
	if nUserLev >= nLimitLevel then
		return 1;
	else
		return 0;
	end
end

function GetConcentrateExpPerMinute(nUserLev, nItemLev, nItemSmithLev, nItemColor)
    local n = GetMonsterExp(nUserLev);
	local bLimitLevel = GetLimitUser(nUserLev);
    local d = 0;
	local a = 0;
	local A = 0;
	
	
    if nItemColor == 0 then
        d = 0.8;
    elseif nItemColor == 1 then
        d = 0.9;
    elseif nItemColor == 2 then
        d = 1;
    elseif nItemColor == 3 then
        d = 1.1;
    elseif nItemColor == 4 then
        d = 1.2;
    else
        d = 1.2;
    end
    
    if nItemSmithLev <= 0 then
        a = 1;
    elseif nItemSmithLev >= 12 then
        a = 12;
    else
        a = nItemSmithLev;
    end  
    
	A = 1.8 * n * d * (nItemLev + 1) * (1 + a * a * a / 1000) / nUserLev;
	if bLimitLevel == 1 then
		A = 0; 
	end
    return A;
end

function GetConcentrateNimbusPerMinute(nUserLev, nItemLev, nItemSmithLev, nItemColor)
    local n = GetMonsterExp(nUserLev) / 6;
	local bLimitLevel = GetLimitUser(nUserLev);
    local d = 0;
	local a = 0;
	local A = 0;
	
    if nItemColor == 0 then
        d = 0.8;
    elseif nItemColor == 1 then
        d = 0.9;
    elseif nItemColor == 2 then
        d = 1;
    elseif nItemColor == 3 then
        d = 1.1;
    elseif nItemColor == 4 then
        d = 1.2;
    else
        d = 1.2;
    end
    
    if nItemSmithLev <= 0 then
        a = 1;
    elseif nItemSmithLev >= 12 then
        a = 12;
    else
        a = nItemSmithLev;
    end  
	
    local A = 1.8 * n * d * (nItemLev + 1) * (1 + a * a * a / 1000) / nUserLev;
	if bLimitLevel == 1 then
		A = A * 1.5; 
	end
    return A;
end

function OnConcentrateFlagChange(nUserId, nFlag)
    if nFlag == 1 then
        AddEffect(0, nUserId, 2279);
	 IfCreRideThenUnRide(nUserId);
    else
        RemoveEffect(nUserId, 2279)
	RemoveEffect(nUserId, 2280);
    end
end

function OnEnterNoConcentrateArea(nUserId)
    CenterMsg(nUserId, L("msg_concentrate7"));
    AddEffect(0, nUserId, 2280);
end

function OnLeaveNoConcentrateArea(nUserId)
    CenterMsg(nUserId, L("msg_concentrate8"));
    RemoveEffect(nUserId, 2280);
end

function OnUserLevelUp(nUserId, nUserLev)
    SetUserMaxConcentrateCount(nUserId, GetMaxConcentrateCount(nUserLev));
	if nUserLev >= 30 and nUserLev <=39 then
		local intUserConcentCount = GetUserConcentrateCount(nUserId);
		SetUserConcentrateCount(nUserId, intUserConcentCount + 40);
		
	end
end