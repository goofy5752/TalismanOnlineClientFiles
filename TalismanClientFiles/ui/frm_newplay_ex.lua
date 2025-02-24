
-- 点击取消按钮(关闭)
function layWorld_frmNewPlayEx_btCancel_OnLCLick(self)
	SAPI.GetParent(self):Hide();
end
-- 点击返回按钮
function layWorld_frmNewPlayEx_btBack_OnLClick(self)
	local frmHelpIndex = SAPI.GetSibling(self, "frmHelpIndex");
	if frmHelpIndex:getVisible() == true then return end
	
	local frmgettask = SAPI.GetSibling(self, "frmgettask");
	frmgettask:Hide();
	local frmkillmonster = SAPI.GetSibling(self, "frmkillmonster");
	frmkillmonster:Hide();
	local frmhelpfubenIndex = SAPI.GetSibling(self, "frmhelpfubenIndex");
	frmhelpfubenIndex:Hide();
	
	frmHelpIndex:Show();
end
-- 点击任务按钮
function layWorld_frmNewPlayEx_frmHelpIndex_btTaskGuide_OnLClick(self)
	local frmHelpIndex = SAPI.GetParent(self);
	frmHelpIndex:Hide();
	local frmgettask = SAPI.GetSibling(frmHelpIndex, "frmgettask");
	local edbtask = SAPI.GetChild(frmgettask, "edbtask");
	
	layWorld_frmNewPlayEx_frmgettask_edbtask_Refresh(edbtask);
	
	frmgettask:Show();
end
-- 点击练级按钮
function layWorld_frmNewPlayEx_frmHelpIndex_btMonsterGuide_OnLClick(self)
	local frmHelpIndex = SAPI.GetParent(self);
	frmHelpIndex:Hide();
	local frmkillmonster = SAPI.GetSibling(frmHelpIndex, "frmkillmonster");
	local edbmonster = SAPI.GetChild(frmkillmonster, "edbmonster");
	
	layWorld_frmNewPlayEx_frmkillmonster_edbmonster_Refresh(edbmonster);
	
	frmkillmonster:Show();
end
-- 点击副本按钮
function layWorld_frmNewPlayEx_frmHelpIndex_btDungeonGuild_OnLClick(self)
	local frmHelpIndex = SAPI.GetParent(self);
	frmHelpIndex:Hide();
	local frmhelpfubenIndex = SAPI.GetSibling(frmHelpIndex, "frmhelpfubenIndex");
	local edbfubenname = SAPI.GetChild(frmhelpfubenIndex, "edbfubenname");
	
	layWorld_frmNewPlayEx_frmhelpfubenIndex_edbfubenname_Refresh(edbfubenname);
	
	frmhelpfubenIndex:Show();
end
------------------------------------------------------------------------------------
----------------------------   任务帮助    ---------------------------------------
------------------------------------------------------------------------------------
function layWorld_frmNewPlayEx_frmgettask_edbtask_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfLevelUp");
end
function layWorld_frmNewPlayEx_frmgettask_edbtask_OnEvent(self, event, arg)
	if event == "EVENT_SelfLevelUp" then
		layWorld_frmNewPlayEx_frmgettask_edbtask_Refresh(self);
	end
end
-- 点击任务链接时
function layWorld_frmNewPlayEx_frmgettask_edbtask_OnHyperLink(self, hypertype, hyperlink)
    if hyperlink ~= nil then
		if hyperlink == "Return" then
			local btBack = uiGetglobal("layWorld.frmNewPlayEx.btBack");
			layWorld_frmNewPlayEx_btBack_OnLClick(btBack);
		else
			Receive(hyperlink);
		end
    end
end
function layWorld_frmNewPlayEx_frmgettask_edbtask_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmNewPlayEx.frmgettask.edbtask"); end
	local rich_text = uiTaskGetCanAcceptTaskInfo(0, EV_LIST_TASK_ALL, false);
	if rich_text == nil then return end
	self:SetRichText(rich_text, false);
	self:ScrollToTop();
end
------------------------------------------------------------------------------------
----------------------------   练级帮助    ---------------------------------------
------------------------------------------------------------------------------------
function layWorld_frmNewPlayEx_frmkillmonster_edbmonster_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfLevelUp");
end
function layWorld_frmNewPlayEx_frmkillmonster_edbmonster_OnEvent(self, event, arg)
	if event == "EVENT_SelfLevelUp" then
		layWorld_frmNewPlayEx_frmkillmonster_edbmonster_Refresh(self);
	end
end
-- 点击练级地点链接时
function layWorld_frmNewPlayEx_frmkillmonster_edbmonster_OnHyperLink(self, hypertype, hyperlink)
    if hyperlink ~= nil then
		if hyperlink == "Return" then
			local btBack = uiGetglobal("layWorld.frmNewPlayEx.btBack");
			layWorld_frmNewPlayEx_btBack_OnLClick(btBack);
		else
			Receive(hyperlink);
		end
    end
end
function layWorld_frmNewPlayEx_frmkillmonster_edbmonster_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmNewPlayEx.frmkillmonster_edbmonster"); end
	local level = uiGetMyInfo("Exp");
	local name, party, sex = uiGetMyInfo("Role");
	local path = uiGetCommonPath().."help/";
	local file = "";
	if level <=4 then
    	file = "helpmonster1to4.xml"
	elseif level >= 5 and level <= 10 then
		if party == 0 then
			file = "helpmonster5to10a.xml";
		elseif party == 1 then
			file = "helpmonster5to10a.xml";
		elseif party == 2 then
			file = "helpmonster5to10a.xml";
		elseif party == 3 then
			file = "helpmonster5to10b.xml";
		elseif party == 4 then
			file = "helpmonster5to10b.xml";
		end
	elseif level >= 11 and level <= 20 then
		file = "helpmonster11to20.xml";
	elseif level >= 21 and level <= 24 then
		file = "helpmonster21to24.xml";
	elseif level >= 25 and level <= 30 then
		file = "helpmonster25to30.xml";
	elseif level >= 31 and level <= 35 then
		file = "helpmonster31to35.xml";
	elseif level >= 36 and level <= 40 then
		file = "helpmonster36to40.xml";
	elseif level >= 41 and level <= 45 then
		file = "helpmonster41to45.xml";
	elseif level >= 46 and level <= 50 then
		file = "helpmonster46to50.xml";
	elseif level >= 51 and level <= 60 then
		file = "helpmonster51to60.xml";
	elseif level >= 60 then
		file = "helpmonster51to60.xml";
	end
	self:SetRichTextFile(path..file, false);
	self:ScrollToTop();
end
------------------------------------------------------------------------------------
----------------------------   副本帮助    ---------------------------------------
------------------------------------------------------------------------------------
function layWorld_frmNewPlayEx_frmhelpfubenIndex_edbfubenname_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfLevelUp");
end
function layWorld_frmNewPlayEx_frmhelpfubenIndex_edbfubenname_OnEvent(self, event, arg)
	if event == "EVENT_SelfLevelUp" then
		layWorld_frmNewPlayEx_frmhelpfubenIndex_edbfubenname_Refresh(self);
	end
end
-- 点击副本链接时
function layWorld_frmNewPlayEx_frmhelpfubenIndex_edbfubenname_OnHyperLink(self, hypertype, hyperlink)
    if hyperlink ~= nil then
		if hyperlink == "Return" then
			local btBack = uiGetglobal("layWorld.frmNewPlayEx.btBack");
			layWorld_frmNewPlayEx_btBack_OnLClick(btBack);
		else
			Receive(hyperlink);
		end
    end
end
function layWorld_frmNewPlayEx_frmhelpfubenIndex_edbfubenname_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmNewPlayEx.frmhelpfubenIndex.edbfubenname"); end
	local level = uiGetMyInfo("Exp");
	local path = uiGetCommonPath().."help/";
	local files = {};
	if level < 15 then return end
	if level >=15 and level < 25 then
		table.insert(files, "helpfuben1.xml");
		table.insert(files, "helpfuben2.xml");
	elseif level >= 25  and level < 35 then
		table.insert(files, "helpfuben3.xml");
	elseif level >= 35  and level < 40 then
		table.insert(files, "helpfuben35.xml");
	elseif level >= 40  and level < 45 then
		table.insert(files, "helpfuben4.xml");
	elseif level >= 45  and level < 55 then
		table.insert(files, "helpfuben5.xml");
	elseif level >= 55  and level < 60 then
		table.insert(files, "helpfuben6.xml");
	elseif level >= 60  then
		table.insert(files, "helpfuben7.xml");
	end
	local bAppend = false;
	for i, f in ipairs(files) do
		self:SetRichTextFile(path..f, bAppend);
		bAppend = true;
	end
	self:ScrollToTop();
end
-- 主窗口显示时
function layWorld_frmNewPlayEx_OnShow(self)
	uiRegisterEscWidget(self);
	local btBack = SAPI.GetChild(self, "btBack");
	layWorld_frmNewPlayEx_btBack_OnLClick(btBack);
end








