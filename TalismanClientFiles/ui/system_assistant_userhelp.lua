
local AllowedTaskId =
{
	list = {464,551,553,555,556,557,558,559,560,561,11,25,853},
	IsAllowed = function(self, id)
		return SAPI.ExistInTable(self.list, id);
	end,
	Size = function(self)
		return table.getn(self.list);
	end
};
local AllowedItemId =
{
	-- 350	- 小蘑菇孢子	
	-- 355	- 大蘑菇孢子	
	-- 3010 - 隐血符咒
	list = {3010,350,352,6264--[[7000,7018,7016,7101,7228]]},
	related_task =
	{
		[350] = 25,	-- 相关任务
		[352] = 25,	-- 相关任务
		[6264] = 559, -- 相关任务
	--[[
		[7000] = 2,	--任务2 - 生铁7000
		[7018] = 4, --任务4 - 成熟的麦子7018
		[7016] = 5, --任务5 - 棉袄7016
		[7101] = 93, --任务93 - 千年夜明珠的传说7101
		[7228] = 483, --任务483 - 普通的玉璞7228
	]]
	},
	IsAllowed = function(self, id)
		return SAPI.ExistInTable(self.list, id);
	end,
	GetRelatedTaskId = function (self, id)
		return self.related_task[id];
	end,
	Size = function(self)
		return table.getn(self.list);
	end
};
local AllowedItemId_Pos = 
{
	-- 3010 - 隐血符咒
	-- 801	- 捕兽铃
	list = {3010,801},
	IsAllowed = function(self, id)
		return SAPI.ExistInTable(self.list, id);
	end,
	Size = function(self)
		return table.getn(self.list);
	end
};
local function RefreshSystemValue_Task(id)
	if id == nil then
		-- 刷新所有
		for i, v in ipairs(AllowedTaskId.list) do
			RefreshSystemValue_Task(v);
		end
		return;
	end
	local SysPtr = uiUserHelpGetSystemPtr();
	if AllowedTaskId:IsAllowed(id) then
		if uiTaskIsFinished(id) then
			SysPtr:Set("task"..id, 3);
		elseif uiTaskIsDoing(id) then
			if uiTaskCanFinishTask(id) then
				SysPtr:Set("task"..id, 2);
			else
				SysPtr:Set("task"..id, 1);
			end
		else
			SysPtr:Set("task"..id, 0);
		end
	end
end

local function RefreshSystemValue_Item(id)
	if id == nil then
		-- 刷新所有
		for i, v in ipairs(AllowedItemId.list) do
			RefreshSystemValue_Item(v);
		end
		return;
	end
	local SysPtr = uiUserHelpGetSystemPtr();
	if AllowedItemId:IsAllowed(id) then
		local count = uiGetBagItemInfoByTableIndex(id);
		if not count or count <= 0 then count = 0 end
		SysPtr:Set("item"..id, count);
		local RelatedTaskId = AllowedItemId:GetRelatedTaskId(id);
		if RelatedTaskId then
			RefreshSystemValue_Task(RelatedTaskId);
		end
	end
end

local function RefreshSystemValue_ItemPos(id)
	if id == nil then
		-- 刷新所有
		for i, v in ipairs(AllowedItemId_Pos.list) do
			RefreshSystemValue_ItemPos(v);
		end
		return;
	end
	local SysPtr = uiUserHelpGetSystemPtr();
	if AllowedItemId_Pos:IsAllowed(id) then
		local count, objId = uiGetBagItemInfoByTableIndex(id);
		local pos = "unknown"; -- 如果这里是空字符串的话，表达式会当掉
		if objId and objId > 0 then
			local bag, line, col = uiItemGetItemCoordByObjectId(objId);
			pos = GetItemButtonNameByCoord(bag, line, col);
		end
		SysPtr:Set("itembutton"..id, pos);
	end
end

local function RefreshSystemValue_ItemBag()
	local combagfreesize=0;
	local count = uiItemGetItemBagCount();
	local SysPtr = uiUserHelpGetSystemPtr();
	for i = 0, count-1, 1 do
		local line, col, itemcount, istask, isoutdate = uiItemGetItemBagInfoByIndex();
		if not istask and not isoutdate then
			combagfreesize = combagfreesize + line * col - itemcount;
		end
	end
	SysPtr:Set("combagfreesize", combagfreesize);
end

function laySystemAssistant_UserHelp_OnLoad(self)

	-- 注册感兴趣的消息
	self:RegisterScriptEventNotify("EVENT_SelfLevelUp");
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("event_update_task");		-- 任务更新
	self:RegisterScriptEventNotify("EVENT_SelfDie");
	self:RegisterScriptEventNotify("EVENT_ON_USER_AUTO_WALK")
	
	self:RegisterScriptEventNotify("bag_item_update");			-- 道具更新
	self:RegisterScriptEventNotify("bag_item_removed");			-- 道具移除
	self:RegisterScriptEventNotify("bag_item_added");			-- 道具添加
	self:RegisterScriptEventNotify("bag_item_exchange_grid");	-- 道具位置变换
	
	self:RegisterScriptEventNotify("TargetChanged");		-- 目标改变
	
	self:RegisterScriptEventNotify("EVENT_TeamRefresh");		-- 队伍刷新
	
	self:RegisterScriptEventNotify("RefreshStall");				--刷新自己摊位界面
    self:RegisterScriptEventNotify("RefreshOtherStall");		--刷新目标摊位界面
    self:RegisterScriptEventNotify("EVENT_SelfStallStateChanged"); --自己摊位状态改变
    self:RegisterScriptEventNotify("EVENT_OtherStallStateChanged"); --目标摊位状态改变
	
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentChanged");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentEquiped");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentUnequiped");

end

function laySystemAssistant_UserHelp_OnEvent(self, event, args)

	-- 收到感兴趣的消息后，往帮助系统里设置对应的值，以供表达示或更多的其它地方使用
	local SysPtr = uiUserHelpGetSystemPtr();
	if not SysPtr then
		return
	else
		if event == "EVENT_SelfLevelUp" then
			local level = uiGetMyInfo("Exp");
			SysPtr:Set("Level", level);
		elseif event == "event_update_task" then		-- 任务更新
			RefreshSystemValue_Task();
		elseif event == "bag_item_update" or event == "bag_item_added" then
			local _, tableid = uiItemGetItemInfoByCoord(args[2], args[3], args[4]);
			RefreshSystemValue_Item(tableid);
			RefreshSystemValue_ItemPos(tableid);
			RefreshSystemValue_ItemBag();
		elseif event == "bag_item_removed" then
			local tableid = args[6];
			RefreshSystemValue_Item(tableid);
			RefreshSystemValue_ItemPos(tableid);
			RefreshSystemValue_ItemBag();
		elseif event == "bag_item_exchange_grid" then
			local _, tableid = uiItemGetItemInfoByCoord(args[2], args[3], args[4]);
			RefreshSystemValue_ItemPos(tableid);
			local _, tableid = uiItemGetItemInfoByCoord(args[5], args[6], args[7]);
			RefreshSystemValue_ItemPos(tableid);
			RefreshSystemValue_ItemBag();
		elseif event == "TargetChanged" then
			local id = uiUserGetNpcTargetInfo();
			if id == nil then id = 0 end
			SysPtr:Set("targetid", id);
		elseif event == "EVENT_TeamRefresh" then
			local teamcount = uiTeamGetCount();
			if teamcount == nil then teamcount = 0 end
			SysPtr:Set("teamsize", teamcount);
		elseif event == "RefreshStall" then
			local objlist=uiStallGetSaleItemList();
			local number=0;
			if objlist then
				number=table.getn(objlist);
			end
			SysPtr:Set("stallitemcount",number);
		elseif event == "RefreshOtherStall" then
			local objlist=uiStallGetOtherSaleItemList();
			local number=0;
			if objlist then
				number=table.getn(objlist);
			end
			SysPtr:Set("otherstallitemcount",number);
		elseif event == "EVENT_SelfStallStateChanged" then
			if uiStallIsStall() == true then
				SysPtr:Set("stallstate",1);
			else
				SysPtr:Set("stallstate",0);
			end
		elseif event == "EVENT_OtherStallStateChanged" then
			if uiStallOtherIsStall() == true then
				SysPtr:Set("otherstallstate",1);
			else
				SysPtr:Set("otherstallstate",0);
			end
		elseif event == "EVENT_SelfEnterWorld" then
			local level = uiGetMyInfo("Exp");
			SysPtr:Set("Level", level);
			RefreshSystemValue_Item();
			RefreshSystemValue_ItemPos();
			RefreshSystemValue_ItemBag();
			SysPtr:Set("targetid", 0);
			SysPtr:Set("teamsize", 0);
			SysPtr:Set("stallitemcount",0);
			SysPtr:Set("stallstate",0);
		elseif event == "EVENT_SelfDie" then
			SysPtr:Set("Die", 1);
		elseif event == "EVENT_ON_USER_AUTO_WALK" then
			SysPtr:Set("AutoWalk", 1)
		elseif event == "EVENT_SelfEquipmentChanged" then
			RefreshSystemValue_Task(853);
		elseif event == "EVENT_SelfEquipmentEquiped" then
			RefreshSystemValue_Task(853);
		elseif event == "EVENT_SelfEquipmentUnequiped" then
			RefreshSystemValue_Task(853);
		end
	end

end

