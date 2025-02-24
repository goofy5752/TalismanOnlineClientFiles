function layWorld_frmRace_OnLoad(self)
	self:RegisterScriptEventNotify("sev_run_info_notify");
end

function layWorld_frmRace_OnEvent(self, event, args)
	if event == "sev_run_info_notify" then
		if uiRunIsOpen() ~= true then self:Hide() return end
		local PathIndex, NodeIndex, NextNodeX, NextNodeY = args[1], args[2], args[3], args[4];
		if PathIndex == 255 or NodeIndex == 255 then self:Hide() return end
		local PathName, TotalNodeCount = uiRunGetPathInfo(PathIndex);
		if not PathName then self:Hide() return end
		local lbPathName = SAPI.GetChild(self, "lbPathName");
		local ebContent = SAPI.GetChild(self, "ebContent");
		lbPathName:SetText(string.format(LAN("msg_run_title"), PathName, NodeIndex, TotalNodeCount));
		if NodeIndex == 0 then
			ebContent:SetText(string.format(LAN("msg_run_content1")).."\n"..string.format(LAN("msg_run_content3"), NextNodeX, NextNodeY).."\n"..LAN("msg_run_content4"));
		else
			ebContent:SetText(string.format(LAN("msg_run_content2"), NodeIndex).."\n"..string.format(LAN("msg_run_content3"), NextNodeX, NextNodeY).."\n"..LAN("msg_run_content4"));
		end
		self:Show();
	end
end



