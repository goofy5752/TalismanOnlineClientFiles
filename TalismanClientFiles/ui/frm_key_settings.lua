
local LOCAL_KeySettings_EventList = 
{
};

function frmKeySettings_TemplateKeySettingButton_OnLClick(self)
	local INDEX = self.INDEX;
	if not INDEX then return end
	
	local TemplateLabelKeySettingsLine = SAPI.GetParent(self);
	local index = TemplateLabelKeySettingsLine.KeyLineIndex;
	if not index then return end
	local lineinfo = LOCAL_KeySettings_EventList[index]
	if not lineinfo then return end
	if lineinfo.Flag == "Title" then return end
	if lineinfo.Flag == "Event" then
		local edtNewKey = uiGetglobal("layWorld.frmKeySettingEx.edtNewKey");
		edtNewKey.KeyEvent = lineinfo.Value;
		edtNewKey.KeyIndex = INDEX;
		edtNewKey:Hide();
		edtNewKey:ShowAndFocus();
		--uiHotkeySetHotkeyCode(lineinfo.Value, INDEX, 27, true, false, false);
	end
end

function layWorld_frmKeySettingEx_ebInformation_OnLoad(self)
	self:RegisterScriptEventNotify("EventHotkeyCodeCleared");
end

function layWorld_frmKeySettingEx_ebInformation_OnEvent(self, event, args)
	if event == "EventHotkeyCodeCleared" then
		local keyEvent = args[1];
		if not keyEvent or keyEvent == "" then return end
		for i = 0, 1, 1 do
			local code, shift, ctrl, alt, name = uiHotkeyGetHotkeyCodeInfo(keyEvent, i);
			if code and code ~= 0 then return end
		end
		local richtext = EvUiLuaClass_RichText:new();
		local line = EvUiLuaClass_RichTextLine:new();
		
		local description = uiHotkeyGetHotkeyInfo(keyEvent);
		local i, _, desc = string.find(description, "^%$(.*)$");
		if i then
			desc = LAN(desc);
		else
			desc = description;
		end
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Text = "[";
		item.Color = "#FFFFFFFF";
		line:InsertItem(item);
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Text = desc;
		item.Color = "#FFFFFF00";
		line:InsertItem(item);
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Text = LAN("key_setting_unset2");
		item.Color = "#FFFF0000";
		line:InsertItem(item);
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Text = "]";
		item.Color = "#FFFFFFFF";
		line:InsertItem(item);
		
		richtext:InsertLine(line);
		self:SetRichText(richtext:ToRichString(), false);
	end
end

function layWorld_frmKeySettingEx_btRestoreDefault_OnLClick(self)
	uiHotkeyLoadDefaultSettings();
	layWorld_frmKeySettingEx_Refresh(SAPI.GetParent(self));
end

function layWorld_frmKeySettingEx_btCancelKeySetting_OnLClick(self)
	local edtNewKey = uiGetglobal("layWorld.frmKeySettingEx.edtNewKey");
	if edtNewKey:getVisible() ~= true then return end
	local keyevent = edtNewKey.KeyEvent;
	local keyindex = edtNewKey.KeyIndex;
	if not keyevent or not keyindex then return end
	edtNewKey:Hide();
	uiHotkeySetHotkeyCode(keyevent, keyindex, 0, false, false, false);
	layWorld_frmKeySettingEx_Refresh(SAPI.GetParent(self));
end

function layWorld_frmKeySettingEx_btOK_OnLClick(self)
	uiHotkeySave();
	local frame = SAPI.GetParent(self);
	frame:Hide();
end

function layWorld_frmKeySettingEx_btCancel_OnLClick(self)
	local frame = SAPI.GetParent(self);
	frame:Hide();
end

function layWorld_frmKeySettingEx_edtNewKey_OnKeyUp(self, key)
	self:Hide();
	local event = self.KeyEvent;
	local index = self.KeyIndex;
	if not event or not index then return end
	local res = uiHotkeySetHotkeyCode(event, index, key, uiIsKeyPressed("SHIFT"), uiIsKeyPressed("CTRL"), uiIsKeyPressed("ALT"));
	if res then
		local ebInformation = SAPI.GetSibling(self, "ebInformation");
		
		local richtext = EvUiLuaClass_RichText:new();
		local line = EvUiLuaClass_RichTextLine:new();
		local item = EvUiLuaClass_RichTextItem:new();
		item.Text = string.format("%s", LAN("key_setting_successful"));
		item.Color = "#FF00FF00";
		line:InsertItem(item);
		
		richtext:InsertLine(line);
		
		ebInformation:InsertRichTextToCursor(richtext:ToRichString());
	end
	layWorld_frmKeySettingEx_Refresh();
end

function layWorld_frmKeySettingEx_edtNewKey_OnShow(self)
	local ebInformation = SAPI.GetSibling(self, "ebInformation");
	
	local richtext = EvUiLuaClass_RichText:new();
	local line = EvUiLuaClass_RichTextLine:new();
	local item = EvUiLuaClass_RichTextItem:new();
	item.Text = LAN("key_setting_prompt");
	item.Color = "#FF00FF00";
	line:InsertItem(item);
	
	local keyEvent = self.KeyEvent;
	local description = uiHotkeyGetHotkeyInfo(keyEvent);
	local i, _, desc = string.find(description, "^%$(.*)$");
	if i then
		desc = LAN(desc);
	else
		desc = description;
	end
	local item = EvUiLuaClass_RichTextItem:new();
	item.Text = desc;
	item.Color = "#FFFFFF00";
	line:InsertItem(item);
	
	richtext:InsertLine(line);
	
	ebInformation:SetRichText(richtext:ToRichString(), false);
end

function layWorld_frmKeySettingEx_edtNewKey_OnHide(self)
	local ebInformation = SAPI.GetSibling(self, "ebInformation");
	ebInformation:SetText("");
end

function layWorld_frmKeySettingEx_ckbRoleSpecify_OnLClick(self)
	if self:getChecked() == true then
		uiHotkeyBindRole();
	else
		uiHotkeyBindAccount();
	end
	local frame = SAPI.GetParent(self);
	layWorld_frmKeySettingEx_Refresh(frame);
end

function layWorld_frmKeySettingEx_sbScrollBar_OnScroll(self)
	local frame = SAPI.GetParent(self);
	layWorld_frmKeySettingEx_Refresh(frame);
end

function layWorld_frmKeySettingEx_OnShow(self)
	local sbScrollBar = SAPI.GetChild(self, "sbScrollBar");
	
	local titlelist, eventmap = uiHotkeyGetHotkeyGroupList();
	LOCAL_KeySettings_EventList = {};
	for i, v in ipairs(titlelist) do
		--uiInfo(string.format("group[%s]:", tostring(v)));
		local eventlist = eventmap[v];
		table.insert(LOCAL_KeySettings_EventList, {Flag="Title", Value=v});
		for i, v in ipairs(eventlist) do
			--uiInfo(string.format(" - event[%d] = %s", i, tostring(v)));
			table.insert(LOCAL_KeySettings_EventList, {Flag="Event", Value=v});
		end
	end
	
	sbScrollBar:SetData(0, table.getn(LOCAL_KeySettings_EventList) - 5, 0, -1);
	sbScrollBar:ScrollToTop();
end

function layWorld_frmKeySettingEx_OnHide(self)
	uiHotkeyLoad();
end

function layWorld_frmKeySettingEx_Refresh(self)
	if not self then self = uiGetglobal("layWorld.frmKeySettingEx") end
	local sbScrollBar = SAPI.GetChild(self, "sbScrollBar");
	local offset = sbScrollBar:getValue();
	--uiInfo("offset = "..offset);
	local lineinfo = LOCAL_KeySettings_EventList[offset + 1];
	for i = 1, 15, 1 do
		local lbLine = SAPI.GetChild(self, "lbLine"..i);
		local lineinfo = LOCAL_KeySettings_EventList[offset + i];
		if lineinfo == nil then
			lbLine:Hide();
		else
			--local btKey0 = SAPI.GetChild(lbLine, "btKey0");
			--local btKey1 = SAPI.GetChild(lbLine, "btKey1");
			
			--uiInfo("lineinfo.Flag = "..tostring(lineinfo.Flag));
			--uiInfo("lineinfo.Value = "..tostring(lineinfo.Value));
			if lineinfo.Flag == "Title" then
				local i, _, desc = string.find(lineinfo.Value, "^%$(.*)$");
				if i then
					desc = LAN(desc);
				else
					desc = lineinfo.Value;
				end
				local lbTitle = SAPI.GetChild(lbLine, "lbTitle");
				lbTitle:SetTextColorEx(0,255,0,255);
				lbTitle:SetText(desc);
				for i = 0, 1, 1 do
					local btKey = SAPI.GetChild(lbLine, "btKey"..i);
					btKey:Hide();
				end
			elseif lineinfo.Flag == "Event" then
				local description = uiHotkeyGetHotkeyInfo(lineinfo.Value);
				local i, _, desc = string.find(description, "^%$(.*)$");
				if i then
					desc = LAN(desc);
				else
					desc = lineinfo.Value;
				end
				local lbTitle = SAPI.GetChild(lbLine, "lbTitle");
				lbTitle:SetTextColorEx(255,255,255,255);
				lbTitle:SetText(desc);
				for i = 0, 1, 1 do
					local btKey = SAPI.GetChild(lbLine, "btKey"..i);
					local code, shift, ctrl, alt, name = uiHotkeyGetHotkeyCodeInfo(lineinfo.Value, i);
					if code then
						if name == "UNSET" then name = LAN("key_setting_unset1") end
						btKey:SetText(name);
					else
						btKey:SetText("");
					end
					btKey:Show();
				end
			end
			lbLine:Show();
			lbLine.KeyLineIndex = offset + i;
		end
	end
	
	-- ckbRoleSpecify
	local rolespecial = uiHotkeyIsBindRole();
	local ckbRoleSpecify = SAPI.GetChild(self, "ckbRoleSpecify");
	ckbRoleSpecify:SetChecked(rolespecial);
end





