local LOCAL_UI_ALERN_TIME = 0;
local LOCAL_UI_ALERN_HOUR = 0;
local LOCAL_UI_ALERN_OPEN = false;

function layWorld_lbLayerAlern_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function layWorld_lbLayerAlern_OnEvent(self, event, arg)
	if event == "EVENT_SelfEnterWorld" then
		local strOpen = uiGetConfigureEntry("alern", "open");
		if strOpen == "true" then LOCAL_UI_ALERN_OPEN = true end
		if LOCAL_UI_ALERN_OPEN == true then
			self:Show();
		end
	end
end

function layWorld_lbLayerAlern_OnUpdate(self, delta)
	if LOCAL_UI_ALERN_OPEN == true then
		if LOCAL_UI_ALERN_TIME == 0 then
			local frmAlern = SAPI.GetChild(self,"frmAlern");
			local edbInfo = SAPI.GetChild(frmAlern, "edbInfo");
			edbInfo:SetText(string.format(uiLanString("msg_time_info"), LOCAL_UI_ALERN_HOUR));
			frmAlern:ActiveAnchor();
			frmAlern:ShowAndFocus();
		end
		LOCAL_UI_ALERN_TIME = LOCAL_UI_ALERN_TIME + delta;
		if LOCAL_UI_ALERN_TIME >= 36000000--[[1000 * 60 * 60]] then
			LOCAL_UI_ALERN_TIME = 0;
			LOCAL_UI_ALERN_HOUR = LOCAL_UI_ALERN_HOUR + 1;
		end
	end
end



