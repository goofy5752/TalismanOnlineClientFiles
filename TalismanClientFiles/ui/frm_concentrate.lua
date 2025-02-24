
function layWorld_frmNingshen_OnLoad(self)
    self:RegisterScriptEventNotify("EVENT_ToggleConcentrate");
	
    self:RegisterScriptEventNotify("EVENT_UpdateConcentrateCnt");
	
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentChanged");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentEquiped");
	self:RegisterScriptEventNotify("EVENT_SelfEquipmentUnequiped");
	
	self:RegisterScriptEventNotify("bag_item_update");
	self:RegisterScriptEventNotify("bag_item_removed");
	self:RegisterScriptEventNotify("bag_item_added");
end

function layWorld_frmNingshen_OnEvent(self, event, arg)
	if event == "EVENT_ToggleConcentrate" then
		if arg[1] ~= EV_EXCUTE_EVENT_ON_LCLICK and arg[1] ~= EV_EXCUTE_EVENT_KEY_DOWN then return end
		if self:getVisible() == false then
			if uiConcentrateCanConcentrate(true) == false then return end -- 检查凝神系统是否开放
			self:ShowAndFocus();
		else
			self:Hide();
		end
	elseif event == "EVENT_UpdateConcentrateCnt" then
		if self:getVisible() == false then return end
		layWorld_frmNingshen_Refresh(self);
	elseif event == "EVENT_SelfEquipmentChanged" or event == "EVENT_SelfEquipmentEquiped" or event == "EVENT_SelfEquipmentUnequiped" then
		if self:getVisible() == false then return end
		local part = arg[2];
		if part == EV_EQUIP_PART_MAINTRUMP then
			layWorld_frmNingshen_Refresh(self);
		end
	elseif event == "bag_item_update" or event == "bag_item_removed" or event == "bag_item_added" then
		if self:getVisible() == false then return end
		layWorld_frmNingshen_Refresh(self);
	end
end

function layWorld_frmNingshen_OnShow(self)
	uiRegisterEscWidget(self);
	layWorld_frmNingshen_Refresh(self);
end

function layWorld_frmNingshen_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmNingshen") end
	local btmainweapon = SAPI.GetChild(self, "btmainweapon");
	local btningshenguo = SAPI.GetChild(self, "btningshenguo");
	local lbningshengetval = SAPI.GetChild(self, "lbningshengetval");
	local edbningsheninfo = SAPI.GetChild(self, "edbningsheninfo");
	local lbuserlevinfo = SAPI.GetChild(self, "lbuserlevinfo"); -- 等级
	local lbleftningsheninfo = SAPI.GetChild(self, "lbleftningsheninfo"); -- 凝神次数
	local btBegin = SAPI.GetChild(self, "btBegin");
	
	local value, max_value, exp_per_minute, nim_per_minute = uiConcentrateGetData();
	if value == nil then value, max_value, exp_per_minute, nim_per_minute = 0, 0, 0, 0 end
	local level = uiGetMyInfo("Exp");
	lbuserlevinfo:SetText(tostring(level));
	lbleftningsheninfo:SetText(string.format("%d/%d", value, max_value));
	
	lbningshengetval:SetText(string.format(LAN("msg_concentrate_gain"), exp_per_minute, nim_per_minute));
	edbningsheninfo:SetText(LAN("msg_concentrate_help"));
	
	local id, classid = uiItemGetCurEquipItemByPart(EV_EQUIP_PART_MAINTRUMP);
	if id == nil or id == 0 then
		btmainweapon:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
		btmainweapon:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
		btmainweapon:SetNormalImage(0); -- 清除图标
	else
		btmainweapon:Set(EV_UI_SHORTCUT_OBJECTID_KEY, id);
		btmainweapon:Set(EV_UI_SHORTCUT_CLASSID_KEY, classid);
		local tableInfo = uiItemGetItemClassInfoByTableIndex(classid);
		local image = SAPI.GetImage(tableInfo.Icon, 4, 4, -4, -4);
		btmainweapon:SetNormalImage(image); -- 设置图标
	end
	
	local count, id, classid = uiGetBagItemInfoByType(EV_ITEM_TYPE_NINGSHENGUO);
	if count == nil or count == 0 then
		btningshenguo:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
		btningshenguo:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
		btningshenguo:SetUltraTextNormal("");
		btningshenguo:SetNormalImage(0);
	else
		btningshenguo:Set(EV_UI_SHORTCUT_OBJECTID_KEY, id);
		btningshenguo:Set(EV_UI_SHORTCUT_CLASSID_KEY, classid);
		btningshenguo:SetUltraTextNormal(tostring(count));
		local tableInfo = uiItemGetItemClassInfoByTableIndex(classid);
		local image = SAPI.GetImage(tableInfo.Icon, 4, 4, -4, -4);
		btningshenguo:SetNormalImage(image);
	end
end

function layWorld_frmNingshen_btBegin_OnLoad(self)
    self:RegisterScriptEventNotify("EVENT_OnConcentrateFlagChanged");
end

function layWorld_frmNingshen_btBegin_OnEvent(self, event, arg)
	if event == "EVENT_OnConcentrateFlagChanged" then
		local bInConcentrate = arg[1];
		self:Set("IsInConcentrate", bInConcentrate);
		layWorld_frmNingshen_btBegin_Refresh(self);
	end
end

function layWorld_frmNingshen_btBegin_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmNingshen.btBegin") end
	local bInConcentrate = self:Get("IsInConcentrate");
	if bInConcentrate == nil or bInConcentrate == false then
		self:SetText(LAN("msg_concentrate_start"));
	else
		self:SetText(LAN("msg_concentrate_stop"));
	end
end

function layWorld_frmNingshen_btBegin_OnLClick(self)
	local bInConcentrate = self:Get("IsInConcentrate");
	if bInConcentrate == nil or bInConcentrate == false then
		uiConcentrateStart();
	else
		uiConcentrateStop();
	end
end

function layWorld_frmNingshen_btmainweapon_OnHint(self)
	local hint = uiItemGetEquipedItemHintByPart(EV_EQUIP_PART_MAINTRUMP);
	if hint == nil then hint = 0 end
	self:SetHintRichText(hint);
end

function layWorld_frmNingshen_btningshenguo_OnHint(self)
	local id = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local hint = nil;
	if id ~= nil and id ~= 0 then
		hint = uiItemGetBagItemHintByObjectId(id);
	end
	if hint == nil then hint = 0 end
	self:SetHintRichText(hint);
end





