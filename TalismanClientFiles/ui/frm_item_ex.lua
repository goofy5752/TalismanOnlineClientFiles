include "ui/frm_item_use_ex.lua"

--local Local_Item_CurBag = 0;
local Local_Item_MinBag = 0;
local Local_Item_TaskBag = 1;
local Local_Item_MaxBag = 2;
local Local_Item_AllowedMaxBag = 4;
local Local_Item_MaxLine = 0;
local Local_Item_MaxCol = 0;
--local Local_Item_CurMaxLine = 0;
--local Local_Item_CurMaxCol = 0;
--local Local_Item_CurBagIsOutOfDate = false;

local function ShowCommonBag (common)
	local form = uiGetglobal("layWorld.frmItemEx");
	local btTask = SAPI.GetChild(form, "btTask");
	local btCommon = SAPI.GetChild(form, "btCommon");
	local wtBag0 = SAPI.GetChild(form, "wtBag0");
	local wtBag1 = SAPI.GetChild(form, "wtBag1");
	if common then
		btTask:SetChecked(false);
		btCommon:SetChecked(true);
		wtBag0:Show();
		wtBag1:Hide();
	else
		btTask:SetChecked(true);
		btCommon:SetChecked(false);
		wtBag0:Hide();
		wtBag1:Show();
	end
end

local function IsItemButtonOutOfDate (button)
	local coord = button:Get(EV_UI_ITEM_COORD3_KEY); -- 取坐标
	local line, col, item_count, isTaskBag, isOutOfDate, outDateTime = uiItemGetItemBagInfoByIndex(coord[1]);
	return isOutOfDate;
end

local function RefrshItemBag (bagindex)
	-- 如果 bagindex == nil 则刷新所有包包
	if bagindex == nil then
		for i = Local_Item_MinBag, Local_Item_AllowedMaxBag - 1 do
			RefrshItemBag(i);
		end
		return;
	end
	
	-- 检查背包有效性
	if bagindex < Local_Item_MinBag or bagindex > Local_Item_AllowedMaxBag - 1 then return end
	local form = uiGetglobal("layWorld.frmItemEx");
	local bagUI = SAPI.GetChild(form, "wtBag"..bagindex);
	local lbName = SAPI.GetChild(bagUI, "lbName");
	lbName:Show();
	local lbState = SAPI.GetChild(bagUI, "lbState");
	if bagindex > Local_Item_MaxBag - 1 then
		lbName:SetText(string.format(LAN("msg_extern_bag_name"), bagindex-Local_Item_TaskBag));
		lbState:Set("OutDateTime", -1);
		lbState.NeedUpdate = true;
		TemplateLimitTimeLabel_OnUpdate(lbState, 0);
		return;
	end
	
	local line, col, item_count, isTaskBag, isOutOfDate, outDateTime = uiItemGetItemBagInfoByIndex(bagindex);
	
	if bagindex == Local_Item_TaskBag then
		lbName:SetText(LAN("msg_task_bag_name"))
		lbState:Delete("OutDateTime");
		lbState.NeedUpdate = true;
		TemplateLimitTimeLabel_OnUpdate(lbState, 0);
	else
		if line == nil then
			lbState:Set("OutDateTime", -1); uiError("layWorld_frmItemEx_SetCurBag error!!! line=nil bag="..bagindex);
			lbState.NeedUpdate = true;
			TemplateLimitTimeLabel_OnUpdate(lbState, 0);
			return;
		end
		if bagindex > Local_Item_TaskBag then
			lbName:SetText(string.format(LAN("msg_extern_bag_name"), bagindex-Local_Item_TaskBag));
		else
			lbName:SetText(LAN("msg_default_bag_name"));
		end
		lbState:Set("OutDateTime", outDateTime);
		lbState.NeedUpdate = true;
		TemplateLimitTimeLabel_OnUpdate(lbState, 0);
	end
	
	-- 刷新
	for l = 0,line-1,1 do
		for c = 0,col-1,1 do
			TemplateBtnUserItem_Refresh(bagindex, l, c);
		end
	end
end

LClass_ItemFreezeManager = 
{
	list = {},
	Push = function (self, ID)
		if ID and type(ID) == "number" then
			if ID == 0 then return end
			if self.list[ID] == nil then
				self.list[ID] = 0;
			end
			self.list[ID] = self.list[ID] + 1;
			if self.list[ID] > 1 then
				uiError("LClass_ItemFreezeManager::Push : self.list[ID] > 1 error!!!");
				return;
			end
		end
	end,
	Erase = function (self, ID)
		if ID and type(ID) == "number" then
			if ID == 0 then return end
			if self.list[ID] == nil or self.list[ID] == 0 then
				uiError("LClass_ItemFreezeManager::Erase : no freezed error!!!");
				return;
			end
			self.list[ID] = self.list[ID] - 1;
		end
	end,
	IsFreezed = function (self, ID)
		return self.list[ID] ~= nil and self.list[ID] > 0;
	end,
};

function TemplateUserItemBag_OnHide(self)
	local lbState = SAPI.GetChild(self, "lbState");
	lbState:Delete("OutDateTime");
	TemplateLimitTimeLabel_OnUpdate(lbState, 0);
end

function TemplateBtnUserItem_OnLoad(self)
	--[[ -- 初始化时不需要DragOut功能
	self:ModifyFlag("DragOut_MouseMove", true);
	self:ModifyFlag("DragOut_LeftButton", true);
	self:ModifyFlag("DragOut_RightButton", false);
	]]
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_ITEM);
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_ITEM);
end

function TemplateBtnUserItem_OnLClick(self)
	self:Delete(EV_UI_ITEM_DIVIDE_COUNT_KEY); -- 清除拆分数量
	local id = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if id == nil or id == 0 then return end
	if classid == nil or classid == 0 then return end
	local cursor = uiGetGameCursor();
	if Local_Item_UseItemDispatcher:IsProcessing() then -- 检查当前光标状态
		Local_Item_UseItemDispatcher:Target(id);
		uiClearDrag();
		return;
	elseif Local_Skill_UseSkillDispatcher and Local_Skill_UseSkillDispatcher:IsProcessing() then
		Local_Skill_UseSkillDispatcher:Target(id);
		uiClearDrag();
		return;
	end
	if uiIsKeyPressed("SHIFT") == true then
		local ebInput = uiGetglobal("layWorld.frmChatInput.ebInput");
		if ebInput:getVisible() == true then
			layWorld_wtLayerChatEx_frmChatInput_ebInput_OnDragIn(ebInput, self:getName());
			uiClearDrag();
		elseif LClass_ItemFreezeManager:IsFreezed(id) == false then
			local classinfo = uiItemGetItemClassInfoByTableIndex(classid);
			local iteminfo = uiItemGetBagItemInfoByObjectId(id);
			if classinfo.IsCountable == true and iteminfo.Count > 1 then
				local frmItemBreakEx = uiGetglobal("layWorld.frmItemBreakEx");
				if frmItemBreakEx:getVisible() == true then frmItemBreakEx:Hide() end
				frmItemBreakEx:Set(EV_UI_ITEM_DIVIDE_ID_KEY, id);
				frmItemBreakEx:ShowAndFocus();
				uiClearDrag();
				return;
			end
		end
	end
end

function TemplateBtnUserItem_OnRClick(self)
	local bCanUseItem = true;
	if bCanUseItem == false then return end
	
	local id = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if id == nil or id == 0 then return end
	Local_Item_UseItemDispatcher:Use(id); -- 使用道具
end

function TemplateBtnUserItem_OnHint(self)
	local id = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if id == nil or id == 0 then self:SetHintRichText(0); return end
	local hint = uiItemGetBagItemHintByObjectId(id);
	if hint == nil then return end
	self:SetHintRichText(hint);
end

function TemplateBtnUserItem_OnDragIn(self, drag)
	if IsItemButtonOutOfDate (self) then uiClientMsg(LAN("msg_leasing_over"), true) return end
	local btDrag = uiGetglobal(drag);
	local Owner = btDrag:Get(EV_UI_SHORTCUT_OWNER_KEY);
	local Type = btDrag:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if Type ~= EV_SHORTCUT_OBJECT_ITEM then return end
	local coord3To = self:Get(EV_UI_ITEM_COORD3_KEY);
	if coord3To == nil then return end
	local bagTo, lineTo, colTo = coord3To[1], coord3To[2], coord3To[3];
	if Owner == EV_UI_SHORTCUT_OWNER_ITEM then
		-- 移动道具
		-- 先取出双方的坐标
		local coord3From = btDrag:Get(EV_UI_ITEM_COORD3_KEY);
		if coord3From == nil then return end
		local bagFrom = coord3From[1];
		local lineFrom = coord3From[2];
		local colFrom = coord3From[3];
		if bagFrom == bagTo and lineFrom == lineTo and colFrom == colTo then return end
		--@@@ 执行移动
		local divide_count = btDrag:Get(EV_UI_ITEM_DIVIDE_COUNT_KEY);
		if divide_count ~= nil and divide_count > 0 then
			--  拆分道具
			uiItemDivideItem(bagFrom, lineFrom, colFrom, bagTo, lineTo, colTo, divide_count);
		else
			uiItemMoveItem(bagFrom, lineFrom, colFrom, bagTo, lineTo, colTo);
		end
		btDrag:Delete(EV_UI_ITEM_DIVIDE_COUNT_KEY);
	elseif Owner == EV_UI_SHORTCUT_OWNER_EQUIP then
		-- 脱下装备
		local equip_part = btDrag:Get(EV_UI_EQUIP_PART_KEY);
		uiItemUnequip(equip_part, bagTo, lineTo, colTo);
	elseif Owner == EV_UI_SHORTCUT_OWNER_BANK then
		local ItemId = btDrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if ItemId == nil or ItemId == 0 then return end
		-- ### UI_Bank_Npc_Object_Id 是在frm_Warehouse_ex.lua中定义的全局变量
		if UI_Bank_Npc_Object_Id == 0 or UI_Bank_Npc_Object_Id == nil then return end
		uiItemPutInFromBank(ItemId, bagTo, lineTo, colTo, UI_Bank_Npc_Object_Id);
	elseif Owner == EV_UI_SHORTCUT_OWNER_GUILD_BANK then -- 帮会仓库
		local ItemId = btDrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if ItemId == nil or ItemId == 0 then return end
		-- ### UI_Bank_Npc_Object_Id 是在frm_Warehouse_ex.lua中定义的全局变量
		if UI_Guild_Bank_Npc_Object_Id == 0 or UI_Guild_Bank_Npc_Object_Id == nil then return end
		uiGuild_TakeOutGuildBankItemByCoord(ItemId, UI_Guild_Bank_Npc_Object_Id, bagTo, lineTo, colTo);
	end
end

local last_dragout_fail_time = 0;
function TemplateBtnUserItem_OnDragOut(self)
	if IsItemButtonOutOfDate (self) then
		uiClearDrag();
		if os.clock() - last_dragout_fail_time > 5 then
			uiClientMsg(LAN("msg_leasing_over"), true);
			last_dragout_fail_time = os.clock();
		end
		return;
	end
end

function TemplateBtnUserItem_OnDragNull(self)
	local id = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	layWorld_frmItemEx_API_DeleteItem(id, classid);
end
function TemplateBtnUserItem_OnDragEnd(self)
	local id = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if id == nil or id == 0 then return end
	local count = self:Get(EV_UI_ITEM_DIVIDE_COUNT_KEY);
	if count == nil or count <= 0 then return end
	-- 如果正在拆分,要解冻了
	-- @@@脚本的冻结还未实现
end
function TemplateBtnUserItem_OnUpdate(self, delta)
	local id = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if not id or id == 0 then return end
	local mask_value = 0;
	if LClass_ItemFreezeManager:IsFreezed(id) == true then
		self:ModifyFlag("DragOut_MouseMove", false);
		self:ModifyFlag("DragOut_LeftButton", false);
		mask_value = 1;
	else
		local coord3To = self:Get(EV_UI_ITEM_COORD3_KEY);
		if coord3To == nil then return end
		local bag, line, col = coord3To[1], coord3To[2], coord3To[3];
		mask_value = uiItemGetBagItemMaskValueByCoord(bag, line, col);
		if mask_value == nil then return end
		if mask_value < 0 then mask_value = 0 end
		self:ModifyFlag("DragOut_MouseMove", true);
		self:ModifyFlag("DragOut_LeftButton", true);
	end
	self:SetMaskValue(mask_value);
end
function TemplateBtnUserItem_API_DragOutToDivide(id, count)
	if id == nil or id == 0 then return end
	if count == nil or count == 0 then return end
	local iteminfo = uiItemGetBagItemInfoByObjectId(id);
	if count > iteminfo.Count-1 then count = iteminfo.Count-1 end
	local btItem, bag, line, col = TemplateBtnUserItem_API_FindButtonByObjectId(id);
	if btItem == nil then return end
	btItem:Set(EV_UI_ITEM_DIVIDE_COUNT_KEY, count);
	uiDragOut(btItem);
end
function TemplateBtnUserItem_API_FindButtonByObjectId(id)
	if id == nil or id == 0 then return end
	local MaxBag = Local_Item_MaxBag;
	local MaxLine = Local_Item_MaxLine;
	local MaxCol = Local_Item_MaxCol;
	for bag = 0,MaxBag-1,1 do
		local wtBag = uiGetglobal("layWorld.frmItemEx.wtBag"..bag);
		for l = 0,MaxLine-1,1 do
			for c = 0,MaxCol-1,1 do
				local btItem = SAPI.GetChild(wtBag, "btItem"..l*MaxCol + c);
				local _id = btItem:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
				if _id ~= nil and id == _id then return btItem, bag, l, c end
			end
		end
	end
end
function TemplateBtnUserItem_Refresh(bag, line, col)
	--if Local_Item_CurBag ~= bag then return end -- 不是当前页
	local MaxCol = Local_Item_MaxCol;
	local count = line*MaxCol + col;
	btItem = uiGetglobal("layWorld.frmItemEx.wtBag"..bag..".btItem"..count);
	-- 确定动态变量值
	local id, index = uiItemGetItemInfoByCoord(bag, line, col);
	local icon = 0; -- 图标地址 -- 指针地址
	local itemCount = 0; -- 道具的当前数量
	local countText = ""; -- 道具的当前数量文本
	local bModifyFlag = false;
	if id ~= nil then
		local tableInfo = uiItemGetItemClassInfoByTableIndex(index); -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon);
		if tableInfo.IsCountable == true then
			local objInfo = uiItemGetBagItemInfoByObjectId(id); -- 道具的动态信息
			itemCount = objInfo.Count;
			countText = tostring(itemCount);
		end
		bModifyFlag = true;
		btItem:Set(EV_UI_SHORTCUT_OBJECTID_KEY, id);
		btItem:Set(EV_UI_SHORTCUT_CLASSID_KEY, index);
	else
		btItem:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
		btItem:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
	end
	-- 操作按钮
	btItem:ModifyFlag("DragOut_MouseMove", bModifyFlag);
	btItem:ModifyFlag("DragOut_LeftButton", bModifyFlag);
	btItem:SetNormalImage(icon);
	btItem:SetUltraTextNormal(countText);
	-- 刷新界面
	btItem:SetMaskValue(0);
	TemplateBtnUserItem_OnUpdate(btItem);
end

--[[
function TemplateBtnUserItem_RefreshAll()
	local page = Local_Item_CurBag;
	local line, col = Local_Item_CurMaxLine, Local_Item_CurMaxCol;
	for l = 0,line-1,1 do
		for c = 0,col-1,1 do
			TemplateBtnUserItem_Refresh(page, l, c);
		end
	end
end
]]


function TemplateBtnUserEquip_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentChanged");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentEquiped");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentUnequiped");
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_EQUIP);
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_ITEM);
end
function TemplateBtnUserEquip_OnEvent(self, event, arg)
	if event == "EVENT_SelfEnterWorld" then
		local t_equip_part =
		{
			["btPart0"] = EV_EQUIP_PART_CLOTHING,	-- 盔甲
			["btPart1"] = EV_EQUIP_PART_SASH,		--  腰带
			["btPart2"] = EV_EQUIP_PART_CUFF,		--  护腕
			["btPart3"] = EV_EQUIP_PART_GLOVE,		--  手套
			["btPart4"] = EV_EQUIP_PART_KNEEPAD,	--  护膝
			["btPart5"] = EV_EQUIP_PART_MAINTRUMP,	--  主法宝
			["btPart6"] = EV_EQUIP_PART_SUBTRUMP1,	--  辅助法宝
			["btPart7"] = EV_EQUIP_PART_SUBTRUMP2,	--  辅助法宝
			["btPart8"] = EV_EQUIP_PART_SHOES,		--  鞋子
			["btPart9"] = EV_EQUIP_PART_AMULET1,	--  护身符
			["btPart10"] = EV_EQUIP_PART_AMULET2,	--  护身符
			["btPart11"] = EV_EQUIP_PART_RING1,		--  戒指
			["btPart12"] = EV_EQUIP_PART_RING2,		--  戒指
		}
		local name = self:getShortName();
		self:Set(EV_UI_EQUIP_PART_KEY, t_equip_part[name]);
	elseif event == "EVENT_SelfEquipmentChanged" or event == "EVENT_SelfEquipmentEquiped" then
		TemplateBtnUserEquip_OnEvent_SelfEquipmentChanged(self, arg);
	elseif event == "EVENT_SelfEquipmentUnequiped" then
		TemplateBtnUserEquip_OnEvent_SelfEquipmentUnequiped(self, arg);
	end
end
-- 装备更换
function TemplateBtnUserEquip_OnEvent_SelfEquipmentChanged(self, arg)
	local changed_part = arg[2]; -- 当前变更的部位
	local part = self:Get(EV_UI_EQUIP_PART_KEY);
	if part ~= changed_part then return end
	TemplateBtnUserEquip_Refresh(self);
end
-- 脱下装备
function TemplateBtnUserEquip_OnEvent_SelfEquipmentUnequiped(self, arg)
	local changed_part = arg[2]; -- 当前脱下的部位
	local part = self:Get(EV_UI_EQUIP_PART_KEY);
	if part ~= changed_part then return end
	TemplateBtnUserEquip_Refresh(self);
end
-- 刷新指定装备
function TemplateBtnUserEquip_Refresh(self)
	local part = self:Get(EV_UI_EQUIP_PART_KEY);
	local id, classid = uiItemGetCurEquipItemByPart(part); -- 获取此部位的当前装备
	if id == nil or id == 0 or classid == nil or classid == 0 then
		self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
		self:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
		self:SetNormalImage(0); -- 清除图标
		self:ModifyFlag("DragOut_MouseMove", false);
		self:ModifyFlag("DragOut_LeftButton", false);
	else
		self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, id);
		self:Set(EV_UI_SHORTCUT_CLASSID_KEY, classid);
		local tableInfo = uiItemGetItemClassInfoByTableIndex(classid); -- 道具的静态信息
		self:SetNormalImage(SAPI.GetImage(tableInfo.Icon)); -- 设置图标
		self:ModifyFlag("DragOut_MouseMove", true);
		self:ModifyFlag("DragOut_LeftButton", true);
	end
end
-- 刷新所有装备
function TemplateBtnUserEquip_RefreshAll()
	local form = uiGetglobal("layWorld.frmItemEx");
	for i = 0,12,1 do
		local btPart = SAPI.GetChild(form, "btPart"..i);
		TemplateBtnUserEquip_Refresh(btPart); -- 逐个刷新
	end
end
function TemplateBtnUserEquip_OnRClick(self)
	-- 脱下装备
	local equip_party = self:Get(EV_UI_EQUIP_PART_KEY);
	uiItemUnequip(equip_party, -1, -1, -1);
end
function TemplateBtnUserEquip_OnHint(self)
	local equip_part = self:Get(EV_UI_EQUIP_PART_KEY);
	if equip_part == nil then self:SetHintRichText(0); return end
	local hint = uiItemGetEquipedItemHintByPart(equip_part);
	if hint == nil then hint = 0 end
	self:SetHintRichText(hint);
end
function TemplateBtnUserEquip_OnDragIn(self, drag)
	local btDrag = uiGetglobal(drag);
	local Owner = btDrag:Get(EV_UI_SHORTCUT_OWNER_KEY);
	local Type = btDrag:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if Type ~= EV_SHORTCUT_OBJECT_ITEM then return end
	if Owner == EV_UI_SHORTCUT_OWNER_ITEM then
		 -- 只有从道具栏拖上来的道具,要求装备
		local equip_party = self:Get(EV_UI_EQUIP_PART_KEY);
		if not equip_party then return end
		local id = btDrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY); -- 取得ObjectID
		if id == nil or id <= 0 then return end
		uiItemEquipItemByPart(id, equip_party);
	end
end

function layWorld_frmItemEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("bag_item_update");
	self:RegisterScriptEventNotify("bag_item_exchange_grid");
	self:RegisterScriptEventNotify("bag_item_before_remove");
	self:RegisterScriptEventNotify("bag_item_removed");
	self:RegisterScriptEventNotify("bag_item_before_add");
	self:RegisterScriptEventNotify("bag_item_added");
	self:RegisterScriptEventNotify("ToggleItem");
	self:RegisterScriptEventNotify("EVENT_BagContainerRefresh");
end

function layWorld_frmItemEx_OnShow(self)
	local btExtendBag = SAPI.GetChild(self, "btExtendBag");
	if Local_Item_MaxBag > Local_Item_TaskBag + 1 then
		self:SetSize(524,642);
		btExtendBag:SetChecked(false);
	else
		self:SetSize(294,642);
		btExtendBag:SetChecked(true);
	end
	
	ShowCommonBag (true);
	
	uiRegisterEscWidget(self);
	-- 刷新游戏数据
	layWorld_frmItemEx_Refresh();
end

function layWorld_frmItemEx_OnEvent(self, event, arg)
	if event == "ToggleItem" then
        if arg[1] == EV_EXCUTE_EVENT_KEY_DOWN or arg[1] == EV_EXCUTE_EVENT_ON_LCLICK then
			if self:getVisible() == true then self:Hide() else self:ShowAndFocus() end
		end
	elseif event == "EVENT_SelfEnterWorld" then
		layWorld_frmItemEx_OnEvent_SelfEnterWorld(self, event, arg);
	elseif event == "bag_item_update" then
		layWorld_frmItemEx_OnEvent_BagItemUpdate(self, event, arg);
	elseif event == "bag_item_exchange_grid" then
		layWorld_frmItemEx_OnEvent_BagItemExChangeGrid(self, event, arg);
	elseif event == "bag_item_before_remove" then
		-- bag_item_before_remove
	elseif event == "bag_item_removed" then
		layWorld_frmItemEx_OnEvent_BagItemRemoved(self, event, arg);
	elseif event == "bag_item_before_add" then
		-- bag_item_before_add
	elseif event == "bag_item_added" then
		layWorld_frmItemEx_OnEvent_BagItemAdded(self, event, arg);
	elseif event == "EVENT_BagContainerRefresh" then
		local bagCount = uiItemGetItemBagCount();
		Local_Item_MaxBag = bagCount;
		RefrshItemBag ();
		--layWorld_frmItemEx_SetCurBag(Local_Item_CurBag);
	end
end

function layWorld_frmItemEx_OnEvent_SelfEnterWorld(self, event, arg)
	Local_Item_UseItemDispatcher:Init(); -- 初始化分发器
	local info = uiItemGetItemSystemInfo();
	local slot = info.ItemSlot.Item;
	-- 初始化动态数据
	Local_Item_MaxLine = slot.Line;	-- 
	Local_Item_MaxCol = slot.Col;
	local bagCount = uiItemGetItemBagCount();
	Local_Item_MaxBag = bagCount;
	for bag = 0,bagCount-1,1 do
		local line, col, item_count, isTaskBag = uiItemGetItemBagInfoByIndex(bag);
		if isTaskBag == true then
			Local_Item_TaskBag = bag; -- 任务包
			break;
		end
	end
	-- 初始化界面元素
	local left = slot.Left;
	local top = slot.Top;
	local width = slot.Right - slot.Left + 1;
	local height = slot.Bottom - slot.Top + 1;
	Local_Item_AllowedMaxBag = slot.Page;
	for bag = 0,Local_Item_AllowedMaxBag - 1,1 do
		left = slot.Left;
		top = slot.Top;
		width = slot.Right - slot.Left + 1;
		height = slot.Bottom - slot.Top + 1;
		local line, col, item_count, isTaskBag = uiItemGetItemBagInfoByIndex(bag);
		local wtBag = SAPI.GetChild(self, "wtBag"..bag);
		if isTaskBag then
			--wtBag:MoveSize(slot.Left, slot.Top, width, height);
			left, top, width, height = uiGetWidgetLocalRect(wtBag);
		else
			left, top, width, height = uiGetWidgetLocalRect(wtBag);
		end
		for line = 0,Local_Item_MaxLine-1,1 do
			for col = 0,Local_Item_MaxCol-1,1 do
				local count = line*Local_Item_MaxCol + col;
				local btItem = SAPI.GetChild(wtBag, "btItem"..count);
				local left = slot.OffsetLeft + col*slot.Width;
				local top = slot.OffsetTop + line*slot.Height;
				local width = slot.OffsetRight - slot.OffsetLeft + 1;
				local height = slot.OffsetRight - slot.OffsetLeft + 1;
				btItem:MoveSize(left, top, width, height);
				btItem:Show();
				btItem:Set(EV_UI_ITEM_COORD3_KEY, {bag, line, col}); -- 设置坐标
			end
		end
	end
	--layWorld_frmItemEx_SetCurBag(0);
	layWorld_frmItemEx_Refresh(); -- 刷新游戏数据
end

function layWorld_frmItemEx_btDelete_OnDragIn(self, drag)
	local btDrag = uiGetglobal(drag);
	if btDrag == nil then return end
	local id = btDrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local classid = btDrag:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	layWorld_frmItemEx_API_DeleteItem(id, classid);
end

function layWorld_frmItemEx_API_DeleteItem(id, classid)
	if id == nil or type(id) ~= "number" or id == 0 then return end
	if classid == nil or type(classid) ~= "number" or classid == 0 then return end
	local classinfo = uiItemGetItemClassInfoByTableIndex(classid);
	local message = string.format(LAN("MSG_DEL_CONFIRM"), classinfo.Name);
	local title = LAN("MSG_DEL_CONFIRM_");
	local form, messagebox = uiMessageBox(message, title, true, true, true);
	SAPI.AddDefaultMessageBoxCallBack(form, function(event, Arg) uiItemDeleteItem(Arg) end, nil, id);
	messagebox:SetMessageColor(32, 32, 208, 255);
end

function layWorld_frmItemEx_btCommon_OnLCLick(self)
	ShowCommonBag (true);
end

function layWorld_frmItemEx_btTask_OnLCLick(self)
	ShowCommonBag (false);
end

function layWorld_frmItemEx_btExtendBag_OnLCLick(self)
	local form = SAPI.GetParent(self);
	if self:getChecked() then
		form:SetSize(294,642);
	else
		form:SetSize(524,642);
	end
end
--[[
function layWorld_frmItemEx_SetCurBag(bag)
	local maxbag = Local_Item_MaxBag;
	local taskbag = Local_Item_TaskBag;
	if bag >= maxbag then return end
	local form = uiGetglobal("layWorld.frmItemEx");
	local btCommon = SAPI.GetChild(form, "btCommon"); -- 普通道具包标签
	local btTask = SAPI.GetChild(form, "btTask"); -- 任务道具包标签
	local lbPage = SAPI.GetChild(form, "lbPage");
	local btPreBag = SAPI.GetChild(form, "btPreBag");
	local btNextBag = SAPI.GetChild(form, "btNextBag");
	local lbLimitTime = SAPI.GetChild(form, "lbLimitTime");
	local line, col, item_count, isTaskBag, isOutOfDate, outDateTime = uiItemGetItemBagInfoByIndex(bag);
	if line == nil then uiError("layWorld_frmItemEx_SetCurBag error!!! line=nil bag="..bag) return end
	if isTaskBag == true then
		btCommon:SetChecked(false);
		btTask:SetChecked(true);
		lbPage:Hide();
		btPreBag:Hide();
		btNextBag:Hide();
	else
		btCommon:SetChecked(true);
		btTask:SetChecked(false);
		local combag = bag;
		if bag > taskbag then combag = bag - 1 end
		lbPage:SetText(string.format("%d/%d", combag+1, maxbag-1));
		lbPage:Show();
		btPreBag:Show();
		btNextBag:Show();
	end
	Local_Item_CurBag = bag;
	Local_Item_CurMaxLine = line;
	Local_Item_CurMaxCol = col;
	for bag = 0,maxbag-1,1 do
		local wtBag = SAPI.GetChild(form, "wtBag"..bag);
		if bag == Local_Item_CurBag then
			wtBag:Show();
		else
			wtBag:Hide();
		end
	end
	Local_Item_CurBagIsOutOfDate = isOutOfDate;
	TemplateBtnUserItem_RefreshAll();
	lbLimitTime:Set("OutDateTime", outDateTime);
	layWorld_frmItemEx_lbLimitTime_OnUpdate(lbLimitTime, 0);
end
]]
--[[
function layWorld_frmItemEx_lbLimitTime_OnUpdate(self, delta)
	local OutDateTime = self:Get("OutDateTime");
	if not OutDateTime or OutDateTime == 0 then self:Hide() return end
	self:Show();
	local ServerTime = uiGetServerTime();
	if ServerTime < OutDateTime then
		-- 有效期之内
		self:SetTextColorEx(224,224,224,255);
		local year, month, day, hour, minute, second, millisecond = uiFormatTime(OutDateTime - ServerTime);
	else
		-- 过期
		self:SetTextColorEx( 17, 17,224,255);
		if Local_Item_CurBagIsOutOfDate then
			Local_Item_CurBagIsOutOfDate = true;
			TemplateBtnUserItem_RefreshAll();
		end
	end
	local year, month, day, hour, minute, second, millisecond = uiFormatTime(OutDateTime);
	local text = string.format(LAN("msg_leasingtime"), year, month, day, hour, minute);
	self:SetText(text);
end
]]

function TemplateLimitTimeLabel_OnUpdate(self, delta)
	local NeedUpdate = self.NeedUpdate;
	if not NeedUpdate then return end
	local OutDateTime = self:Get("OutDateTime");
	if not OutDateTime then -- 比如：任务包
		self:SetText("Unknown");
		self:SetTextColorEx(224,224,224,255);
		self:SetHintText("");
		self:Hide();
		SAPI.GetSibling(self, "lbLock"):Hide();
		self.NeedUpdate = false;
		return;
	end
	if OutDateTime == 0 then
		self:SetText(LAN("msg_extend_bag_forever"));
		self:SetTextColorEx(224,224,224,255);
		self:SetHintText("");
		SAPI.GetSibling(self, "lbLock"):Hide();
		self.NeedUpdate = false;
		return;
	end
	if OutDateTime == -1 then
		self:SetText(LAN("msg_extern_bag_never_add"));--未激活
		self:SetTextColorEx(224,224,224,255);
		self:SetHintText("");
		SAPI.GetSibling(self, "lbLock"):Show();
		self.NeedUpdate = false;
		return;
	end
	SAPI.GetSibling(self, "lbLock"):Hide();
	local ServerTime = uiGetServerTime();
	if ServerTime < OutDateTime then
		-- 有效期之内
		self:SetTextColorEx(224,224,224,255);
		local year, month, day, hour, minute, second, millisecond = uiFormatTime(OutDateTime - ServerTime);
		self:SetText(LAN("msg_exterd_bag_limit"));
	else
		-- 过期
		self:SetTextColorEx( 17, 17,224,255);
		self.NeedUpdate = false;
		self:SetText(LAN("msg_extern_bag_outdate"));
	end
	local year, month, day, hour, minute, second, millisecond = uiFormatTime(OutDateTime);
	local text = string.format(LAN("msg_leasingtime"), year, month, day, hour, minute);
	self:SetHintText(text);
end

function layWorld_frmItemEx_OnEvent_BagItemUpdate(self, event, arg)
	local bag, line, col = arg[2], arg[3], arg[4];
	TemplateBtnUserItem_Refresh(bag, line, col);
end

function layWorld_frmItemEx_OnEvent_BagItemExChangeGrid(self, event, arg)
	local bag, line, col = arg[2], arg[3], arg[4];
	TemplateBtnUserItem_Refresh(bag, line, col);	-- from
	local bag, line, col = arg[5], arg[6], arg[7];
	TemplateBtnUserItem_Refresh(bag, line, col);	-- to
end

function layWorld_frmItemEx_OnEvent_BagItemRemoved(self, event, arg)
	local bag, line, col = arg[2], arg[3], arg[4];
	TemplateBtnUserItem_Refresh(bag, line, col);	-- from
end

function layWorld_frmItemEx_OnEvent_BagItemAdded(self, event, arg)
	local bag, line, col = arg[2], arg[3], arg[4];
	TemplateBtnUserItem_Refresh(bag, line, col);	-- from
end

--[[
-- 下一个包包页
function layWorld_frmItemEx_btNextBag_OnLClick(self)
	local bag = Local_Item_CurBag;
	local taskbag = Local_Item_TaskBag;
	local maxbag = Local_Item_MaxBag;
	while true do
		bag = bag + 1;
		if bag >= maxbag then return end -- 已经是第一页了
		if bag == Local_Item_CurBag then return end -- 没有下一页
		if bag ~= taskbag then
			layWorld_frmItemEx_SetCurBag(bag);
			return;
		end
	end
end
]]
--[[
-- 上一个包包页
function layWorld_frmItemEx_btPreBag_OnLClick(self)
	local bag = Local_Item_CurBag;
	local taskbag = Local_Item_TaskBag;
	local maxbag = Local_Item_MaxBag;
	while true do
		bag = bag - 1;
		if bag < 0 then return end -- 已经是最后一页了
		if bag == Local_Item_CurBag then return end -- 没有上一页
		if bag ~= taskbag then
			layWorld_frmItemEx_SetCurBag(bag);
			return;
		end
	end
end
]]

------------------------
-- 刷新游戏数据
------------------------
function layWorld_frmItemEx_Refresh()
	RefrshItemBag();
	TemplateBtnUserEquip_RefreshAll();
	layWorld_frmItemEx_modelSelf_Refresh();
	layWorld_wtLayerSelfMoney_Refresh();
	layWorld_wtLayerSelfbindMoney_Refresh();
end


function layWorld_frmItemEx_modelSelf_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentChanged");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentEquiped");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentUnequiped");
end

function layWorld_frmItemEx_modelSelf_OnEvent(self, event, arg)
	if event == "EVENT_SelfEnterWorld" then
	elseif event == "EVENT_SelfEquipmentChanged" or event == "EVENT_SelfEquipmentEquiped" then
		layWorld_frmItemEx_modelSelf_RefreshPart(self, arg[2]);
	elseif event == "EVENT_SelfEquipmentUnequiped" then
		layWorld_frmItemEx_modelSelf_RefreshPart(self, arg[2]);
	end
end

function layWorld_wtLayerSelfMoney_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmItemEx.wtLayerSelfMoney") end
	local lbGoldNum = SAPI.GetChild(self, "lbGoldNum");
	local lbSilverNum = SAPI.GetChild(self, "lbSilverNum");
	local lbSopperNum = SAPI.GetChild(self, "lbSopperNum");
	local money = uiGetMyInfo("Money");
	local gold, silver, sopper = SAPI.GetMoneyShowStyle(money);
	lbGoldNum:SetText(tostring(gold));
	lbSilverNum:SetText(tostring(silver));
	lbSopperNum:SetText(tostring(sopper));
end

function layWorld_wtLayerSelfbindMoney_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmItemEx.wtLayerSelfbindMoney") end
	local lbGoldNum = SAPI.GetChild(self, "lbBindGoldNum");
	local lbSilverNum = SAPI.GetChild(self, "lbBindSilverNum");
	local lbSopperNum = SAPI.GetChild(self, "lbBindCopperNum");
	local _, bindmoney = uiGetMyInfo("Money");
	local gold, silver, sopper = SAPI.GetMoneyShowStyle(bindmoney);
	lbGoldNum:SetText(tostring(gold));
	lbSilverNum:SetText(tostring(silver));
	lbSopperNum:SetText(tostring(sopper));
end

function layWorld_frmItemEx_modelSelf_RefreshPart(self, part)
	local model_pre = "SELF_SUB_MODEL";
	local path_pre = "SELF_SUB_PATH";
	if self == nil then self = uiGetglobal("layWorld.frmItemEx.modelSelf") end
	local model= uiItemGetCurEquipModelByPart(part);
	local equip_mode, param = uiItemGetEquipParamByPart(part);
	if equip_mode == nil then return end
	if equip_mode == EV_EQUIP_MODE_LOAD_SKIN then
		self:UnloadSkin(model_pre..part);
		if model == nil or model[1] == nil then
			self:UnloadSkin(model_pre..part);
		else
			self:LoadSkin(model_pre..part, model[1]);
		end
	elseif equip_mode == EV_EQUIP_MODE_LINK then
		local slot = param.Slot;
		for i, s in ipairs(slot) do
			local short_name = model_pre..part..i;
			if model == nil or model[i] == nil then
				self:UnlinkModel(short_name);
			else
				local m = model[i];
				self:LinkModel(m, short_name, s);
			end
		end
	elseif equip_mode == EV_EQUIP_MODE_LINK_WITH_PATH then
		local path = param.Path;
		self:LinkModel(path.Name, path_pre, path.Slot);
		local slot = param.Slot;
		for i, s in ipairs(slot) do
			local short_name = model_pre..part..i;
			local full_name = path_pre.."."..short_name;
			if model == nil or model[1] == nil then
				self:UnlinkModel(full_name);
			else
				local m = model[1];
				self:LinkSubModel(m, short_name, s, path_pre);
			end
		end
	end
end

function layWorld_frmItemEx_modelSelf_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmItemEx.modelSelf") end
	self:SetCameraEye(0, -80, 50, true);
	self:SetCameraLookAt(0, 0, 25);
	self:SetCameraUp(0, 0, 1);
	local model = uiItemGetCurModel();
	local head, hair = uiItemGetCurAppearance();
	self:SetModel(uiItemGetCurModel());
	self:LoadSkin("head", head);
	self:LoadSkin("hair", hair);
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_MAINTRUMP);			--主法宝
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_SUBTRUMP1);            --辅助法宝1
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_SUBTRUMP2);            --辅助法宝2
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_CLOTHING);             --盔甲
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_GLOVE);                --手套
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_SHOES);                --鞋子
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_CUFF);                 --护腕
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_KNEEPAD);              --护膝
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_SASH);                 --腰带
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_RING1);                --戒指1
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_RING2);                --戒指2
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_AMULET1);              --护身符1
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_AMULET2);              --护身符2
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_PANTS);                --裤子
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_CLOAK);                --披风
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_HELM);                 --头盔
	layWorld_frmItemEx_modelSelf_RefreshPart(self, EV_EQUIP_PART_SHOULDER);             --护肩
end

local function SortBagItem (queue_mode, baglist)
	-- 整理背包
	
	if baglist == nil then  -- 总排序
		baglist = {};
		for bagindex = 0, Local_Item_MaxBag - 1 do
			local line, col, count, istask, outdate = uiItemGetItemBagInfoByIndex(bagindex);
			if istask then
				SortBagItem(queue_mode, {bagindex});
			elseif outdate then
				--SortBagItem(queue_mode, {bagindex}); -- 过期的包包 服务器 不允许移动
			else
				table.insert(baglist, bagindex);
			end
		end
	end
	
	-- 1.数据列表变量 < 叠加 >
	local ItemList_M = {};	-- 叠加道具列表
	local ItemList_P = {};	-- 位置列表
	local ItemList_L = {};	-- 用于排序的道具列表
	
	local ExchangeItem = function (first, second)
		local Temp = {
			ObjectId = first.ObjectId,
			TableId = first.TableId,
			MaxCount = first.MaxCount,
			Count = first.Count,
			Type = first.Type,
			};
		first.ObjectId = second.ObjectId;
		first.TableId = second.TableId;
		first.MaxCount = second.MaxCount;
		first.Count = second.Count;
		first.Type = second.Type;
		
		second.ObjectId = Temp.ObjectId;
		second.TableId = Temp.TableId;
		second.MaxCount = Temp.MaxCount;
		second.Count = Temp.Count;
		second.Type = Temp.Type;
	end
	local ClearItem = function (item)
		item.ObjectId = nil;
		item.TableId = nil;
		item.MaxCount = nil;
		item.Count = nil;
		item.Type = nil;
	end
	
	-- 2.收集数据列表
	for bagindex = 0, Local_Item_MaxBag - 1 do
		local line, col, count, istask, outdate = uiItemGetItemBagInfoByIndex(bagindex);
		if SAPI.ExistInTable(baglist, bagindex) == true then
			local itembag = {maxline = line, maxcol = col};
			for l = 0, line - 1 do
				local itemline = {};
				for c = 0, col - 1 do
					local iteminfo = {};
					iteminfo.bag = bagindex;
					iteminfo.line = l;
					iteminfo.col = c;
					local ObjectId, TableId = uiItemGetItemInfoByCoord(bagindex, l, c);
					if ObjectId then
						iteminfo.ObjectId = ObjectId;
						iteminfo.TableId = TableId;
						local classInfo = uiItemGetItemClassInfoByTableIndex(TableId);
						iteminfo.Type = classInfo.Type;
						if LClass_ItemFreezeManager:IsFreezed(ObjectId) == false then -- 如果被冻结，则不允许叠加
							if classInfo.IsCountable then
								iteminfo.MaxCount = classInfo.MaxCount;
								local objInfo = uiItemGetBagItemInfoByObjectId(ObjectId);
								iteminfo.Count = objInfo.Count;
							end
						end
					end
					table.insert(itemline, iteminfo);
					table.insert(ItemList_L, iteminfo);
					if iteminfo.MaxCount then
						if ItemList_M[TableId] == nil then
							ItemList_M[TableId] = {};
						end
						table.insert(ItemList_M[TableId], iteminfo);
					end
				end
				table.insert(itembag, itemline);
			end
			ItemList_P[bagindex] = itembag;
		end
	end
	
	-- 3.叠加整理 < 叠加 >
	for TableId, ItemList in pairs(ItemList_M) do
		local OpItem = nil;
		for i, v in ipairs(ItemList) do
			local MaxCount = v.MaxCount;
			if v.Count < MaxCount then
				for j = 1, i - 1 do
					OpItem = ItemList[j];
					if OpItem and uiItemCheckSameBagItemByCoord(v.bag, v.line, v.col, OpItem.bag, OpItem.line, OpItem.col) then
						local totle = OpItem.Count + v.Count;
						if totle > MaxCount then
							totle = MaxCount - OpItem.Count;
							uiItemDivideItem(v.bag, v.line, v.col, OpItem.bag, OpItem.line, OpItem.col, totle);
							v.Count = v.Count - totle;
							OpItem.Count = MaxCount;
							OpItem = v;
						else
							uiItemMoveItem(v.bag, v.line, v.col, OpItem.bag, OpItem.line, OpItem.col);
							ClearItem(v);
							OpItem.Count = OpItem.Count + totle;
							break;
						end
					end
				end
			end
		end
	end
	
	-- 4.排序 < 移动 >
	local sortfunc = nil;
	if queue_mode == true then
		sortfunc = function (first, second)
						if first.Type == nil then return false end
						if second.Type == nil then return true end
						
						if first.Type == second.Type then
							if first.TableId == second.TableId then
								return first.ObjectId < second.ObjectId;
							end
							return first.TableId < second.TableId;
						end
						
						return first.Type < second.Type;
					end;
	else
		sortfunc = function (first, second)
						if first.Type == nil then return false end
						if second.Type == nil then return true end
						
						if first.Type == second.Type then
							if first.TableId == second.TableId then
								return first.ObjectId > second.ObjectId;
							end
							return first.TableId > second.TableId;
						end
						
						return first.Type > second.Type;
					end;
	end
	table.sort(ItemList_L, sortfunc);
							
	local SortList = {};
	local index = 1;
	for bagindex = 0, Local_Item_MaxBag - 1 do
		local bag = ItemList_P[bagindex];
		if bag then
			for line, lineitem in ipairs(bag) do
				for col, item in ipairs(lineitem) do
					local itemL = ItemList_L[index];
					if itemL.ObjectId then
						SortList[itemL.ObjectId] = {bag=bagindex, line=line-1, col=col-1};
					end
					index = index + 1;
				end
			end
		end
	end
	
	for bagindex = 0, Local_Item_MaxBag - 1 do
		local bag = ItemList_P[bagindex];
		if bag then
			for line, lineitem in ipairs(bag) do
				for col, item in ipairs(lineitem) do
					local move = true;
					while move do
						if item.ObjectId then
							-- 检查是不是需要移动
							local SortItem = SortList[item.ObjectId];
							if SortItem then
								if item.bag == SortItem.bag and item.line == SortItem.line and item.col == SortItem.col then
									move = false;
								else
									local itemto = ItemList_P[SortItem.bag][SortItem.line+1][SortItem.col+1];
									if not itemto then
										uiError(string.format("itemto nil error!!![%s][%s][%s]", tostring(SortItem.bag), tostring(SortItem.line), tostring(SortItem.col)));
										return;
									end
									uiItemMoveItem(item.bag, item.line, item.col, itemto.bag, itemto.line, itemto.col);
									ExchangeItem(item, itemto);
								end
							else
								uiError(string.format("SortItem nil error!!![Objectid = %s]", tostring(item.ObjectId)));
								return;
							end
						else
							move = false;
						end
					end
				end
			end
		end
	end
	
	
	--[[
	-- 4.数据列表变量 < 移动 >
	local SpaceList = {};
	local ItemList = {};
	
	-- 5.收集数据列表 < 移动 >
	for bagindex = 0, Local_Item_MaxBag - 1 do
		local bag = ItemList_P[bagindex];
		if bag then
			for line, lineitem in ipairs(bag) do
				for col, item in ipairs(lineitem) do
					if item.ObjectId then
						table.insert(ItemList, item);
					else
						table.insert(SpaceList, item);
					end
				end
			end
		end
	end
	
	-- 6.位置整理 < 移动 >
	if table.getn(SpaceList) < table.getn(ItemList) then
		local curindex = table.getn(ItemList);
		-- 如果空格在道具之前，则移动之
		for i, v in ipairs(SpaceList) do
			vItem = ItemList[curindex];
			if vItem.bag < v.bag then
				break;
			elseif vItem.bag == v.bag then
				if vItem.line < v.line then
					break;
				elseif vItem.line == v.line then
					if vItem.col <= v.col then
						break;
					end
				end
			end
			uiItemMoveItem(vItem.bag, vItem.line, vItem.col, v.bag, v.line, v.col);
			curindex = curindex - 1;
		end
	else
		local curindex = 1;
		local v = nil;
		for i = table.getn(ItemList), 1, -1 do
			vSpace = SpaceList[curindex];
			v = ItemList[i];
			if vSpace.bag > v.bag then
				break;
			elseif vSpace.bag == v.bag then
				if vSpace.line > v.line then
					break;
				elseif vSpace.line == v.line then
					if vSpace.col >= v.col then
						break;
					end
				end
			end
			uiItemMoveItem(v.bag, v.line, v.col, vSpace.bag, vSpace.line, vSpace.col);
			curindex = curindex + 1;
		end
	end
	]]
end

function layWorld_frmItemEx_btSort_OnLClick(self)
	SortBagItem (true);
end
function layWorld_frmItemEx_btSort_OnRClick(self)
	SortBagItem (false);
end















