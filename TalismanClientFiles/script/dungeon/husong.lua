-- NPC李英琼及她的巡逻路径
-- 每个剧情的发生点（必须在巡逻路径上）
-- 2种带巡逻路径的强盗怪物
-- NPC炸弹


include("script/dungeon/dungeon_object.lua")


CDungeon_HuSong = class(CDungeonObject)


DungeonTable[2] = CDungeon_HuSong

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


function CDungeon_HuSong:ctor(idx, objectId)
    OutputLog("[CDungeon_HuSong:ctor]               Index = "..self.Index.." ObjectId "..self.ObjectId)

    -- 初始化语言 
    --LOAD_LAN("msg_script_protect_spawn");

    -- 注册事件（不需要的事件不要注册！）
    RegisterDungeonEvent(objectId, EV_DUNGEON_BEGIN);
    RegisterDungeonEvent(objectId, EV_DUNGEON_END);
    RegisterDungeonEvent(objectId, EV_DUNGEON_1SEC_TIMER);
    --RegisterDungeonEvent(objectId, EV_DUNGEON_1SEC_TIMER_DEAD);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_DEAD);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_REVIVE);
    RegisterDungeonEvent(objectId, EV_DUNGEON_MASS_CREATE);
    RegisterDungeonEvent(objectId, EV_DUNGEON_MASS_DEAD);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_APPLYQUIT);

    -- 初始化变量
    self.AvgLevel = 0;                  -- 玩家的平均等级
    self.CurrMassLevel = 0;             -- 当前刷怪的等级
    self.Protector = 0;                 -- 护送的NPC
    self.CurrScene = 0;                 -- 当前的剧情
    self.bSceneRunning = false;         -- 是否在进行当前剧情

end


function CDungeon_HuSong:On1SecTimer(dungeon, now)
    -- 判断是否触发剧情
    if (self.bSceneRunning) then
        self:SceneRun();
    else
        if (self.CurrScene < ScenePositionCount) then
             -- 距离小于120就表示到剧情触发点了
            if (GetPosDistanceGrid(self.Protector, ScenePosition[self.CurrScene + 1].x, ScenePosition[self.CurrScene + 1].y) < 120) then
                self:SceneBegin(self.CurrScene + 1);
            end
        end
    end
end


function CDungeon_HuSong:On1SecTimer_Dead(dungeon, now)
    --OutputLog("[CDungeon_HuSong:On1SecTimer_Dead]   Dungeon = "..dungeon)

end


function CDungeon_HuSong:OnDungeonBegin(dungeon)
    --OutputLog("[CDungeon_HuSong:OnDungeonBegin]     Dungeon = "..dungeon)

    self.AvgLevel = self:CalcAvgLevel(DUNGEON_FACTION1);
    self.CurrMassLevel = self.AvgLevel - 1;

    -- 生成护送被保护者
    self.Protector = CreateNpcInDungeon(self.ObjectId, 4692, DUNGEON_FACTION1, 565, 218, 0, self.AvgLevel, 10);
    Say(self.Protector, "GO GO GO"); -- @@@@@
end


function CDungeon_HuSong:OnDungeonEnd(dungeon,winner)
    --OutputLog("[CDungeon_HuSong:OnDungeonEnd]       Dungeon = "..dungeon)

    -- 显示对话框
    local content = "";
    if (winner == DUNGEON_FACTION1) then
        content = RICH_TEXT_BEGIN..GetFileContent("dungeon/husong_success.xml")..RICH_TEXT_END;
    elseif (winner == DUNGEON_FACTION2) then
        content = RICH_TEXT_BEGIN..GetFileContent("dungeon/husong_fail.xml")..RICH_TEXT_END;
    end
    DungeonShowMsg(dungeon, DUNGEON_FACTION_ALL, content, 1, 1);

    -- 根据胜负给出奖励
    -- @@@@@

end

function CDungeon_HuSong:OnDungeonActorDead(dungeon, actorId, killer, faction)
    OutputLog("[CDungeon_HuSong:OnDungeonActorDead] Dungeon = "..dungeon.." CreId = "..actorId)

end


function CDungeon_HuSong:OnDungeonActorRevive(dungeon, actorId)
    OutputLog("[CDungeon_HuSong:OnDungeonActorRevive] Dungeon = "..dungeon.." CreId = "..actorId)

    --AddEffectEx(actorId,2094,0,0,0,0)
end


function CDungeon_HuSong:OnDungeonMassCreate(dungeon, massId)
    --OutputLog("[CDungeon_HuSong:OnDungeonMassCreate]  Dungeon = "..dungeon.." CreId = "..massId)

end


function CDungeon_HuSong:OnDungeonMassDead(dungeon, massId, killer, faction)
    --OutputLog("[CDungeon_HuSong:OnDungeonMassDead]   Dungeon = "..dungeon.." CreId = "..massId)

    if (massId == self.Protector) then
        EndDungeon(self.ObjectId, DUNGEON_FACTION2);
    end
end


function CDungeon_HuSong:OnDungeonActorApplyQuit(dungeon, actorId)
    OutputLog("[CDungeon_HuSong:OnDungeonActorApplyQuit]  Dungeon = "..dungeon.." CreId = "..actorId)

    LeaveDungeon(self.ObjectId, actorId);

end


function CDungeon_HuSong:SpawnMonster(npcId, x, y, level, ability)
    OutputLog("[CDungeon_HuSong:SpawnMonster]  npc = "..npcId.." x = "..x.." y = "..y);

    CreateNpcInDungeon(self.ObjectId, npcId, DUNGEON_FACTION2, x, y, 0, level, ability)
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
