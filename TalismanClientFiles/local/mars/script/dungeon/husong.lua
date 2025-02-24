include("script/dungeon/dungeon_object.lua")

CDungeon_HuSong = class(CDungeonObject)

DungeonTable[2] = CDungeon_HuSong

function CDungeon_HuSong:ctor(idx, objectId)
    RegisterDungeonEvent(objectId, EV_DUNGEON_BEGIN);
    RegisterDungeonEvent(objectId, EV_DUNGEON_END);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_REVIVE);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_APPLYQUIT);
    --RegisterDungeonEvent(objectId, EV_DUNGEON_1SEC_TIMER);
    --RegisterDungeonEvent(objectId, EV_DUNGEON_1SEC_TIMER_DEAD);
    --RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_DEAD);
    --RegisterDungeonEvent(objectId, EV_DUNGEON_MASS_CREATE);
    RegisterDungeonEvent(objectId, EV_DUNGEON_MASS_DEAD);

    self.AvgLevel = 0;                  -- 玩家的平均等级
    self.Protector = 0;                 -- 护送的NPC
end

function CDungeon_HuSong:CalcAvgLevel()
    local total = DungeonFactionGetActorCount(self.ObjectId, DUNGEON_FACTION1);
    local MaxLevel = 0;
    local AllLevel = 0;
    local AvgLevel = 0;
    if (total > 0) then
        for i=0,total-1 do
            local oneActor = DungeonFactionGetActor(self.ObjectId, DUNGEON_FACTION1, i);
            local lev = GetCreLev(oneActor)
            if ( lev > MaxLevel ) then
                MaxLevel = lev
            end

            AllLevel = lev + AllLevel
        end
        AvgLevel = math.floor( AllLevel / total);
        if ( AvgLevel < MaxLevel - 5 ) then
            AvgLevel = MaxLevel - 5
        end

        if (AvgLevel < 1) then
            AvgLevel = 1;
        end
    end

    return AvgLevel;
end

function CDungeon_HuSong:OnDungeonBegin(dungeon)

    self.AvgLevel = self:CalcAvgLevel();

    self.Protector = CreateNpcInDungeon(self.ObjectId, 6666, DUNGEON_FACTION1, 563, 221, 4, self.AvgLevel, 10, 1);
    --self.Protector = CreateNpcInDungeon(self.ObjectId, 6666, DUNGEON_FACTION1, 615, -237, 4, self.AvgLevel, 10, 1);
    Say(self.Protector, "感谢各位仙家的鼎力相助，但此次征途艰险万分，沿路妖魔众多，随时有牺牲的可能。你们现在还有反悔的机会（可以点退出），请三思而后行。");
    Say(self.Protector, "如果你们决心已定，我们就开始（点我，和我对话）");
end

function CDungeon_HuSong:OnDungeonActorRevive(dungeon, actorId)
    AddEffectEx(actorId,2094,0,0,0,0)
end

function CDungeon_HuSong:OnDungeonActorApplyQuit(dungeon, actorId)
    LeaveDungeon(self.ObjectId, actorId);
end

function CDungeon_HuSong:OnDungeonEnd(dungeon,winner)
    local content = "";
    if (winner == DUNGEON_FACTION1) then
        content = RICH_TEXT_BEGIN..GetFileContent("dungeon/husong_success.xml")..RICH_TEXT_END;
    elseif (winner == DUNGEON_FACTION2) then
        content = RICH_TEXT_BEGIN..GetFileContent("dungeon/husong_fail.xml")..RICH_TEXT_END;
    end
    DungeonShowMsg(dungeon, DUNGEON_FACTION_ALL, content, 1, 1);
end

function CDungeon_HuSong:OnDungeonMassDead(dungeon, massId, killer, faction)
    if (massId == self.Protector) then
        EndDungeon(self.ObjectId, DUNGEON_FACTION2);
    end
end






local HS_SpawnNpc = {4817,4818,4820,4821,4823,4824,4825,4826,4828,4827,4829,4830,4831,4832};
local ScenePosition = {
                        { x = 1, y = 1 },
                      };

local ScenePositionCount = math.random(table.getn(ScenePosition));


-- 护送李英琼开始
-- 每隔一段路就生成一些NPC来攻击李英琼
-- 为了增加趣味性，避免重复枯燥的操作，加入一些特殊剧情
-- 剧情1 -  刷新普通怪物6只，强度 *0.8
-- 剧情2 -  刷新普通怪物6只，强度 *1，怪物死后生成1个炸弹8秒后爆炸，玩家必须在给定时间内打掉炸弹，否则会炸到李英琼
-- 剧情3 -  8个强盗巡逻怪（强度 *1.5），把关，不让玩家和李英琼通过，玩家要通过引怪，一一击破
-- 剧情4 -  李英琼发现1个宝箱并告知玩家去捡（宝箱里的物品该如何设置？）
-- 剧情5 -  刷新普通怪物10只，强度 *1.2
-- 剧情6 -  刷新普通怪物4只，强度 *1.8，另外随机2只元素抗性（具体元素随机）特高的怪物（目的是体现玩家的职业技能价值）
-- 剧情7 -  刷新6只高强度怪物，强度 *5，玩家能坚持20秒后，系统生成1个超强BOSS（强度 *30）帮助玩家过关并且结束这波后就消失了
-- 剧情8 -  李英琼告诉玩家前方有雷区，玩家要主动去引爆，否则会炸伤李英琼
-- 剧情9 -  随机3个元素攻击特高的怪物（目的是体现玩家的防御装备价值），另外还有4个普通怪物，强度 *2
-- 剧情10 - 刷新普通怪物8只，强度 *2
-- 剧情11 - 刷新普通怪物8只，强度 *2.5
-- 剧情12 - 刷新普通怪物8只，强度 *3 ，1分钟之后系统生成背后偷袭的一个boss带着6个npc的追兵。
-- 到达目标地点后就结束副本，胜利！如果中途全部退出或者李英琼被打死，失败！

function CDungeon_HuSong:SceneBegin(sceneId)
    OutputLog("[SceneBegin]               Scene = "..sceneId)

    if (sceneId == 1) then
        local ability = 0.8;
        local creCount = 6;
        local spawnPos = { 
                            { x = 1, y = 1 }, 
                         };
        for i=1,creCount do
            CreateNpcInDungeon(self.ObjectId, HS_SpawnNpc[1], DUNGEON_FACTION2, spawnPos[i].x, spawnPos[i].y, 0, self.AvgLevel , ability)
        end
    elseif (sceneId == 2) then

    elseif (sceneId == 3) then

    elseif (sceneId == 4) then

    elseif (sceneId == 5) then

    elseif (sceneId == 6) then

    elseif (sceneId == 7) then

    elseif (sceneId == 8) then

    elseif (sceneId == 9) then

    elseif (sceneId == 10) then

    elseif (sceneId == 11) then

    elseif (sceneId == 12) then

    end

    self.CurrScene = sceneId;
    self.bSceneRunning = true;

    DisActivePatrol(self.Protector);
end


function CDungeon_HuSong:SceneEnd(sceneId)
    OutputLog("[SceneEnd]               Scene = "..sceneId)

    self.bSceneRunning = false;

    ActivePatrol(self.Protector);
end


function CDungeon_HuSong:SceneRun(sceneId)
    local bEnd = false;

    if (DungeonFactionGetAliveMassesCount(self.ObjectId, DUNGEON_FACTION2) == 0) then
        bEnd = true;
    end

    if (bEnd) then
        self:SceneEnd(sceneId);
    end
end

function CDungeon_HuSong:OnDungeonMassCreate(dungeon, massId)
    --OutputLog("[CDungeon_HuSong:OnDungeonMassCreate]  Dungeon = "..dungeon.." CreId = "..massId)

end




function CDungeon_HuSong:SpawnMonster(npcId, x, y, level, ability)
    OutputLog("[CDungeon_HuSong:SpawnMonster]  npc = "..npcId.." x = "..x.." y = "..y);

    CreateNpcInDungeon(self.ObjectId, npcId, DUNGEON_FACTION2, x, y, 0, level, ability)
end
