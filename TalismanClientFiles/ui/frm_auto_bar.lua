local frmAutoBar_TemplateAutoBarItem_List =
{
};

local frmAutoBar_AutoUseList =
{
	UIChanged = false,
};

function layWorld_wtAutoBarUseManager_OnUpdate(self, delta)
	frmAutoBar_TemplateAutoBarItem_AutoUse();
	--[[
	for k, v in pairs(frmAutoBar_TemplateAutoBarItem_List) do
		frmAutoBar_TemplateAutoBarItem_AutoUse(v);
	end
	]]
end

function layWorld_frmAutoBar_btDefaultSetting_OnLClick(self)
	for k, v in pairs(frmAutoBar_TemplateAutoBarItem_List) do
		local cbSelect = SAPI.GetChild(v, "cbSelect");
		local BtItem = SAPI.GetChild(v, "BtItem");
		local itemid = BtItem:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if not itemid or itemid == 0 then
			cbSelect:SetChecked(false);
		elseif cbSelect:getChecked() ~= true then
			cbSelect:SetChecked(true);
			--local BtItem = SAPI.GetChild(v, "BtItem");
			--frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(BtItem);
		end
	end
	frmAutoBar_AutoUseList.UIChanged = true;
end

function frmAutoBar_TemplateAutoBarItem_BtItem_OnLoad(self)
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_AUTO_BAR);
	--self:RegisterScriptEventNotify("bag_item_update");
	--self:RegisterScriptEventNotify("bag_item_exchange_grid");
	self:RegisterScriptEventNotify("bag_item_removed");
	self:RegisterScriptEventNotify("bag_item_added");
end

function frmAutoBar_TemplateAutoBarItem_BtItem_OnEvent(self, event, args)
	--if event == "bag_item_update" then
		--frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(self);
	--elseif event == "bag_item_exchange_grid" then
		--frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(self);
	if event == "bag_item_removed" then
		local id = args[5];
		local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
		if not shortcut_type or shortcut_type ~= EV_SHORTCUT_OBJECT_ITEM then return end
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if not shortcut_objectid or shortcut_objectid ~= id then return end
		frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(self);
	elseif event == "bag_item_added" then
		local id = args[5];
		local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
		if not shortcut_type or shortcut_type ~= EV_SHORTCUT_OBJECT_ITEM then return end
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if not shortcut_objectid or shortcut_objectid ~= id then return end
		frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(self);
	end
end

function frmAutoBar_TemplateAutoBarItem_BtItem_OnDragIn(self, drag)
	local allow_owners = 
	{
		EV_UI_SHORTCUT_OWNER_ITEM,
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
	
	local class_info = uiItemGetItemClassInfoByTableIndex(shortcut_classid);
	if not class_info or not class_info.IsPointShop then return end
	if not class_info.BindBuff or class_info.BindBuff == 0 then return end
	
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type);
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid);
	frmAutoBar_AutoUseList.UIChanged = true;
	frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(self);
end

function frmAutoBar_TemplateAutoBarItem_BtItem_OnDragNull(self)
	frmAutoBar_TemplateAutoBarItem_BtItem_Clear(self);
end

function frmAutoBar_TemplateAutoBarItem_BtItem_Clear(self)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_AUTO_BAR then return end
	self:Delete(EV_UI_SHORTCUT_TYPE_KEY);
	self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
	self:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
	frmAutoBar_AutoUseList.UIChanged = true;
	frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(self);
end

function frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(self)
	--local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_AUTO_BAR then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	local BindBuff = nil;
	
	local icon = 0; -- 图标地址 -- 指针地址
	local itemCount = 0; -- 道具的当前数量
	local countText = ""; -- 道具的当前数量文本
	local bModifyFlag = false;
	local bHaveItem = false;
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE;
	elseif not shortcut_classid or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid); -- 道具的静态信息
		if tableInfo and tableInfo.IsPointShop then
			bHaveItem = true;
			local count, first_objectid = uiGetBagItemInfoByTableIndex(shortcut_classid);
			if shortcut_objectid == nil or shortcut_objectid == 0 or uiItemCheckBagItemExist(shortcut_objectid) == false then
				shortcut_objectid = first_objectid;
				if shortcut_objectid == nil or shortcut_objectid == 0 then
					shortcut_objectid = 0;
					self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
				else
					self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
				end
			end
			icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2);
			if tableInfo.IsCountable == true then
				BindBuff = tableInfo.BindBuff;
				local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid); -- 道具的动态信息
				itemCount = count;
				if itemCount > 0 then
					countText = tostring(itemCount);
				end
			end
			bModifyFlag = true;
		end
	end
	-- 操作按钮
	self.BindBuff = BindBuff;
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag);
	self:ModifyFlag("DragOut_LeftButton", bModifyFlag);
	self:SetNormalImage(icon);
	self:SetUltraTextNormal(countText);
	local cbSelect = SAPI.GetSibling(self, "cbSelect");
	if not bHaveItem then
		cbSelect:SetChecked(bHaveItem);
	end
	--frmAutoBar_TemplateAutoBarItem_SaveUserConfig(SAPI.GetParent(self));
end

function frmAutoBar_TemplateAutoBarItem_BtItem_RefreshCount(self)
	local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_AUTO_BAR then return end
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

function frmAutoBar_TemplateAutoBarItem_BtItem_OnUpdate(self, delta)
	local now = os.clock();
	local LastUpdate = self.LastUpdate;
	if not LastUpdate then LastUpdate = now; self.LastUpdate = now end
	if LastUpdate + 0.2 <= now then
		self.LastUpdate = now;
		frmAutoBar_TemplateAutoBarItem_BtItem_RefreshCount(self);
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
	end
	
	if mask_value == nil then mask_value = 1 end
	if mask_value < 0 then mask_value = 0 end
	self:SetMaskValue(mask_value);
end

function frmAutoBar_TemplateAutoBarItem_BtItem_OnHint(self)
	local hint = 0;
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		else
			hint = uiItemGetBagItemHintByObjectId(shortcut_objectid);
		end
	end
	self:SetHintRichText(hint);
end

function layWorld_frmAutoBar_lbSelectAll_cbSelectAll_OnLClick(self)
	local AutoBarItemSwitch = self:getChecked();
	local lbSelectAll = SAPI.GetParent(self);
	local lbButtonGroup = SAPI.GetSibling(lbSelectAll, "lbButtonGroup");
	for i = 1, 12, 1 do
		local lbAutoItem = SAPI.GetChild(lbButtonGroup, "lbAutoItem"..i);
		local cbSelect = SAPI.GetChild(lbAutoItem, "cbSelect");
		if AutoBarItemSwitch then
			cbSelect:Enable();
		else
			cbSelect:Disable();
		end
	end
	frmAutoBar_AutoUseList.UIChanged = true;
	--uiSetUserConfig("AutoBarItemSwitch", tostring(AutoBarItemSwitch));
end

function frmAutoBar_TemplateAutoBarItem_cbSelect_OnLClick(self)
	local BtItem = SAPI.GetSibling(self, "BtItem");
	local shortcut_classid = BtItem:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if not shortcut_classid or shortcut_classid == 0 then self:SetChecked(false) return end
	frmAutoBar_AutoUseList.UIChanged = true;
end

function frmAutoBar_TemplateAutoBarItem_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	frmAutoBar_TemplateAutoBarItem_List[self:getName()] = self;
end

function frmAutoBar_TemplateAutoBarItem_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		frmAutoBar_TemplateAutoBarItem_LoadUserConfig(self)
	end
end

function layWorld_frmAutoBar_lbSelectAll_cbSelectAll_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function layWorld_frmAutoBar_lbSelectAll_cbSelectAll_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		frmAutoBar_TemplateAutoBarItem_LoadUserConfig_Switch(self);
	end
end

function frmAutoBar_TemplateAutoBarItem_AutoUse(self)
	if not self then self = uiGetglobal("layWorld.frmAutoBar") end
	if not frmAutoBar_AutoUseList["Switch"] then return end
	
	-- 开始自动使用了
	local bufflist = uiGetMyInfo("EffectList");
	if not bufflist then return end
	
	for i, v in ipairs(frmAutoBar_AutoUseList) do
		local itemid = v[1];
		local buffid = v[2];
		if buffid and SAPI.ExistInTable(bufflist, buffid) ~= true then
			-- Buff已经没了
			if itemid and itemid ~= 0 and uiItemCanUseItem(itemid) then
				Local_Item_UseItemDispatcher:Use(itemid);
			end
		end
	end
end

function frmAutoBar_TemplateAutoBarItem_LoadUserConfig(self)
	local ID = self.ID;
	if not ID or ID == 0 then return end
	local AutoBarItem = uiGetUserConfig("AutoBarItem"..ID);
	local i, _, itemid, itemindex, autouse = string.find(AutoBarItem, "^(%d+),(%d+),(.-)$");
	if not i then
		itemid = 0;
		itemindex = 0;
		autouse = false;
	else
		itemid = tonumber(itemid);
		itemindex = tonumber(itemindex);
		if autouse == "true" then
			autouse = true;
		else
			autouse = false;
		end
	end
	local BtItem = SAPI.GetChild(self, "BtItem");
	BtItem:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_ITEM);
	BtItem:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
	--BtItem:Set(EV_UI_SHORTCUT_OBJECTID_KEY, itemid);
	--uiInfo("itemindex = "..tostring(itemindex));
	BtItem:Set(EV_UI_SHORTCUT_CLASSID_KEY, itemindex);
	frmAutoBar_TemplateAutoBarItem_BtItem_Refresh(BtItem);
	--uiInfo("EV_UI_SHORTCUT_OBJECTID_KEY = "..tostring(BtItem:Get(EV_UI_SHORTCUT_OBJECTID_KEY)));
	local cbSelect = SAPI.GetChild(self, "cbSelect");
	
	if autouse then
		cbSelect:SetChecked(true);
		table.insert(frmAutoBar_AutoUseList, {BtItem[EV_UI_SHORTCUT_OBJECTID_KEY], BtItem.BindBuff});
	else
		cbSelect:SetChecked(false);
	end
	
	local AutoBarItemSwitch = uiGetUserConfig("AutoBarItemSwitch");
	if AutoBarItemSwitch == "true" then
		cbSelect:Enable();
	else
		cbSelect:Disable();
	end
end

function frmAutoBar_TemplateAutoBarItem_SaveUserConfig(self)
	local ID = self.ID;
	if not ID or ID == 0 then return end
	-- BtItem
	local BtItem = SAPI.GetChild(self, "BtItem");
	local itemid = BtItem:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local itemindex = BtItem:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if not itemid then itemid = 0 end
	if not itemindex then itemindex = 0 end
	local cbSelect = SAPI.GetChild(self, "cbSelect");
	local autouse = cbSelect:getChecked();
	local config = string.format("%d,%d,%s", itemid, itemindex, tostring(autouse));
	
	uiSetUserConfig("AutoBarItem"..ID, config);
	frmAutoBar_TemplateAutoBarItem_LoadUserConfig(self); -- 保存完毕 重新载入一次
end

function frmAutoBar_TemplateAutoBarItem_LoadUserConfig_Switch(self)
	local AutoBarItemSwitch = uiGetUserConfig("AutoBarItemSwitch");
	if AutoBarItemSwitch == "true" then
		self:SetChecked(true);
		frmAutoBar_AutoUseList["Switch"] = true;
	else
		self:SetChecked(false);
		frmAutoBar_AutoUseList["Switch"] = false;
	end
end

function frmAutoBar_TemplateAutoBarItem_SaveUserConfig_Switch(self)
	local AutoBarItemSwitch = self:getChecked();
	local lbSelectAll = SAPI.GetParent(self);
	local lbButtonGroup = SAPI.GetSibling(lbSelectAll, "lbButtonGroup");
	for i = 1, 12, 1 do
		local lbAutoItem = SAPI.GetChild(lbButtonGroup, "lbAutoItem"..i);
		local cbSelect = SAPI.GetChild(lbAutoItem, "cbSelect");
		if AutoBarItemSwitch then
			cbSelect:Enable();
		else
			cbSelect:Disable();
		end
	end
	uiSetUserConfig("AutoBarItemSwitch", tostring(AutoBarItemSwitch));
	frmAutoBar_TemplateAutoBarItem_LoadUserConfig_Switch(self); -- 保存完毕 重新载入一次
end

function layWorld_frmAutoBar_btOk_OnLClick(self)
	frmAutoBar_ConfigOk();
end

function layWorld_frmAutoBar_btOk_OnUpdate(self, delta)
	if frmAutoBar_AutoUseList.UIChanged then
		self:Enable();
		self:SetText(LAN("MSG_AUTO_BAR_NEEDSAVE"));
	else
		self:Disable();
		self:SetText(LAN("MSG_AUTO_BAR_SAVEED"));
	end
end

function layWorld_frmAutoBar_btClose_OnLClick(self)
	SAPI.GetParent(self):Hide();
end

function layWorld_frmAutoBar_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_ToggleAutoBar");
end

function layWorld_frmAutoBar_OnEvent(self, event, args)
	if args[1] ~= EV_EXCUTE_EVENT_ON_LCLICK and args[1] ~= EV_EXCUTE_EVENT_KEY_DOWN then return end
	if self:getVisible() == true then
		self:Hide();
	else
		if uiGetConfigureEntry("auto_bar", "close") == "true" then
		else
			self:ShowAndFocus();
		end
	end
end

function layWorld_frmAutoBar_OnShow(self)
	if uiGetConfigureEntry("auto_bar", "close") == "true" then
		self:Hide();
	end
end

function layWorld_frmAutoBar_OnHide(self)
	if frmAutoBar_AutoUseList.UIChanged then
		self:ShowAndFocus();
		local msgbox = uiMessageBox(LAN("MSG_AUTO_BAR_SAVE_CONFIRM"), "", true, true, true);
		SAPI.AddDefaultMessageBoxCallBack(
			msgbox,
			function(event, frame)
				frmAutoBar_ConfigOk()
				frame:Hide();
			end,
			function(event, frame)
				frmAutoBar_ConfigCancel()
				frame:Hide();
			end,
			self	);
	end
end

-- 设置读取配置
function frmAutoBar_ConfigOk(self)
	frmAutoBar_AutoUseList.UIChanged = false;
	frmAutoBar_AutoUseList = {};
	if not self then self = uiGetglobal("layWorld.frmAutoBar") end
	local lbSelectAll = SAPI.GetChild(self, "lbSelectAll");
	local cbSelectAll = SAPI.GetChild(lbSelectAll, "cbSelectAll");
	frmAutoBar_TemplateAutoBarItem_SaveUserConfig_Switch(cbSelectAll);
	local lbButtonGroup = SAPI.GetChild(self, "lbButtonGroup");
	for i = 1, 12, 1 do
		local lbAutoItem = SAPI.GetChild(lbButtonGroup, "lbAutoItem"..i);
		frmAutoBar_TemplateAutoBarItem_SaveUserConfig(lbAutoItem);
	end
end

-- 重新读取配置
function frmAutoBar_ConfigCancel(self)
	frmAutoBar_AutoUseList.UIChanged = false;
	frmAutoBar_AutoUseList = {};
	if not self then self = uiGetglobal("layWorld.frmAutoBar") end
	local lbSelectAll = SAPI.GetChild(self, "lbSelectAll");
	local cbSelectAll = SAPI.GetChild(lbSelectAll, "cbSelectAll");
	frmAutoBar_TemplateAutoBarItem_LoadUserConfig_Switch(cbSelectAll);
	local lbButtonGroup = SAPI.GetChild(self, "lbButtonGroup");
	for i = 1, 12, 1 do
		local lbAutoItem = SAPI.GetChild(lbButtonGroup, "lbAutoItem"..i);
		frmAutoBar_TemplateAutoBarItem_LoadUserConfig(lbAutoItem);
	end
end













