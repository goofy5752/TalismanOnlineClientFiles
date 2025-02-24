include("script/ectype/ectype_class.lua")

ClassTable = {}
ObjTable = {}

function Init()
	ClassTable[13] = CEctype13
	ClassTable[15] = CEctype15
end

function Uninit()		
end

function CreateEctype(nTypeId, nObjId)
    if ClassTable[nTypeId] == nil then
        return nil
    end   

	if ObjTable[nObjId] == nil then
	    ObjTable[nObjId] = ClassTable[nTypeId].new(nTypeId, nObjId)
	end
		
	return ObjTable[nObjId]
end

function DeleteEctype(nTypeId, nObjId)
	if ObjTable[nObjId] then
		ObjTable[nObjId] = nil
	end
end

function OnTimer(nTypeId, nObjId, dwNow)
    local Ectype = CreateEctype(nTypeId, nObjId)
    if Ectype == nil then
        return
    end
    
    Ectype:OnTimer(dwNow)
end

function OnEnterBattle(nTypeId, nObjId, nCreId)
    local Ectype = CreateEctype(nTypeId, nObjId)
    if Ectype == nil then
        return
    end
    
    Ectype:OnEnterBattle(nCreId)
end

function OnLeaveBattle(nTypeId, nObjId, nCreId)
    local Ectype = CreateEctype(nTypeId, nObjId)
    if Ectype == nil then
        return
    end
    
    Ectype:OnLeaveBattle(nCreId)
end

function OnLaunchSelfScript(
    nTypeId,
    nObjId,
    nReleaseType, 
    nReleaseId,
    nCreId,
    fParam1,
    fParam2,
    fParam3
)
    local Ectype = CreateEctype(nTypeId, nObjId)
    if Ectype == nil then
        return
    end
    
    Ectype:OnLaunchSelfScript(
        nReleaseType,
        nReleaseId,
        nCreId,
        fParam1,
        fParam2,
        fParam3
    )
end

