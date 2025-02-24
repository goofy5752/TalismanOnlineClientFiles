
include("script/game_script_base.lua")

DungeonTable = {}
DungeonObjectTable = {}


-- 竞技副本里的事件 -- 

EV_MIN                              = 0

EV_DUNGEON_BEGIN                    = 1     -- 比赛开始
EV_DUNGEON_END                      = 2     -- 比赛结束
EV_DUNGEON_1SEC_TIMER               = 3     -- 每秒钟触发（比赛中）
EV_DUNGEON_1SEC_TIMER_DEAD          = 4     -- 每秒钟触发（比赛结束后）

EV_DUNGEON_ACTOR_DEAD               = 20    -- 参赛者死亡
EV_DUNGEON_ACTOR_REVIVE             = 21    -- 参赛者复活
EV_DUNGEON_ACTOR_APPLYQUIT          = 22    -- 参赛者比赛过程中请求退出

EV_DUNGEON_MASS_CREATE              = 50    -- 普通NPC出生
EV_DUNGEON_MASS_DEAD                = 51    -- 普通NPC死亡



-- 竞技副本的阵营 --
DUNGEON_FACTION_INVALID             = 0
DUNGEON_FACTION1                    = 1     -- 阵营1（通常代表正义方）
DUNGEON_FACTION2                    = 2     -- 阵营2（通常代表邪恶方）
DUNGEON_FACTION_OBSERVER            = 4     -- 观众
DUNGEON_FACTION_NEUTRAL             = 8     -- 中立阵营（只有NPC，没有玩家）
DUNGEON_FACTION_ALL                 = 255


DUNGEON_PVP                         = 0     -- PvP
DUNGEON_PVE                         = 1     -- PvE


RICH_TEXT_BEGIN     = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><UiRichText>";
RICH_TEXT_END       = "</UiRichText>";


-- 公共函数 --

function GetDungeonScriptType(idx)
    if DungeonTable[idx]~=nil then
        return DungeonTable[idx]
    else
        return nil
    end
end


function CreateDungeonObject(idx, objid)
	if DungeonTable[idx] then
		if DungeonObjectTable[objid]==nil then
			DungeonObjectTable[objid] = DungeonTable[idx].new(idx, objid)
			--OutputLog("创建DungeonObject，dungeonIndex = "..idx..", objId = "..objid)
		end
		return DungeonObjectTable[objid]
	else
		return nil
	end
end


function DestroyDungeonObject(idx, objid)
	if DungeonObjectTable[objid] then
		DungeonObjectTable[objid]=nil
		--OutputLog("销毁DungenObject，dungeonIndex = "..idx..", objId = "..objid)
	end
end

