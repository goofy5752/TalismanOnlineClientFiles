function frmHelpPromptEx_TemplateBtnHelpPrompt_OnLClick(self)
	if not self then return end
	local Type = self.Type;
	local Content = self.Content;
	if not Type or not Content then self:Hide() return end
	self.Type = nil;
	self.Content = nil;
	self:Hide();
	local frmHelpBoxEx = uiGetglobal("layWorld.frmHelpBoxEx");
	local edbHelpIndex = SAPI.GetChild(frmHelpBoxEx, "edbHelpIndex");
	if Type == "text" then
		edbHelpIndex:SetText(Content);
	elseif Type == "richtext" then
		edbHelpIndex:SetRichText(Content, false);
	elseif Type == "file" then
		local bShow, filepath = uiHelpGetHelpConfig();
		edbHelpIndex:SetRichTextFile(filepath..Content, false);
	else
		return;
	end
	frmHelpBoxEx:ShowAndFocus();
end

function frmHelpPromptEx_TemplateBtnHelpPrompt_OnHide(self)
	if not self then return end
	self.Type = nil;
	self.Content = nil;
	self.ShowTime = nil;
end

local LOCAL_TemplateBtnMinRemind_List={};

function frmHelpPromptEx_TemplateBtnMinRemind_OnLClick(self)
	local ID = self.ID;
	if not ID or ID == 0 then return end
	uiUserCallRemind(ID-1);
--[[
	local name = self:getName();
	for i = 1, 3, 1 do
		if name == "btMinRemind"..i then
			local event = LOCAL_TemplateBtnMinRemind_List[i];
			table.remove(LOCAL_TemplateBtnMinRemind_List, i);
			if event and event.func and event.args then
				event.func(event.args[1], event.args[2], event.args[3], event.args[4], event.args[5], event.args[6], event.args[7], event.args[8]);
			end
			layWorld_lbMinRemindGroup_Refresh(SAPI.GetParent());
		end
	end
]]
end
--[[
function frmHelpPromptEx_TemplateBtnMinRemind_Push(func, hint)
	if not func or type(func) ~= "function" then return false end
	table.insert(LOCAL_TemplateBtnMinRemind_List, {func = func, hint = hint, args = arg});
	layWorld_lbMinRemindGroup_Refresh(nil);
	return true;
end
]]

function layWorld_lbMinRemindGroup_Refresh(self)
	if not self then self = uiGetglobal("layWorld.lbMinRemindGroup") end
	for i = 1, 3, 1 do
		local btMinRemind = SAPI.GetChild(self, "btMinRemind"..i);
		local event = LOCAL_TemplateBtnMinRemind_List[i];
		if event == nil then
			btMinRemind:Hide();
		else
			local hint = event.hint;
			if not hint then hint = "" end
			btMinRemind:SetHintText(hint);
			btMinRemind:ShowAndFocus();
		end
	end
end

function frmHelpPromptEx_TemplateBtnHelpPrompt_Refresh(self)
	if not self then return end
	local Type = self.Type;
	local Content = self.Content;
	if not Type or not Content then frmHelpPromptEx_TemplateBtnHelpPrompt_Clear(self) self:Hide() return end
	self.ShowTime = os.clock();
	self:ShowAndFocus();
end

function layWorld_lbHelpPromptGroup_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_NewHelpPrompt");
	self:RegisterScriptEventNotify("ConfigChange");
end

function layWorld_lbHelpPromptGroup_OnEvent(self, event, args)
	if event == "EVENT_NewHelpPrompt" then
		layWorld_lbHelpPromptGroup_OnEvent_EVENT_NewHelpPrompt(self, event, args);
	elseif event == "ConfigChange" then
		layWorld_lbHelpPromptGroup_OnEvent_ConfigChange(self, event, args);
	end
end

function layWorld_lbMinRemindGroup_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_RemindRefresh");
end

function layWorld_lbMinRemindGroup_OnEvent(self, event, args)
	if event == "EVENT_RemindRefresh" then
		local Count = uiUserGetRemindCount();
		for i = 1, 3, 1 do
			local btMinRemind = SAPI.GetChild(self, "btMinRemind"..i);
			if i > Count then
				btMinRemind:Hide();
			else
				btMinRemind:Show();
			end
		end
	end
end

function layWorld_lbHelpPromptGroup_OnEvent_EVENT_NewHelpPrompt(self, event, args)
	local bShow, filepath = uiHelpGetHelpConfig();
	if not bShow then return end
	local btHelpPromptOperator = nil;
	for i = 1, 3, 1 do
		local btHelpPrompt = SAPI.GetChild(self, "btHelpPrompt"..i);
		if not btHelpPrompt:getVisible() then
			btHelpPromptOperator = btHelpPrompt;
			break;
		end
		if not btHelpPromptOperator or btHelpPromptOperator.ShowTime > btHelpPrompt.ShowTime then
			btHelpPromptOperator = btHelpPrompt;
		end
	end
	btHelpPromptOperator.Type = args[1];
	btHelpPromptOperator.Content = args[2];
	frmHelpPromptEx_TemplateBtnHelpPrompt_Refresh(btHelpPromptOperator);
end

function layWorld_lbHelpPromptGroup_OnEvent_ConfigChange(self, event, args)
	--local section = args[1];
	--if section ~= "interface.basic.help" then return end
	local bShow, filepath = uiHelpGetHelpConfig();
	if not bShow then
		for i = 1, 3, 1 do
			local btHelpPrompt = SAPI.GetChild(self, "btHelpPrompt"..i);
			btHelpPrompt:Hide();
		end
	end
end
		
		
		