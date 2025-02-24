--      等级差造成的打不中（竞技场中削弱等级差造成的MISS）
-- BOSS的生成、光环
-- 同步距离太小（能不能在竞技场中加大）
--      抵抗目前没有对有益BUFF起作用
-- 瘟疫的散播方式
--      怪物打完一个怪就回到巡逻位置然后才搜索下一个目标，能不能打完第一个就立即搜索
-- 场景最好容易区分目前的所在地
-- 温泉不要显示血条和名字


-- 温泉模型的BBox是不是太大导致在附近不好点
-- 攻击光环和防御光环脚底下踩个效果
-- 物品掉落调整（1 不掉3种炮台道具   2 弱效群补棒提高掉率）
-- 双方的炮台位置不对称造成不公平
--      竞技场的BUFF和道具在离开竞技场要立即清除，一定要仔细检查，否则问题大了
--      大本营没有攻击，机关兽也没有攻击
--      炮台免疫所有BUFF
--      物品的掉落(包括测试)
-- 结束时的对话框和奖励
-- 汉化以及文字部分


include("script/dungeon/dungeon_object.lua")


CDungeon_3C = class(CDungeonObject)


DungeonTable[3] = CDungeon_3C


-- 左边和右边的巡逻路线
local PatrolPathCenter1_v1 = "624 120;644 120;664 120;684 120;704 120;718 122;730 126;746 128;764 130;784 130;804 130;824 130;844 130;864 130;884 130;904 130;924 130;931 127";
local PatrolPathCenter1_v2 = "624 114;644 114;664 114;684 114;704 116;718 120;730 122;746 120;764 122;784 122;804 122;824 122;844 122;864 122;884 122;904 122;924 122;931 127";
local PatrolPathCenter2_v1 = "924 130;904 130;884 130;864 130;844 130;824 130;804 130;784 130;764 130;746 128;730 124;718 120;704 120;684 120;664 120;644 120;624 120;613 118";
local PatrolPathCenter2_v2 = "924 122;904 122;884 122;864 122;844 122;824 122;804 122;784 122;764 122;746 120;730 118;718 118;704 118;684 114;664 114;644 114;624 114;613 118";
local PatrolPathTop1_v1 = "611 138;623 159;634 172;641 179;660 183;676 188;690 195;708 199;726 202;746 202;766 202;786 202;806 202;826 202;844 200;864 200;884 200;900 195;915 185;919 169;930 159;930 139;931 127";
local PatrolPathTop1_v2 = "621 144;623 166;634 180;641 185;660 190;676 194;690 200;708 205;726 208;746 208;766 208;786 208;806 208;826 208;844 206;864 206;884 206;900 201;915 191;919 175;930 165;930 145;931 127";
local PatrolPathTop2_v1 = "931 147;930 159;919 169;915 185;900 195;884 206;864 206;844 206;826 208;806 208;786 208;766 208;746 208;726 208;708 205;690 200;676 194;660 190;641 185;634 180;623 166;621 144;618 132;611 120";
local PatrolPathTop2_v2 = "931 157;930 167;919 175;915 191;900 201;884 211;864 211;844 211;826 214;806 214;786 214;766 214;746 214;726 214;708 211;690 206;676 200;660 196;641 191;634 186;623 172;621 150;618 135;611 120";
local PatrolPathBottom1_v1 = "611 95;617 81;621 70;631 58;650 53;668 51;684 47;700 41;716 37;736 37;756 37;776 37;796 37;816 37;836 37;854 39;872 43;892 43;909 49;924 59;932 70;932 87;932 107;932 126;";
local PatrolPathBottom1_v2 = "611 101;617 87;621 76;631 64;650 59;668 57;684 53;700 47;716 43;736 43;756 43;776 43;796 43;816 43;836 43;854 45;872 49;892 49;909 55;924 65;932 76;932 93;932 113;932 126;";
local PatrolPathBottom2_v1 = "933 104;932 87;932 70;924 59;909 49;892 43;872 43;854 39;836 37;816 37;796 37;776 37;756 37;736 37;716 37;700 41;684 47;668 51;650 53;631 58;621 70;617 81;611 98;611 116;";
local PatrolPathBottom2_v2 = "933 110;932 93;932 76;924 65;909 55;892 49;872 49;854 45;836 43;816 43;796 43;776 43;756 43;736 43;716 43;700 47;684 53;668 57;650 59;631 64;621 76;617 87;611 98;611 116;";

local SpawnNpc = { 4744,4745,4746,4747,4748,4749,4750,4751,4752,4753 }
local SpawnBossId = { 4810,4811,4812,4813,4814,4815,4816 }

local SpawnNpcCount = table.getn(SpawnNpc);
local SpawnBossCount = table.getn(SpawnBossId);

local SpawnNpcPos_Center1_v1 = { x = 624, y = 120 }
local SpawnNpcPos_Center1_v2 = { x = 624, y = 114 }
local SpawnNpcPos_Center2_v1 = { x = 924, y = 130 }
local SpawnNpcPos_Center2_v2 = { x = 924, y = 122 }
local SpawnNpcPos_Top1_v1 = { x = 611, y = 138 }
local SpawnNpcPos_Top1_v2 = { x = 621, y = 148 }
local SpawnNpcPos_Top2_v1 = { x = 931, y = 147 }
local SpawnNpcPos_Top2_v2 = { x = 931, y = 157 }
local SpawnNpcPos_Bottom1_v1 = { x = 611, y = 95 }
local SpawnNpcPos_Bottom1_v2 = { x = 611, y = 101 }
local SpawnNpcPos_Bottom2_v1 = { x = 933, y = 104 }
local SpawnNpcPos_Bottom2_v2 = { x = 933, y = 110 }


-- 宝箱位置和宝箱（NPC）的ID
local SpawnGiftPos = {
                        { x = 779, y = 131 },
                        { x = 813, y = 143 },
                        { x = 766, y = 118 },
                        { x = 797, y = 96 },
                        { x = 763, y = 162 },
                        { x = 764, y = 221 },
                        { x = 795, y = 36 },
                     };
local SpawnGiftNpc = { 4805 };

-- 宝箱守护者的位置和NPC的ID
local SpawnGiftProtectorPos = {
                        { x = 779, y = 128 },
                        { x = 813, y = 139 },
                        { x = 766, y = 121 },
                        { x = 794, y = 96 },
                        { x = 766, y = 162 },
                        { x = 764, y = 218 },
                        { x = 795, y = 39 },
                     };
local SpawnGiftProtectorNpc = 4808;

local RevivePos1 = { x = 583, y = 118 };
local RevivePos2 = { x = 966, y = 127 };

local BeKill_Actor = {};    -- 每个参赛者被杀死数量
local Kill_Actor = {};      -- 每个参赛者杀死的对方参赛者数量

local KillBonusItem = { 4137,4138,4139,4140 };
local KillBonusItemCount = table.getn(KillBonusItem);

local SpawnBossInterval = 14;


function CDungeon_3C:ctor(idx, objectId)
    OutputLog("[CDungeon_3C:ctor]               Index = "..self.Index.." ObjectId "..self.ObjectId)

    -- 初始化语言 
    --LOAD_LAN("msg_script_protect_spawn");
    LOAD_LAN("msg_script_warn_base");
    LOAD_LAN("msg_script_killer_gift");
    LOAD_LAN("msg_script_spawn_boss");
    LOAD_LAN("msg_script_spawn_box");
    LOAD_LAN("msg_script_spawn_monsternext");

    -- 注册事件（不需要的事件不要注册！）
    RegisterDungeonEvent(objectId, EV_DUNGEON_BEGIN);
    RegisterDungeonEvent(objectId, EV_DUNGEON_END);
    RegisterDungeonEvent(objectId, EV_DUNGEON_1SEC_TIMER);
    RegisterDungeonEvent(objectId, EV_DUNGEON_1SEC_TIMER_DEAD);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_DEAD);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_REVIVE);
    RegisterDungeonEvent(objectId, EV_DUNGEON_MASS_CREATE);
    RegisterDungeonEvent(objectId, EV_DUNGEON_MASS_DEAD);
    RegisterDungeonEvent(objectId, EV_DUNGEON_ACTOR_APPLYQUIT);

    -- 初始化变量
    self.now = 0;
    self.start = 0;

    self.Protector_Faction1 = 0;        -- 阵营1的大本营
    self.Protector_Faction2 = 0;        -- 阵营2的大本营
    self.ShopNpc_Faction1 = 0		-- 阵营1的商店
    self.ShopNpc_Faction2 = 0		-- 阵营2的商店
    self.AvgLevel_Faction1 = 0;         -- 进入时阵营1的平均等级
    self.AvgLevel_Faction2 = 0;         -- 进入时阵营2的平均等级
    self.AvgLevel = 0;                  -- 副本内角色的平均等级
    self.TD_Score1 = 0;                  -- 阵营1结束时候增加的积分
    self.TD_Score2 = 0;                  -- 阵营2结束时候增加的积分
    self.TD_KillNum1 = 0;               -- 阵营1总的杀怪数
    self.TD_KillNum2 = 0;               -- 阵营2总的杀怪数
    self.TD_Exp1 = 0 ;                   -- 阵营1奖励经验
    self.TD_Nimbus1 = 0 ;                -- 阵营1奖励灵力
    self.TD_Money1 = 0 ;                 -- 阵营1奖励金钱
    self.TD_Exp2 = 0 ;                   -- 阵营2奖励经验
    self.TD_Nimbus2 = 0 ;                -- 阵营2奖励灵力
    self.TD_Money2 = 0 ;                 -- 阵营2奖励金钱
    self.TD_Team1 = "";                  -- 阵营1队伍名
    self.TD_Team2 = "";                  -- 阵营2队伍名
    self.TD_Winner = "";                 -- 胜利者
    self.pk_lev1 = 0;                    -- 阵营1竞技等级
    self.pk_lev2 = 0;                    -- 阵营2竞技等级
    self.Race_Score1 = 0;		 -- 阵营1战斗积分
    self.Race_Score2 = 0;		 -- 阵营2战斗积分
    self.Race_Player = 5;		 -- 杀死玩家的基础分
    self.Race_Monster = 1;     		 -- 杀死怪物的基础分
    self.TD_KillActor1 = 0;		 -- 阵营1杀死玩家数
    self.TD_KillActor2 = 0;              -- 阵营2杀死玩家数
    self.User1 = "";
    self.User1 = "";

    -- 刷怪
    self.CurrMassLevel = 0;             -- 当前刷新怪物的等级
    self.CurrMassIndex = 0;             -- 当前刷新怪物的Index
    self.SpawnMonsterLeft = 0;          -- 当前剩余的刷怪的数量
    self.SpawnBossLeft = 0;             -- 当前剩余的刷BOSS的数量
    self.CurrSpawnState = 2;            -- 当前刷怪的状态（1-刷怪过程中   2-刷怪结束）
    self.NextSpawnTime = 0;             -- 下一次刷怪的时间
    self.SpawnSecondsCounter = 0;       -- 刷怪的秒数计数（xx秒钟刷出来一个）
    self.NextBossIndex = 1;             -- 下一次刷BOSS的Index
    self.NextBossBoShu = SpawnBossInterval + math.random(-3, 3);    -- 下一次刷BOSS时的NPC强度

    self.ProtectorHint1 = 0;            -- 上一次通知大本营被打的时间1
    self.ProtectorHint2 = 0;            -- 上一次通知大本营被打的时间2
    self.ProtectorHp1 = 0;              -- 上一次大本营的HP 1
    self.ProtectorHp2 = 0;              -- 上一次大本营的HP 2
end


function CDungeon_3C:On1SecTimer(dungeon, now)
    --OutputLog("[CDungeon_3C:On1SecTimer]        Dungeon = "..dungeon.." Now = "..now)
  
    if (self.start == -1) then
        return
    end

    if (self.start == 0) then
        self.start = now
    end

    if ((now - self.start) > 3600) then
	if(self.Race_Score1 > self.Race_Score2) then
          EndDungeon(dungeon, DUNGEON_FACTION1);
        elseif (self.Race_Score1 < self.Race_Score2) then
	  EndDungeon(dungeon, DUNGEON_FACTION2);	
	end
	if (self.Race_Score1 == self.Race_Score2) then
	 local temp_random = math.random(0,100);
	 if  (self.TD_KillNum1 > self.TD_KillNum2) then
	  EndDungeon(dungeon, DUNGEON_FACTION2);
         elseif (self.TD_KillNum1 < self.TD_KillNum2) then
  	  EndDungeon(dungeon, DUNGEON_FACTION1);
	 elseif (temp_random > 50) then
	  --OutputLog("temp_random = "..temp_random)           
          EndDungeon(dungeon, DUNGEON_FACTION1);
	 else
          EndDungeon(dungeon, DUNGEON_FACTION2);
	 end
	end

        --self.start = -1
    end

    self.now = now;

    -- 刷新怪物和BOSS
    if (self.CurrSpawnState == 1) then

        if (self.SpawnSecondsCounter > 0) then
            self.SpawnSecondsCounter = self.SpawnSecondsCounter - 1;
        else
            if (self.SpawnMonsterLeft > 0) then
                self:SpawnMass();
            elseif (self.SpawnBossLeft > 0) then
                self:SpawnBoss();
            else 
                self:UpdateStateAfterSpawn()
            end

            self.SpawnSecondsCounter = 2;
        end

    elseif (self.CurrSpawnState == 2) then

        if (self.NextSpawnTime == 0) then
            self.NextSpawnTime = now + 5;
        elseif (now >= self.NextSpawnTime) then -- 超过时间就进入刷怪状态
            self.CurrSpawnState = 1;
            self.CurrMassIndex = self.CurrMassIndex + 1
            self.SpawnMonsterLeft = 3;
            self.SpawnBossLeft = 0;
            self.SpawnSecondsCounter = 0;
            self:BroadcastSpawn();

            -- 判断是不是刷BOSS的时候了
            if (self.CurrMassIndex >= self.NextBossBoShu) then
                self.SpawnBossLeft = 1;
            end
        end

    end

    -- 刷新宝箱
    if (math.random(900) == 1) then -- 平均15分钟刷1个
    --if (math.random(120) == 1) then
        self:SpawnGift();
    end

    -- 双方的大本营是否受到攻击了，如果是就通知对方
    if (now > self.ProtectorHint1 + 8) then
        local hp = GetCreHp(self.Protector_Faction1); 
        
        if (hp < self.ProtectorHp1) then
            local LAN_Warn_Base = LAN("msg_script_warn_base"); -- "你的大本营目前正在受到攻击！";
            DungeonFactionReceiveMsg(self.ObjectId, DUNGEON_FACTION1, LAN_Warn_Base, CHANNEL_SYS);
        end

        self.ProtectorHp1 = hp;
    end

    if (now > self.ProtectorHint2 + 8) then
        local hp = GetCreHp(self.Protector_Faction2);
        if (hp < self.ProtectorHp2) then
            local LAN_Warn_Base = LAN("msg_script_warn_base"); -- "你的大本营目前正在受到攻击！";
            DungeonFactionReceiveMsg(self.ObjectId, DUNGEON_FACTION2, LAN_Warn_Base, CHANNEL_SYS);
        end

        self.ProtectorHp2 = hp;
    end

end


function CDungeon_3C:On1SecTimer_Dead(dungeon, now)

end


function CDungeon_3C:OnDungeonBegin(dungeon)

    -- 计算平均等级
    self.AvgLevel_Faction1 = self:CalcAvgLevel(DUNGEON_FACTION1);
    self.AvgLevel_Faction2 = self:CalcAvgLevel(DUNGEON_FACTION2);
    self.AvgLevel = math.floor((self.AvgLevel_Faction1 + self.AvgLevel_Faction2) / 2);

    self.CurrMassLevel = self.AvgLevel;
    self.CurrMassIndex = 0;

    -- 生成双方大本营和炮台
    self.Protector_Faction1 = CreateNpcInDungeon(self.ObjectId, 4806, DUNGEON_FACTION1, 617, 118, 4, self.AvgLevel, 1, 1);
    self.Protector_Faction2 = CreateNpcInDungeon(self.ObjectId, 4806, DUNGEON_FACTION2, 929, 127, 12, self.AvgLevel, 1, 1);

    --生成双方温泉
    local npc1 = CreateNpcInDungeon(self.ObjectId, 4809, DUNGEON_FACTION1, 598, 131, 4, self.AvgLevel, 10, 1);
    AddEffectEx( npc1, 2208, 0,  0, 0, 0);
    local npc2 = CreateNpcInDungeon(self.ObjectId, 4809, DUNGEON_FACTION2, 947, 104, 12, self.AvgLevel, 10, 1);
    AddEffectEx( npc2, 2208, 0,  0, 0, 0);
    
    --生成商店
    self.ShopNpc_Faction1 = CreateNpcInDungeon(self.ObjectId, 4883, DUNGEON_FACTION1, 602, 110, 4, self.AvgLevel, 10, 1);
    self.ShopNpc_Faction2 = CreateNpcInDungeon(self.ObjectId, 4883, DUNGEON_FACTION2, 954, 132, 12, self.AvgLevel, 10, 1);
    

    local defendRate1 = 2;
    local defendRate2 = 3;
    local defendRate3 = 3;
    -- 生成正方炮台
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 693, 129, 8, self.AvgLevel, defendRate1, 1);  -- 中路1（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 695, 107, 0, self.AvgLevel, defendRate1, 1);  -- 中路1（下）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 648, 126, 8, self.AvgLevel, defendRate2, 1);  -- 中路2（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 648, 108, 0, self.AvgLevel, defendRate2, 1);  -- 中路2（下）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 683, 129, 8, self.AvgLevel, defendRate1, 1);  -- 中路1（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 685, 107, 0, self.AvgLevel, defendRate1, 1);  -- 中路1（下）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 638, 126, 8, self.AvgLevel, defendRate2, 1);  -- 中路2（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 638, 108, 0, self.AvgLevel, defendRate2, 1);  -- 中路2（下）（减速）

    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 695, 210, 8, self.AvgLevel, defendRate1, 1);  -- 上路1（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 695, 192, 0, self.AvgLevel, defendRate1, 1);  -- 上路1（下）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 632, 189, 8, self.AvgLevel, defendRate2, 1);  -- 上路2（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 639, 176, 0, self.AvgLevel, defendRate2, 1);  -- 上路2（下）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 685, 210, 8, self.AvgLevel, defendRate1, 1);  -- 上路1（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 685, 192, 0, self.AvgLevel, defendRate1, 1);  -- 上路1（下）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 623, 184, 8, self.AvgLevel, defendRate2, 1);  -- 上路2（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 629, 170, 0, self.AvgLevel, defendRate2, 1);  -- 上路2（下）（减速）

    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 695, 55, 8, self.AvgLevel, defendRate1, 1);  -- 下路1（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 695, 31, 0, self.AvgLevel, defendRate1, 1);  -- 下路1（下）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 637, 62, 8, self.AvgLevel, defendRate2, 1);  -- 下路2（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION1, 633, 48, 0, self.AvgLevel, defendRate2, 1);  -- 下路2（下）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 685, 55, 8, self.AvgLevel, defendRate1, 1);  -- 下路1（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 685, 31, 0, self.AvgLevel, defendRate1, 1);  -- 下路1（下）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 627, 66, 8, self.AvgLevel, defendRate2, 1);  -- 下路2（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION1, 621, 52, 0, self.AvgLevel, defendRate2, 1);  -- 下路2（下）（减速）

    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION1, 617, 109, 8, self.AvgLevel, defendRate3, 1);  -- 护卫1
    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION1, 617, 129, 0, self.AvgLevel, defendRate3, 1);  -- 护卫2
    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION1, 624, 150, 0, self.AvgLevel, defendRate3, 1);  -- 护卫3
    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION1, 626, 90, 0, self.AvgLevel, defendRate3, 1);  -- 护卫4

    -- 生成反方炮台
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 851, 136, 8, self.AvgLevel, defendRate1, 1);  -- 中路1（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 851, 116, 0, self.AvgLevel, defendRate1, 1);  -- 中路1（下）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 902, 142, 8, self.AvgLevel, defendRate2, 1);  -- 中路2（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 902, 116, 0, self.AvgLevel, defendRate2, 1);  -- 中路2（下）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 861, 138, 8, self.AvgLevel, defendRate1, 1);  -- 中路1（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 861, 118, 0, self.AvgLevel, defendRate1, 1);  -- 中路1（下）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 912, 142, 8, self.AvgLevel, defendRate2, 1);  -- 中路2（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 912, 116, 0, self.AvgLevel, defendRate2, 1);  -- 中路2（下）（减速）

    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 851, 218, 8, self.AvgLevel, defendRate1, 1);  -- 上路1（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 851, 198, 0, self.AvgLevel, defendRate1, 1);  -- 上路1（下）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 902, 215, 8, self.AvgLevel, defendRate2, 1);  -- 上路2（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 902, 195, 0, self.AvgLevel, defendRate2, 1);  -- 上路2（下）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 861, 218, 8, self.AvgLevel, defendRate1, 1);  -- 上路1（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 861, 198, 0, self.AvgLevel, defendRate1, 1);  -- 上路1（下）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 912, 215, 8, self.AvgLevel, defendRate2, 1);  -- 上路2（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 912, 195, 0, self.AvgLevel, defendRate2, 1);  -- 上路2（下）（减速）

    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 851, 55, 8, self.AvgLevel, defendRate1, 1);  -- 下路1（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 851, 31, 0, self.AvgLevel, defendRate1, 1);  -- 下路1（下）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 902, 62, 8, self.AvgLevel, defendRate2, 1);  -- 下路2（上）
    CreateNpcInDungeon(self.ObjectId, 4801, DUNGEON_FACTION2, 902, 31, 0, self.AvgLevel, defendRate2, 1);  -- 下路2（下）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 861, 55, 8, self.AvgLevel, defendRate1, 1);  -- 下路1（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 861, 31, 0, self.AvgLevel, defendRate1, 1);  -- 下路1（下）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 912, 62, 8, self.AvgLevel, defendRate2, 1);  -- 下路2（上）（减速）
    CreateNpcInDungeon(self.ObjectId, 4800, DUNGEON_FACTION2, 912, 36, 0, self.AvgLevel, defendRate2, 1);  -- 下路2（下）（减速）

    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION2, 925, 117, 8, self.AvgLevel, defendRate3, 1);  -- 护卫1
    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION2, 925, 137, 0, self.AvgLevel, defendRate3, 1);  -- 护卫2
    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION2, 925, 88, 0, self.AvgLevel, defendRate3, 1);  -- 护卫3
    CreateNpcInDungeon(self.ObjectId, 4802, DUNGEON_FACTION2, 923, 164, 0, self.AvgLevel, defendRate3, 1);  -- 护卫4
end


function CDungeon_3C:OnDungeonEnd(dungeon,winner)
    --OutputLog("[CDungeon_3C:OnDungeonEnd]       Dungeon = "..dungeon)
    local i;
    local faction1_actor ;
    local faction2_actor ;
    local delta_score1 = 0;
    local delta_score2 = 0;
    local temp_actor1 = 0;
    local temp_actor2 = 0;
    local strRed = L("msg_script_red_faction"); 
    local strBlue = L("msg_script_blue_faction"); 

    -- 显示对话框
    local content = RICH_TEXT_BEGIN..GetFileContent("dungeon/3c_end.xml")..RICH_TEXT_END;

    -- 根据胜负给出奖励
    self.TD_Exp1 = GetMonsterExp (self.AvgLevel) * self.TD_KillNum1*0.05;
    self.TD_Nimbus1 = GetMonsterNimbus (self.AvgLevel) * self.TD_KillNum1*0.1;
    self.TD_Money1 = GetMonsterGold (self.AvgLevel) * self.TD_KillNum1*0.05;
    self.TD_Exp2 = GetMonsterExp (self.AvgLevel) * self.TD_KillNum2*0.05;
    self.TD_Nimbus2 = GetMonsterNimbus (self.AvgLevel) * self.TD_KillNum2*0.1;
    self.TD_Money2 = GetMonsterGold (self.AvgLevel) * self.TD_KillNum2*0.05;
    local faction1_count = DungeonFactionGetActorCount(dungeon, DUNGEON_FACTION1);
    local faction2_count = DungeonFactionGetActorCount(dungeon, DUNGEON_FACTION2);
    --OutputLog(" faction1_count = "..faction1_count);
    --OutputLog(" faction2_count = "..faction2_count);
    if (faction1_count > 0 ) then 
        local temp_actor1 = DungeonFactionGetActor(dungeon, DUNGEON_FACTION1, 0);
        self.TD_Team1 = GetUserDungeonTeam(temp_actor1);
        self.pk_lev1 = GetDungeonTeamLevel(self.TD_Team1,DUNGEON_PVP);
        OutputLog(" temp_actor1 = "..temp_actor1);
        self.TD_score1 = GetDungeonTeamScore (self.TD_Team1,DUNGEON_PVP);
    end
    
    if (faction2_count > 0 ) then 
        local temp_actor2 = DungeonFactionGetActor(dungeon, DUNGEON_FACTION2, 0);
        self.TD_Team2 = GetUserDungeonTeam(temp_actor2);
        self.pk_lev2 = GetDungeonTeamLevel(self.TD_Team2,DUNGEON_PVP);
        self.TD_score2 = GetDungeonTeamScore (self.TD_Team2,DUNGEON_PVP);
    end
    --OutputLog(" pk_lev1 = "..self.pk_lev1);
    --OutputLog(" pk_lev2 = "..self.pk_lev2);
    if (winner == DUNGEON_FACTION1) then -- 阵营1赢了，阵营2输了	
 		--OutputLog(" TD_Winner1 ");
                delta_score1 = 100 - (self.pk_lev1-self.pk_lev2)*20;
                delta_score2 = (100 - (self.pk_lev1-self.pk_lev2)*20)/2;
                if (delta_score1 < 20) then 
                    delta_score1 = 20;
                end
                if (delta_score1 > 200) then 
                    delta_score1 = 200;
                end
                if (delta_score2 < 10) then 
                    delta_score2 = 10;
                end
                if (delta_score2 > 100) then 
                    delta_score2 = 100;
                end
            self.TD_Score1 = 30;
            self.TD_Score2 = 15;
            for i=0,faction1_count-1 do
                faction1_actor = DungeonFactionGetActor(dungeon, DUNGEON_FACTION1, i);
                AddUserDungeonScore (faction1_actor,DUNGEON_PVP,self.TD_Score1);
                AddExp (faction1_actor,self.TD_Exp1,0);
                AddNimbus (faction1_actor,self.TD_Nimbus1,0);
                AddMoney (faction1_actor,self.TD_Money1);
            end
            
            for i=0,faction2_count-1 do
                faction2_actor = DungeonFactionGetActor(dungeon, DUNGEON_FACTION2, i);
                AddUserDungeonScore (faction2_actor,DUNGEON_PVP,self.TD_Score2);
                AddExp (faction2_actor,self.TD_Exp2,0);
                AddNimbus (faction2_actor,self.TD_Nimbus2,0);
                AddMoney (faction2_actor,self.TD_Money2);
            end
            
            self.TD_Winner = strRed
            local teamScore1 = AddDungeonTeamScore(self.TD_Team1, DUNGEON_PVP, self.TD_Score1);
            local teamScore2 = AddDungeonTeamScore(self.TD_Team2, DUNGEON_PVP, self.TD_Score2);
            --OutputLog(" teamScore1 = "..self.TD_Score1);
            --OutputLog(" teamScore2 = "..-self.TD_Score2);
            content = string.gsub(content, "$TD_Winner", self.TD_Winner);
            content = string.gsub(content, "$TD_Team1", strRed);
            content = string.gsub(content, "$TD_Score1", self.TD_Score1);                        
            content = string.gsub(content, "$TD_Exp1", math.floor(self.TD_Exp1));
            content = string.gsub(content, "$TD_Nimbus1", math.floor(self.TD_Nimbus1));
            content = string.gsub(content, "$TD_Money1", math.floor(self.TD_Money1)); 
            
            content = string.gsub(content, "$TD_Team2", strBlue);
            content = string.gsub(content, "$TD_Score2", self.TD_Score2);                        
            content = string.gsub(content, "$TD_Exp2", math.floor(self.TD_Exp2));
            content = string.gsub(content, "$TD_Nimbus2", math.floor(self.TD_Nimbus2));
            content = string.gsub(content, "$TD_Money2", math.floor(self.TD_Money2));
            --OutputLog(" TD_Winner = "..self.TD_Winner);
	    --OutputLog(" TD_KillNum1 = "..self.TD_KillNum1);
            DungeonShowMsg(dungeon, DUNGEON_FACTION_ALL, content, 1, 1);

    elseif (winner == DUNGEON_FACTION2) then -- 阵营1输了 阵营2赢了
                --OutputLog(" TD_Winner2 ");
                delta_score1 = (100 - (self.pk_lev2-self.pk_lev1)*20)/2;
                delta_score2 = 100 - (self.pk_lev2-self.pk_lev1)*20;
                if (delta_score2 < 20) then 
                    delta_score2 = 20;
                end
                if (delta_score2 > 200) then 
                    delta_score2 = 200;
                end
                if (delta_score1 < 10) then 
                    delta_score1 = 10;
                end
                if (delta_score1 > 100) then 
                    delta_score1 = 100;
                end

           local faction1_count = DungeonFactionGetActorCount(dungeon, DUNGEON_FACTION1);
           local faction2_count = DungeonFactionGetActorCount(dungeon, DUNGEON_FACTION2);
	    self.TD_Score1 = 15;
           self.TD_Score2 = 30;
            for i=0,faction1_count-1 do
                faction1_actor = DungeonFactionGetActor(dungeon, DUNGEON_FACTION1, i);
                AddUserDungeonScore (faction1_actor,DUNGEON_PVP,self.TD_Score1);
                AddExp (faction1_actor,self.TD_Exp1,0);
                AddNimbus (faction1_actor,self.TD_Nimbus1,0);
                AddMoney (faction1_actor,self.TD_Money1);
            end
            
            for i=0,faction2_count-1 do
                faction2_actor = DungeonFactionGetActor(dungeon, DUNGEON_FACTION2, i);
                AddUserDungeonScore (faction2_actor,DUNGEON_PVP,self.TD_Score2);
                AddExp (faction2_actor,self.TD_Exp2,0);
                AddNimbus (faction2_actor,self.TD_Nimbus2,0);
                AddMoney (faction2_actor,self.TD_Money2);
            end
            
            self.TD_Winner = strBlue
            local teamScore1 = AddDungeonTeamScore(self.TD_Team1, DUNGEON_PVP, self.TD_Score1);
            local teamScore2 = AddDungeonTeamScore(self.TD_Team2, DUNGEON_PVP, self.TD_Score2);
            --OutputLog(" teamScore1 = "..-self.TD_Score1);
            --OutputLog(" teamScore2 = "..self.TD_Score2);
            content = string.gsub(content, "$TD_Winner", self.TD_Winner);
            content = string.gsub(content, "$TD_Team1", strRed);
            content = string.gsub(content, "$TD_Score1", self.TD_Score1); 
            content = string.gsub(content, "$TD_Exp1", math.floor(self.TD_Exp1));
            content = string.gsub(content, "$TD_Nimbus1", math.floor(self.TD_Nimbus1));
            content = string.gsub(content, "$TD_Money1", math.floor(self.TD_Money1));
            
            content = string.gsub(content, "$TD_Team2", strBlue);
            content = string.gsub(content, "$TD_Score2", self.TD_Score2); 
            content = string.gsub(content, "$TD_Exp2", math.floor(self.TD_Exp2));
            content = string.gsub(content, "$TD_Nimbus2", math.floor(self.TD_Nimbus2));
            content = string.gsub(content, "$TD_Money2", math.floor(self.TD_Money2));
            
            DungeonShowMsg(dungeon, DUNGEON_FACTION_ALL, content, 1, 1);
    end
end

function CDungeon_3C:OnDungeonActorDead(dungeon, actorId, killer, faction)
    --OutputLog("[CDungeon_3C:OnDungeonActorDead] Dungeon = "..dungeon.." CreId = "..actorId)

    self:AddKillActor(killer, actorId);

   
	
    -- 如果是玩家杀死的，就奖励killer一个道具
    if (killer ~= 0 and IsUser(killer)~= 0) then
        local idx = math.random(KillBonusItemCount);
        AddItem(killer, KillBonusItem[idx], itemColor_White, 0, itemBind_NotBind);
	local str = LAN("msg_script_killer_gift"); -- "%s在战斗中击杀了%s，并获得系统的一个奖励物品";
        str = string.format(str, GetCreName(killer), GetCreName(actorId));
	
	if (faction == 1) then
	    self.Race_Score2 = self.Race_Score2 + self.Race_Player;
	    DungeonSetDataInt(dungeon, "S2", self.Race_Score2, 1);
	elseif (faction == 2) then
	    self.Race_Score1 = self.Race_Score1 + self.Race_Player;
	    DungeonSetDataInt(dungeon, "S1", self.Race_Score1, 1);
	end
        --OutputLog("[CDungeon_3C:OnDungeonActorDead] Dungeon = "..dungeon.." S1 = "..self.Race_Score1);
	--OutputLog("[CDungeon_3C:OnDungeonActorDead] Dungeon = "..dungeon.." S2 = "..self.Race_Score2);
	DungeonFactionReceiveMsg(self.ObjectId, DUNGEON_FACTION_ALL, str, CHANNEL_SYS);
    end
end


function CDungeon_3C:OnDungeonActorRevive(dungeon, actorId)
    --OutputLog("[CDungeon_3C:OnDungeonActorRevive] Dungeon = "..dungeon.." CreId = "..actorId)

    AddEffectEx(actorId,2207,0,0,0,0)
end


function CDungeon_3C:OnDungeonMassCreate(dungeon, massId)
    --OutputLog("[CDungeon_3C:OnDungeonMassCreate]  Dungeon = "..dungeon.." CreId = "..massId)

end


function CDungeon_3C:OnDungeonMassDead(dungeon, massId, killer, faction)
    --OutputLog("[CDungeon_3C:OnDungeonMassDead]   Dungeon = "..dungeon.." CreId = "..massId)
    if (faction == DUNGEON_FACTION2 and killer ~= 0 and IsUser(killer)~=0) then
	self.TD_KillNum1 = self.TD_KillNum1 +1;
	self.Race_Score1 = self.Race_Score1 + self.Race_Monster;
	DungeonSetDataInt(dungeon, "S1", self.Race_Score1, 1);
    end
    
    if (faction == DUNGEON_FACTION1 and killer ~= 0 and IsUser(killer)~=0) then
	self.TD_KillNum2 = self.TD_KillNum2 +1;
	self.Race_Score2 = self.Race_Score2 + self.Race_Monster;
	DungeonSetDataInt(dungeon, "S2", self.Race_Score2, 1);
    end

    --OutputLog("[CDungeon_3C:OnDungeonActorDead] Dungeon = "..dungeon.." S1 = "..self.Race_Score1);
    --OutputLog("[CDungeon_3C:OnDungeonActorDead] Dungeon = "..dungeon.." S2 = "..self.Race_Score2);
    if (massId == self.Protector_Faction1) then
        EndDungeon(self.ObjectId, DUNGEON_FACTION2);
    elseif (massId == self.Protector_Faction2) then
        EndDungeon(self.ObjectId, DUNGEON_FACTION1);
    end
end


function CDungeon_3C:OnDungeonActorApplyQuit(dungeon, actorId)
    OutputLog("[CDungeon_3C:OnDungeonActorApplyQuit]  Dungeon = "..dungeon.." CreId = "..actorId)

    LeaveDungeon(self.ObjectId, actorId);

end


function CDungeon_3C:CalcAvgLevel(faction)
    local total = DungeonFactionGetActorCount(self.ObjectId, faction);
    local MaxLevel = 0;
    local AllLevel = 0;
    local AvgLevel = 0;
    if (total > 0) then
        for i=0,total-1 do
            local oneActor = DungeonFactionGetActor(self.ObjectId, faction, i);
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


function CDungeon_3C:AddKillActor(killer, dead)
    if (killer ~= 0) then
        if (Kill_Actor[killer] == nil) then
            Kill_Actor[killer] = 1;
        else
            Kill_Actor[killer] = Kill_Actor[killer] + 1;
        end
	
        
	DungeonActorSetDataInt(killer, "k", Kill_Actor[killer], 1);
    end

    if (dead ~= 0) then
        if (BeKill_Actor[dead] == nil) then
            BeKill_Actor[dead] = 1;
        else
            BeKill_Actor[dead] = BeKill_Actor[dead] + 1;
        end

        DungeonActorSetDataInt(dead, "bk", BeKill_Actor[dead], 1);
    end
end


function CDungeon_3C:UpdateStateAfterSpawn()
    if (self.CurrSpawnState == 1) then
        if (self.SpawnMonsterLeft <= 0 and self.SpawnBossLeft <= 0) then
            self.CurrSpawnState = 2;

            local t = 80;
            if (self.CurrMassIndex < 10) then
                t = 60;
            elseif (self.CurrMassIndex > 50) then
                t = 120;
            end
            self.NextSpawnTime = self.now + t;
        end
    end
end


function CDungeon_3C:SpawnMass()
    --local idx = math.mod(self.CurrMassIndex - 1, SpawnNpcCount) + 1;
    local idx = 0;
    local npc = 0;

    local lev = self.CurrMassLevel;
    local ability = 0.6 + self.CurrMassIndex * 0.03;
    local bounsRiseRate = 0.6 + self.CurrMassIndex * 0.03 * 0.5;

    -- 中间
    idx = math.random(SpawnNpcCount);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION1, SpawnNpcPos_Center1_v1.x, SpawnNpcPos_Center1_v1.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathCenter1_v1);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION1, SpawnNpcPos_Center1_v2.x, SpawnNpcPos_Center1_v2.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathCenter1_v2);

    idx = math.random(SpawnNpcCount);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION2, SpawnNpcPos_Center2_v1.x, SpawnNpcPos_Center2_v1.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathCenter2_v1);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION2, SpawnNpcPos_Center2_v2.x, SpawnNpcPos_Center2_v2.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathCenter2_v2);

    -- 上边
    idx = math.random(SpawnNpcCount);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION1, SpawnNpcPos_Top1_v1.x, SpawnNpcPos_Top1_v1.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathTop1_v1);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION1, SpawnNpcPos_Top1_v2.x, SpawnNpcPos_Top1_v2.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathTop1_v2);

    idx = math.random(SpawnNpcCount);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION2, SpawnNpcPos_Top2_v1.x, SpawnNpcPos_Top2_v1.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathTop2_v1);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION2, SpawnNpcPos_Top2_v2.x, SpawnNpcPos_Top2_v2.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathTop2_v2);

    -- 下边
    idx = math.random(SpawnNpcCount);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION1, SpawnNpcPos_Bottom1_v1.x, SpawnNpcPos_Bottom1_v1.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathBottom1_v1);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION1, SpawnNpcPos_Bottom1_v2.x, SpawnNpcPos_Bottom1_v2.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathBottom1_v2);

    idx = math.random(SpawnNpcCount);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION2, SpawnNpcPos_Bottom2_v1.x, SpawnNpcPos_Bottom2_v1.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathBottom2_v1);
    npc = CreateNpcInDungeon(self.ObjectId, SpawnNpc[idx], DUNGEON_FACTION2, SpawnNpcPos_Bottom2_v2.x, SpawnNpcPos_Bottom2_v2.y, 0, lev, ability, bounsRiseRate)
    SetNpcPatrolPath(npc, PatrolPathBottom2_v2);

    if (self.SpawnMonsterLeft > 0) then
        self.SpawnMonsterLeft = self.SpawnMonsterLeft - 1;
    end

    self:UpdateStateAfterSpawn();
end


function CDungeon_3C:SpawnBoss()
    if (self.NextBossIndex > SpawnBossCount) then       -- 超过BOSS的最大个数就不刷了
        if (self.SpawnBossLeft > 0) then
            self.SpawnBossLeft = self.SpawnBossLeft - 1;
        end

        self:UpdateStateAfterSpawn();

        return;
    end

    local npc = 0;

    local lev = self.CurrMassLevel;
    local ability = 0.6 + self.CurrMassIndex * 0.03;
    local bounsRiseRate = 0.6 + self.CurrMassIndex * 0.03 * 0.5;

    -- 正方
    local r = math.random(1, 3);
    if (r == 1) then
        npc = CreateNpcInDungeon(self.ObjectId, SpawnBossId[self.NextBossIndex], DUNGEON_FACTION1, SpawnNpcPos_Center1_v1.x, SpawnNpcPos_Center1_v1.y, 0, lev, ability, bounsRiseRate)
        SetNpcPatrolPath(npc, PatrolPathCenter1_v1);
    elseif (r == 2) then
        npc = CreateNpcInDungeon(self.ObjectId, SpawnBossId[self.NextBossIndex], DUNGEON_FACTION1, SpawnNpcPos_Top1_v1.x, SpawnNpcPos_Top1_v1.y, 0, lev, ability, bounsRiseRate)
        SetNpcPatrolPath(npc, PatrolPathTop1_v1);
    elseif (r == 3) then
        npc = CreateNpcInDungeon(self.ObjectId, SpawnBossId[self.NextBossIndex], DUNGEON_FACTION1, SpawnNpcPos_Bottom1_v1.x, SpawnNpcPos_Bottom1_v1.y, 0, lev, ability, bounsRiseRate)
        SetNpcPatrolPath(npc, PatrolPathBottom1_v1);
    end

    -- 反方
    local r = math.random(1, 3);
    if (r == 1) then
        npc = CreateNpcInDungeon(self.ObjectId, SpawnBossId[self.NextBossIndex], DUNGEON_FACTION2, SpawnNpcPos_Center2_v1.x, SpawnNpcPos_Center2_v1.y, 0, lev, ability, bounsRiseRate)
        SetNpcPatrolPath(npc, PatrolPathCenter2_v1);
    elseif (r == 2) then
        npc = CreateNpcInDungeon(self.ObjectId, SpawnBossId[self.NextBossIndex], DUNGEON_FACTION2, SpawnNpcPos_Top2_v1.x, SpawnNpcPos_Top2_v1.y, 0, lev, ability, bounsRiseRate)
        SetNpcPatrolPath(npc, PatrolPathTop2_v1);
    elseif (r == 3) then
        npc = CreateNpcInDungeon(self.ObjectId, SpawnBossId[self.NextBossIndex], DUNGEON_FACTION2, SpawnNpcPos_Bottom2_v1.x, SpawnNpcPos_Bottom2_v1.y, 0, lev, ability, bounsRiseRate)
        SetNpcPatrolPath(npc, PatrolPathBottom2_v1);
    end

    -- 更新状态
    if (self.SpawnBossLeft > 0) then
        self.SpawnBossLeft = self.SpawnBossLeft - 1;
    end

    self:UpdateStateAfterSpawn();

    self.NextBossIndex = self.NextBossIndex + 1;

    self.NextBossBoShu = (self.NextBossIndex * SpawnBossInterval) + math.random(-3, 3);

    -- 通知参赛者
    local str = LAN("msg_script_spawn_boss"); -- "两个神秘的BOSS已经分别在战场附近协助作战！";
    DungeonFactionReceiveMsg(self.ObjectId, DUNGEON_FACTION_ALL, str, CHANNEL_SYS);
end


function CDungeon_3C:SpawnGift()
    local r = math.random(table.getn(SpawnGiftPos));

    local x = SpawnGiftPos[r].x;
    local y = SpawnGiftPos[r].y;
    local x1 = SpawnGiftProtectorPos[r].x;
    local y2 = SpawnGiftProtectorPos[r].y;

    local npcCount = table.getn(SpawnGiftNpc);
    local i = math.floor((npcCount * self.CurrMassIndex) / 30 + math.random(-2, 2));
    if (i < 1) then
        i = 1;
    elseif (i > npcCount) then
        i = npcCount;
    end

    CreateNpcInDungeon(self.ObjectId, SpawnGiftNpc[i], DUNGEON_FACTION_NEUTRAL, x, y, 0, 0, 0, 1);
    -- 生成守护怪
    CreateNpcInDungeon(self.ObjectId, SpawnGiftProtectorNpc, DUNGEON_FACTION_NEUTRAL, x1, y1, 0, self.CurrMassLevel, 0.6 + self.CurrMassIndex * 0.03, 0.6 + self.CurrMassIndex * 0.03*0.5)

    local str = LAN("msg_script_spawn_box"); -- "一个宝箱从天而降，但是有神秘的生物守护者它";
    DungeonFactionReceiveMsg(self.ObjectId, DUNGEON_FACTION_ALL, str, CHANNEL_SYS);

    OutputLog("[CDungeon_3C:SpawnGift]  Gift Pos = ("..x..", "..y.."), Npc = "..SpawnGiftNpc[i]);
end


function CDungeon_3C:BroadcastSpawn()
    
    local str = LAN("msg_script_spawn_monsternext"); -- "新一轮的怪物已经刷新，强度为%d";
    str = string.format(str, self.CurrMassIndex);
    DungeonFactionReceiveMsg(self.ObjectId, DUNGEON_FACTION_ALL, str, CHANNEL_SYS);
end

