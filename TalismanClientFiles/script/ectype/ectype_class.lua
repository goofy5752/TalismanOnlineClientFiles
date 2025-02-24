include("script/lua_class_inc.lua")

--------------------------------------------------------------------------------

CEctype = class()

function CEctype:ctor(nTypeId, nObjId)
	self.nTypeId = nTypeId
	self.nObjId = nObjId
end

function CEctype:OnTimer(dwNow)
end

function CEctype:OnEnterBattle(nCreId)
end

function CEctype:OnLeaveBattle(nCreId)
end

function CEctype:OnLaunchSelfScript(
    nReleaseType, 
    nReleaseId,
    nCreId,
    fParam1,
    fParam2,
    fParam3
)
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--id=13 的脚本实现
--------------------------------------------------------------------------------

CEctype13 = class(CEctype)

function CEctype13:ctor(nTypeId, nObjId)
	self.dwLastTime = -1
	self.nExchangePosFlag = 0
	self.nNpc4613EnterBattleFlag = 0
	self.nNpc4614EnterBattleFlag = 0
end

function CEctype13:OnTimer(dwNow)
    if self.nExchangePosFlag == 0 then
        return
    end
    
    if self.dwLastTime == -1 then
        self.dwLastTime = dwNow
        return
    end
    
    if dwNow > (self.dwLastTime + 60 * 1000) then
        self.dwLastTime = dwNow
        
        nNpc4613Id = GetNpcIdByTypeIdThroughScene(self.nObjId, 4613)
        nNpc4614Id = GetNpcIdByTypeIdThroughScene(self.nObjId, 4614)
        
        if (nNpc4613Id == 0) or (nNpc4614Id == 0) then
            self.nExchangePosFlag = 0
            return
        end

        ExchangeCrePos(nNpc4613Id, nNpc4614Id)
        
    end
end

function CEctype13:OnEnterBattle(nCreId)
    nNpcTypeId = GetNpcTypeIdByObjectId(nCreId)
    if nNpcTypeId == 0 then
        return
    end
    
    if nNpcTypeId == 4613 then
        self.nNpc4613EnterBattleFlag = 1
    elseif nNpcTypeId == 4614 then
        self.nNpc4614EnterBattleFlag = 1
    else
        return
    end
    
    if  (self.nNpc4613EnterBattleFlag == 1) or 
        (self.nNpc4614EnterBattleFlag == 1) 
    then
        self.nExchangePosFlag = 1
    end
end

function CEctype13:OnLeaveBattle(nCreId)
    nNpcTypeId = GetNpcTypeIdByObjectId(nCreId)
    if nNpcTypeId == 0 then
        return
    end
    
    if nNpcTypeId == 4613 then
        self.nNpc4613EnterBattleFlag = 0
    elseif nNpcTypeId == 4614 then
        self.nNpc4614EnterBattleFlag = 0
    else
        return
    end
    
    if  (self.nNpc4613EnterBattleFlag == 0) and
        (self.nNpc4614EnterBattleFlag == 0) 
    then
        self.nExchangePosFlag = 0
        self.dwLastTime = -1
    end
end

function CEctype13:OnLaunchSelfScript(
    nReleaseType, 
    nReleaseId,
    nCreId,
    fParam1,
    fParam2,
    fParam3
)
    if nReleaseType ~= 1 then
        return
    end
    
    if nReleaseId ~= 1240 then
        return
    end
    
    nNpcTypeId = GetNpcTypeIdByObjectId(nCreId)
    if nNpcTypeId ~= 4615 then
        return
    end
    
    Random = math.random(1, 100);
    if (Random < 100) and (Random > 66) then
        CreSetPositionById(nCreId, -1134, 106, 1)
    elseif (Random < 66) and (Random > 33) then
        CreSetPositionById(nCreId, -1142, 91, 1)
    else
        CreSetPositionById(nCreId, -1151, 109, 1)
    end
    
end
--------------------------------------------------------------------------------
--id=15 的脚本实现
--------------------------------------------------------------------------------

CEctype15 = class(CEctype)

function CEctype15:ctor(nTypeId, nObjId)
	self.dw4840LastTime = -1
	self.nNpc4840EnterBattleFlag = 0
	self.dw4837LastTime = -1
	self.nNpc4837EnterBattleFlag = 0
end

function CEctype15:OnTimer(dwNow)
    if self.dw4840LastTime == -1 then
        self.dw4840LastTime = dwNow
	 self.dw4837LastTime = dwNow
        return
    end

    if dwNow > (self.dw4840LastTime + 30 * 1000) then
        self.dw4840LastTime = dwNow
        if self.nNpc4840EnterBattleFlag == 1 then
		nNpc4840Id = GetNpcIdByTypeIdThroughScene(self.nObjId, 4840)
    		Random = math.random(1, 100);
    		if (Random < 100) and (Random >= 66) then
        		CreateNpc(nNpc4840Id, 4859, 0, 0, 0)
    		elseif (Random < 66) and (Random >= 33) then
        		CreateNpc(nNpc4840Id, 4860, 0, 0, 0)
    		else
        		CreateNpc(nNpc4840Id, 4861, 0, 0, 0)
    		end
    	 end
    end

    if dwNow > (self.dw4837LastTime + 15 * 1000) then
        self.dw4837LastTime = dwNow
        if self.nNpc4837EnterBattleFlag == 1 then
	       nNpc4837Id = GetNpcIdByTypeIdThroughScene(self.nObjId, 4837)
		CreateNpc(nNpc4837Id , 4862, 0, 0, 0)
		CreateNpc(nNpc4837Id , 4862, 0, 0, 0)
		CreateNpc(nNpc4837Id , 4862, 0, 0, 0)
    	 end
    end

end

function CEctype15:OnEnterBattle(nCreId)
    nNpcTypeId = GetNpcTypeIdByObjectId(nCreId)
    if nNpcTypeId == 0 then
        return
    end
    
    if nNpcTypeId == 4840 then
        self.nNpc4840EnterBattleFlag = 1
    end

    if nNpcTypeId == 4837 then
        self.nNpc4837EnterBattleFlag = 1
    end

end

function CEctype15:OnLeaveBattle(nCreId)
    nNpcTypeId = GetNpcTypeIdByObjectId(nCreId)
    if nNpcTypeId == 0 then
        return
    end
    
    if nNpcTypeId == 4840 then
        self.nNpc4840EnterBattleFlag = 0
    end

    if nNpcTypeId == 4837 then
        self.nNpc4837EnterBattleFlag = 0
    end

end

