local LOCAL_POPUPMENU_MODE_KEY = "LOCAL_POPUPMENU_MODE_KEY";
local LOCAL_POPUPMENU_MODE_H = "H"; -- 横向
local LOCAL_POPUPMENU_MODE_V = "V"; -- 纵向
local LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MIN = 1;
local LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MAX = 12;
local LOCAL_SHORTCUT_DBID_KEY = "LOCAL_SHORTCUT_DBID_KEY";
local LOCAL_SHORTCUT_DBID_OLD_KEY = "LOCAL_SHORTCUT_DBID_OLD_KEY";


LClassItemClassPool =
{
	Get = function(self, classid)
		if self[classid] then return self[classid] end
		self[classid] = uiItemGetItemClassInfoByTableIndex(classid);
		return self[classid];
	end
};

local LOCAL_SHORTCUT_ID_MAP =
{
	{15*24+1+ 0, 15*24+1+ 1, 15*24+1+ 2, 15*24+1+ 3, 15*24+1+ 4, 15*24+1+ 5, 15*24+1+ 6, 15*24+1+ 7, 15*24+1+ 8, 15*24+1+ 9, 15*24+1+10, 15*24+1+11,},
	{15*24+1+12, 15*24+1+13, 15*24+1+14, 15*24+1+15, 15*24+1+16, 15*24+1+17, 15*24+1+18, 15*24+1+19, 15*24+1+20, 15*24+1+21, 15*24+1+22, 15*24+1+23,},
	{ 3*24+1+22,  4*24+1+22,  5*24+1+22,  6*24+1+22,  7*24+1+22,  8*24+1+22,  9*24+1+22, 10*24+1+22, 11*24+1+22, 12*24+1+22, 13*24+1+22, 14*24+1+22,},
	{ 3*24+1+23,  4*24+1+23,  5*24+1+23,  6*24+1+23,  7*24+1+23,  8*24+1+23,  9*24+1+23, 10*24+1+23, 11*24+1+23, 12*24+1+32, 13*24+1+23, 14*24+1+23,},
	{16*24+1+ 1, 16*24+1+ 2, 16*24+1+ 3, 16*24+1+ 4, 16*24+1+ 5, 16*24+1+ 6, 16*24+1+ 7, 16*24+1+ 8, 16*24+1+ 9, 16*24+1+ 0, 0, 0,},
	{16*24+1+11, 16*24+1+12, 16*24+1+13, 16*24+1+14, 16*24+1+15, 16*24+1+16, 16*24+1+17, 16*24+1+18, 16*24+1+19, 16*24+1+10, 0, 0,},
	{16*24+1+21, 16*24+1+22, 16*24+1+23, 16*24+1+24, 16*24+1+25, 16*24+1+26, 16*24+1+27, 16*24+1+28, 16*24+1+29, 16*24+1+20, 0, 0,},
	GetId = function(self, line, col) return self[line][col]; end,
}

local LOCAL_SHORTCUT_EVENT_MAP =
{
	{event="Shortcut", {16, 1}, {16, 2}, {16, 3}, {16, 4}, {16, 5}, {16, 6}, {16, 7}, {16, 8}, {16, 9}, {16,10}, {16,11}, {16,12},},
	{event="Shortcut", {16,13}, {16,14}, {16,15}, {16,16}, {16,17}, {16,18}, {16,19}, {16,20}, {16,21}, {16,22}, {16,23}, {16,24},},
	{event="Shortcut", { 4,23}, { 5,23}, { 6,23}, { 7,23}, { 8,23}, { 9,23}, {10,23}, {11,23}, {12,23}, {13,23}, {14,23}, {15,23},},
	{event="Shortcut", { 4,24}, { 5,24}, { 6,24}, { 7,24}, { 8,24}, { 9,24}, {10,24}, {11,24}, {12,24}, {13,24}, {14,24}, {15,24},},
	{event="MainShortcut", event1="MainShortcutS", 1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
	{event="MainShortcut", event1="MainShortcutS", 1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
	{event="MainShortcut", event1="MainShortcutS", 1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
	GetName = function(self, line, col)
		if self[line] == nil or self[line][col] == nil then return "" end
		local event = self[line].event;
		if event == "Shortcut" then
			return string.format(event.."(%d,%d)", self[line][col][1], self[line][col][2]);
		elseif event == "MainShortcut"then
			return string.format(event.."(%d)", self[line][col]);
		else
			return "";
		end
	end,
	GetEvent = function(self, line)
		if self[line] == nil then return "" end
		return self[line].event, self[line].event1;
	end,
	GetPosition = function(self, line, col)
		if self[line] == nil and self[line][col] == nil then return nil end
		return self[line][col];
	end
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------                                           快捷栏的模板实现 (start)                                            --------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Shortcut_TemplateShortcutShortcutButton_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("KeySettingChange");
	self:RegisterScriptEventNotify("EVENT_Shortcut_Update");
	
	--self:RegisterScriptEventNotify("EVENT_SelfEquipmentChanged");
	--self:RegisterScriptEventNotify("EVENT_SelfEquipmentEquiped");
	--self:RegisterScriptEventNotify("EVENT_SelfEquipmentUnequiped");
	
	--self:RegisterScriptEventNotify("bag_item_update");
	--self:RegisterScriptEventNotify("bag_item_exchange_grid");
	--self:RegisterScriptEventNotify("bag_item_before_remove");
	self:RegisterScriptEventNotify("bag_item_removed");
	--self:RegisterScriptEventNotify("bag_item_before_add");
	self:RegisterScriptEventNotify("bag_item_added");
	
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_SHORTCUT);	-- 按键类别
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_NONE);			-- 内容的类别
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0);							-- 内容的ObjectId
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0);							-- 内容的表格Id

	--self:RegisterScriptEventNotify("ajsdlask"); -- 玩家dragin dragout的全局消息
end

function Shortcut_TemplateShortcutShortcutButton_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		Shortcut_TemplateShortcutShortcutButton_RefreshKeyName(self);
	elseif event == "KeySettingChange" then
		Shortcut_TemplateShortcutShortcutButton_OnEvent_KeySettingChange(self, event, args);
	elseif event == "EVENT_Shortcut_Update" then
		Shortcut_TemplateShortcutShortcutButton_OnEvent_ShortcutUpdate(self, event, args);
	elseif event == "Shortcut" then
		Shortcut_TemplateShortcutShortcutButton_OnEvent_Shortcut(self, event, args);
	elseif event == "MainShortcut" or event == "MainShortcutS" then
		Shortcut_TemplateShortcutShortcutButton_OnEvent_MainShortcut(self, event, args);
	elseif event == "EVENT_GlobalDragOut" then
		if self.AlwaysHide then
			self:Hide();
		else
			self:Show();
		end
	--elseif event == "EVENT_SelfEquipmentChanged" then
		--Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	--elseif event == "EVENT_SelfEquipmentEquiped" then
		--Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	--elseif event == "EVENT_SelfEquipmentUnequiped" then
		--Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	--elseif event == "bag_item_update" then
		--Shortcut_TemplateShortcutShortcutButton_RefreshCount(self); -- 刷新数字
	--elseif event == "bag_item_exchange_grid" then
		--Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	--elseif event == "bag_item_before_remove" then
		--Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	elseif event == "bag_item_removed" then
		local id = args[5];
		local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
		if not shortcut_type or shortcut_type ~= EV_SHORTCUT_OBJECT_ITEM then return end
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if not shortcut_objectid or shortcut_objectid ~= id then return end
		Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	--elseif event == "bag_item_before_add" then
		--Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	elseif event == "bag_item_added" then
		local id = args[5];
		local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
		if not shortcut_type or shortcut_type ~= EV_SHORTCUT_OBJECT_ITEM then return end
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if not shortcut_objectid or shortcut_objectid ~= id then return end
		Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	end
end

function Shortcut_TemplateShortcutShortcutButton_OnEvent_KeySettingChange(self, event, args)
	Shortcut_TemplateShortcutShortcutButton_RefreshKeyName(self);
end

function Shortcut_TemplateShortcutShortcutButton_OnEvent_ShortcutUpdate(self, event, args)
	local dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	if dbid == nil or dbid == 0 then return end
	local id, shortcut_type, object_type, object_id, class_id = uiShortcutGetData(dbid);
	if dbid ~= id then return end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, object_type);
	if object_type == EV_SHORTCUT_OBJECT_SKILL then
		self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, object_id);
		if class_id ~= 0 then
			self:Set(EV_UI_SHORTCUT_CLASSID_KEY, class_id);
		else
			self:Set(EV_UI_SHORTCUT_CLASSID_KEY, object_id);
		end
	else
		self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, object_id);
		self:Set(EV_UI_SHORTCUT_CLASSID_KEY, class_id);
	end
	self:Show();
	Shortcut_TemplateShortcutShortcutButton_Refresh(self);
end

function Shortcut_TemplateShortcutShortcutButton_OnEvent_Shortcut(self, event, args)
	if self:getVisible() ~= true then return end
	local opReason = args[1];
	if opReason ~= EV_EXCUTE_EVENT_KEY_DOWN then return end
	local opLine = args[2];
	local opCol = args[3];
	local group = SAPI.GetParent(self);
	local group_id = group.ID;
	if not group_id then return end
	local index = self.ID;
	if not index then return end
	local pos = LOCAL_SHORTCUT_EVENT_MAP:GetPosition(group_id, index);
	if pos[1] == opLine and pos[2] == opCol then
		Shortcut_TemplateShortcutShortcutButton_Process(self);
	end
end

function Shortcut_TemplateShortcutShortcutButton_OnEvent_MainShortcut(self, event, args)
	if self:getVisible() ~= true then return end
	local opReason = args[1];
	if opReason ~= EV_EXCUTE_EVENT_KEY_DOWN then return end
	local opCol = args[2];
	local group = SAPI.GetParent(self);
	local group_id = group.ID;
	if not group_id then return end
	local index = self.ID;
	if not index then return end
	local pos = LOCAL_SHORTCUT_EVENT_MAP:GetPosition(group_id, index);
	if pos == opCol then
		local usetoself = false;
		if event == "MainShortcutS" then usetoself = true end
		Shortcut_TemplateShortcutShortcutButton_Process(self, usetoself);
	end
end

function Shortcut_TemplateShortcutShortcutButton_Save(self)
	local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	if shortcut_dbid == nil or shortcut_dbid == 0 then return end
	
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SHORTCUT then return end
	
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if shortcut_classid == nil then shortcut_classid = 0 end
	
	if shortcut_dbid ~= nil and shortcut_dbid > 0 then
		uiShortcutSetData(shortcut_dbid, shortcut_owner, shortcut_type, shortcut_objectid, shortcut_classid);
	end
end

-- 克隆
function Shortcut_TemplateShortcutShortcutButton_Clone(from, to)
	local shortcut_dbid = from:Get(LOCAL_SHORTCUT_DBID_KEY);
	local shortcut_owner = from:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SHORTCUT then return end
	shortcut_owner = to:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SHORTCUT then return end
	
	local shortcut_type = from:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = from:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = from:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if shortcut_classid == nil then shortcut_classid = 0 end
	
	to:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type);
	to:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
	to:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid);
	Shortcut_TemplateShortcutShortcutButton_Refresh(to);
end

function Shortcut_TemplateShortcutShortcutButton_OnDragIn(self, drag)
	local allow_owners = 
	{
		EV_UI_SHORTCUT_OWNER_ITEM,
		EV_UI_SHORTCUT_OWNER_SKILL,
		EV_UI_SHORTCUT_OWNER_MISC,
		EV_UI_SHORTCUT_OWNER_SHORTCUT,
		EV_UI_SHORTCUT_OWNER_ATTRIBUTE,
		IsAllowed = function(self, owner)
			if owner == nil then return false end
			for i, v in ipairs(self) do
				if v == owner then return true end
			end
			return false;
		end
	}
	local drag_out = uiGetglobal(drag);
	if drag_out == nil then return end
	local shortcut_owner = drag_out:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil then return end
	if allow_owners:IsAllowed(shortcut_owner) == false then return end
	local shortcut_type = drag_out:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = drag_out:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = drag_out:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if shortcut_classid == nil then shortcut_classid = 0 end
	Shortcut_TemplateShortcutShortcutButton_Clear(drag_out); -- 清除旧的
	-- 如果当前按钮有东西，先dragout
	local btShortcutTemp = SAPI.GetSibling(self, "btShortcutTemp");
	if SAPI.Equal(self, btShortcutTemp) == false then
		Shortcut_TemplateShortcutShortcutButton_Clear(btShortcutTemp);
		Shortcut_TemplateShortcutShortcutButton_Clone(self, btShortcutTemp); -- 克隆
		local temp_classid = btShortcutTemp:Get(EV_UI_SHORTCUT_CLASSID_KEY);
		if temp_classid ~= nil and temp_classid > 0 then
			uiDragOut(btShortcutTemp);
		end
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type);
	if shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_classid);
	else
		self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
	end
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid);
	Shortcut_TemplateShortcutShortcutButton_Refresh(self);
	-- 保存设置
	Shortcut_TemplateShortcutShortcutButton_Save(drag_out);
	Shortcut_TemplateShortcutShortcutButton_Save(self);
end

function Shortcut_TemplateShortcutShortcutButton_OnDragNull(self)
	Shortcut_TemplateShortcutShortcutButton_Clear(self);
	-- 保存设置
	Shortcut_TemplateShortcutShortcutButton_Save(self);
end

function Shortcut_TemplateShortcutShortcutButton_OnLClick(self)
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then return end
	if shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then return end
		if Local_Skill_UseSkillDispatcher and Local_Skill_UseSkillDispatcher:IsProcessing() then
			Local_Skill_UseSkillDispatcher:Target(shortcut_objectid);
			return;
		end
		Local_Item_UseItemDispatcher:Use(shortcut_objectid);
	elseif shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
		if shortcut_classid == nil or shortcut_classid == 0 then return end
		--uiSkill_UseTheSkillByIndex(shortcut_classid);
		Local_Skill_UseSkillDispatcher:Use(shortcut_classid);
	elseif shortcut_type == EV_SHORTCUT_OBJECT_MISC then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then return end
		uiSkill_MiscAction(shortcut_objectid);
	end
end

function Shortcut_TemplateShortcutShortcutButton_Process(self, usetoself)
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then return end
	if shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then return end
		Local_Item_UseItemDispatcher:Use(shortcut_objectid, usetoself);
	elseif shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
		if shortcut_classid == nil or shortcut_classid == 0 then return end
		--uiSkill_UseTheSkillByIndex(shortcut_classid);
		Local_Skill_UseSkillDispatcher:Use(shortcut_classid, usetoself, EV_EXCUTE_EVENT_KEY_DOWN);
	elseif shortcut_type == EV_SHORTCUT_OBJECT_MISC then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then return end
		uiSkill_MiscAction(shortcut_objectid);
	end
end

function Shortcut_TemplateShortcutShortcutButton_OnRClick(self)
	Shortcut_TemplateShortcutShortcutButton_OnLClick(self);
end

function Shortcut_TemplateShortcutShortcutButton_OnHint(self)
	local hint = 0;
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		else
			hint = uiItemGetBagItemHintByObjectId(shortcut_objectid);
		end
	elseif shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
		if shortcut_classid == nil or shortcut_classid == 0 then
		else
			hint = uiSkill_GetMySkillRichText(shortcut_classid);
			if hint == nil then hint = 0 end
		end
	elseif shortcut_type == EV_SHORTCUT_OBJECT_MISC then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		else
			local item = EvUiLuaClass_RichTextItem:new();
			local text = "";
			if shortcut_objectid == nil or shortcut_objectid == 0 then
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_SIT then				-- 打坐
				text = LAN("hint_sit");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_PRACTICE then          -- 修炼法宝
				text = LAN("hint_practice");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_NORMALATTACK then      -- 普通攻击
				text = LAN("hint_normalattack");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_ITEMFUSE then        	-- 法宝熔合
				text = LAN("hint_fuse");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_AUTOUSE then			-- 消耗品助手
				text = LAN("hint_autouse");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_CONCENTRATE then		-- 凝神
				text = LAN("hint_concentrate");
			end
			item.Text = text;
			item.Font = LAN("font_title");
			item.FontSize = LAN("font_s_17");
			local line = EvUiLuaClass_RichTextLine:new();
			line:InsertItem(item);
			local rich_text = EvUiLuaClass_RichText:new();
			rich_text:InsertLine(line);
			hint = uiCreateRichText("String", rich_text:ToRichString());
		end
	end
	self:SetHintRichText(hint);
end

function Shortcut_TemplateShortcutShortcutButton_RefreshCount(self)
	local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SHORTCUT then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	
	local itemCount = 0; -- 道具的当前数量
	local countText = ""; -- 道具的当前数量文本
	--local bModifyFlag = false;
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE;
	elseif shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local tableInfo = LClassItemClassPool:Get(shortcut_classid); -- 道具的静态信息
		if tableInfo then
			local count, first_objectid = uiGetBagItemInfoByTableIndex(shortcut_classid);
			if shortcut_objectid == nil or shortcut_objectid == 0 or uiItemCheckBagItemExist(shortcut_objectid) == false then
				if tableInfo.IsCountable then
					shortcut_objectid = first_objectid;
					if shortcut_objectid == nil or shortcut_objectid == 0 then
						shortcut_objectid = 0;
						self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
					else
						self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
					end
				end
			end
			if tableInfo.IsCountable == true then
				--local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid); -- 道具的动态信息
				itemCount = count;
				if itemCount > 0 then
					countText = tostring(itemCount);
				end
			end
		end
		--bModifyFlag = true;
	end
	-- 操作按钮
	self:SetUltraTextNormal(countText);
end

function Shortcut_TemplateShortcutShortcutButton_OnUpdate(self)
	local now = os.clock();
	local LastUpdate = self.LastUpdate;
	if not LastUpdate then LastUpdate = now; self.LastUpdate = now end
	if LastUpdate + 0.2 <= now then
		self.LastUpdate = now;
		Shortcut_TemplateShortcutShortcutButton_RefreshCount(self);
	end
	
	local mask_value = 0;
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if shortcut_type == nil then
	elseif shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then
			mask_value = 1;
		else
			if shortcut_objectid > 0 then
				mask_value = uiItemGetBagItemMaskValueByObjectId(shortcut_objectid);
			end
		end
	elseif shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		if shortcut_classid == nil or shortcut_classid == 0 then
		else
			mask_value = uiSkill_GetMySkillMaskValue(shortcut_classid);
		end
	end
	if mask_value == nil then mask_value = 1 end
	if mask_value < 0 then mask_value = 0 end
	self:SetMaskValue(mask_value);
	
	if self.AutoHide then
		if not uiGetCurDrag() and (not shortcut_type or shortcut_type == EV_SHORTCUT_OBJECT_NONE) then
			self:Hide();
		end
	end
end

function Shortcut_TemplateShortcutShortcutButton_Refresh(self)
	local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SHORTCUT then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	
	local icon = 0; -- 图标地址 -- 指针地址
	local itemCount = 0; -- 道具的当前数量
	local countText = ""; -- 道具的当前数量文本
	--local bModifyFlag = false;
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE;
	elseif shortcut_type == EV_SHORTCUT_OBJECT_MISC then
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_SIT then				-- 打坐
			icon = SAPI.GetImage("ic_action_sit", 2, 2, -2, -2);
			--bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_PRACTICE then          -- 修炼法宝
			icon = SAPI.GetImage("ic_action_pracitice", 2, 2, -2, -2);
			--bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_NORMALATTACK then      -- 普通攻击
			icon = SAPI.GetImage("ic_action_attack", 2, 2, -2, -2);
			--bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_ITEMFUSE then        	-- 法宝熔合
			icon = SAPI.GetImage("ic_action_fuse", 2, 2, -2, -2);
			--bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_AUTOUSE then			-- 消耗品助手
			icon = SAPI.GetImage("ic_sys001", 2, 2, -2, -2);
			--bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_CONCENTRATE then		-- 凝神
			icon = SAPI.GetImage("ic_sys002", 2, 2, -2, -2);
			--bModifyFlag = true;
		end
	elseif shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid); -- 道具的静态信息
		if tableInfo then
			local count, first_objectid = uiGetBagItemInfoByTableIndex(shortcut_classid);
			if shortcut_objectid == nil or shortcut_objectid == 0 or uiItemCheckBagItemExist(shortcut_objectid) == false then
				if tableInfo.IsCountable then
					shortcut_objectid = first_objectid;
					if shortcut_objectid == nil or shortcut_objectid == 0 then
						shortcut_objectid = 0;
						self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
					else
						self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
					end
				end
			end
			icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2);
			if tableInfo.IsCountable == true then
				--local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid); -- 道具的动态信息
				itemCount = count;
				if itemCount > 0 then
					countText = tostring(itemCount);
				end
			end
		end
		--bModifyFlag = true;
	elseif shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		local tableInfo = uiSkill_GetSkillBaseInfoByIndex(shortcut_classid);
		icon = SAPI.GetImage(tableInfo.StrImage, 2, 2, -2, -2);
		--bModifyFlag = true;
	end
	-- 操作按钮
	--self:ModifyFlag("DragOut_MouseMove", bModifyFlag);
	self:SetNormalImage(icon);
	self:SetUltraTextNormal(countText);
	Shortcut_TemplateShortcutShortcutButton_RefreshLockState(self)
end

function Shortcut_TemplateShortcutShortcutButton_RefreshLockState(self)
	local bModifyFlag = false;
	local objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if not self.Lock and ((objectid and objectid ~= 0) or (classid and classid ~= 0)) then
		bModifyFlag = true;
	end
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag);
end

function Shortcut_TemplateShortcutShortcutButton_RefreshVisible(self)
	if self.AlwaysHide then
		self:Hide();
		return;
	end
	if not self.AutoHide then
		self:Show();
		return;
	end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type and shortcut_type ~= EV_SHORTCUT_OBJECT_NONE then
		self:Show();
		return;
	end
end

function Shortcut_TemplateShortcutShortcutButton_Clear(self)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SHORTCUT then return end
	self:Delete(EV_UI_SHORTCUT_TYPE_KEY);
	self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
	self:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
	Shortcut_TemplateShortcutShortcutButton_Refresh(self);
end

function Shortcut_TemplateShortcutShortcutButton_RefreshKeyName(self)
	local group = SAPI.GetParent(self);
	local group_id = group.ID;
	if not group_id then return end
	local index = self.ID;
	local eventname = LOCAL_SHORTCUT_EVENT_MAP:GetName(group_id, index);
	local keyname = uiHotkeyGetHotkeyName(eventname);
	self:SetUltraTextShortcut(keyname);
end

function Shortcut_TemplateShortcutButtonGroup_OnLoad(self)
	API_Shortcut_TemplateShortcutButtonGroup_ActiveMode(self);
	local group_id = self:Get("ID");
	if group_id ~= nil and type(group_id) == "number" then
		for i = 1, LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MAX, 1 do
			-- 为各按钮设置ID
			local id = LOCAL_SHORTCUT_ID_MAP:GetId(group_id, i);
			if id == nil or type(id) ~= "number" then id = 0 end -- 保证 id 是一个 number
			local button = SAPI.GetChild(self, "btShortcut"..i);
			button:Set(LOCAL_SHORTCUT_DBID_KEY, id);
			button.ID = i;
			local event, event1 = LOCAL_SHORTCUT_EVENT_MAP:GetEvent(group_id);
			if event and event ~= "" then
				button:RegisterScriptEventNotify(event);
				button:RegisterScriptEventNotify("EVENT_GlobalDragOut");
			end
			if event1 and event1 ~= "" then
				button:RegisterScriptEventNotify(event1);
			end
		end
	end
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("ConfigChange");
end

function Shortcut_TemplateShortcutButtonGroup_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		Shortcut_TemplateShortcutButtonGroup_LoadConfig(self);
	elseif event == "ConfigChange" then
		if args[1] ~= "interface.advanced.actionbar" then return end
		Shortcut_TemplateShortcutButtonGroup_LoadConfig(self);
	end
end

function Shortcut_TemplateShortcutButtonGroup_LoadConfig(self)
	local LockActionBar, AlwaysShowActionBar, ShowRight1ActionBar, ShowRight2ActionBar, ShowLeftDownActionBar, ShowRightDownActionBar = uiInterfaceGetUserConfig("interface.advanced.actionbar");
	if LockActionBar == nil then return end
	local AutoHide = (not AlwaysShowActionBar);
	local AlwaysHide = false;
	--if AutoHide then
		local POSITION = self.POSITION;
		if POSITION == nil or type(POSITION) ~= "string" then
		elseif POSITION == "LEFTDOWN" then
			AlwaysHide = not ShowLeftDownActionBar;
		elseif POSITION == "RIGHTDOWN" then
			AlwaysHide = not ShowRightDownActionBar;
		elseif POSITION == "RIGHT1" then
			AlwaysHide = not ShowRight1ActionBar;
		elseif POSITION == "RIGHT2" then
			AlwaysHide = not ShowRight2ActionBar;
		end
	--end
	for i = 1, 12, 1 do
		local btShortcut = SAPI.GetChild(self, "btShortcut"..i);
		btShortcut.Lock = LockActionBar;
		Shortcut_TemplateShortcutShortcutButton_RefreshLockState(btShortcut);
		btShortcut.AutoHide = AutoHide;
		btShortcut.AlwaysHide = AlwaysHide;
		Shortcut_TemplateShortcutShortcutButton_RefreshVisible(btShortcut);
	end
end

function Shortcut_TemplateShortcutButtonGroup_btControl_OnRClick(self)
	local menu = uiGetPopupMenu();
	menu:Hide();
	menu:RemoveAll();
	menu:SetHeaderText("$快捷栏$")
	menu:AddMenuItem("$切换方向$", true);
	menu:AddMenuItem("$增加一个$", true);
	menu:AddMenuItem("$减少一个$", true);
	local frame = SAPI.GetParent(self);
	SAPI.AddDefaultPopupMenuCallBack(CallBack_Shortcut_TemplateShortcutButtonGroup_OnPopupMenu, frame);
	uiShowPopupMenu();
end

function CallBack_Shortcut_TemplateShortcutButtonGroup_OnPopupMenu(menu, select, args)
	local select_text = menu:getMenuText(select);
	local frame = args;
	if select_text == "$切换方向$" then
		API_Shortcut_TemplateShortcutButtonGroup_SwitchMode(frame)
	elseif select_text == "$增加一个$" then
		API_Shortcut_TemplateShortcutButtonGroup_ButtonPlus(frame);
	elseif select_text == "$减少一个$" then
		API_Shortcut_TemplateShortcutButtonGroup_ButtonSub(frame);
	end
	
end

function API_Shortcut_TemplateShortcutButtonGroup_SwitchMode(self)
	local mode = self:Get("MODE");
	if mode == nil then return false end
	if mode == LOCAL_POPUPMENU_MODE_H then
		mode = LOCAL_POPUPMENU_MODE_V;
	else
		mode = LOCAL_POPUPMENU_MODE_H;
	end
	API_Shortcut_TemplateShortcutButtonGroup_SetMode(self, mode);
	return true;
end

function API_Shortcut_TemplateShortcutButtonGroup_ButtonPlus(self)
	local button_count = self:Get("BUTTON_COUNT");
	button_count = button_count + 1;
	if button_count > LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MAX then
		button_count = LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MAX;
	end
	self:Set("BUTTON_COUNT", button_count);
	API_Shortcut_TemplateShortcutButtonGroup_ActiveMode(self);
end

function API_Shortcut_TemplateShortcutButtonGroup_ButtonSub(self)
	local button_count = self:Get("BUTTON_COUNT");
	button_count = button_count - 1;
	if button_count < LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MIN then
		button_count = LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MIN;
	end
	self:Set("BUTTON_COUNT", button_count);
	API_Shortcut_TemplateShortcutButtonGroup_ActiveMode(self);
end

function API_Shortcut_TemplateShortcutButtonGroup_SetMode(self, mode)
	if mode == nil or type(mode) ~= "string" then return end
	self:Set("MODE", mode);
	API_Shortcut_TemplateShortcutButtonGroup_ActiveMode(self);
end

function API_Shortcut_TemplateShortcutButtonGroup_ActiveMode(self)
	local mode = self:Get("MODE");
	local button_gap = self:Get("BUTTON_GAP");
	local button_size = self:Get("BUTTON_SIZE");
	local button_count_max = 12;
	local button_count = self:Get("BUTTON_COUNT");
	local pos =
	{
		x=0,
		y=0,
		offset_x = 0,
		offset_y = 0,
		GetX = function(self) return self.x + self.offset_x; end,
		GetY = function(self) return self.y + self.offset_y; end,
		SetX = function(self, x) self.x = x; end,
		SetY = function(self, y) self.y = y; end,
		SetOffsetX = function(self, x) self.offset_x = x; end,
		SetOffsetY = function(self, y) self.offset_y = y; end,
	};
	local btControl = SAPI.GetChild(self, "btControl");
	local CanControl = self:Get("CAN_CONTROL");
	if CanControl ~= nil and CanControl == true then
		btControl:Show();
		btControl:FadingOut();
	else
		btControl:Hide();
	end
	if mode == LOCAL_POPUPMENU_MODE_H then
		btControl:MoveSize(pos:GetX(), pos:GetY(), button_size / 2, button_size);
		pos:SetX(button_size / 2 + 3);
	else
		btControl:MoveSize(pos:GetX(), pos:GetY(), button_size, button_size / 2);
		pos:SetY(button_size / 2 + 3);
	end
	for i = 1,button_count do
		local offset = (button_size + button_gap) * (i - 1);
		if mode == LOCAL_POPUPMENU_MODE_H then
			pos:SetOffsetX(offset);
		else
			pos:SetOffsetY(offset);
		end
		local button = SAPI.GetChild(self, "btShortcut"..i);
		button:MoveSize(pos:GetX(), pos:GetY(), button_size, button_size);
	end
	for i = button_count + 1, LOCAL_SHORTCUT_GROUP_BUTTON_COUNT_MAX do
		local button = SAPI.GetChild(self, "btShortcut"..i);
		button:MoveTo(-100, -100);
	end
	self:SetSize(pos:GetX() + button_size + 1, pos:GetY() + button_size + 1);
end

function Shortcut_TemplateShortcutButtonCombatPetSkill_OnLClick(self)
	local ID = self.ID
	if ID == nil or ID == 0 then return end
	uiSkill_ReleaseCurrentCombatPetSkill(ID);
end

function Shortcut_TemplateShortcutButtonCombatPetSkill_OnHint(self)
	local ID = self.ID;
	if ID == nil or ID == 0 then
		self:SetHintRichText(0);
	else
		self:SetHintRichText(uiSkill_GetCurrentCombatPetSkillHint(ID));
	end
end

function Shortcut_TemplateShortcutButtonCombatPetSkill_OnUpdate(self)
	local ID = self.ID;
	if ID == nil or ID == 0 then
		self:SetMaskValue(0);
	end
	local MaskValue = uiSkill_GetCurrentCombatPetSkillMaskValue(ID)
	self:SetMaskValue(MaskValue);
	if MaskValue == 0 and self.AutoRelease then
		uiSkill_ReleaseCurrentCombatPetSkill(ID);
	end
end

function Shortcut_TemplateShortcutButtonCombatPetSkill_OnRClick(self)
	local ID = self.ID;
	if ID == nil or ID == 0 then return end
	uiSkill_SwitchCurrentCombatPetSkillAutoRelease(ID);
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------                                           快捷栏的模板实现 (end)                                            ---------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function layWorld_frmSystemButtonEx_lbNetStatus_btUp(self)
	local CurPage = 1;
	for i = 2,3,1 do
		local group = SAPI.GetSibling(self, "MainBarShortcutGroup"..i);
		if group:getVisible() == true then
			group:Hide()
			CurPage = i - 1;
			local group_pre = SAPI.GetSibling(self, "MainBarShortcutGroup"..CurPage);
			group_pre:Show();
			break;
		end
	end
	local lbPageNumber = SAPI.GetSibling(self, "lbPageNumber");
	lbPageNumber:SetText(tostring(CurPage));
end

function layWorld_frmSystemButtonEx_lbNetStatus_btDown(self)
	local CurPage = 3;
	for i = 1,2,1 do
		local group = SAPI.GetSibling(self, "MainBarShortcutGroup"..i);
		if group:getVisible() == true then
			group:Hide()
			CurPage = i + 1;
			local group_next = SAPI.GetSibling(self, "MainBarShortcutGroup"..CurPage);
			group_next:Show();
			break;
		end
	end
	local lbPageNumber = SAPI.GetSibling(self, "lbPageNumber");
	lbPageNumber:SetText(tostring(CurPage));
end

function layWorld_frmSystemButtonEx_lbPageNumber_OnLoad(self)
	self:RegisterScriptEventNotify("MainShortcutPage");
end

function layWorld_frmSystemButtonEx_lbPageNumber_OnEvent(self, event, args)
	if event == "MainShortcutPage" then
		local opReason = args[1];
		if opReason ~= EV_EXCUTE_EVENT_KEY_UP then return end
		local page = args[2];
		if page < 1 or page > 3 then return end
		for i = 1, 3, 1 do
			local group = SAPI.GetSibling(self, "MainBarShortcutGroup"..i);
			if i == page then
				group:Show();
			else
				group:Hide();
			end
		end
		self:SetText(tostring(page));
	end
end
				
function layWorld_frmSystemButtonEx_lbNetStatus_OnHint(self)
	local ping, sendPacketNum, recvPacketNum, totalByteSend, totalByteRecv, secByteSend, secByteRecv, lastSecByteSend, lastSecByteRecv, sendCompressRate, recvCompressRate = uiNetGetData();
	local hint_text = string.format(LAN("net_status_hint1"), ping)
	if sendPacketNum ~= nil then
		hint_text = hint_text..string.format(
		[[
		sendPacketNum = %d
		recvPacketNum = %d
		totalByteSend = %d
		totalByteRecv = %d
		secByteSend = %d
		secByteRecv = %d
		lastSecByteSend = %d
		lastSecByteRecv = %d
		sendCompressRate = %d
		recvCompressRate = %d]],
		sendPacketNum, recvPacketNum, totalByteSend, totalByteRecv, secByteSend, secByteRecv, lastSecByteSend, lastSecByteRecv, sendCompressRate, recvCompressRate);
	end
	self:SetHintText(hint_text);
end

function layWorld_frmSystemButtonEx_lbNetStatus_OnUpdate(self, delta)
	local ping = uiNetGetData();
	local child_name = "BgNormal";
	if ping < 500 then
		child_name = "BgFast";
	elseif ping < 1000 then
		child_name = "BgNormal";
	else
		child_name = "BgBad";
	end
	local child_show = SAPI.GetChild(self, child_name);
	if child_show:getVisible() == false then child_show:Show() end
end

function layWorld_frmPetCtrlEx_OnLoad(self)
	self:RegisterScriptEventNotify("CEV_COMBAT_PET_RECALLED");
	self:RegisterScriptEventNotify("CEV_COMBAT_PET_RELEASED");
	self:RegisterScriptEventNotify("KeySettingChange");
	self:RegisterScriptEventNotify("CEV_PET_RECV_DATA_CHANGED");
	self:RegisterScriptEventNotify("PetShortcut");
end

function layWorld_frmPetCtrlEx_OnEvent(self, event, args)
	if event == "CEV_COMBAT_PET_RECALLED" then
		self:Hide();
	elseif event == "CEV_COMBAT_PET_RELEASED" then
		layWorld_frmPetCtrlEx_OnEvent_CombatPetRecalled(self, args)
	elseif event == "KeySettingChange" then
		layWorld_frmPetCtrlEx_Refresh(self);
	elseif event == "CEV_PET_RECV_DATA_CHANGED" then
		layWorld_frmPetCtrlEx_Refresh(self);
	elseif event == "PetShortcut" then
		layWorld_frmPetCtrlEx_OnEvent_PetShortcut(self, args);
	end
end

function layWorld_frmPetCtrlEx_OnEvent_CombatPetRecalled(self, args)
	layWorld_frmPetCtrlEx_Refresh(self);
	self:Show();
end

function layWorld_frmPetCtrlEx_Refresh(self)
	local ePassive = 0; -- 被动
	local eDefence = 1; -- 防守
	local eAggressive = 2; -- 未知
	if not self then self = uiGetglobal("layWorld.frmPetCtrlEx") end
	local id, isdead, renamecount, battlemode, enjoy, close, skilllist = uiUserGetCurrentCombatPetData();
	if not id or isdead then self:Hide() return end
	local btAttack = SAPI.GetChild(self, "btAttack");
	local AttackEvent = "PetShortcut(1)";
	local AttackKeyName = uiHotkeyGetHotkeyName(AttackEvent);
	btAttack:SetUltraTextShortcut(AttackKeyName);
	local btReturn = SAPI.GetChild(self, "btReturn");
	local ReturnEvent = "PetShortcut(2)";
	local ReturnKeyName = uiHotkeyGetHotkeyName(ReturnEvent);
	btReturn:SetUltraTextShortcut(ReturnKeyName);
	
	local btDefence = SAPI.GetChild(self, "btDefence");
	local btPassive = SAPI.GetChild(self, "btPassive");
	if battlemode == ePassive then
		btDefence:SetChecked(false);
		btPassive:SetChecked(true);
	elseif battlemode == eDefence then
		btDefence:SetChecked(true);
		btPassive:SetChecked(false);
	else
		btDefence:SetChecked(false);
		btPassive:SetChecked(false);
	end
	local iterator = 1;
	for i, v in ipairs(skilllist) do
		iterator = iterator + 1;
		local btSkill = SAPI.GetChild(self, "btSkill"..i);
		local Id = v.Id;
		local AutoRelease = v.AutoRelease;
		local info = uiSkill_GetSkillBaseInfoByIndex(Id);
		local icon = info.StrImage;
		if not icon then icon = "" end
		btSkill:SetNormalImage(SAPI.GetImage(icon));
		local Event = string.format("PetShortcut(%d)", i+2);
		local KeyName = uiHotkeyGetHotkeyName(Event);
		btSkill:SetUltraTextShortcut(KeyName);
		btSkill.ID = Id;
		local currentpose = btSkill:GetCoverModelCurrentPose();
		if AutoRelease then
			if currentpose ~= "wait" then
				btSkill:CoverModelPlayPose("wait", true);
				btSkill.AutoRelease = true;
			end
		else
			if currentpose ~= "idle" then
				btSkill:CoverModelPlayPose("idle", true);
				btSkill.AutoRelease = false;
			end
		end
		btSkill:Show();
	end
	for i = iterator, 5, 1 do
		local btSkill = SAPI.GetChild(self, "btSkill"..i);
		btSkill:Hide();
		btSkill.ID = nil;
	end
end

function layWorld_frmPetCtrlEx_OnEvent_PetShortcut(self, args)
	local reason = args[1];
	if reason == EV_EXCUTE_EVENT_KEY_UP then return end
	local index = args[2];
	if index == 1 then
		uiUserCurrentCombatPetAttack();
	elseif index == 2 then
		uiUserCurrentCombatPetReturn();
	elseif index >= 3 and index <=7 then
		local btSkill = SAPI.GetChild(self, "btSkill"..(index-2));
		local ID = btSkill.ID;
		if ID and ID > 0 then
			uiSkill_ReleaseCurrentCombatPetSkill(ID);
		end
	end
end

----------  主菜单
function layWorld_frmSystemButtonEx_MainMenuButton_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("KeySettingChange");
end

function layWorld_frmSystemButtonEx_MainMenuButton_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		layWorld_frmSystemButtonEx_MainMenuButtonKeynameRefresh(self);
	elseif event == "KeySettingChange" then
		layWorld_frmSystemButtonEx_MainMenuButtonKeynameRefresh(self);
	end
end

function layWorld_frmSystemButtonEx_MainMenuButtonKeynameRefresh(self)
	local HintTextKey = self.HintTextKey;
	if not HintTextKey then return end
	
	local hint = 0;
	local rich_text = EvUiLuaClass_RichText:new();
	local line = EvUiLuaClass_RichTextLine:new();
	local item = EvUiLuaClass_RichTextItem:new();
	item.Text = LAN(self.HintTextKey);
	item.Font = LAN("font_title");
	item.FontSize = LAN("font_s_18");
	line:InsertItem(item);
	
	local ShortcutEventName = self.ShortcutEventName;
	if ShortcutEventName then
		-- 加上快捷键信息
		local keyname = uiHotkeyGetHotkeyName(ShortcutEventName);
		if keyname and type(keyname) == "string" and keyname ~= "" then
			local item = EvUiLuaClass_RichTextItem:new();
			item.Text = "("..keyname..")";
			item.Font = LAN("font_title");
			item.FontSize = LAN("font_s_18");
			item.Color = "#ffaacc00";
			line:InsertItem(item);
		end
	end
	
	rich_text:InsertLine(line);
	
	hint = uiCreateRichText("String", rich_text:ToRichString());
	self:SetHintText("");
	self:SetHintRichText(hint);
end














