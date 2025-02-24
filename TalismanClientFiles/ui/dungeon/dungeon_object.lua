
include("script/dungeon/dungeon_base.lua")


CDungeonObject = class();


function CDungeonObject:ctor(idx, objectId)
    self.Index = idx
    self.ObjectId = objectId
end


function CDungeonObject:On1SecTimer(dungeon, now)
end


function CDungeonObject:On1SecTimer_Dead(dungeon, now)
end


function CDungeonObject:OnDungeonBegin(dungeon)
end


function CDungeonObject:OnDungeonEnd(dungeon,winner)
end


function CDungeonObject:OnDungeonActorDead(dungeon, actorId, killer, faction)
end


function CDungeonObject:OnDungeonActorRevive(dungeon, actorId)
end


function CDungeonObject:OnDungeonMassCreate(dungeon, massId)
end


function CDungeonObject:OnDungeonMassDead(dungeon, massId, killer, faction)
end


function CDungeonObject:OnDungeonActorApplyQuit(dungeon, actorId)
end


function On1SecTimer(dungeon, now)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:On1SecTimer(dungeon, now)
    end
end


function On1SecTimer_Dead(dungeon, now)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:On1SecTimer_Dead(dungeon, now)
    end
end


function OnDungeonBegin(dungeon)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:OnDungeonBegin(dungeon)
    end
end


function OnDungeonEnd(dungeon,winner)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:OnDungeonEnd(dungeon,winner)
    end
end


function OnDungeonActorDead(dungeon, actorId, killer, faction)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:OnDungeonActorDead(dungeon, actorId, killer, faction)
    end
end


function OnDungeonActorRevive(dungeon, actorId)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:OnDungeonActorRevive(dungeon, actorId)
    end
end


function OnDungeonMassCreate(dungeon, massId)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:OnDungeonMassCreate(dungeon, massId)
    end
end


function OnDungeonMassDead(dungeon, massId, killer, faction)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:OnDungeonMassDead(dungeon, massId, killer, faction)
    end
end


function OnDungeonActorApplyQuit(dungeon, massId)
    local obj = DungeonObjectTable[dungeon]
    if obj~=nil then
        obj:OnDungeonActorApplyQuit(dungeon, massId)
    end
end

